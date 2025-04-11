<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.watchlist.Watchlist" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Watchlist - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --neon-blue: #00c8ff;
            --neon-purple: #8a2be2;
            --neon-pink: #ff00ff;
            --dark-bg: #121212;
            --card-bg: #1e1e1e;
            --card-secondary: #2d2d2d;
            --text-primary: #e0e0e0;
            --text-secondary: #aaaaaa;
            --input-bg: #333;
            --input-border: #444;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding-bottom: 60px;
            background-image:
                radial-gradient(circle at 90% 10%, rgba(0, 200, 255, 0.15) 0%, transparent 30%),
                radial-gradient(circle at 10% 90%, rgba(255, 0, 255, 0.1) 0%, transparent 30%);
        }

        .navbar {
            background-color: rgba(30, 30, 30, 0.8);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #333;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-weight: bold;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            font-size: 1.5rem;
        }

        .nav-link {
            color: var(--text-primary);
            margin: 0 10px;
            position: relative;
        }

        .nav-link:hover {
            color: var(--neon-blue);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            bottom: 0;
            left: 0;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            transform: scaleX(0);
            transform-origin: bottom right;
            transition: transform 0.3s;
        }

        .nav-link:hover::after {
            transform: scaleX(1);
            transform-origin: bottom left;
        }

        .container {
            margin-top: 30px;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid #333;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .card-header {
            background-color: var(--card-secondary);
            color: var(--neon-blue);
            font-weight: 600;
            border-bottom: 1px solid #444;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-header i {
            margin-right: 10px;
            color: var(--neon-purple);
            font-size: 1.2rem;
        }

        .card-header .actions {
            display: flex;
            gap: 10px;
        }

        .btn-neon {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        .btn-neon:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(0, 200, 255, 0.6);
            color: white;
        }

        .btn-outline-neon {
            background: transparent;
            border: 1px solid var(--neon-blue);
            color: var(--neon-blue);
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            border-radius: 8px;
        }

        .btn-outline-neon:hover {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            color: white;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 0.85rem;
        }

        .alert-success {
            background-color: rgba(0, 51, 0, 0.7);
            color: #66ff66;
            border-color: #005500;
            border-radius: 8px;
        }

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        .alert-info {
            background-color: rgba(0, 0, 51, 0.7);
            color: #6666ff;
            border-color: #000055;
            border-radius: 8px;
        }

        .filter-bar {
            background-color: rgba(30, 30, 30, 0.7);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid #333;
        }

        .filter-label {
            color: var(--neon-blue);
            font-weight: 600;
            margin-right: 10px;
        }

        .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 8px 15px;
        }

        .form-select:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
        }

        .stats-card {
            text-align: center;
            padding: 15px;
            border-radius: 12px;
            background-color: rgba(30, 30, 30, 0.5);
            border: 1px solid #333;
            height: 100%;
            transition: all 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            background-color: rgba(40, 40, 40, 0.7);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: block;
            margin-bottom: 5px;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .watchlist-item {
            background-color: rgba(30, 30, 30, 0.5);
            border: 1px solid #333;
            border-radius: 12px;
            margin-bottom: 15px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .watchlist-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .watchlist-header {
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #333;
            background-color: rgba(0, 200, 255, 0.05);
        }

        .movie-poster-small {
            width: 50px;
            height: 70px;
            background: linear-gradient(135deg, #333, #222);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 5px;
            color: #555;
            font-size: 1.5rem;
            margin-right: 15px;
        }

        .movie-info {
            flex-grow: 1;
        }

        .movie-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 2px;
        }

        .movie-details {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .movie-priority {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .priority-badge {
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .priority-1 {
            background: linear-gradient(to right, #D50000, #FF1744);
            color: white;
        }

        .priority-2 {
            background: linear-gradient(to right, #FF6D00, #FF9100);
            color: white;
        }

        .priority-3 {
            background: linear-gradient(to right, #FFAB00, #FFD740);
            color: black;
        }

        .priority-4 {
            background: linear-gradient(to right, #00C853, #69F0AE);
            color: black;
        }

        .priority-5 {
            background: linear-gradient(to right, #2979FF, #82B1FF);
            color: white;
        }

        .watchlist-body {
            padding: 15px;
        }

        .watchlist-notes {
            margin-bottom: 15px;
            color: var(--text-primary);
            background-color: rgba(30, 30, 30, 0.5);
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #444;
        }

        .date-info {
            display: flex;
            justify-content: space-between;
            color: var(--text-secondary);
            font-size: 0.85rem;
            margin-bottom: 15px;
        }

        .watched-status {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 10px;
        }

        .watched {
            background: linear-gradient(to right, #4CAF50, #8BC34A);
            color: white;
        }

        .unwatched {
            background: linear-gradient(to right, #FF5722, #FF9800);
            color: white;
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
        }

        .action-button {
            padding: 8px 15px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }

        .action-button i {
            margin-right: 5px;
        }

        .btn-manage {
            background-color: var(--neon-blue);
            color: white;
        }

        .btn-manage:hover {
            background-color: #0099cc;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            color: white;
        }

        .btn-remove {
            background-color: #d32f2f;
            color: white;
        }

        .btn-remove:hover {
            background-color: #b71c1c;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            color: white;
        }

        .empty-watchlist {
            text-align: center;
            padding: 40px 20px;
        }

        .empty-watchlist i {
            font-size: 3rem;
            color: #444;
            margin-bottom: 15px;
        }

        .empty-message {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .recently-watched {
            padding: 15px;
        }

        .recently-watched-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--neon-blue);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .recently-watched-title i {
            margin-right: 10px;
            color: var(--neon-purple);
        }

        .recent-movie {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 8px;
            background-color: rgba(30, 30, 30, 0.5);
            border: 1px solid #333;
            transition: all 0.2s;
        }

        .recent-movie:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            background-color: rgba(40, 40, 40, 0.7);
        }

        .recent-movie-title {
            flex-grow: 1;
        }

        .recent-date {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }
    </style>
</head>
<body>
    <%
        // Get user from session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get data from request attributes - with null safety
        List<Watchlist> watchlist = (List<Watchlist>) request.getAttribute("watchlist");
        if (watchlist == null) watchlist = new ArrayList<>();

        Map<String, Movie> movieMap = (Map<String, Movie>) request.getAttribute("movieMap");
        if (movieMap == null) movieMap = new HashMap<>();

        String filter = (String) request.getAttribute("filter");
        if (filter == null) filter = "all";

        String sort = (String) request.getAttribute("sort");
        if (sort == null) sort = "priority";

        // Use safe defaults for the statistics
        Integer totalCountObj = (Integer) request.getAttribute("totalCount");
        int totalCount = (totalCountObj != null) ? totalCountObj : 0;

        Integer unwatchedCountObj = (Integer) request.getAttribute("unwatchedCount");
        int unwatchedCount = (unwatchedCountObj != null) ? unwatchedCountObj : 0;

        Integer watchedCountObj = (Integer) request.getAttribute("watchedCount");
        int watchedCount = (watchedCountObj != null) ? watchedCountObj : 0;

        List<String> recentMovieIds = (List<String>) request.getAttribute("recentMovieIds");
        if (recentMovieIds == null) recentMovieIds = new ArrayList<>();

        // Date formatter
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    %>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/">FilmFlux</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/">
                            <i class="bi bi-house-fill"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/search-movie">
                            <i class="bi bi-film"></i> Movies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/rental-history">
                            <i class="bi bi-collection-play"></i> My Rentals
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/view-watchlist">
                            <i class="bi bi-bookmark-star"></i> Watchlist
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/user/profile.jsp">
                            <i class="bi bi-person-circle"></i> <%= user.getUsername() %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Flash messages -->
        <%
            // Check for messages from session
            String successMessage = (String) request.getSession().getAttribute("successMessage");
            String errorMessage = (String) request.getSession().getAttribute("errorMessage");
            String infoMessage = (String) request.getSession().getAttribute("infoMessage");

            if(successMessage != null) {
                out.println("<div class='alert alert-success'>");
                out.println("<i class='bi bi-check-circle-fill me-2'></i>");
                out.println(successMessage);
                out.println("</div>");
                request.getSession().removeAttribute("successMessage");
            }

            if(errorMessage != null) {
                out.println("<div class='alert alert-danger'>");
                out.println("<i class='bi bi-exclamation-triangle-fill me-2'></i>");
                out.println(errorMessage);
                out.println("</div>");
                request.getSession().removeAttribute("errorMessage");
            }

            if(infoMessage != null) {
                out.println("<div class='alert alert-info'>");
                out.println("<i class='bi bi-info-circle-fill me-2'></i>");
                out.println(infoMessage);
                out.println("</div>");
                request.getSession().removeAttribute("infoMessage");
            }
        %>

        <!-- Watchlist Stats -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= totalCount %></span>
                    <span class="stat-label">Total Movies</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= unwatchedCount %></span>
                    <span class="stat-label">Unwatched</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= watchedCount %></span>
                    <span class="stat-label">Watched</span>
                </div>
            </div>
        </div>

        <!-- Filter and Sort Bar -->
        <div class="filter-bar d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <span class="filter-label">Filter:</span>
                <select class="form-select me-3" id="filterSelect">
                    <option value="all" <%= "all".equals(filter) ? "selected" : "" %>>All Movies</option>
                    <option value="unwatched" <%= "unwatched".equals(filter) ? "selected" : "" %>>Unwatched</option>
                    <option value="watched" <%= "watched".equals(filter) ? "selected" : "" %>>Watched</option>
                </select>

                <span class="filter-label">Sort:</span>
                <select class="form-select" id="sortSelect">
                    <option value="priority" <%= "priority".equals(sort) ? "selected" : "" %>>Priority</option>
                    <option value="added-desc" <%= "added-desc".equals(sort) ? "selected" : "" %>>Recently Added</option>
                    <option value="added-asc" <%= "added-asc".equals(sort) ? "selected" : "" %>>Oldest Added</option>
                </select>
            </div>

            <div>
                <a href="<%= request.getContextPath() %>/recently-watched" class="btn btn-outline-neon">
                    <i class="bi bi-clock-history"></i> Recently Watched
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="row">
            <!-- Watchlist -->
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <i class="bi bi-bookmark-star"></i> My Watchlist
                        </div>
                    </div>
                    <div class="card-body p-3">
                        <% if (watchlist == null || watchlist.isEmpty()) { %>
                            <div class="empty-watchlist">
                                <i class="bi bi-bookmark"></i>
                                <p class="empty-message">Your watchlist is empty.</p>
                                <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-neon">
                                    <i class="bi bi-search"></i> Browse Movies
                                </a>
                            </div>
                        <% } else { %>
                            <% for (Watchlist item : watchlist) {
                                Movie movie = movieMap.get(item.getMovieId());
                                if (movie != null) {
                                    String priorityClass = "priority-" + item.getPriority();
                                    String priorityText = "";

                                    switch(item.getPriority()) {
                                        case 1: priorityText = "Highest"; break;
                                        case 2: priorityText = "High"; break;
                                        case 3: priorityText = "Medium"; break;
                                        case 4: priorityText = "Low"; break;
                                        case 5: priorityText = "Lowest"; break;
                                    }
                            %>
                                <div class="watchlist-item">
                                    <div class="watchlist-header">
                                        <div class="d-flex align-items-center flex-grow-1">
                                            <div class="movie-poster-small">
                                                <i class="bi bi-film"></i>
                                            </div>
                                            <div class="movie-info">
                                                <div class="movie-title">
                                                    <%= movie.getTitle() %>
                                                    <% if (item.isWatched()) { %>
                                                        <span class="watched-status watched"><i class="bi bi-check-circle-fill"></i> Watched</span>
                                                    <% } else { %>
                                                        <span class="watched-status unwatched"><i class="bi bi-clock"></i> Unwatched</span>
                                                    <% } %>
                                                </div>
                                                <div class="movie-details">
                                                    <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="movie-priority">
                                            <span class="priority-badge <%= priorityClass %>">
                                                <%= priorityText %> Priority
                                            </span>
                                        </div>
                                    </div>
                                    <div class="watchlist-body">
                                        <% if (item.getNotes() != null && !item.getNotes().isEmpty()) { %>
                                            <div class="watchlist-notes">
                                                <strong>Notes:</strong> <%= item.getNotes() %>
                                            </div>
                                        <% } %>

                                        <div class="date-info">
                                            <div>Added: <%= dateFormat.format(item.getAddedDate()) %></div>
                                            <% if (item.isWatched() && item.getWatchedDate() != null) { %>
                                                <div>Watched: <%= dateFormat.format(item.getWatchedDate()) %></div>
                                            <% } %>
                                        </div>

                                        <div class="action-buttons">
                                            <a href="<%= request.getContextPath() %>/manage-watchlist?id=<%= item.getWatchlistId() %>" class="action-button btn-manage">
                                                <i class="bi bi-pencil-square"></i> Manage
                                            </a>
                                            <a href="<%= request.getContextPath() %>/remove-from-watchlist?id=<%= item.getWatchlistId() %>" class="action-button btn-remove">
                                                <i class="bi bi-trash"></i> Remove
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            <%
                                }
                            } %>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Recently Watched -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <i class="bi bi-clock-history"></i> Recently Watched
                        </div>
                        <div class="actions">
                            <a href="<%= request.getContextPath() %>/recently-watched" class="btn btn-sm btn-outline-neon">
                                View All
                            </a>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="recently-watched">
                            <% if (recentMovieIds == null || recentMovieIds.isEmpty()) { %>
                                <div class="text-center p-4">
                                    <i class="bi bi-clock" style="font-size: 2rem; color: #444;"></i>
                                    <p class="mt-3 text-secondary">No recently watched movies</p>
                                </div>
                            <% } else {
                                // Display only first 5 recent movies
                                int displayCount = Math.min(5, recentMovieIds.size());
                                for (int i = 0; i < displayCount; i++) {
                                    String movieId = recentMovieIds.get(i);
                                    Movie movie = movieMap.get(movieId);
                                    if (movie != null) {
                            %>
                                <div class="recent-movie">
                                    <div class="movie-poster-small">
                                        <i class="bi bi-film"></i>
                                    </div>
                                    <div class="recent-movie-title">
                                        <%= movie.getTitle() %>
                                    </div>
                                </div>
                            <%
                                    }
                                }
                            %>
                                <div class="text-center mt-3 mb-3">
                                    <a href="<%= request.getContextPath() %>/recently-watched" class="btn btn-sm btn-neon">
                                        <i class="bi bi-list"></i> See All
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Handle filter and sort changes
        document.addEventListener('DOMContentLoaded', function() {
            const filterSelect = document.getElementById('filterSelect');
            const sortSelect = document.getElementById('sortSelect');

            filterSelect.addEventListener('change', updateFilters);
            sortSelect.addEventListener('change', updateFilters);

            function updateFilters() {
                const filter = filterSelect.value;
                const sort = sortSelect.value;
                window.location.href = '<%= request.getContextPath() %>/view-watchlist?filter=' + filter + '&sort=' + sort;
            }
        });
    </script>
    </body>
    </html>