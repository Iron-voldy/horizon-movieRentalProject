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
    <title>Genre Recommendations - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
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
        String selectedGenre = (String) request.getAttribute("selectedGenre");
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
            <h1><%= selectedGenre %> Movies</h1>
            <p class="text-muted">
                Top-rated films in the <%= selectedGenre %> genre, selected just for you
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
                    <a href="<%= request.getContextPath() %>/genre-recommendations?genre=<%= genre %>"
                        class="badge <%= genre.equals(selectedGenre) ? "bg-primary" : "bg-secondary" %> text-decoration-none me-2 mb-2">
                        <%= genre %>
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Genre Recommendations -->
        <% if (recommendations == null || recommendations.isEmpty()) { %>
            <div class="text-center p-5">
                <i class="bi bi-film display-1 text-muted"></i>
                <p class="text-muted mt-3">No <%= selectedGenre %> movies available</p>
                <a href="<%= request.getContextPath() %>/generate-recommendations?type=general" class="btn btn-primary">
                    <i class="bi bi-arrow-repeat"></i> Generate Recommendations
                </a>
            </div>
        <% } else { %>
            <div class="row">
                <% for (GeneralRecommendation recommendation : recommendations) {
                    Movie movie = movieMap.get(recommendation.getMovieId());
                    if (movie != null) {
                %>
                    <div class="col-md-4 col-lg-3 mb-4">
                        <div class="card h-100">
                            <div class="card-img-top bg-dark text-center" style="height: 200px;">
                                <% if (movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty()) { %>
                                    <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>"
                                        alt="<%= movie.getTitle() %>" style="height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <i class="bi bi-film text-muted" style="font-size: 5rem; margin-top: 60px;"></i>
                                <% } %>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title"><%= movie.getTitle() %></h5>
                                <p class="card-text text-muted">
                                    <%= movie.getDirector() %> • <%= movie.getReleaseYear() %>
                                </p>

                                <span class="badge bg-primary mb-2">
                                    <i class="bi bi-tag-fill"></i> <%= movie.getGenre() %>
                                </span>

                                <div class="mb-2">
                                    <%
                                        // Display stars based on rating
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

                                <div class="card-text bg-light p-2 rounded mb-3 flex-grow-1">
                                    "<%= recommendation.getReason() %>"
                                </div>

                                <div class="d-flex gap-1 mt-auto">
                                    <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-sm btn-outline-primary flex-grow-1">
                                        <i class="bi bi-info-circle"></i> Details
                                    </a>
                                    <a href="<%= request.getContextPath() %>/add-to-watchlist?movieId=<%= movie.getMovieId() %>" class="btn btn-sm btn-outline-secondary flex-grow-1">
                                        <i class="bi bi-bookmark-plus"></i> Watchlist
                                    </a>
                                    <% if (movie.isAvailable()) { %>
                                        <a href="<%= request.getContextPath() %>/rent-movie?id=<%= movie.getMovieId() %>" class="btn btn-sm btn-outline-success flex-grow-1">
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

            <div class="text-center my-4">
                <a href="<%= request.getContextPath() %>/recommendation-action?action=generate-genre&genre=<%= selectedGenre %>" class="btn btn-primary">
                    <i class="bi bi-arrow-repeat"></i> Refresh Recommendations
                </a>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>