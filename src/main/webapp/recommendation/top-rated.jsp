<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.recommendation.GeneralRecommendation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Rated Movies - Movie Rental System</title>

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

        .recommendation-generate-btn {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            transition: all 0.3s ease;
        }

        .recommendation-generate-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(108, 99, 255, 0.3);
        }

        .genre-nav {
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

        .top-rated-empty-state {
            background-color: var(--card-background);
            border-radius: 12px;
            padding: 50px 20px;
            text-align: center;
        }

        .top-rated-empty-state-icon {
            font-size: 4rem;
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .top-rated-empty-state-title {
            color: var(--text-primary);
            margin-bottom: 10px;
        }

        .top-rated-empty-state-subtitle {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .top-rated-list .card {
            background-color: var(--card-background);
            border: 1px solid rgba(255,255,255,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 1rem;
        }

        .top-rated-list .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.3);
        }

        .top-rated-list .card-body {
            color: var(--text-primary);
        }

        .top-rated-list .card-text {
            color: var(--text-secondary);
        }

        .top-rated-list .ranking-number {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: bold;
        }

        .top-rated-list .movie-image-container {
            background-color: rgba(255,255,255,0.05);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
        }

        .top-rated-list .movie-image-container img {
            max-width: 100%;
            max-height: 100%;
            object-fit: cover;
        }

        .top-rated-list .movie-image-container i {
            color: var(--text-secondary);
            font-size: 3rem;
        }

        .top-rated-list .movie-actions .btn {
            background-color: rgba(255,255,255,0.05);
            color: var(--text-secondary);
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
        }

        .top-rated-list .movie-actions .btn:hover {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .top-rated-list .card {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <%
        // Get user from session
        User user = (User) request.getSession(false).getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get data from request attributes
        List<GeneralRecommendation> recommendations = (List<GeneralRecommendation>) request.getAttribute("recommendations");
        Map<String, Movie> movieMap = (Map<String, Movie>) request.getAttribute("movieMap");
        List<String> allGenres = (List<String>) request.getAttribute("allGenres");

        // Date formatter
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    %>

    <!-- Navigation Bar -->
    <jsp:include page="../includes/navbar.jsp" />

    <div class="container mt-4">
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

        <!-- Page Header -->
        <div class="page-header text-center mb-4">
            <h1>Top Rated Movies</h1>
            <p class="text-muted">
                The highest-rated films in our collection, as rated by our community of movie lovers
            </p>
        </div>

        <!-- Recommendation Tabs -->
        <div class="recommendation-tabs mb-4">
            <ul class="nav nav-tabs justify-content-center">
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/view-recommendations?type=personal">
                        <i class="bi bi-person-check"></i> Personalized
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/view-recommendations?type=general">
                        <i class="bi bi-globe"></i> General
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%= request.getContextPath() %>/top-rated">
                        <i class="bi bi-star-fill"></i> Top Rated
                    </a>
                </li>
            </ul>
        </div>

        <!-- Genre Navigation -->
        <div class="genre-nav mb-4">
            <div class="d-flex flex-wrap">
                <% for (String genre : allGenres) { %>
                    <a href="<%= request.getContextPath() %>/genre-recommendations?genre=<%= genre %>" class="genre-badge">
                        <%= genre %>
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Top Rated Movies List -->
        <% if (recommendations == null || recommendations.isEmpty()) { %>
            <div class="top-rated-empty-state">
                <i class="bi bi-star top-rated-empty-state-icon"></i>
                <h3 class="top-rated-empty-state-title">No Top-Rated Movies Available</h3>
                <p class="top-rated-empty-state-subtitle">We'll update our top-rated list soon!</p>
                <a href="<%= request.getContextPath() %>/generate-recommendations?type=top-rated" class="btn recommendation-generate-btn">
                    <i class="bi bi-arrow-repeat"></i> Generate Top Rated
                </a>
            </div>
        <% } else { %>
            <div class="top-rated-list">
                <%
                    int displayRank = 1;
                    for (GeneralRecommendation recommendation : recommendations) {
                        Movie movie = movieMap.get(recommendation.getMovieId());
                        if (movie != null) {
                %>
                    <div class="card recommendation-card">
                        <div class="row g-0">
                            <div class="col-md-1 d-flex align-items-center justify-content-center">
                                <h2 class="ranking-number m-0"><%= displayRank++ %></h2>
                            </div>
                            <div class="col-md-2">
                                <div class="movie-image-container h-100">
                                    <% if (movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty()) { %>
                                        <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>"
                                             alt="<%= movie.getTitle() %>">
                                    <% } else { %>
                                        <i class="bi bi-film"></i>
                                    <% } %>
                                </div>
                            </div>
                            <div class="col-md-7">
                                <div class="card-body">
                                    <h5 class="card-title"><%= movie.getTitle() %></h5>
                                    <p class="card-text">
                                        <%= movie.getDirector() %> • <%= movie.getReleaseYear() %> • <%= movie.getGenre() %>
                                    </p>

                                    <div class="mb-2">
                                        <%
                                            double rating = movie.getRating();
                                            int fullStars = (int) Math.floor(rating / 2);
                                            boolean halfStar = (rating / 2) - fullStars >= 0.5;

                                            for (int i = 0; i < fullStars; i++) {
                                                out.print("<i class='bi bi-star-fill text-warning'></i> ");
                                            }

                                            if (halfStar) {
                                                out.print("<i class='bi bi-star-half text-warning'></i> ");
                                            }

                                            int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                                            for (int i = 0; i < emptyStars; i++) {
                                                out.print("<i class='bi bi-star text-warning'></i> ");
                                            }
                                        %>
                                        <span class="ms-1"><%= movie.getRating() %>/10</span>
                                    </div>

                                    <p class="card-text recommendation-reason">
                                        "<%= recommendation.getReason() %>"
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-2 d-flex flex-column justify-content-center p-3 movie-actions">
                                <a href="<%= request.getContextPath()%>/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-sm mb-2">
                                                                                                         <i class="bi bi-info-circle"></i> Details
                                                                                                     </a>
                                                                                                     <a href="<%= request.getContextPath() %>/add-to-watchlist?movieId=<%= movie.getMovieId() %>" class="btn btn-sm mb-2">
                                                                                                         <i class="bi bi-bookmark-plus"></i> Watchlist
                                                                                                     </a>
                                                                                                     <% if (movie.isAvailable()) { %>
                                                                                                         <a href="<%= request.getContextPath() %>/rent-movie?id=<%= movie.getMovieId() %>" class="btn btn-sm">
                                                                                                             <i class="bi bi-cart-plus"></i> Rent
                                                                                                         </a>
                                                                                                     <% } %>
                                                                                                 </div>
                                                                                             </div>
                                                                                         </div>
                                                                                     <%
                                                                                             }
                                                                                         }
                                                                                     %>
                                                                                 </div>

                                                                                 <div class="text-center my-4">
                                                                                     <a href="<%= request.getContextPath() %>/generate-recommendations?type=top-rated" class="btn recommendation-generate-btn">
                                                                                         <i class="bi bi-arrow-repeat"></i> Refresh Top Rated
                                                                                     </a>
                                                                                 </div>
                                                                             <% } %>
                                                                         </div>

                                                                         <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
                                                                     </body>
                                                                     </html>