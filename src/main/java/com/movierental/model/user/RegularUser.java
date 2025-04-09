package com.movierental.model.user;

/**
 * RegularUser class representing a standard user with basic privileges
 */
public class RegularUser extends User {
    private static final int RENTAL_LIMIT = 3;

    // Constructor with all fields
    public RegularUser(String userId, String username, String password, String email, String fullName) {
        super(userId, username, password, email, fullName);
    }

    // Default constructor
    public RegularUser() {
        super();
    }

    @Override
    public int getRentalLimit() {
        return RENTAL_LIMIT;
    }

    // Calculate rental fee (regular users pay standard rate)
    public double calculateRentalFee(int daysRented) {
        return 2.99 * daysRented;
    }

    // Calculate late fee (regular users pay higher late fee)
    public double calculateLateFee(int daysLate) {
        return 1.50 * daysLate;
    }

    @Override
    public String toFileString() {
        return "REGULAR," + super.toFileString();
    }

    // Create RegularUser from string representation (from file)
    public static RegularUser fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 6 && parts[0].equals("REGULAR")) {
            return new RegularUser(parts[1], parts[2], parts[3], parts[4], parts[5]);
        }
        return null;
    }
}