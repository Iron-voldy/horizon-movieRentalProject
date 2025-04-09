package com.movierental.model.watchlist;

import java.io.*;
import java.util.*;
import javax.servlet.ServletContext;
import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;

public class WatchlistManager {
    private static final String WATCHLIST_FILE_NAME = "watchlists.txt";
    private static final String RECENTLY_WATCHED_FILE_NAME = "recently_watched.txt";

    private String watchlistFilePath;
    private String recentlyWatchedFilePath;
    private List<Watchlist> watchlists;
    private Map<String, RecentlyWatched> recentlyWatchedMap;
    private ServletContext servletContext;

    // Default constructor
    public WatchlistManager() {
        this(null);
    }

    // Constructor with ServletContext
    public WatchlistManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        watchlists = new ArrayList<>();
        recentlyWatchedMap = new HashMap<>();
        initializeFilePaths();
        loadWatchlists();
        loadRecentlyWatched();
    }

    // Initialize file paths
    private void initializeFilePaths() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            watchlistFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + WATCHLIST_FILE_NAME;
            recentlyWatchedFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + RECENTLY_WATCHED_FILE_NAME;

            // Ensure directories exist
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            watchlistFilePath = dataPath + File.separator + WATCHLIST_FILE_NAME;
            recentlyWatchedFilePath = dataPath + File.separator + RECENTLY_WATCHED_FILE_NAME;

            // Ensure directories exist
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("WatchlistManager: Using watchlist file path: " + watchlistFilePath);
        System.out.println("WatchlistManager: Using recently watched file path: " + recentlyWatchedFilePath);
    }

    // Load watchlists from file
    private void loadWatchlists() {
        File file = new File(watchlistFilePath);

        // Create directory if it doesn't exist
        if (file.getParentFile() != null && !file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created new watchlists file: " + watchlistFilePath);
            } catch (IOException e) {
                System.err.println("Error creating watchlists file: " + e.getMessage());
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

                Watchlist watchlist = Watchlist.fromFileString(line);
                if (watchlist != null) {
                    watchlists.add(watchlist);
                }
            }
            System.out.println("Loaded " + watchlists.size() + " watchlist entries");
        } catch (IOException e) {
            System.err.println("Error loading watchlists: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save watchlists to file
    private void saveWatchlists() {
        try {
            // Ensure parent directory exists
            File file = new File(watchlistFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(watchlistFilePath))) {
                for (Watchlist watchlist : watchlists) {
                    writer.write(watchlist.toFileString());
                    writer.newLine();
                }
            }
            System.out.println("Saved " + watchlists.size() + " watchlist entries to " + watchlistFilePath);
        } catch (IOException e) {
            System.err.println("Error saving watchlists: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Load recently watched from file
    private void loadRecentlyWatched() {
        File file = new File(recentlyWatchedFilePath);

        // Create directory if it doesn't exist
        if (file.getParentFile() != null && !file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created new recently watched file: " + recentlyWatchedFilePath);
            } catch (IOException e) {
                System.err.println("Error creating recently watched file: " + e.getMessage());
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

                RecentlyWatched recentlyWatched = RecentlyWatched.fromFileString(line);
                if (recentlyWatched != null) {
                    recentlyWatchedMap.put(extractUserIdFromLine(line), recentlyWatched);
                }
            }
            System.out.println("Loaded " + recentlyWatchedMap.size() + " recently watched entries");
        } catch (IOException e) {
            System.err.println("Error loading recently watched: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Helper method to extract user ID from file line
    private String extractUserIdFromLine(String line) {
        String[] parts = line.split(",");
        return parts.length > 0 ? parts[0] : null;
    }

    // Save recently watched to file
    private void saveRecentlyWatched() {
        try {
            // Ensure parent directory exists
            File file = new File(recentlyWatchedFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(recentlyWatchedFilePath))) {
                for (RecentlyWatched recentlyWatched : recentlyWatchedMap.values()) {
                    writer.write(recentlyWatched.toFileString());
                    writer.newLine();
                }
            }
            System.out.println("Saved " + recentlyWatchedMap.size() + " recently watched entries");
        } catch (IOException e) {
            System.err.println("Error saving recently watched: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Add to watchlist
    public Watchlist addToWatchlist(String userId, String movieId, int priority, String notes) {
        // Check if movie exists - use the MovieManager with ServletContext
        MovieManager movieManager = (servletContext != null) ?
                new MovieManager(servletContext) :
                new MovieManager();
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            System.out.println("Movie not found: " + movieId);
            return null; // Movie doesn't exist
        }

        // Check if already in watchlist
        for (Watchlist existingWatchlist : watchlists) {
            if (existingWatchlist.getUserId().equals(userId) &&
                    existingWatchlist.getMovieId().equals(movieId)) {
                System.out.println("Movie already in watchlist");
                return existingWatchlist; // Already in watchlist
            }
        }

        // Create a new watchlist entry
        Watchlist watchlist = new Watchlist();
        watchlist.setWatchlistId(UUID.randomUUID().toString());
        watchlist.setUserId(userId);
        watchlist.setMovieId(movieId);
        watchlist.setAddedDate(new Date());
        watchlist.setWatched(false);
        watchlist.setWatchedDate(null);
        watchlist.setPriority(priority);
        watchlist.setNotes(notes);

        // Add to list and save
        watchlists.add(watchlist);
        saveWatchlists();

        System.out.println("Added to watchlist successfully");
        return watchlist;
    }

    // Get watchlist by user ID
    public List<Watchlist> getWatchlistByUser(String userId) {
        List<Watchlist> userWatchlist = new ArrayList<>();

        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId)) {
                userWatchlist.add(watchlist);
            }
        }

        return userWatchlist;
    }

    // Get unwatched movies by user
    public List<Watchlist> getUnwatchedByUser(String userId) {
        List<Watchlist> unwatched = new ArrayList<>();

        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && !watchlist.isWatched()) {
                unwatched.add(watchlist);
            }
        }

        return unwatched;
    }

    // Get watched movies by user
    public List<Watchlist> getWatchedByUser(String userId) {
        List<Watchlist> watched = new ArrayList<>();

        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.isWatched()) {
                watched.add(watchlist);
            }
        }

        return watched;
    }

    // Check if movie is in user's watchlist
    public boolean isInWatchlist(String userId, String movieId) {
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.getMovieId().equals(movieId)) {
                return true;
            }
        }

        return false;
    }

    // Get watchlist by ID
    public Watchlist getWatchlistById(String watchlistId) {
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getWatchlistId().equals(watchlistId)) {
                return watchlist;
            }
        }

        return null;
    }

    // Get watchlist by user and movie
    public Watchlist getWatchlistByUserAndMovie(String userId, String movieId) {
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.getMovieId().equals(movieId)) {
                return watchlist;
            }
        }

        return null;
    }

    // Update watchlist
    public boolean updateWatchlist(Watchlist watchlist) {
        for (int i = 0; i < watchlists.size(); i++) {
            if (watchlists.get(i).getWatchlistId().equals(watchlist.getWatchlistId())) {
                watchlists.set(i, watchlist);
                saveWatchlists();
                return true;
            }
        }

        return false;
    }

    // Mark as watched
    public boolean markAsWatched(String watchlistId) {
        Watchlist watchlist = getWatchlistById(watchlistId);

        if (watchlist == null) {
            return false;
        }

        watchlist.markAsWatched();
        saveWatchlists();

        // Add to recently watched
        addToRecentlyWatched(watchlist.getUserId(), watchlist.getMovieId());

        return true;
    }

    // Remove from watchlist by watchlist ID
    public boolean removeFromWatchlist(String watchlistId) {
        for (int i = 0; i < watchlists.size(); i++) {
            if (watchlists.get(i).getWatchlistId().equals(watchlistId)) {
                watchlists.remove(i);
                saveWatchlists();
                return true;
            }
        }

        return false;
    }

    // Remove from watchlist by user ID and movie ID
    public boolean removeFromWatchlist(String userId, String movieId) {
        for (int i = 0; i < watchlists.size(); i++) {
            if (watchlists.get(i).getUserId().equals(userId) &&
                    watchlists.get(i).getMovieId().equals(movieId)) {
                watchlists.remove(i);
                saveWatchlists();
                return true;
            }
        }

        return false;
    }

    // Get recently watched for a user
    public RecentlyWatched getRecentlyWatched(String userId) {
        if (recentlyWatchedMap.containsKey(userId)) {
            return recentlyWatchedMap.get(userId);
        } else {
            // Create new entry if doesn't exist
            RecentlyWatched recentlyWatched = new RecentlyWatched(userId);
            recentlyWatchedMap.put(userId, recentlyWatched);
            saveRecentlyWatched();
            return recentlyWatched;
        }
    }

    // Add to recently watched
    public void addToRecentlyWatched(String userId, String movieId) {
        RecentlyWatched recentlyWatched = getRecentlyWatched(userId);
        recentlyWatched.addMovie(movieId);
        saveRecentlyWatched();
    }

    // Clear recently watched for a user
    public void clearRecentlyWatched(String userId) {
        if (recentlyWatchedMap.containsKey(userId)) {
            recentlyWatchedMap.get(userId).clear();
            saveRecentlyWatched();
        }
    }

    // Get all watchlists
    public List<Watchlist> getAllWatchlists() {
        return new ArrayList<>(watchlists);
    }

    // Sort watchlists by priority
    public List<Watchlist> sortByPriority(List<Watchlist> watchlistToSort) {
        List<Watchlist> sorted = new ArrayList<>(watchlistToSort);
        Collections.sort(sorted, new Comparator<Watchlist>() {
            @Override
            public int compare(Watchlist w1, Watchlist w2) {
                return Integer.compare(w1.getPriority(), w2.getPriority());
            }
        });
        return sorted;
    }

    // Sort watchlists by date added
    public List<Watchlist> sortByDateAdded(List<Watchlist> watchlistToSort, boolean ascending) {
        List<Watchlist> sorted = new ArrayList<>(watchlistToSort);
        Collections.sort(sorted, new Comparator<Watchlist>() {
            @Override
            public int compare(Watchlist w1, Watchlist w2) {
                return ascending ?
                        w1.getAddedDate().compareTo(w2.getAddedDate()) :
                        w2.getAddedDate().compareTo(w1.getAddedDate());
            }
        });
        return sorted;
    }

    // Get total watchlist count for a user
    public int getWatchlistCount(String userId) {
        int count = 0;
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId)) {
                count++;
            }
        }
        return count;
    }

    // Get unwatched count for a user
    public int getUnwatchedCount(String userId) {
        int count = 0;
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && !watchlist.isWatched()) {
                count++;
            }
        }
        return count;
    }

    // Get watched count for a user
    public int getWatchedCount(String userId) {
        int count = 0;
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.isWatched()) {
                count++;
            }
        }
        return count;
    }

    // Set ServletContext (can be used to update the context after initialization)
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePaths();
        // Reload data with the new file paths
        watchlists.clear();
        recentlyWatchedMap.clear();
        loadWatchlists();
        loadRecentlyWatched();
    }
}