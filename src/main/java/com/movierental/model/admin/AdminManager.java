package com.movierental.model.admin;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletContext;

/**
 * AdminManager class handles all admin-related operations
 */
public class AdminManager {
    private static final String ADMIN_FILE_NAME = "admins.txt";
    private List<Admin> admins;
    private ServletContext servletContext;
    private String dataFilePath;

    // Constructor
    public AdminManager() {
        this(null);
    }

    // Constructor with ServletContext
    public AdminManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        admins = new ArrayList<>();
        initializeFilePath();
        loadAdmins();

        // Add a default admin if no admins exist
        if (admins.isEmpty()) {
            createDefaultAdmin();
        }
    }

    // Initialize the file path
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + ADMIN_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + ADMIN_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("AdminManager: Using data file path: " + dataFilePath);
    }

    // Create a default admin account
    private void createDefaultAdmin() {
        Admin admin = new Admin();
        admin.setAdminId(UUID.randomUUID().toString());
        admin.setUsername("admin");
        admin.setPassword("admin123");
        admin.setEmail("admin@horizon.com");
        admin.setFullName("System Administrator");
        admin.setRole("SUPER_ADMIN");

        admins.add(admin);
        saveAdmins();

        System.out.println("Created default admin account. Username: admin, Password: admin123");
    }

    // Load admins from file
    private void loadAdmins() {
        File file = new File(dataFilePath);

        // If file doesn't exist, create it
        if (!file.exists()) {
            try {
                // Ensure parent directory exists
                if (file.getParentFile() != null) {
                    file.getParentFile().mkdirs();
                }
                file.createNewFile();
                System.out.println("Created admins file: " + dataFilePath);
            } catch (IOException e) {
                System.err.println("Error creating admins file: " + e.getMessage());
                e.printStackTrace();
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                Admin admin = Admin.fromFileString(line);
                if (admin != null) {
                    admins.add(admin);
                    System.out.println("Loaded admin: " + admin.getUsername());
                }
            }
            System.out.println("Total admins loaded: " + admins.size());
        } catch (IOException e) {
            System.err.println("Error loading admins: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save admins to file
    private boolean saveAdmins() {
        try {
            // Ensure directory exists
            File file = new File(dataFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
                for (Admin admin : admins) {
                    writer.write(admin.toFileString());
                    writer.newLine();
                }
            }
            System.out.println("Admins saved successfully to: " + dataFilePath);
            return true;
        } catch (IOException e) {
            System.err.println("Error saving admins: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    // Add a new admin
    public boolean addAdmin(Admin admin) {
        try {
            // Check if username already exists
            if (getAdminByUsername(admin.getUsername()) != null) {
                System.out.println("Username already exists: " + admin.getUsername());
                return false;
            }

            // Generate a unique ID if not provided
            if (admin.getAdminId() == null || admin.getAdminId().isEmpty()) {
                admin.setAdminId(UUID.randomUUID().toString());
            }

            admins.add(admin);
            boolean saved = saveAdmins();
            System.out.println("Admin saved successfully: " + saved);
            return saved;
        } catch (Exception e) {
            System.err.println("Exception occurred when adding admin:");
            e.printStackTrace();
            return false;
        }
    }

    // Get admin by ID
    public Admin getAdminById(String adminId) {
        for (Admin admin : admins) {
            if (admin.getAdminId().equals(adminId)) {
                return admin;
            }
        }
        return null;
    }

    // Get admin by username
    public Admin getAdminByUsername(String username) {
        for (Admin admin : admins) {
            if (admin.getUsername().equals(username)) {
                return admin;
            }
        }
        return null;
    }

    // Update admin details
    public boolean updateAdmin(Admin updatedAdmin) {
        for (int i = 0; i < admins.size(); i++) {
            if (admins.get(i).getAdminId().equals(updatedAdmin.getAdminId())) {
                admins.set(i, updatedAdmin);
                return saveAdmins();
            }
        }
        return false;
    }

    // Delete admin
    public boolean deleteAdmin(String adminId) {
        // Don't allow deleting the last admin
        if (admins.size() <= 1) {
            return false;
        }

        // Ensure we're not deleting the last super admin
        Admin adminToDelete = getAdminById(adminId);
        if (adminToDelete != null && adminToDelete.isSuperAdmin()) {
            // Count remaining super admins
            int superAdminCount = 0;
            for (Admin admin : admins) {
                if (admin.isSuperAdmin()) {
                    superAdminCount++;
                }
            }

            // If this is the last super admin, don't delete
            if (superAdminCount <= 1) {
                return false;
            }
        }

        for (int i = 0; i < admins.size(); i++) {
            if (admins.get(i).getAdminId().equals(adminId)) {
                admins.remove(i);
                return saveAdmins();
            }
        }
        return false;
    }

    // Get all admins
    public List<Admin> getAllAdmins() {
        return new ArrayList<>(admins);
    }

    // Authenticate admin
    public Admin authenticateAdmin(String username, String password) {
        Admin admin = getAdminByUsername(username);
        if (admin != null && admin.authenticate(password)) {
            return admin;
        }
        return null;
    }

    // Set ServletContext (can be used to update the context after initialization)
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePath();
        // Reload admins with the new file path
        admins.clear();
        loadAdmins();
    }
}