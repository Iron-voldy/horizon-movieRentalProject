package com.movierental.model.rental;

import java.io.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletContext;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.user.PremiumUser;
import com.movierental.model.user.RegularUser;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * RentalManager class handles all rental-related operations
 */
public class RentalManager {
    private static final String RENTAL_FILE_NAME = "rentals.txt";
    private List<Transaction> transactions;
    private MovieManager movieManager;
    private UserManager userManager;
    private ServletContext servletContext;
    private String dataFilePath;

    // Default constructor
    public RentalManager() {
        this(null);
    }

    // Constructor with ServletContext
    public RentalManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        transactions = new ArrayList<>();
        initializeFilePath();

        // Initialize managers with the same ServletContext
        this.movieManager = new MovieManager(servletContext);
        this.userManager = new UserManager(servletContext);

        loadTransactions();
    }

    // Constructor with existing managers
    public RentalManager(MovieManager movieManager, UserManager userManager, ServletContext servletContext) {
        transactions = new ArrayList<>();
        this.movieManager = movieManager;
        this.userManager = userManager;
        this.servletContext = servletContext;
        initializeFilePath();
        loadTransactions();
    }

    // Initialize the file path
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + RENTAL_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + RENTAL_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("RentalManager: Using data file path: " + dataFilePath);
    }

    // Load transactions from file
    private void loadTransactions() {
        File file = new File(dataFilePath);

        // Create directory if it doesn't exist
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }

        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created rentals file: " + dataFilePath);
            } catch (IOException e) {
                System.err.println("Error creating rentals file: " + e.getMessage());
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

                Transaction transaction = Transaction.fromFileString(line);
                if (transaction != null) {
                    transactions.add(transaction);
                    System.out.println("Loaded transaction: " + transaction.getTransactionId());
                }
            }
            System.out.println("Total transactions loaded: " + transactions.size());
        } catch (IOException e) {
            System.err.println("Error loading transactions: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save transactions to file
    private void saveTransactions() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
            for (Transaction transaction : transactions) {
                writer.write(transaction.toFileString());
                writer.newLine();
            }
            System.out.println("Transactions saved successfully to: " + dataFilePath);
        } catch (IOException e) {
            System.err.println("Error saving transactions: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Rent a movie
    public Transaction rentMovie(String userId, String movieId, int rentalDays) {
        System.out.println("RentalManager: Starting rental process...");
        System.out.println("RentalManager: User ID: " + userId);
        System.out.println("RentalManager: Movie ID: " + movieId);
        System.out.println("RentalManager: Rental Days: " + rentalDays);

        // Check if user exists
        User user = userManager.getUserById(userId);
        if (user == null) {
            System.out.println("RentalManager: User not found");
            return null;
        }
        System.out.println("RentalManager: User found: " + user.getUsername());

        // Check if movie exists and is available
        Movie movie = movieManager.getMovieById(movieId);
        if (movie == null) {
            System.out.println("RentalManager: Movie not found");
            return null;
        }
        System.out.println("RentalManager: Movie found: " + movie.getTitle());

        if (!movie.isAvailable()) {
            System.out.println("RentalManager: Movie is not available");
            return null;
        }
        System.out.println("RentalManager: Movie is available");

        // Check if user has reached rental limit
        List<Transaction> userActiveRentals = getActiveRentalsByUser(userId);
        System.out.println("RentalManager: User has " + userActiveRentals.size() + " active rentals");
        System.out.println("RentalManager: User's rental limit is " + user.getRentalLimit());

        if (userActiveRentals.size() >= user.getRentalLimit()) {
            System.out.println("RentalManager: User has reached rental limit");
            return null;
        }

        // Calculate rental fee based on user type and movie type
        double rentalFee = calculateRentalFee(user, movie, rentalDays);
        System.out.println("RentalManager: Calculated rental fee: " + rentalFee);

        // Calculate due date
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, rentalDays);
        Date dueDate = calendar.getTime();

        // Create new transaction
        Transaction transaction = new Transaction();
        transaction.setTransactionId(UUID.randomUUID().toString());
        transaction.setUserId(userId);
        transaction.setMovieId(movieId);
        transaction.setRentalDate(new Date());
        transaction.setDueDate(dueDate);
        transaction.setRentalFee(rentalFee);
        transaction.setReturned(false);
        transaction.setCanceled(false);

        System.out.println("RentalManager: Created transaction with ID: " + transaction.getTransactionId());

        // Update movie availability
        movie.setAvailable(false);
        boolean movieUpdated = movieManager.updateMovie(movie);
        System.out.println("RentalManager: Updated movie availability: " + movieUpdated);

        // Add transaction to list and save
        transactions.add(transaction);
        saveTransactions();
        System.out.println("RentalManager: Rental transaction completed successfully");

        return transaction;
    }

    // Return a movie
    public boolean returnMovie(String transactionId) {
        System.out.println("RentalManager: Starting return process for transaction: " + transactionId);

        Transaction transaction = getTransactionById(transactionId);
        if (transaction == null) {
            System.out.println("RentalManager: Transaction not found");
            return false;
        }

        if (transaction.isReturned() || transaction.isCanceled()) {
            System.out.println("RentalManager: Movie already returned or rental canceled");
            return false;
        }

        // Set return date and update returned status
        Date returnDate = new Date();
        transaction.setReturnDate(returnDate);
        transaction.setReturned(true);

        // Calculate late fee if applicable
        if (returnDate.after(transaction.getDueDate())) {
            int daysLate = transaction.calculateDaysOverdue();
            User user = userManager.getUserById(transaction.getUserId());

            double lateFee = calculateLateFee(user, daysLate);
            transaction.setLateFee(lateFee);
            System.out.println("RentalManager: Added late fee of " + lateFee);
        }

        // Update movie availability
        Movie movie = movieManager.getMovieById(transaction.getMovieId());
        if (movie != null) {
            movie.setAvailable(true);
            movieManager.updateMovie(movie);
            System.out.println("RentalManager: Updated movie availability");
        } else {
            System.out.println("RentalManager: Warning - Movie not found when returning");
        }

        // Save updated transaction
        saveTransactions();
        System.out.println("RentalManager: Return process completed successfully");

        return true;
    }

    // Cancel a rental
    public boolean cancelRental(String transactionId, String reason) {
        System.out.println("RentalManager: Starting cancellation process for transaction: " + transactionId);

        Transaction transaction = getTransactionById(transactionId);
        if (transaction == null) {
            System.out.println("RentalManager: Transaction not found");
            return false;
        }

        if (transaction.isReturned() || transaction.isCanceled()) {
            System.out.println("RentalManager: Movie already returned or rental canceled");
            return false;
        }

        // Update transaction status
        transaction.setCanceled(true);
        transaction.setCancellationDate(new Date());
        transaction.setCancellationReason(reason);

        // Update movie availability
        Movie movie = movieManager.getMovieById(transaction.getMovieId());
        if (movie != null) {
            movie.setAvailable(true);
            movieManager.updateMovie(movie);
            System.out.println("RentalManager: Updated movie availability after cancellation");
        } else {
            System.out.println("RentalManager: Warning - Movie not found when canceling rental");
        }

        // Save updated transaction
        saveTransactions();
        System.out.println("RentalManager: Cancellation process completed successfully");

        return true;
    }

    // Edit rental (update due date)
    public boolean updateRentalDueDate(String transactionId, int newRentalDays) {
        System.out.println("RentalManager: Starting update process for transaction: " + transactionId);

        Transaction transaction = getTransactionById(transactionId);
        if (transaction == null) {
            System.out.println("RentalManager: Transaction not found");
            return false;
        }

        if (transaction.isReturned() || transaction.isCanceled()) {
            System.out.println("RentalManager: Cannot update a returned or canceled rental");
            return false;
        }

        // Get user and movie to recalculate fee
        User user = userManager.getUserById(transaction.getUserId());
        Movie movie = movieManager.getMovieById(transaction.getMovieId());

        if (user == null || movie == null) {
            System.out.println("RentalManager: User or movie not found");
            return false;
        }

        // Calculate new due date
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(transaction.getRentalDate()); // Start from original rental date
        calendar.add(Calendar.DAY_OF_MONTH, newRentalDays);
        Date newDueDate = calendar.getTime();

        // Calculate new rental fee
        double newRentalFee = calculateRentalFee(user, movie, newRentalDays);

        // Update transaction
        transaction.setDueDate(newDueDate);
        transaction.setRentalFee(newRentalFee);

        // Save updated transaction
        saveTransactions();
        System.out.println("RentalManager: Rental update completed successfully");

        return true;
    }

    // Calculate rental fee based on user type and movie
    private double calculateRentalFee(User user, Movie movie, int days) {
        double movieFee = movie.calculateRentalPrice(days);
        System.out.println("RentalManager: Base movie fee: " + movieFee);

        // Apply user discount if applicable
        if (user instanceof PremiumUser) {
            double discountedFee = movieFee * 0.8; // 20% discount for premium users
            System.out.println("RentalManager: Applied premium discount: " + discountedFee);
            return discountedFee;
        }

        return movieFee; // Regular price for regular users
    }

    // Calculate late fee based on user type and days late
    private double calculateLateFee(User user, int daysLate) {
        if (daysLate <= 0) {
            return 0.0;
        }

        if (user instanceof PremiumUser) {
            return ((PremiumUser) user).calculateLateFee(daysLate);
        } else if (user instanceof RegularUser) {
            return ((RegularUser) user).calculateLateFee(daysLate);
        } else {
            // Default late fee calculation
            return 1.0 * daysLate;
        }
    }

    // Get transaction by ID
    public Transaction getTransactionById(String transactionId) {
        for (Transaction transaction : transactions) {
            if (transaction.getTransactionId().equals(transactionId)) {
                return transaction;
            }
        }
        return null;
    }

    // Get all transactions
    public List<Transaction> getAllTransactions() {
        return new ArrayList<>(transactions);
    }

    // Get transactions by user ID
    public List<Transaction> getTransactionsByUser(String userId) {
        List<Transaction> userTransactions = new ArrayList<>();
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId)) {
                userTransactions.add(transaction);
            }
        }
        return userTransactions;
    }

    // Get active (not returned and not canceled) rentals by user ID
    public List<Transaction> getActiveRentalsByUser(String userId) {
        List<Transaction> activeRentals = new ArrayList<>();
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId) && transaction.isActive()) {
                activeRentals.add(transaction);
            }
        }
        return activeRentals;
    }

    // Get canceled rentals by user ID
    public List<Transaction> getCanceledRentalsByUser(String userId) {
        List<Transaction> canceledRentals = new ArrayList<>();
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId) && transaction.isCanceled()) {
                canceledRentals.add(transaction);
            }
        }
        return canceledRentals;
    }

    // Get overdue rentals
    public List<Transaction> getOverdueRentals() {
        List<Transaction> overdueRentals = new ArrayList<>();
        Date currentDate = new Date();

        for (Transaction transaction : transactions) {
            if (transaction.isActive() && currentDate.after(transaction.getDueDate())) {
                overdueRentals.add(transaction);
            }
        }
        return overdueRentals;
    }

    // Get overdue rentals by user
    public List<Transaction> getOverdueRentalsByUser(String userId) {
        List<Transaction> overdueRentals = new ArrayList<>();
        Date currentDate = new Date();

        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId) &&
                    transaction.isActive() &&
                    currentDate.after(transaction.getDueDate())) {
                overdueRentals.add(transaction);
            }
        }
        return overdueRentals;
    }

    // Get rental history for a movie
    public List<Transaction> getRentalHistoryForMovie(String movieId) {
        List<Transaction> movieRentals = new ArrayList<>();
        for (Transaction transaction : transactions) {
            if (transaction.getMovieId().equals(movieId)) {
                movieRentals.add(transaction);
            }
        }
        return movieRentals;
    }

    // Delete a transaction
    public boolean deleteTransaction(String transactionId) {
        for (int i = 0; i < transactions.size(); i++) {
            if (transactions.get(i).getTransactionId().equals(transactionId)) {
                // If the transaction is for a movie that hasn't been returned or canceled,
                // make the movie available again
                Transaction transaction = transactions.get(i);
                if (transaction.isActive()) {
                    Movie movie = movieManager.getMovieById(transaction.getMovieId());
                    if (movie != null) {
                        movie.setAvailable(true);
                        movieManager.updateMovie(movie);
                    }
                }

                transactions.remove(i);
                saveTransactions();
                return true;
            }
        }
        return false;
    }

    // Check if a user has a specific movie rented
    public boolean hasUserRentedMovie(String userId, String movieId) {
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId) &&
                    transaction.getMovieId().equals(movieId) &&
                    transaction.isActive()) {
                return true;
            }
        }
        return false;
    }

    // Get total rental fees for a given user
    public double getTotalRentalFeesByUser(String userId) {
        double total = 0.0;
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId) && !transaction.isCanceled()) {
                total += transaction.getRentalFee();
                total += transaction.getLateFee();
            }
        }
        return total;
    }

    // Set ServletContext (can be used to update the context after initialization)
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePath();

        // Update managers with the new ServletContext
        if (this.movieManager != null) {
            this.movieManager.setServletContext(servletContext);
        } else {
            this.movieManager = new MovieManager(servletContext);
        }

        if (this.userManager != null) {
            this.userManager.setServletContext(servletContext);
        } else {
            this.userManager = new UserManager(servletContext);
        }

        // Reload transactions with the new file path
        transactions.clear();
        loadTransactions();
    }
}