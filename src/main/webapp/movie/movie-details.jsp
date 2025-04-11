<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.NewRelease" %>
<%@ page import="com.movierental.model.movie.ClassicMovie" %>
<%@ page import="com.movierental.model.movie.MovieManager" %>
<%@ page import="com.movierental.model.review.ReviewManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Details - Movie Rental System</title>
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

        .movie-header {
            background: linear-gradient(135deg, rgba(0, 200, 255, 0.2), rgba(138, 43, 226, 0.2));
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid #333;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            display: flex;
            align-items: center;
        }

        .movie-poster {
            width: 250px;
            height: 375px;
            background: linear-gradient(135deg, #333, #222);
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            margin-right: 30px;
        }

        .movie-poster img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .poster-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #555;
            font-size: 4rem;
        }

        .movie-title {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--text-primary);
        }

        .movie-subtitle {
            font-size: 1.1rem;
            color: var(--text-secondary);
            margin-bottom: 15px;
        }

        .movie-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-right: 10px;
            margin-bottom: 10px;
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

        .badge-green {
            background: linear-gradient(to right, #4CAF50, #8BC34A);
            color: white;
            box-shadow: 0 0 10px rgba(76, 175, 80, 0.4);
        }

        .badge-red {
            background: linear-gradient(to right, #F44336, #FF5722);
            color: white;
            box-shadow: 0 0 10px rgba(244, 67, 54, 0.4);
        }

        .rating-large {
            display: flex;
            align-items: center;
            margin-top: 15px;
        }

        .rating-large .rating-stars {
            color: #ffd700;
            font-size: 1.5rem;
            margin-right: 10px;
        }

        .rating-large .rating-value {
            font-size: 1.1rem;
            font-weight: 600;
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

        .btn-danger {
            background: linear-gradient(to right, #F44336, #FF5722);
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(244, 67, 54, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(244, 67, 54, 0.6);
            color: white;
        }

        .movie-action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
            border-radius: 10px;
            background-color: var(--card-secondary);
            color: var(--text-primary);
            text-decoration: none;
            transition: all 0.3s ease;
            margin-bottom: 15px;
            border: 1px solid #444;
        }

        .movie-action-btn i {
            font-size: 1.5rem;
            margin-right: 10px;
            color: var(--neon-blue);
        }

        .movie-action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            background-color: #3a3a3a;
            color: var(--text-primary);
        }

        .movie-details-table {
            width: 100%;
        }

        .movie-details-table td {
            padding: 12px 5px;
            border-bottom: 1px solid #333;
        }

        .movie-details-table tr:last-child td {
            border-bottom: none;
        }

        .detail-label {
            color: var(--text-secondary);
            width: 150px;
        }

        .detail-value {
            color: var(--text-primary);
            font-weight: 500;
        }

        .special-info {
            background: rgba(0, 200, 255, 0.05);
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
            border: 1px dashed #444;
        }

        .special-info-title {
            color: var(--neon-blue);
            font-weight: 600;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .special-info-title i {
            margin-right: 8px;
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

        // Get movie ID from request
        String movieId = request.getParameter("id");

        if (movieId == null || movieId.trim().isEmpty()) {
            // Redirect to search page if no movie ID provided
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Create MovieManager with ServletContext
        MovieManager movieManager = new MovieManager(getServletContext());

        // Find the movie
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            // Set error message if movie not found
            session.setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Determine movie type for additional rendering
        boolean isNewRelease = movie instanceof NewRelease;
        boolean isClassic = movie instanceof ClassicMovie;

        // Check if the movie has a cover photo
        String coverPhotoUrl = movieManager.getCoverPhotoUrl(movie);
        boolean hasCoverPhoto = movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty();
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/search-movie">
                            <i class="bi bi-film"></i> Movies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/rental-history">
                            <i class="bi bi-collection-play"></i> My Rentals
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/view-watchlist">
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
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");

            if(successMessage != null) {
                out.println("<div class='alert alert-success'>");
                out.println("<i class='bi bi-check-circle-fill me-2'></i>");
                out.println(successMessage);
                out.println("</div>");
                session.removeAttribute("successMessage");
            }

            if(errorMessage != null) {
                out.println("<div class='alert alert-danger'>");
                out.println("<i class='bi bi-exclamation-triangle-fill me-2'></i>");
                out.println(errorMessage);
                out.println("</div>");
                session.removeAttribute("errorMessage");
            }
        %>

        <!-- Movie Header -->
        <div class="movie-header">
            <div class="movie-poster">
                <% if(hasCoverPhoto) { %>
                    <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>" alt="<%= movie.getTitle() %>">
                <% } else { %>
                    <div class="poster-placeholder">
                        <i class="bi bi-film"></i>
                    </div>
                <% } %>
            </div>
            <div class="movie-info">
                <h1 class="movie-title"><%= movie.getTitle() %></h1>
                <div class="movie-subtitle">
                    <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                </div>

                <div>
                    <span class="movie-badge badge-blue"><%= movie.getGenre() %></span>

                    <% if(isNewRelease) { %>
                        <span class="movie-badge badge-purple">New Release</span>
                    <% } else if(isClassic) { %>
                        <span class="movie-badge badge-purple">Classic</span>
                        <% if(isClassic && ((ClassicMovie)movie).hasAwards()) { %>
                            <span class="movie-badge badge-gold">Award Winner</span>
                        <% } %>
                    <% } %>

                    <span class="movie-badge <%= movie.isAvailable() ? "badge-green" : "badge-red" %>">
                        <%= movie.isAvailable() ? "Available" : "Not Available" %>
                    </span>
                </div>

                <div class="rating-large">
                    <div class="rating-stars">
                        <%
                            double rating = movie.getRating();
                            int fullStars = (int) Math.floor(rating / 2);
                            boolean halfStar = (rating / 2) - fullStars >= 0.5;

                            for(int i = 0; i < fullStars; i++) {
                                out.print("<i class='bi bi-star-fill'></i>");
                            }

                            if(halfStar) {
                                out.print("<i class='bi bi-star-half'></i>");
                            }

                            int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                            for(int i = 0; i < emptyStars; i++) {
                                out.print("<i class='bi bi-star'></i>");
                            }
                        %>
                    </div>
                    <span class="rating-value"><%= movie.getRating() %>/10</span>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Movie Details -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-info-circle"></i> Movie Details
                    </div>
                    <div class="card-body p-4">
                        <table class="movie-details-table">
                            <tr>
                                <td class="detail-label">Title</td>
                                <td class="detail-value"><%= movie.getTitle() %></td>
                            </tr>
                            <tr>
                                <td class="detail-label">Director</td>
                                <td class="detail-value"><%= movie.getDirector() %></td>
                            </tr>
                            <tr>
                                <td class="detail-label">Genre</td>
                                <td class="detail-value"><%= movie.getGenre() %></td>
                            </tr>
                            <tr>
                                <td class="detail-label">Release Year</td>
                                <td class="detail-value"><%= movie.getReleaseYear() %></td>
                            </tr>
                            <tr>
                                <td class="detail-label">Rating</td>
                                <td class="detail-value"><%= movie.getRating() %>/10</td>
                            </tr>
                            <tr>
                                <td class="detail-label">Type</td>
                                <td class="detail-value">
                                    <%= isNewRelease ? "New Release" : (isClassic ? "Classic" : "Regular") %>
                                </td>
                            </tr>
                            <tr>
                                <td class="detail-label">Status</td>
                                <td class="detail-value">
                                    <%= movie.isAvailable() ? "Available" : "Currently Rented" %>
                                </td>
                            </tr>
                            <tr>
                                <td class="detail-label">Rental Price</td>
                                <td class="detail-value">
                                    $<%= String.format("%.2f", movie.calculateRentalPrice(1)) %> per day
                                </td>
                            </tr>
                        </table>

                        <% if(isNewRelease) {
                            NewRelease newRelease = (NewRelease) movie;
                            SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
                        %>
                            <div class="special-info">
                                <div class="special-info-title">
                                    <i class="bi bi-calendar-check"></i> New Release Information
                                </div>
                                <p>Release Date: <%= sdf.format(newRelease.getReleaseDate()) %></p>
                                <p>
                                    Status:
                                    <% if(newRelease.isStillNewRelease()) { %>
                                        <span style="color: #4CAF50;">Still considered a new release</span>
                                    <% } else { %>
                                        <span style="color: #FFA000;">No longer considered a new release</span>
                                    <% } %>
                                </p>
                            </div>
                        <% } else if(isClassic) {
                            ClassicMovie classicMovie = (ClassicMovie) movie;
                        %>
                            <div class="special-info">
                                <div class="special-info-title">
                                    <i class="bi bi-trophy"></i> Classic Movie Information
                                </div>
                                <% if(classicMovie.getSignificance() != null && !classicMovie.getSignificance().isEmpty()) { %>
                                    <p><strong>Historical/Cultural Significance:</strong></p>
                                    <p><%= classicMovie.getSignificance() %></p>
                                <% } %>
                                <p>
                                    <strong>Major Awards:</strong>
                                    <%= classicMovie.hasAwards() ? "Yes" : "No" %>
                                </p>
                                <p>
                                    Classic Status:
                                    <% if(classicMovie.isClassicByAge()) { %>
                                        <span style="color: #4CAF50;">Certified classic (over 25 years old)</span>
                                    <% } else { %>
                                        <span style="color: #FFA000;">Cultural classic (under 25 years old)</span>
                                    <% } %>
                                </p>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Reviews Summary Section -->
                <div class="card mt-3">
                    <div class="card-header">
                        <i class="bi bi-star"></i> Reviews
                    </div>
                    <div class="card-body p-4">
                        <%
                            ReviewManager reviewManager = new ReviewManager(application);
                            double avgRating = reviewManager.calculateAverageRating(movie.getMovieId());
                            int reviewCount = reviewManager.getReviewsByMovie(movie.getMovieId()).size();

                            if(reviewCount > 0) {
                        %>
                            <div class="d-flex align-items-center mb-3">
                                <h4 class="me-3 mb-0"><%= String.format("%.1f", avgRating) %></h4>
                                <div>
                                    <div class="rating-stars">
                                        <%
                                            int reviewFullStars = (int) Math.floor(avgRating);
                                            boolean reviewHalfStar = (avgRating - reviewFullStars) >= 0.5;

                                            for(int i = 0; i < reviewFullStars; i++) {
                                                out.print("<i class='bi bi-star-fill'></i> ");
                                            }

                                            if(reviewHalfStar) {
                                                out.print("<i class='bi bi-star-half'></i> ");
                                            }

                                            int reviewEmptyStars = 5 - reviewFullStars - (reviewHalfStar ? 1 : 0);
                                            for(int i = 0; i < reviewEmptyStars; i++) {
                                                out.print("<i class='bi bi-star'></i> ");
                                            }
                                        %>
                                    </div>
                                    <div class="text-muted"><%= reviewCount %> reviews</div>
                                </div>
                            </div>
                        <% } else { %>
                            <p class="text-center mb-3">No reviews yet.</p>
                        <% } %>

                        <div class="d-flex justify-content-between">
                            <a href="<%= request.getContextPath() %>/movie-reviews?movieId=<%= movie.getMovieId() %>" class="btn btn-outline-neon">
                                <i class="bi bi-eye"></i> View All Reviews
                            </a>
                            <a href="<%= request.getContextPath() %>/add-review?movieId=<%= movie.getMovieId() %>" class="btn btn-neon">
                                <i class="bi bi-pencil"></i> Write a Review
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions Column -->
            <div class="col-md-4">
                <!-- Rent Movie Card -->
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="bi bi-collection-play"></i> Actions
                    </div>
                    <div class="card-body p-4">
                        <% if(movie.isAvailable()) { %>
                            <a href="<%= request.getContextPath() %>/rent-movie?id=<%= movie.getMovieId() %>" class="movie-action-btn">
                                <i class="bi bi-cart-plus"></i>
                                <div>
                                    <div><strong>Rent this Movie</strong></div>
                                    <small>$<%= String.format("%.2f", movie.calculateRentalPrice(1)) %> per day</small>
                                </div>
                            </a>
                        <% } else { %>
                            <div class="movie-action-btn" style="opacity: 0.6; cursor: not-allowed;">
                                <i class="bi bi-cart-plus"></i>
                                <div>
                                    <div><strong>Currently Unavailable</strong></div>
                                    <small>This movie is currently rented</small>
                                </div>
                            </div>
                        <% } %>

                        <a href="<%= request.getContextPath() %>/add-to-watchlist?movieId=<%= movie.getMovieId() %>" class="movie-action-btn">
                            <i class="bi bi-bookmark-plus"></i>
                            <div>
                                <div><strong>Add to Watchlist</strong></div>
                                <small>Save for later</small>
                            </div>
                        </a>

                        <div class="d-grid gap-2 mt-4">
                            <a href="<%= request.getContextPath() %>/update-movie?id=<%= movie.getMovieId() %>" class="btn btn-neon">
                                <i class="bi bi-pencil"></i> Edit Movie
                            </a>
                            <a href="<%= request.getContextPath() %>/delete-movie?id=<%= movie.getMovieId() %>" class="btn btn-danger">
                                <i class="bi bi-trash"></i> Delete Movie
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Similar Movies Card (placeholder) -->
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-film"></i> Similar Movies
                    </div>
                    <div class="card-body p-4 text-center">
                        <i class="bi bi-grid" style="font-size: 3rem; color: #444;"></i>
                        <p class="mt-3 text-secondary">Similar movies will appear here</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-4 d-flex justify-content-between">
            <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to Movies
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>