package com.movierental.model.watchlist;

import java.util.Date;

/**
 * Watchlist class representing a movie in a user's watchlist
 */
public class Watchlist {
    private String watchlistId;
    private String userId;
    private String movieId;
    private Date addedDate;
    private boolean watched;
    private Date watchedDate;    // will be null if not watched
    private int priority;        // 1-5, with 1 being highest priority
    private String notes;        // optional user notes

    // Constructor with all fields
    public Watchlist(String watchlistId, String userId, String movieId, Date addedDate,
                     boolean watched, Date watchedDate, int priority, String notes) {
        this.watchlistId = watchlistId;
        this.userId = userId;
        this.movieId = movieId;
        this.addedDate = addedDate;
        this.watched = watched;
        this.watchedDate = watchedDate;
        this.priority = priority;
        this.notes = notes;
    }

    // Constructor for adding a new unwatched movie
    public Watchlist(String watchlistId, String userId, String movieId, int priority, String notes) {
        this.watchlistId = watchlistId;
        this.userId = userId;
        this.movieId = movieId;
        this.addedDate = new Date();
        this.watched = false;
        this.watchedDate = null;
        this.priority = priority;
        this.notes = notes;
    }

    // Default constructor
    public Watchlist() {
        this.watchlistId = "";
        this.userId = "";
        this.movieId = "";
        this.addedDate = new Date();
        this.watched = false;
        this.watchedDate = null;
        this.priority = 3;  // default medium priority
        this.notes = "";
    }

    // Getters and setters
    public String getWatchlistId() {
        return watchlistId;
    }

    public void setWatchlistId(String watchlistId) {
        this.watchlistId = watchlistId;
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

    public Date getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(Date addedDate) {
        this.addedDate = addedDate;
    }

    public boolean isWatched() {
        return watched;
    }

    public void setWatched(boolean watched) {
        this.watched = watched;
        // Update watched date if marked as watched
        if (watched && this.watchedDate == null) {
            this.watchedDate = new Date();
        } else if (!watched) {
            this.watchedDate = null;
        }
    }

    public Date getWatchedDate() {
        return watchedDate;
    }

    public void setWatchedDate(Date watchedDate) {
        this.watchedDate = watchedDate;
        // Update watched flag if date is set
        this.watched = (watchedDate != null);
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        // Ensure priority is within range
        if (priority < 1) {
            this.priority = 1;
        } else if (priority > 5) {
            this.priority = 5;
        } else {
            this.priority = priority;
        }
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // Mark movie as watched
    public void markAsWatched() {
        this.watched = true;
        this.watchedDate = new Date();
    }

    // Convert to a string representation for file storage
    public String toFileString() {
        return watchlistId + "," +
                userId + "," +
                movieId + "," +
                addedDate.getTime() + "," +
                watched + "," +
                (watchedDate != null ? watchedDate.getTime() : "0") + "," +
                priority + "," +
                (notes != null ? notes.replace(",", "\\,") : "");
    }

    // Create Watchlist from string representation (from file)
    public static Watchlist fromFileString(String fileString) {
        String[] parts = fileString.split(",", 8); // Limit to 8 parts as notes may contain commas

        if (parts.length >= 7) {
            Watchlist watchlist = new Watchlist();
            watchlist.setWatchlistId(parts[0]);
            watchlist.setUserId(parts[1]);
            watchlist.setMovieId(parts[2]);
            watchlist.setAddedDate(new Date(Long.parseLong(parts[3])));
            watchlist.setWatched(Boolean.parseBoolean(parts[4]));

            long watchedDateLong = Long.parseLong(parts[5]);
            if (watchedDateLong > 0) {
                watchlist.setWatchedDate(new Date(watchedDateLong));
            } else {
                watchlist.setWatchedDate(null);
            }

            watchlist.setPriority(Integer.parseInt(parts[6]));

            if (parts.length > 7) {
                watchlist.setNotes(parts[7].replace("\\,", ","));
            } else {
                watchlist.setNotes("");
            }

            return watchlist;
        }

        return null;
    }
}