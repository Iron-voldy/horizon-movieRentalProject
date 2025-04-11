<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.review.Review" %>
<%@ page import="com.movierental.model.review.VerifiedReview" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Review - Movie Rental System</title>
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
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(244, 67, 54, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(244, 67, 54, 0.6);
            color: white;
        }

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            font-size: 2rem;
            margin-bottom: 20px;
        }

        .star-rating input {
            display: none;
        }

        .star-rating label {
            cursor: pointer;
            color: #444;
            padding: 0 5px;
            transition: color 0.2s;
        }

        .star-rating input:checked ~ label {
            color: #ffd700;
            text-shadow: 0 0 10px rgba(255, 215, 0, 0.7);
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: #ffec8b;
            text-shadow: 0 0 15px rgba(255, 236, 139, 0.7);
        }

        .verified-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-left: 10px;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            color: white;
            box-shadow: 0 0 10px rgba(0, 200, 255, 0.5);
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

        // Get review and movie from request attributes
        Review review = (Review) request.getAttribute("review");
        Movie movie = (Movie) request.getAttribute("movie");

        if (review == null || movie == null) {
            response.sendRedirect(request.getContextPath() + "/user-reviews");
            return;
        }

        boolean isVerified = review instanceof VerifiedReview;
        boolean showDeleteConfirm = "true".equals(request.getParameter("showDeleteConfirm"));
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
                        <div>
                            <i class="bi bi-pencil-square"></i> Edit Review
                            <% if (isVerified) { %>
                                <span class="verified-badge"><i class="bi bi-patch-check-fill"></i> Verified Viewer</span>
                            <% } %>
                        </div>
                    </div>
                    <div class="movie-info">
                        <h2 class="movie-title"><%= movie.getTitle() %></h2>
                        <div class="movie-details">
                            <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <% if (showDeleteConfirm) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                Are you sure you want to delete this review? This action cannot be undone.
                                <div class="mt-3">
                                    <a href="<%= request.getContextPath() %>/delete-review?reviewId=<%= review.getReviewId() %>&confirm=yes"
                                       class="btn btn-danger me-2">
                                        <i class="bi bi-trash"></i> Yes, Delete
                                    </a>
                                    <a href="<%= request.getContextPath() %>/update-review?reviewId=<%= review.getReviewId() %>"
                                       class="btn btn-secondary">
                                        <i class="bi bi-x"></i> Cancel
                                    </a>
                                </div>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/update-review" method="post">
                            <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                            <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">

                            <div class="mb-3">
                                <label class="form-label">Your Rating</label>
                                <div class="star-rating">
                                    <input type="radio" id="star5" name="rating" value="5" <%= (review.getRating() == 5) ? "checked" : "" %> />
                                    <label for="star5" title="5 stars"><i class="bi bi-star-fill"></i></label>

                                    <input type="radio" id="star4" name="rating" value="4" <%= (review.getRating() == 4) ? "checked" : "" %> />
                                    <label for="star4" title="4 stars"><i class="bi bi-star-fill"></i></label>

                                    <input type="radio" id="star3" name="rating" value="3" <%= (review.getRating() == 3) ? "checked" : "" %> />
                                    <label for="star3" title="3 stars"><i class="bi bi-star-fill"></i></label>

                                    <input type="radio" id="star2" name="rating" value="2" <%= (review.getRating() == 2) ? "checked" : "" %> />
                                    <label for="star2" title="2 stars"><i class="bi bi-star-fill"></i></label>

                                    <input type="radio" id="star1" name="rating" value="1" <%= (review.getRating() == 1) ? "checked" : "" %> />
                                    <label for="star1" title="1 star"><i class="bi bi-star-fill"></i></label>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="comment" class="form-label">Your Review</label>
                                <textarea class="form-control" id="comment" name="comment" rows="5" required><%= review.getComment() %></textarea>
                            </div>

                            <div class="mt-4 d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/movie-reviews?movieId=<%= movie.getMovieId() %>" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-neon">
                                    <i class="bi bi-save"></i> Update Review
                                </button>
                            </div>
                        </form>

                        <div class="delete-section">
                            <div class="delete-title">
                                <i class="bi bi-trash"></i> Delete Review
                            </div>
                            <p>If you wish to delete this review permanently, click the button below.</p>
                            <form action="<%= request.getContextPath() %>/delete-review" method="post">
                                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                                <input type="hidden" name="confirmDelete" value="yes">
                                <div class="d-flex justify-content-between">
                                    <select name="redirectTo" class="form-select w-50 me-2">
                                        <option value="movie">Return to movie reviews</option>
                                        <option value="user">Return to my reviews</option>
                                    </select>
                                    <button type="submit" class="btn btn-danger">
                                        <i class="bi bi-trash"></i> Delete Review
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>