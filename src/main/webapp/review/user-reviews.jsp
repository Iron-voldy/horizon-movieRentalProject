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
    <title>My Reviews - Movie Rental System</title>
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

        .profile-header {
            background: linear-gradient(135deg, rgba(0, 200, 255, 0.2), rgba(138, 43, 226, 0.2));
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid #333;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            display: flex;
            align-items: center;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            font-weight: 600;
            margin-right: 20px;
            box-shadow: 0 0 20px rgba(0, 200, 255, 0.5);
        }

        .profile-name {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--text-primary);
        }

        .profile-subtitle {
            font-size: 1rem;
            color: var(--text-secondary);
        }

        .stats-card {
            text-align: center;
            padding: 15px;
            border-radius: 12px;
            background-color: rgba(30, 30, 30, 0.5);
            border: 1px solid #333;
            height: 100%;
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

        .review-card {
            background-color: rgba(30, 30, 30, 0.5);
            border: 1px solid #333;
            border-radius: 12px;
            margin-bottom: 20px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .review-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .review-movie {
            padding: 15px;
            background: linear-gradient(to right, rgba(0, 200, 255, 0.1), rgba(138, 43, 226, 0.1));
            border-bottom: 1px solid #333;
            display: flex;
            align-items: center;
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

        .movie-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 2px;
        }

        .movie-details {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .review-content {
            padding: 15px;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .review-date {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        .review-stars {
            color: #ffd700;
            font-size: 1.1rem;
            text-shadow: 0 0 5px rgba(255, 215, 0, 0.5);
        }

        .review-text {
            color: var(--text-primary);
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .review-actions {
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

        .btn-view {
            background-color: #444;
            color: white;
        }

        .btn-view:hover {
            background-color: #555;
            transform: translateY(-2px);
            color: white;
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

        .empty-reviews {
            text-align: center;
            padding: 40px 20px;
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
        // Get user from session
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get data from request attributes
        List<Review> userReviews = (List<Review>) request.getAttribute("userReviews");
        Map<String, Movie> movieMap = (Map<String, Movie>) request.getAttribute("movieMap");

        // Format date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");

        // Get first letter of username for avatar
        String firstLetter = user.getUsername().substring(0, 1).toUpperCase();

        // Count verified reviews
        int verifiedCount = 0;
        if (userReviews != null) {
            for (Review review : userReviews) {
                if (review.isVerified()) {
                    verifiedCount++;
                }
            }
        }

        int totalReviews = (userReviews != null) ? userReviews.size() : 0;
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
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/user/profile.jsp">
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

        <!-- Profile Header -->
        <div class="profile-header">
            <div class="profile-avatar">
                <%= firstLetter %>
            </div>
            <div>
                <h1 class="profile-name"><%= user.getUsername() %>'s Reviews</h1>
                <div class="profile-subtitle">
                    Joined as a movie reviewer
                </div>
            </div>
        </div>

        <!-- Review Stats -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= totalReviews %></span>
                    <span class="stat-label">Total Reviews</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= verifiedCount %></span>
                    <span class="stat-label">Verified Reviews</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <span class="stat-number"><%= totalReviews - verifiedCount %></span>
                    <span class="stat-label">Standard Reviews</span>
                </div>
            </div>
        </div>

        <!-- Reviews List -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-star"></i> My Reviews
            </div>
            <div class="card-body p-4">
                <% if (userReviews == null || userReviews.isEmpty()) { %>
                    <div class="empty-reviews">
                        <i class="bi bi-chat-square-text"></i>
                        <p class="empty-message">You haven't written any reviews yet.</p>
                        <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-neon">
                            <i class="bi bi-film"></i> Browse Movies to Review
                        </a>
                    </div>
                <% } else { %>
                    <div class="row">
                        <% for (Review review : userReviews) {
                            Movie movie = movieMap.get(review.getMovieId());
                            if (movie != null) {
                                boolean isVerified = review.isVerified();
                        %>
                            <div class="col-md-6">
                                <div class="review-card">
                                    <div class="review-movie">
                                        <div class="movie-poster-small">
                                            <i class="bi bi-film"></i>
                                        </div>
                                        <div>
                                            <div class="movie-title"><%= movie.getTitle() %></div>
                                            <div class="movie-details">
                                                <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="review-content">
                                        <div class="review-header">
                                            <div class="review-date">
                                                <%= dateFormat.format(review.getReviewDate()) %>
                                                <% if (isVerified) { %>
                                                    <span class="verified-badge"><i class="bi bi-patch-check-fill"></i> Verified</span>
                                                <% } %>
                                            </div>
                                            <div class="review-stars">
                                                <% for (int i = 1; i <= 5; i++) { %>
                                                    <i class="bi <%= (i <= review.getRating()) ? "bi-star-fill" : "bi-star" %>"></i>
                                                <% } %>
                                            </div>
                                        </div>
                                        <div class="review-text">
                                            <%= review.getComment() %>
                                        </div>
                                        <div class="review-actions">
                                            <a href="<%= request.getContextPath() %>/movie-reviews?movieId=<%= movie.getMovieId() %>" class="review-action-btn btn-view">
                                                <i class="bi bi-eye"></i> View All Reviews
                                            </a>
                                            <a href="<%= request.getContextPath() %>/update-review?reviewId=<%= review.getReviewId() %>" class="review-action-btn btn-edit">
                                                <i class="bi bi-pencil"></i> Edit
                                            </a>
                                            <a href="<%= request.getContextPath() %>/delete-review?reviewId=<%= review.getReviewId() %>&confirm=yes"
                                               class="review-action-btn btn-delete"
                                               onclick="return confirm('Are you sure you want to delete this review?')">
                                                <i class="bi bi-trash"></i> Delete
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <%
                            }
                        } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>