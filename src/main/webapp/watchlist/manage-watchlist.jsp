<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.watchlist.Watchlist" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Watchlist Item - Movie Rental System</title>
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

        .form-check-input {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
        }

        .form-check-input:checked {
            background-color: var(--neon-blue);
            border-color: var(--neon-blue);
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

        .watchlist-details {
            background: rgba(0, 200, 255, 0.05);
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            border: 1px dashed #444;
        }

        .detail-row {
            display: flex;
            margin-bottom: 10px;
        }

        .detail-label {
            width: 120px;
            color: var(--text-secondary);
        }

        .detail-value {
            flex-grow: 1;
        }

        .watched-toggle {
            background-color: rgba(0, 200, 255, 0.05);
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            border: 1px dashed #444;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .toggle-label {
            font-weight: 500;
            margin-right: 20px;
        }

        .form-switch .form-check-input {
            width: 3em;
            height: 1.5em;
            margin-left: 0;
        }

        .form-switch .form-check-input:checked {
            background-color: var(--neon-blue);
            border-color: var(--neon-blue);
        }

        .delete-section {
            background: rgba(244, 67, 54, 0.1);
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
            border: 1px dashed #F44336;
        }

        .delete-title {
            color: #F44336;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .delete-title i {
            margin-right: 10px;
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

        // Get watchlist and movie from request attributes
        Watchlist watchlist = (Watchlist) request.getAttribute("watchlist");
        Movie movie = (Movie) request.getAttribute("movie");

        if (watchlist == null || movie == null) {
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

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
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-pencil-square"></i> Manage Watchlist Item
                    </div>
                    <div class="movie-info">
                        <h2 class="movie-title"><%= movie.getTitle() %></h2>
                        <div class="movie-details">
                            <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                        </div>
                        <div>
                            <span class="movie-badge badge-blue"><%= movie.getGenre() %></span>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <div class="watchlist-details">
                            <div class="detail-row">
                                <div class="detail-label">Added On:</div>
                                <div class="detail-value"><%= dateFormat.format(watchlist.getAddedDate()) %></div>
                            </div>
                            <% if (watchlist.isWatched() && watchlist.getWatchedDate() != null) { %>
                                <div class="detail-row">
                                    <div class="detail-label">Watched On:</div>
                                    <div class="detail-value"><%= dateFormat.format(watchlist.getWatchedDate()) %></div>
                                </div>
                            <% } %>
                            <div class="detail-row">
                                <div class="detail-label">Status:</div>
                                <div class="detail-value">
                                    <% if (watchlist.isWatched()) { %>
                                        <span class="badge bg-success">Watched</span>
                                    <% } else { %>
                                        <span class="badge bg-warning text-dark">Unwatched</span>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <form action="<%= request.getContextPath() %>/manage-watchlist" method="post">
                            <input type="hidden" name="watchlistId" value="<%= watchlist.getWatchlistId() %>">

                            <div class="priority-section">
                                <label class="form-label">Priority</label>
                                <div class="priority-options">
                                    <label class="priority-option priority-1 <%= watchlist.getPriority() == 1 ? "selected" : "" %>">
                                        <input type="radio" name="priority" value="1" <%= watchlist.getPriority() == 1 ? "checked" : "" %>>
                                        <span class="option-label">Highest</span>
                                        <span class="option-description">Must watch ASAP</span>
                                    </label>

                                    <label class="priority-option priority-2 <%= watchlist.getPriority() == 2 ? "selected" : "" %>">
                                        <input type="radio" name="priority" value="2" <%= watchlist.getPriority() == 2 ? "checked" : "" %>>
                                        <span class="option-label">High</span>
                                        <span class="option-description">Watch soon</span>
                                    </label>

                                    <label class="priority-option priority-3 <%= watchlist.getPriority() == 3 ? "selected" : "" %>">
                                        <input type="radio" name="priority" value="3" <%= watchlist.getPriority() == 3 ? "checked" : "" %>>
                                        <span class="option-label">Medium</span>
                                        <span class="option-description">Standard</span>
                                    </label>

                                    <label class="priority-option priority-4 <%= watchlist.getPriority() == 4 ? "selected" : "" %>">
                                        <input type="radio" name="priority" value="4" <%= watchlist.getPriority() == 4 ? "checked" : "" %>>
                                        <span class="option-label">Low</span>
                                        <span class="option-description">When available</span>
                                    </label>

                                    <label class="priority-option priority-5 <%= watchlist.getPriority() == 5 ? "selected" : "" %>">
                                        <input type="radio" name="priority" value="5" <%= watchlist.getPriority() == 5 ? "checked" : "" %>>
                                        <span class="option-label">Lowest</span>
                                        <span class="option-description">Someday</span>
                                    </label>
                                </div>
                            </div>

                            <div class="watched-toggle">
                                <div class="toggle-label">
                                    <i class="bi bi-check-circle me-2"></i> Have you watched this movie?
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="watched" name="watched" <%= watchlist.isWatched() ? "checked" : "" %>>
                                    <label class="form-check-label" for="watched">
                                        <%= watchlist.isWatched() ? "Yes, I've watched it" : "No, I haven't watched it yet" %>
                                    </label>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="notes" class="form-label">Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3"
                                    placeholder="Add any notes about the movie..."><%= watchlist.getNotes() != null ? watchlist.getNotes() : "" %></textarea>
                            </div>

                            <div class="mt-4 d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/view-watchlist" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Back to Watchlist
                                </a>
                                <button type="submit" class="btn btn-neon">
                                    <i class="bi bi-save"></i> Save Changes
                                </button>
                            </div>
                        </form>

                        <div class="delete-section">
                            <div class="delete-title">
                                <i class="bi bi-trash"></i> Remove from Watchlist
                            </div>
                            <p>If you no longer want to keep this movie in your watchlist, you can remove it.</p>
                            <form action="<%= request.getContextPath() %>/remove-from-watchlist" method="post">
                                <input type="hidden" name="watchlistId" value="<%= watchlist.getWatchlistId() %>">
                                <input type="hidden" name="confirmRemove" value="yes">
                                <button type="submit" class="btn btn-danger w-100">
                                    <i class="bi bi-trash"></i> Remove from Watchlist
                                </button>
                            </form>
                        </div>
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
            const watchedToggle = document.getElementById('watched');
            const watchedLabel = watchedToggle.nextElementSibling;

            priorityOptions.forEach(option => {
                const radio = option.querySelector('input[type="radio"]');

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

            // Update watched toggle label
            watchedToggle.addEventListener('change', function() {
                if (this.checked) {
                    watchedLabel.textContent = "Yes, I've watched it";
                } else {
                    watchedLabel.textContent = "No, I haven't watched it yet";
                }
            });
        });
    </script>
</body>
</html>