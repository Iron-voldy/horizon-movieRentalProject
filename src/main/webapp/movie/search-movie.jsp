<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.NewRelease" %>
<%@ page import="com.movierental.model.movie.ClassicMovie" %>
<%@ page import="com.movierental.model.movie.MovieManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Movies - FilmFlux</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #6C63FF;
            --primary-dark: #5A52E0;
            --secondary: #FF6584;
            --dark: #151419;
            --darker: #0F0E13;
            --light: #F3F3F4;
            --gray: #8B8B99;
            --success: #4BD1A0;
            --warning: #FFC965;
            --danger: #FF6B78;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dark);
            color: var(--light);
            min-height: 100vh;
            padding-bottom: 60px;
        }

        /* Navbar Styles */
        .navbar {
            background-color: rgba(15, 14, 19, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 15px 0;
        }

        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-right: 30px;
        }

        .nav-link {
            font-weight: 500;
            color: var(--light);
            margin: 0 15px;
            position: relative;
            opacity: 0.8;
            transition: all 0.3s ease;
        }

        .nav-link:hover, .nav-link.active {
            opacity: 1;
            color: var(--primary);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            transition: width 0.3s ease;
        }

        .nav-link:hover::after, .nav-link.active::after {
            width: 100%;
        }

        /* Main Container */
        .main-container {
            padding-top: 30px;
        }

        /* Search Card */
        .search-card {
            background: rgba(15, 14, 19, 0.7);
            backdrop-filter: blur(20px);
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            margin-bottom: 30px;
        }

        .card-header {
            background-color: rgba(255, 255, 255, 0.05);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--light);
            display: flex;
            align-items: center;
        }

        .header-title i {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-right: 10px;
            font-size: 1.4rem;
        }

        .card-body {
            padding: 20px;
        }

        /* Form Elements */
        .form-control {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--light);
            padding: 12px 15px;
            font-size: 1rem;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.08);
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(108, 99, 255, 0.25);
            color: var(--light);
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }

        .form-select {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--light);
            padding: 12px 15px;
            font-size: 1rem;
            border-radius: 10px;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23ffffff' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3e%3c/svg%3e");
        }

        .form-select:focus {
            background-color: rgba(255, 255, 255, 0.08);
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(108, 99, 255, 0.25);
            color: var(--light);
        }

        /* Buttons */
        .btn {
            padding: 12px 20px;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary), var(--primary-dark));
            border: none;
            box-shadow: 0 5px 15px rgba(108, 99, 255, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(108, 99, 255, 0.6);
            background: linear-gradient(45deg, var(--primary), var(--primary-dark));
        }

        .btn-outline-primary {
            border: 2px solid var(--primary);
            color: var(--primary);
            font-weight: 600;
        }

        .btn-outline-primary:hover {
            background-color: var(--primary);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(108, 99, 255, 0.3);
        }

        .btn-sm {
            padding: 8px 15px;
            font-size: 0.85rem;
        }

        /* Movie Grid */
        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }

        .movie-card {
            background: rgba(15, 14, 19, 0.7);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .movie-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(108, 99, 255, 0.3);
            border-color: rgba(108, 99, 255, 0.3);
        }

        .movie-poster {
            position: relative;
            height: 375px;
            overflow: hidden;
        }

        .movie-poster img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .movie-card:hover .movie-poster img {
            transform: scale(1.05);
        }

        .poster-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(15, 14, 19, 0.9), transparent);
            padding: 20px 15px;
            transition: all 0.3s ease;
        }

        .movie-card:hover .poster-overlay {
            background: linear-gradient(to top, rgba(108, 99, 255, 0.3), transparent);
        }

        .poster-placeholder {
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(15, 14, 19, 0.8), rgba(30, 28, 38, 0.8));
            color: var(--gray);
            font-size: 4rem;
        }

        .availability-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            z-index: 2;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }

        .available {
            background-color: var(--success);
            box-shadow: 0 0 15px var(--success);
        }

        .unavailable {
            background-color: var(--danger);
            box-shadow: 0 0 15px var(--danger);
        }

        .movie-info {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .movie-title {
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 5px;
            color: var(--light);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.3;
        }

        .movie-subtitle {
            font-size: 0.9rem;
            color: var(--gray);
            margin-bottom: 15px;
        }

        .movie-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            margin-bottom: 15px;
        }

        .badge {
            padding: 5px 10px;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: 8px;
        }

        .badge-blue {
            background: linear-gradient(to right, #0277bd, #00c8ff);
            color: white;
        }

        .badge-purple {
            background: linear-gradient(to right, #8a2be2, #ff00ff);
            color: white;
        }

        .badge-gold {
            background: linear-gradient(to right, #FFC965, #FFAA00);
            color: #333;
        }

        .rating {
            margin-top: auto;
            display: flex;
            align-items: center;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 15px;
        }

        .rating-stars {
            color: var(--warning);
            margin-right: 8px;
        }

        .rating-value {
            font-weight: 600;
            color: var(--light);
        }

        .movie-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
        }

        .movie-action-btn {
            flex: 1;
            text-align: center;
            padding: 8px;
            font-size: 0.85rem;
            border-radius: 8px;
            background-color: rgba(255, 255, 255, 0.05);
            color: var(--gray);
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .movie-action-btn:hover {
            background-color: rgba(108, 99, 255, 0.1);
            color: var(--primary);
            transform: translateY(-2px);
        }

        .movie-action-btn i {
            margin-right: 5px;
        }

        /* Empty State */
        .empty-state {
            padding: 50px 20px;
            text-align: center;
            background: rgba(15, 14, 19, 0.7);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--gray);
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.5rem;
            color: var(--light);
            margin-bottom: 10px;
        }

        .empty-subtitle {
            color: var(--gray);
            margin-bottom: 25px;
        }

        /* Alerts */
        .alert {
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
            font-weight: 500;
        }

        .alert-success {
            background-color: rgba(75, 209, 160, 0.2);
            color: var(--success);
            border-left: 4px solid var(--success);
        }

        .alert-danger {
            background-color: rgba(255, 107, 120, 0.2);
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out forwards;
        }

        /* Responsive Adjustments */
        @media (max-width: 992px) {
            .movie-grid {
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .movie-grid {
                grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
                gap: 15px;
            }

            .movie-poster {
                height: 280px;
            }
        }

        @media (max-width: 576px) {
            .movie-grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                gap: 10px;
            }

            .movie-poster {
                height: 240px;
            }

            .movie-title {
                font-size: 1rem;
            }

            .movie-subtitle, .movie-action-btn {
                font-size: 0.8rem;
            }
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

        // Get search parameters and movie list from request attributes
        String searchQuery = (String) request.getAttribute("searchQuery");
        String searchType = (String) request.getAttribute("searchType");
        List<Movie> movies = (List<Movie>) request.getAttribute("movies");

        if (searchQuery == null) searchQuery = "";
        if (searchType == null) searchType = "title";
        if (movies == null) movies = new ArrayList<Movie>();

        // Create MovieManager to get image URLs
        MovieManager movieManager = new MovieManager(application);
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
                    <li class="nav-item">
                    <a class="nav-link"  href="<%= request.getContextPath() %>/user-reviews">
                        <i class="bi bi-star"></i> My Reviews
                    </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/view-recommendations">
                            <i class="bi bi-lightning-fill"></i> Recommendations
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

    <div class="container main-container">
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

        <!-- Search Card -->
        <div class="search-card fade-in">
            <div class="card-header">
                <div class="header-title">
                    <i class="bi bi-search"></i> Browse Movies
                </div>
                <div>
                    <a href="<%= request.getContextPath() %>/add-movie" class="btn btn-primary btn-sm">
                        <i class="bi bi-plus-circle"></i> Add Movie
                    </a>
                </div>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/search-movie" method="get">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="searchQuery" name="searchQuery"
                                   placeholder="Search movies..." value="<%= searchQuery %>">
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="searchType" name="searchType">
                                <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>Title</option>
                                <option value="director" <%= "director".equals(searchType) ? "selected" : "" %>>Director</option>
                                <option value="genre" <%= "genre".equals(searchType) ? "selected" : "" %>>Genre</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Movies Grid -->
        <% if(movies.isEmpty()) { %>
            <div class="empty-state fade-in">
                <i class="bi bi-film empty-icon"></i>
                <h2 class="empty-title">No movies found</h2>
                <p class="empty-subtitle">Try adjusting your search or add a new movie to the collection</p>
                <a href="<%= request.getContextPath() %>/add-movie" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> Add a Movie
                </a>
            </div>
        <% } else { %>
            <div class="movie-grid">
                <% for(Movie movie : movies) {
                    boolean isNewRelease = movie instanceof NewRelease;
                    boolean isClassic = movie instanceof ClassicMovie;
                    boolean hasAwards = isClassic && ((ClassicMovie)movie).hasAwards();
                    String movieType = isNewRelease ? "New Release" : (isClassic ? "Classic" : "Regular");

                    // Get cover photo URL if available
                    String coverPhotoUrl = movieManager.getCoverPhotoUrl(movie);
                    boolean hasCoverPhoto = movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty();
                %>
                    <div class="movie-card fade-in">
                        <div class="movie-poster">
                            <% if(hasCoverPhoto) { %>
                                <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>" alt="<%= movie.getTitle() %>">
                            <% } else { %>
                                <div class="poster-placeholder">
                                    <i class="bi bi-film"></i>
                                </div>
                            <% } %>
                            <div class="availability-indicator <%= movie.isAvailable() ? "available" : "unavailable" %>"></div>
                            <div class="poster-overlay">
                                <h5 class="movie-title"><%= movie.getTitle() %></h5>
                                <p class="movie-subtitle">
                                    <%= movie.getDirector() %> • <%= movie.getReleaseYear() %>
                                </p>
                            </div>
                        </div>
                        <div class="movie-info">
                            <div class="movie-badges">
                                <span class="badge badge-blue"><%= movie.getGenre() %></span>
                                <% if(isNewRelease) { %>
                                    <span class="badge badge-purple">New Release</span>
                                <% } else if(isClassic) { %>
                                    <span class="badge badge-purple">Classic</span>
                                    <% if(hasAwards) { %>
                                        <span class="badge badge-gold">Award Winner</span>
                                    <% } %>
                                <% } %>
                            </div>

                            <div class="rating">
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

                            <div class="movie-actions">
                                <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="movie-action-btn">
                                    <i class="bi bi-info-circle"></i> Details
                                </a>
                                <a href="<%= request.getContextPath() %>/update-movie?id=<%= movie.getMovieId() %>" class="movie-action-btn">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                <a href="<%= request.getContextPath() %>/delete-movie?id=<%= movie.getMovieId() %>" class="movie-action-btn">
                                    <i class="bi bi-trash"></i> Delete
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Fade in animation for elements
        document.addEventListener('DOMContentLoaded', function() {
            const fadeElements = document.querySelectorAll('.fade-in');
            fadeElements.forEach((element, index) => {
                element.style.animationDelay = `${index * 0.1}s`;
            });
        });
    </script>
</body>
</html>