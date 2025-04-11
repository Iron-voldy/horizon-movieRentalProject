<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.review.Review" %>
<%@ page import="com.movierental.model.review.VerifiedReview" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Reviews - Movie Rental System</title>
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

        .movie-header {
            background: linear-gradient(135deg, rgba(0, 200, 255, 0.2), rgba(138, 43, 226, 0.2));
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            border: 1px solid #333;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            display: flex;
            align-items: center;
        }

        .movie-poster {
            width: 120px;
            height: 180px;
            background: linear-gradient(135deg, #333, #222);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            color: #555;
            font-size: 2.5rem;
            margin-right: 20px;
        }

        .movie-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--text-primary);
        }

        .movie-subtitle {
            font-size: 1rem;
            color: var(--text-secondary);
            margin-bottom: 10px;
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

        .rating-summary {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }

        .rating-large {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-right: 15px;
        }

        .rating-stars {
            color: #ffd700;
            font-size: 1.2rem;
            text-shadow: 0 0 5px rgba(255, 215, 0, 0.5);
        }

        .rating-count {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-left: 10px;
        }

        .rating-bars {
            flex-grow: 1;
            padding-left: 15px;
        }

        .rating-bar-row {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }

        .rating-label {
            width: 30px;
            text-align: right;
            margin-right: 10px;
            color: var(--text-secondary);
        }

        .rating-bar-bg {
            flex-grow: 1;
            height: 8px;
            background-color: #333;
            border-radius: 4px;
            overflow: hidden;
        }

        .rating-bar {
            height: 100%;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            border-radius: 4px;
        }

        .rating-count-label {
            width: 35px;
            text-align: left;
            margin-left: 10px;
            color: var(--text-secondary);
            font-size: 0.8rem;
        }

        .review-card {
            background-color: rgba(30, 30, 30, 0.5);
            border: 1px solid #333;
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 15px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .review-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #333;
        }

        .review-user {
            display: flex;
            align-items: center;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin-right: 10px;
            box-shadow: 0 0 10px rgba(0, 200, 255, 0.4);
        }

        .review-username {
            font-weight: 600;
            color: var(--text-primary);
        }

        .review-date {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .review-stars {
            color: #ffd700;
            font-size: 1.1rem;
            text-shadow: 0 0 5px rgba(255, 215, 0, 0.5);
        }

        .review-content {
            margin-top: 10px;
            color: var(--text-primary);
            line-height: 1.6;
        }

        .verified-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 10px;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            color: white;
            box-shadow: 0 0 10px rgba(0, 200, 255, 0.5);
        }

        .guest-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 10px;
            background: #444;
            color: #ddd;
        }

        .your-review {
            border: 1px solid var(--neon-blue);
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        .review-actions {
            margin-top: 15px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .review-action-btn {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }

        .review-action-btn i {
            margin-right: 5px;
        }

        .btn-edit {
            background-color: #0288d1;
            color: white;
        }

        .btn-edit:hover {
            background-color: #0277bd;
            transform: translateY(-2px);
            color: white;
        }

        .btn-delete {
            background-color: #d32f2f;
            color: white;
        }

        .btn-delete:hover {
            background-color: #c62828;
            transform: translateY(-2px);
            color: white;
        }

        .empty-reviews {
            text-align: center;
            padding: 30px 15px;
        }

        .empty-reviews i {
            font-size: 3rem;
            color: #444;
            margin-bottom: 15px;
        }

        .empty-message {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%
        // Get user from session (if logged in)
        User user = (request.getSession(false) != null) ?
                    (User) request.getSession().getAttribute("user") : null;

        // Get data from request attributes
        Movie movie = (Movie) request.getAttribute("movie");
        List<Review> reviews = (List<Review>) request.getAttribute("reviews");
        double averageRating = (Double) request.getAttribute("averageRating");
        int verifiedReviewsCount = (Integer) request.getAttribute("verifiedReviewsCount");
        int guestReviewsCount = (Integer) request.getAttribute("guestReviewsCount");
        Map<Integer, Integer> ratingDistribution = (Map<Integer, Integer>) request.getAttribute("ratingDistribution");
        boolean hasReviewed = (Boolean) request.getAttribute("hasReviewed");
        Review userReview = (Review) request.getAttribute("userReview");

        // Validate that movie is not null
        if (movie == null) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Format date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");

        // Total reviews count
        int totalReviews = (reviews != null) ? reviews.size() : 0;
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/watchlist/watchlist.jsp">
                            <i class="bi bi-bookmark-star"></i> Watchlist
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <% if (user != null) { %>
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
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/login">
                                <i class="bi bi-box-arrow-in-right"></i> Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/register">
                                <i class="bi bi-person-plus"></i> Register
                            </a>
                        </li>
                    <% } %>
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

        <!-- Movie Header -->
        <div class="movie-header">
            <div class="movie-poster">
                <i class="bi bi-film"></i>
            </div>
            <div>
                <h1 class="movie-title"><%= movie.getTitle() %></h1>
                <div class="movie-subtitle">
                    <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                </div>
                <div>
                    <span class="movie-badge badge-blue"><%= movie.getGenre() %></span>
                </div>

                <div class="rating-summary">
                    <div class="rating-large"><%= String.format("%.1f", averageRating) %></div>
                    <div>
                        <div class="rating-stars">
                            <%
                                // Display stars based on average rating
                                int fullStars = (int) Math.floor(averageRating);
                                boolean halfStar = (averageRating - fullStars) >= 0.5;

                                for (int i = 0; i < fullStars; i++) {
                                    out.print("<i class='bi bi-star-fill'></i> ");
                                }

                                if (halfStar) {
                                    out.print("<i class='bi bi-star-half'></i> ");
                                }

                                int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                                for (int i = 0; i < emptyStars; i++) {
                                    out.print("<i class='bi bi-star'></i> ");
                                }
                            %>
                        </div>
                        <div class="rating-count">
                            Based on <%= totalReviews %> reviews
                            (<%= verifiedReviewsCount %> verified, <%= guestReviewsCount %> guest)
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Rating Distribution and Actions -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card mb-3">
                    <div class="card-header">
                        <i class="bi bi-bar-chart-fill"></i> Rating Distribution
                    </div>
                    <div class="card-body p-3">
                        <div class="rating-bars">
                            <% for (int i = 5; i >= 1; i--) {
                                int count = ratingDistribution.getOrDefault(i, 0);
                                double percentage = (totalReviews > 0) ? (count * 100.0 / totalReviews) : 0;
                            %>
                                <div class="rating-bar-row">
                                    <div class="rating-label"><%= i %><i class="bi bi-star-fill ms-1" style="font-size: 0.7rem;"></i></div>
                                    <div class="rating-bar-bg">
                                        <div class="rating-bar" style="width: <%= percentage %>%;"></div>
                                    </div>
                                    <div class="rating-count-label"><%= count %></div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-chat-right-text-fill"></i> Actions
                    </div>
                    <div class="card-body p-3">
                        <% if (!hasReviewed) { %>
                            <a href="<%= request.getContextPath() %>/add-review?movieId=<%= movie.getMovieId() %>" class="btn btn-neon w-100 mb-2">
                                <i class="bi bi-pencil-square"></i> Write a Review
                            </a>
                        <% } else { %>
                            <a href="<%= request.getContextPath() %>/update-review?reviewId=<%= userReview.getReviewId() %>" class="btn btn-outline-neon w-100 mb-2">
                                <i class="bi bi-pencil-square"></i> Edit Your Review
                            </a>
                        <% } %>
                        <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-outline-neon w-100">
                            <i class="bi bi-film"></i> Back to Movie Details
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reviews List -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-star"></i> Reviews (<%= totalReviews %>)
            </div>
            <div class="card-body p-4">
                <% if (reviews == null || reviews.isEmpty()) { %>
                    <div class="empty-reviews">
                        <i class="bi bi-chat-square-text"></i>
                        <p class="empty-message">No reviews yet. Be the first to review this movie!</p>
                        <a href="<%= request.getContextPath() %>/add-review?movieId=<%= movie.getMovieId() %>" class="btn btn-neon">
                            <i class="bi bi-pencil-square"></i> Write a Review
                        </a>
                    </div>
                <% } else { %>
                    <% for (Review review : reviews) {
                        boolean isUserReview = (user != null && user.getUserId().equals(review.getUserId()));
                        boolean isVerified = review.isVerified();

                        // Get first letter of username for avatar
                        String firstLetter = review.getUserName().substring(0, 1).toUpperCase();
                    %>
                        <div class="review-card <%= isUserReview ? "your-review" : "" %>">
                            <div class="review-header">
                                <div class="review-user">
                                    <div class="user-avatar"><%= firstLetter %></div>
                                    <div>
                                        <div class="review-username">
                                            <%= review.getUserName() %>
                                            <% if (isVerified) { %>
                                                <span class="verified-badge"><i class="bi bi-patch-check-fill"></i> Verified</span>
                                            <% } else if (review.getUserId() == null) { %>
                                                <span class="guest-badge"><i class="bi bi-person"></i> Guest</span>
                                            <% } %>
                                        </div>
                                        <div class="review-date"><%= dateFormat.format(review.getReviewDate()) %></div>
                                    </div>
                                </div>
                                <div class="review-stars">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <i class="bi <%= (i <= review.getRating()) ? "bi-star-fill" : "bi-star" %>"></i>
                                    <% } %>
                                </div>
                            </div>
                            <div class="review-content">
                                <%= review.getComment() %>
                            </div>
                            <% if (isUserReview) { %>
                                <div class="review-actions">
                                    <a href="<%= request.getContextPath() %>/update-review?reviewId=<%= review.getReviewId() %>" class="review-action-btn btn-edit">
                                        <i class="bi bi-pencil"></i> Edit
                                    </a>
                                    <a href="<%= request.getContextPath() %>/delete-review?reviewId=<%= review.getReviewId() %>&confirm=yes"
                                       class="review-action-btn btn-delete"
                                       onclick="return confirm('Are you sure you want to delete this review?')">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>