<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.NewRelease" %>
<%@ page import="com.movierental.model.movie.ClassicMovie" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add to Watchlist - Movie Rental System</title>
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
        }

        .card-header i {
            margin-right: 10px;
            color: var(--neon-purple);
            font-size: 1.2rem;
        }

        .movie-info {
            padding: 20px;
            border-bottom: 1px solid #333;
        }

        .movie-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--text-primary);
        }

        .movie-details {
            color: var(--text-secondary);
            margin-bottom: 15px;
        }

        .movie-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-right: 5px;
            margin-bottom: 5px;
        }

        .badge-blue {
            background: linear-gradient(to right, #0277bd, #00c8ff);
            color: white;
            box-shadow: 0 0 10px rgba(0, 200, 255, 0.4);
        }

        .badge-purple {
            background: linear-gradient(to right, #8a2be2, #ff00ff);
            color: white;
            box-shadow: 0 0 10px rgba(138, 43, 226, 0.4);
        }

        .badge-gold {
            background: linear-gradient(to right, #ffa000, #ffcf40);
            color: #333;
            box-shadow: 0 0 10px rgba(255, 160, 0, 0.4);
        }

        .form-label {
            color: var(--neon-blue);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-control:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
        }

        .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-select:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
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

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        .priority-section {
            margin-bottom: 20px;
        }

        .priority-options {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .priority-option {
            flex: 1;
            text-align: center;
            padding: 15px 10px;
            border-radius: 8px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.2s;
            position: relative;
        }

        .priority-option input {
            position: absolute;
            opacity: 0;
            cursor: pointer;
            height: 0;
            width: 0;
        }

        .priority-option .option-label {
            font-weight: 600;
            font-size: 0.9rem;
            display: block;
            margin-bottom: 5px;
        }

        .priority-option .option-description {
            font-size: 0.75rem;
            color: var(--text-secondary);
        }

        .priority-1 {
            background-color: rgba(213, 0, 0, 0.2);
            border-color: #D50000;
        }

        .priority-1.selected, .priority-1:hover {
            background-color: rgba(213, 0, 0, 0.4);
            box-shadow: 0 0 15px rgba(213, 0, 0, 0.5);
        }

        .priority-2 {
            background-color: rgba(255, 109, 0, 0.2);
            border-color: #FF6D00;
        }

        .priority-2.selected, .priority-2:hover {
            background-color: rgba(255, 109, 0, 0.4);
            box-shadow: 0 0 15px rgba(255, 109, 0, 0.5);
        }

        .priority-3 {
            background-color: rgba(255, 171, 0, 0.2);
            border-color: #FFAB00;
        }

        .priority-3.selected, .priority-3:hover {
            background-color: rgba(255, 171, 0, 0.4);
            box-shadow: 0 0 15px rgba(255, 171, 0, 0.5);
        }

        .priority-4 {
            background-color: rgba(0, 200, 83, 0.2);
            border-color: #00C853;
        }

        .priority-4.selected, .priority-4:hover {
            background-color: rgba(0, 200, 83, 0.4);
            box-shadow: 0 0 15px rgba(0, 200, 83, 0.5);
        }

        .priority-5 {
            background-color: rgba(41, 121, 255, 0.2);
            border-color: #2979FF;
        }

        .priority-5.selected, .priority-5:hover {
            background-color: rgba(41, 121, 255, 0.4);
            box-shadow: 0 0 15px rgba(41, 121, 255, 0.5);
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

        // Get movie from request attribute
        Movie movie = (Movie) request.getAttribute("movie");
        if (movie == null) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Check if movie is a special type
        boolean isNewRelease = movie instanceof NewRelease;
        boolean isClassic = movie instanceof ClassicMovie;
        boolean hasAwards = isClassic && ((ClassicMovie)movie).hasAwards();
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
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-bookmark-plus"></i> Add to Watchlist
                    </div>
                    <div class="movie-info">
                        <h2 class="movie-title"><%= movie.getTitle() %></h2>
                        <div class="movie-details">
                            <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                        </div>
                        <div>
                            <span class="movie-badge badge-blue"><%= movie.getGenre() %></span>
                            <% if(isNewRelease) { %>
                                <span class="movie-badge badge-purple">New Release</span>
                            <% } else if(isClassic) { %>
                                <span class="movie-badge badge-purple">Classic</span>
                                <% if(hasAwards) { %>
                                    <span class="movie-badge badge-gold">Award Winner</span>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/add-to-watchlist" method="post">
                            <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">

                            <div class="priority-section">
                                <label class="form-label">Set Priority</label>
                                <div class="priority-options">
                                    <label class="priority-option priority-1">
                                        <input type="radio" name="priority" value="1">
                                        <span class="option-label">Highest</span>
                                        <span class="option-description">Must watch ASAP</span>
                                    </label>

                                    <label class="priority-option priority-2">
                                        <input type="radio" name="priority" value="2">
                                        <span class="option-label">High</span>
                                        <span class="option-description">Watch soon</span>
                                    </label>

                                    <label class="priority-option priority-3">
                                        <input type="radio" name="priority" value="3" checked>
                                        <span class="option-label">Medium</span>
                                        <span class="option-description">Standard</span>
                                    </label>

                                    <label class="priority-option priority-4">
                                        <input type="radio" name="priority" value="4">
                                        <span class="option-label">Low</span>
                                        <span class="option-description">When available</span>
                                    </label>

                                    <label class="priority-option priority-5">
                                        <input type="radio" name="priority" value="5">
                                        <span class="option-label">Lowest</span>
                                        <span class="option-description">Someday</span>
                                    </label>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="notes" class="form-label">Notes (Optional)</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3"
                                    placeholder="Add any notes about why you want to watch this movie..."></textarea>
                            </div>

                            <div class="mt-4 d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-neon">
                                    <i class="bi bi-bookmark-plus"></i> Add to Watchlist
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Make priority options more interactive
        document.addEventListener('DOMContentLoaded', function() {
            const priorityOptions = document.querySelectorAll('.priority-option');

            priorityOptions.forEach(option => {
                const radio = option.querySelector('input[type="radio"]');

                // Set initial selected state
                if (radio.checked) {
                    option.classList.add('selected');
                }

                // Update on click
                option.addEventListener('click', function() {
                    // Remove selected class from all options
                    priorityOptions.forEach(opt => opt.classList.remove('selected'));

                    // Add selected class to clicked option
                    option.classList.add('selected');

                    // Check the radio button
                    radio.checked = true;
                });
            });
        });
    </script>
</body>
</html>