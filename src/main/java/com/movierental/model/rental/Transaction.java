package com.movierental.model.rental;

import java.util.Date;

/**
 * Transaction class representing a movie rental transaction
 * Updated with additional properties for CRUD operations
 */
public class Transaction {
    private String transactionId;
    private String userId;
    private String movieId;
    private Date rentalDate;
    private Date dueDate;
    private Date returnDate;
    private double rentalFee;
    private double lateFee;
    private boolean returned;
    private boolean canceled;
    private String cancellationReason;
    private Date cancellationDate;

    // Constructor with all fields
    public Transaction(String transactionId, String userId, String movieId, Date rentalDate,
                       Date dueDate, Date returnDate, double rentalFee, double lateFee,
                       boolean returned, boolean canceled, String cancellationReason, Date cancellationDate) {
        this.transactionId = transactionId;
        this.userId = userId;
        this.movieId = movieId;
        this.rentalDate = rentalDate;
        this.dueDate = dueDate;
        this.returnDate = returnDate;
        this.rentalFee = rentalFee;
        this.lateFee = lateFee;
        this.returned = returned;
        this.canceled = canceled;
        this.cancellationReason = cancellationReason;
        this.cancellationDate = cancellationDate;
    }

    // Constructor without return date and late fee (for new rentals)
    public Transaction(String transactionId, String userId, String movieId, Date rentalDate,
                       Date dueDate, double rentalFee) {
        this.transactionId = transactionId;
        this.userId = userId;
        this.movieId = movieId;
        this.rentalDate = rentalDate;
        this.dueDate = dueDate;
        this.rentalFee = rentalFee;
        this.returnDate = null;
        this.lateFee = 0.0;
        this.returned = false;
        this.canceled = false;
        this.cancellationReason = null;
        this.cancellationDate = null;
    }

    // Default constructor
    public Transaction() {
        this.transactionId = "";
        this.userId = "";
        this.movieId = "";
        this.rentalDate = new Date();
        this.dueDate = new Date();
        this.returnDate = null;
        this.rentalFee = 0.0;
        this.lateFee = 0.0;
        this.returned = false;
        this.canceled = false;
        this.cancellationReason = null;
        this.cancellationDate = null;
    }

    // Getters and Setters
    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getMovieId() {
        return movieId;
    }

    public void setMovieId(String movieId) {
        this.movieId = movieId;
    }

    public Date getRentalDate() {
        return rentalDate;
    }

    public void setRentalDate(Date rentalDate) {
        this.rentalDate = rentalDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public double getRentalFee() {
        return rentalFee;
    }

    public void setRentalFee(double rentalFee) {
        this.rentalFee = rentalFee;
    }

    public double getLateFee() {
        return lateFee;
    }

    public void setLateFee(double lateFee) {
        this.lateFee = lateFee;
    }

    public boolean isReturned() {
        return returned;
    }

    public void setReturned(boolean returned) {
        this.returned = returned;
    }

    public boolean isCanceled() {
        return canceled;
    }

    public void setCanceled(boolean canceled) {
        this.canceled = canceled;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }

    public Date getCancellationDate() {
        return cancellationDate;
    }

    public void setCancellationDate(Date cancellationDate) {
        this.cancellationDate = cancellationDate;
    }

    // Calculate days overdue if the movie is late
    public int calculateDaysOverdue() {
        if (returned && returnDate != null && returnDate.after(dueDate)) {
            long diffInMillies = returnDate.getTime() - dueDate.getTime();
            return (int) (diffInMillies / (1000 * 60 * 60 * 24)) + 1; // +1 to include the due date
        }
        return 0;
    }

    // Calculate days remaining in the rental period
    public int calculateDaysRemaining() {
        if (returned || canceled) {
            return 0;
        }

        Date currentDate = new Date();
        if (currentDate.after(dueDate)) {
            return 0; // No days remaining, already overdue
        }

        long diffInMillies = dueDate.getTime() - currentDate.getTime();
        return (int) (diffInMillies / (1000 * 60 * 60 * 24)) + 1; // +1 to include today
    }

    // Get rental duration in days
    public int getRentalDuration() {
        long diffInMillies = dueDate.getTime() - rentalDate.getTime();
        return (int) (diffInMillies / (1000 * 60 * 60 * 24)) + 1; // +1 to include the start date
    }

    // Check if the rental is currently overdue
    public boolean isOverdue() {
        if (returned || canceled) {
            return false;
        }
        return new Date().after(dueDate);
    }

    // Check if the rental is active (not returned and not canceled)
    public boolean isActive() {
        return !returned && !canceled;
    }

    // Convert transaction to string representation for file storage
    public String toFileString() {
        return transactionId + "," +
                userId + "," +
                movieId + "," +
                rentalDate.getTime() + "," +
                dueDate.getTime() + "," +
                (returnDate != null ? returnDate.getTime() : "0") + "," +
                rentalFee + "," +
                lateFee + "," +
                returned + "," +
                canceled + "," +
                (cancellationReason != null ? cancellationReason.replace(",", "\\,") : "") + "," +
                (cancellationDate != null ? cancellationDate.getTime() : "0");
    }

    // Create transaction from string representation (from file)
    public static Transaction fromFileString(String fileString) {
        String[] parts = fileString.split(",(?=([^\\\\]|\\\\[^,])*$)", -1); // Split by comma, accounting for escaped commas

        Transaction transaction = new Transaction();

        if (parts.length >= 9) {
            transaction.setTransactionId(parts[0]);
            transaction.setUserId(parts[1]);
            transaction.setMovieId(parts[2]);
            transaction.setRentalDate(new Date(Long.parseLong(parts[3])));
            transaction.setDueDate(new Date(Long.parseLong(parts[4])));

            long returnDateLong = Long.parseLong(parts[5]);
            if (returnDateLong > 0) {
                transaction.setReturnDate(new Date(returnDateLong));
            }

            transaction.setRentalFee(Double.parseDouble(parts[6]));
            transaction.setLateFee(Double.parseDouble(parts[7]));
            transaction.setReturned(Boolean.parseBoolean(parts[8]));

            // Handle additional fields if they exist
            if (parts.length >= 10) {
                transaction.setCanceled(Boolean.parseBoolean(parts[9]));
            }

            if (parts.length >= 11) {
                String reason = parts[10];
                if (!reason.isEmpty()) {
                    transaction.setCancellationReason(reason.replace("\\,", ","));
                }
            }

            if (parts.length >= 12) {
                long cancelDateLong = Long.parseLong(parts[11]);
                if (cancelDateLong > 0) {
                    transaction.setCancellationDate(new Date(cancelDateLong));
                }
            }

            return transaction;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Transaction{" +
                "transactionId='" + transactionId + '\'' +
                ", userId='" + userId + '\'' +
                ", movieId='" + movieId + '\'' +
                ", rentalDate=" + rentalDate +
                ", dueDate=" + dueDate +
                ", returnDate=" + returnDate +
                ", rentalFee=" + rentalFee +
                ", lateFee=" + lateFee +
                ", returned=" + returned +
                ", canceled=" + canceled +
                ", cancellationReason='" + cancellationReason + '\'' +
                ", cancellationDate=" + cancellationDate +
                '}';
    }
}