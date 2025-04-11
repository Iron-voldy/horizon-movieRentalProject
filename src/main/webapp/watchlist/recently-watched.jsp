<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.watchlist.RecentlyWatched" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recently Watched Movies - Movie Rental System</title>
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

        .btn-secondary {
            background-color: #444;
            border: none;
        }

        .btn-secondary:hover {
            background-color: #555;
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

        .btn-danger {
            background: linear-gradient(to right, #F44336, #FF5722);
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(244, 67, 54, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(244, 67, 54, 0.6);
            color: white;
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

        .timeline-container {
            margin-top: 20px;
        }

        .timeline {
            position: relative;
            padding-left: 60px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 30px;
            width: 2px;
            background: linear-gradient(to bottom, var(--neon-blue), var(--neon-purple));
        }

        .timeline-item {
            position: relative;
            margin-bottom: 30px;
            padding-bottom: 30px;
        }

        .timeline-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .timeline-date {
            position: absolute;
            left: -60px;
            width: 60px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 0.9rem;
            background-color: var(--card-bg);
            padding: 5px 0;
            border-radius: 5px;
        }

        .timeline-dot {
            position: absolute;
            left: -35px;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            box-shadow: 0 0 10px rgba(0, 200, 255, 0.5);
        }

        .timeline-content {
            background-color: rgba(30, 30, 30, 0.5);
            border: 1px solid #333;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .timeline-content:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            background-color: rgba(40, 40, 40, 0.7);
        }

        .movie-info {
            display: flex;
            align-items: center;
        }

        .movie-poster-small {
            width: 60px;
            height: 90px;
            background: linear-gradient(135deg, #333, #222);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 5px;
            color: #555;
            font-size: 1.5rem;
            margin-right: 15px;
            flex-shrink: 0;
        }

        .movie-details {
            flex-grow: 1;
        }

        .movie-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 2px;
            font-size: 1.2rem;
        }

        .movie-subtitle {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .date-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-top: 5px;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            color: white;
        }

        .action-buttons {
            display: flex;
            justify-content: flex-end;
            margin-top: 15px;
            gap: 10px;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 0.85rem;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
        }

        .empty-state i {
            font-size: 4rem;
            color: #444;
            margin-bottom: 20px;
        }

        .empty-message {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .stats-row {
            margin-bottom: 30px;
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
    </style>
</head>
<body>
    <%
        // Get user from session
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get data from request attributes
        RecentlyWatched recentlyWatched = (RecentlyWatched) request.getAttribute("recentlyWatched");
        List<String> movieIds = (recentlyWatched != null) ? recentlyWatched.getMovieIds() : null;
        List<Date> watchDates = (recentlyWatched != null) ? recentlyWatched.getWatchDates() : null;
        Map<String, Movie> movieMap = (Map<String, Movie>) request.getAttribute("movieMap");

        // Date formatter
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
        SimpleDateFormat monthFormat = new SimpleDateFormat("MMM");
        SimpleDateFormat dayFormat = new SimpleDateFormat("dd");

        // Calculate stats if data is available
        int totalWatched = (movieIds != null) ? movieIds.size() : 0;
        int thisMonth = 0;
        int thisWeek = 0;

        if (movieIds != null && watchDates != null) {
            Date now = new Date();
            // Current month and week calculation
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(now);
            int currentMonth = cal.get(java.util.Calendar.MONTH);
            int currentWeek = cal.get(java.util.Calendar.WEEK_OF_YEAR);

            for (Date date : watchDates) {
                cal.setTime(date);
                // Count this month
                if (cal.get(java.util.Calendar.MONTH) == currentMonth &&
                    cal.get(java.util.Calendar.YEAR) == java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)) {
                    thisMonth++;
                }

                // Count this week
                if (cal.get(java.util.Calendar.WEEK_OF_YEAR) == currentWeek &&
                    cal.get(java.util.Calendar.YEAR) == java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)) {
                    thisWeek++;
                }
            }
        }
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
        %>

        <!-- Stats Section -->
        <div class="row stats-row">
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= totalWatched %></span>
                    <span class="stat-label">Total Movies Watched</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= thisMonth %></span>
                    <span class="stat-label">Watched This Month</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= thisWeek %></span>
                    <span class="stat-label">Watched This Week</span>
                </div>
            </div>
        </div>

        <!-- Recently Watched Timeline -->
        <div class="card">
            <div class="card-header">
                <div>
                    <i class="bi bi-clock-history"></i> Recently Watched Movies
                </div>
                <div>
                    <% if (movieIds != null && !movieIds.isEmpty()) { %>
                        <a href="<%= request.getContextPath() %>/recently-watched?action=clear" class="btn btn-outline-neon btn-sm"
                           onclick="return confirm('Are you sure you want to clear your recently watched history?')">
                            <i class="bi bi-trash"></i> Clear History
                        </a>
                    <% } %>
                    <a href="<%= request.getContextPath() %>/view-watchlist" class="btn btn-secondary btn-sm ms-2">
                        <i class="bi bi-bookmark-star"></i> View Watchlist
                    </a>
                </div>
            </div>
            <div class="card-body p-4">
                <% if (movieIds == null || movieIds.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-clock-history"></i>
                        <p class="empty-message">You haven't watched any movies yet</p>
                        <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-neon">
                            <i class="bi bi-search"></i> Browse Movies
                        </a>
                    </div>
                <% } else { %>
                    <div class="timeline-container">
                        <div class="timeline">
                            <%
                                for (int i = 0; i < movieIds.size(); i++) {
                                    String movieId = movieIds.get(i);
                                    Date watchDate = watchDates.get(i);
                                    Movie movie = movieMap.get(movieId);

                                    if (movie != null) {
                            %>
                                <div class="timeline-item">
                                    <div class="timeline-date">
                                        <div><%= monthFormat.format(watchDate) %></div>
                                        <div><%= dayFormat.format(watchDate) %></div>
                                    </div>
                                    <div class="timeline-dot"></div>
                                    <div class="timeline-content">
                                        <div class="movie-info">
                                            <div class="movie-poster-small">
                                                <i class="bi bi-film"></i>
                                            </div>
                                            <div class="movie-details">
                                                <div class="movie-title"><%= movie.getTitle() %></div>
                                                <div class="movie-subtitle">
                                                    <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                                                </div>
                                                <div class="date-badge">
                                                    <i class="bi bi-calendar-check me-1"></i>
                                                    Watched on <%= dateFormat.format(watchDate) %> at <%= timeFormat.format(watchDate) %>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="action-buttons">
                                            <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-secondary btn-sm">
                                                <i class="bi bi-info-circle"></i> Movie Details
                                            </a>
                                            <a href="<%= request.getContextPath() %>/add-review?movieId=<%= movie.getMovieId() %>" class="btn btn-neon btn-sm">
                                                <i class="bi bi-star"></i> Write Review
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>