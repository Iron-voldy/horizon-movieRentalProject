package com.movierental.model.admin;

/**
 * Admin class for system administrators
 */
public class Admin {
    private String adminId;
    private String username;
    private String password;
    private String email;
    private String fullName;
    private String role; // "ADMIN" or "SUPER_ADMIN"

    // Constructor with all fields
    public Admin(String adminId, String username, String password, String email, String fullName, String role) {
        this.adminId = adminId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
    }

    // Default constructor
    public Admin() {
        this.adminId = "";
        this.username = "";
        this.password = "";
        this.email = "";
        this.fullName = "";
        this.role = "ADMIN";
    }

    // Getters and setters
    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // Method to authenticate admin
    public boolean authenticate(String inputPassword) {
        return this.password.equals(inputPassword);
    }

    // Check if admin is a super admin
    public boolean isSuperAdmin() {
        return "SUPER_ADMIN".equals(this.role);
    }

    // Convert admin to string representation for file storage
    public String toFileString() {
        return adminId + "," + username + "," + password + "," + email + "," + fullName + "," + role;
    }

    // Create admin from string representation (from file)
    public static Admin fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 6) {
            return new Admin(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);
        }
        return null;
    }

    @Override
    public String toString() {
        return "Admin{" +
                "adminId='" + adminId + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}