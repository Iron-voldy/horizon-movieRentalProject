<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.recommendation.Recommendation" %>
<%@ page import="com.movierental.model.recommendation.PersonalRecommendation" %>
<%@ page import="com.movierental.model.recommendation.GeneralRecommendation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recommendations - Movie Rental System</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #6C63FF;
            --secondary-color: #FF6584;
            --background-dark: #121212;
            --card-background: #1E1E1E;
            --text-primary: #FFFFFF;
            --text-secondary: #B0B0B0;
            --accent-color: #00C8FF;
        }

        body {
            background-color: var(--background-dark);
            color: var(--text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .recommendations-header {
            background: linear-gradient(135deg, rgba(108, 99, 255, 0.1), rgba(255, 101, 132, 0.1));
            padding: 4rem 0;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .recommendations-header h1 {
            font-weight: 700;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
        }

        .recommendations-nav {
            background-color: rgba(30,30,30,0.8);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .nav-pills .nav-link {
            color: var(--text-secondary);
            transition: all 0.3s ease;
        }

        .nav-pills .nav-link.active {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .recommendation-card {
            background-color: var(--card-background);
            border: 1px solid rgba(255,255,255,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
        }

        .recommendation-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.3);
        }

        .recommendation-card-image {
            height: 250px;
            overflow: hidden;
            position: relative;
        }

        .recommendation-card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .recommendation-card:hover .recommendation-card-image img {
            transform: scale(1.1);
        }

        .recommendation-card-body {
            padding: 1.5rem;
        }

        .recommendation-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .btn-recommendation {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            transition: all 0.3s ease;
        }

        .btn-recommendation:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(108, 99, 255, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 0;
            background-color: var(--card-background);
            border-radius: 10px;
        }

        .genre-filter {
            background-color: rgba(30,30,30,0.5);
            backdrop-filter: blur(10px);
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }

        .genre-badge {
            background-color: rgba(255,255,255,0.1);
            color: var(--text-secondary);
            margin: 0 5px 10px 0;
            transition: all 0.3s ease;
        }

        .genre-badge:hover, .genre-badge.active {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
        }

        @media (max-width: 768px) {
            .recommendations-header {
                padding: 2rem 0;
            }
        }
    </style>
</head>
<body>
    <%
        // Session and authentication check
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get recommendation data
        List<Recommendation> recommendations = null;
        Map<String, Movie> movieMap = null;
        String recommendationType = null;
        List<String> allGenres = null;

        recommendations = (List<Recommendation>) request.getAttribute("recommendations");
        movieMap = (Map<String, Movie>) request.getAttribute("movieMap");
        recommendationType = (String) request.getAttribute("recommendationType");
        allGenres = (List<String>) request.getAttribute("allGenres");

        boolean isPersonal = recommendationType != null && recommendationType.equals("personal");
    %>

    <!-- Navigation Bar -->
    <jsp:include page="../includes/navbar.jsp" />

    <div class="container mt-4">
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

        <!-- Page Header -->
        <div class="page-header text-center mb-4">
            <h1>
                <%= isPersonal ? "Personalized Recommendations" : "General Recommendations" %>
            </h1>
            <p class="text-muted">
                <%= isPersonal ? "Tailored movie suggestions based on your viewing history and preferences" : "Popular and trending movies that you might enjoy" %>
            </p>
        </div>

        <!-- Recommendation Tabs -->
        <div class="recommendation-tabs mb-4">
            <ul class="nav nav-tabs justify-content-center">
                <li class="nav-item">
                    <a class="nav-link <%= isPersonal ? "active" : "" %>" href="<%= request.getContextPath() %>/view-recommendations?type=personal">
                        <i class="bi bi-person-check"></i> Personalized
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= !isPersonal ? "active" : "" %>" href="<%= request.getContextPath() %>/view-recommendations?type=general">
                        <i class="bi bi-globe"></i> General
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/top-rated">
                        <i class="bi bi-star-fill"></i> Top Rated
                    </a>
                </li>
            </ul>
        </div>

        <!-- Genre Navigation -->
        <div class="genre-nav mb-4 p-3 bg-light rounded">
            <div class="d-flex flex-wrap">
                <% for (String genre : allGenres) { %>
                    <a href="<%= request.getContextPath() %>/genre-recommendations?genre=<%= genre %>" class="badge bg-secondary text-decoration-none me-2 mb-2">
                        <%= genre %>
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Recommendations Section -->
        <div class="container">
            <% if (recommendations == null || recommendations.isEmpty()) { %>
                <div class="recommendation-container">
                    <div class="recommendation-empty-state">
                        <i class="bi bi-lightning recommendation-empty-state-icon"></i>
                        <h3 class="recommendation-empty-state-title">No Recommendations Available</h3>
                        <p class="recommendation-empty-state-subtitle">We'll find some great movies for you soon!</p>
                        <a href="<%= request.getContextPath() %>/generate-recommendations?type=<%= recommendationType != null ? recommendationType : "general" %>"
                           class="btn recommendation-generate-btn">
                            <i class="bi bi-arrow-repeat"></i> Generate Recommendations
                        </a>
                    </div>
                </div>
            <% } else { %>
                <div class="recommendation-container">
                    <div class="row g-4">
                        <%
                        for (Recommendation recommendation : recommendations) {
                            Movie movie = movieMap.get(recommendation.getMovieId());
                            if (movie != null) {
                                double relevanceScore = 0.0;
                                String baseSource = "";

                                if (recommendation instanceof PersonalRecommendation) {
                                    PersonalRecommendation pr = (PersonalRecommendation) recommendation;
                                    relevanceScore = pr.getRelevanceScore();
                                    baseSource = pr.getBaseSource();
                                }
                        %>
                            <div class="col-md-4 col-lg-3">
                                <div class="recommendation-card">
                                    <div class="recommendation-card-image">
                                        <% if (movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty()) { %>
                                            <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>"
                                                 alt="<%= movie.getTitle() %>">
                                        <% } else { %>
                                            <div class="recommendation-card-image-placeholder">
                                                <i class="bi bi-film"></i>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="recommendation-card-body">
                                        <h5 class="recommendation-card-title"><%= movie.getTitle() %></h5>
                                        <p class="recommendation-card-subtitle">
                                            <%= movie.getDirector() %> • <%= movie.getReleaseYear() %>
                                        </p>

                                        <% if (isPersonal) { %>
                                            <div class="recommendation-match-badge">
                                                <i class="bi bi-bullseye"></i>
                                                <%= Math.round(relevanceScore * 100) %>% Match
                                            </div>
                                        <% } %>

                                        <div class="recommendation-rating">
                                            <div class="recommendation-rating-stars">
                                                <%
                                                    double rating = movie.getRating();
                                                    int fullStars = (int) Math.floor(rating / 2);
                                                    boolean halfStar = (rating / 2) - fullStars >= 0.5;

                                                    for (int i = 0; i < fullStars; i++) {
                                                        out.print("<i class='bi bi-star-fill'></i>");
                                                    }

                                                    if (halfStar) {
                                                        out.print("<i class='bi bi-star-half'></i>");
                                                    }

                                                    int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                                                    for (int i = 0; i < emptyStars; i++) {
                                                        out.print("<i class='bi bi-star'></i>");
                                                    }
                                                %>
                                            </div>
                                            <span class="recommendation-rating-value"><%= movie.getRating() %>/10</span>
                                        </div>

                                        <div class="recommendation-reason">
                                            "<%= recommendation.getReason() %>"
                                        </div>

                                        <div class="recommendation-actions">
                                            <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>"
                                               class="btn btn-sm recommendation-action-btn">
                                                <i class="bi bi-info-circle"></i> Details
                                            </a>
                                            <a href="<%= request.getContextPath() %>/add-to-watchlist?movieId=<%= movie.getMovieId() %>"
                                               class="btn btn-sm recommendation-action-btn">
                                                <i class="bi bi-bookmark-plus"></i> Watchlist
                                            </a>
                                            <% if (movie.isAvailable()) { %>
                                                <a href="<%= request.getContextPath() %>/rent-movie?id=<%= movie.getMovieId() %>"
                                                   class="btn btn-sm recommendation-action-btn">
                                                    <i class="bi bi-cart-plus"></i> Rent
                                                </a>
                                            <% } %>
                                        </div>
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

            <div class="text-center my-4">
                <a href="<%= request.getContextPath() %>/generate-recommendations?type=<%= recommendationType %>" class="btn btn-primary">
                                                                                     <i class="bi bi-arrow-repeat"></i> Refresh Recommendations
                                                                                 </a>
                                                                                 <% if (isPersonal) { %>
                                                                                     <a href="<%= request.getContextPath() %>/recommendation-action?action=clear-personal" class="btn btn-outline-danger ms-2">
                                                                                         <i class="bi bi-trash"></i> Clear Recommendations
                                                                                     </a>
                                                                                 <% } %>
                                                                                 </div>
                                                                                 </div>

                                                                                 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
                                                                                 </body>
                                                                                 </html>