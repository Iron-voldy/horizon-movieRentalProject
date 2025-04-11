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
    <title>Browse Movies - Horizon</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --secondary: #ec4899;
            --dark: #0f172a;
            --darker: #020617;
            --light-text: #f1f5f9;
            --dark-text: #1e293b;
            --gray-text: #94a3b8;
            --card-bg: #1e293b;
            --card-secondary: #0f172a;
            --border-color: #475569;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --input-bg: #334155;
        }

        body {
            background-color: var(--darker);
            color: var(--light-text);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            padding-bottom: 3rem;
            background-image:
                radial-gradient(circle at 90% 10%, rgba(37, 99, 235, 0.1) 0%, transparent 40%),
                radial-gradient(circle at 10% 90%, rgba(236, 72, 153, 0.1) 0%, transparent 40%);
        }

        /* Main Container */
        .main-container {
            padding-top: 2rem;
        }

        /* Search Card */
        .search-card {
            background-color: var(--card-bg);
            border-radius: 1rem;
            border: 1px solid var(--border-color);
            overflow: hidden;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.25);
            margin-bottom: 2rem;
            transition: transform 0.3s;
        }

        .search-card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background: linear-gradient(to right, rgba(37, 99, 235, 0.1), rgba(236, 72, 153, 0.1));
            border-bottom: 1px solid var(--border-color);
            padding: 1.25rem 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--light-text);
            display: flex;
            align-items: center;
        }

        .header-title i {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-right: 0.75rem;
            font-size: 1.25rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Form Elements */
        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--light-text);
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: var(--input-bg);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.3);
            border-color: var(--primary);
            color: var(--light-text);
        }

        .form-control::placeholder {
            color: var(--gray-text);
        }

        .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--light-text);
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border-radius: 0.5rem;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23f1f5f9' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
        }

        .form-select:focus {
            background-color: var(--input-bg);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.3);
            border-color: var(--primary);
            color: var(--light-text);
        }

        /* Buttons */
        .btn {
            font-weight: 600;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary), #3b82f6);
            border: none;
            color: white;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.25);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px rgba(37, 99, 235, 0.35);
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        /* Movie Grid */
        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .movie-card {
            background-color: var(--card-bg);
            border-radius: 1rem;
            border: 1px solid var(--border-color);
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .movie-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(37, 99, 235, 0.3);
            border-color: rgba(37, 99, 235, 0.3);
        }

        .movie-poster {
            position: relative;
            height: 380px;
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
            background: linear-gradient(to top, rgba(15, 23, 42, 0.9), transparent);
            padding: 1.5rem 1rem 1rem;
            transition: all 0.3s ease;
        }

        .movie-card:hover .poster-overlay {
            background: linear-gradient(to top, rgba(37, 99, 235, 0.4), transparent);
        }

        .poster-placeholder {
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--card-secondary), var(--card-bg));
            color: var(--gray-text);
            font-size: 4rem;
        }

        .availability-indicator {
            position: absolute;
            top: 1rem;
            right: 1rem;
            width: 0.75rem;
            height: 0.75rem;
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
            padding: 1.25rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .movie-title {
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            color: var(--light-text);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.3;
        }

        .movie-subtitle {
            font-size: 0.875rem;
            color: var(--gray-text);
            margin-bottom: 1rem;
        }

        .movie-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .badge {
            padding: 0.4rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: 0.5rem;
        }

        .badge-blue {
            background: linear-gradient(to right, #2563eb, #3b82f6);
            color: white;
        }

        .badge-purple {
            background: linear-gradient(to right, #8b5cf6, #a855f7);
            color: white;
        }

        .badge-gold {
            background: linear-gradient(to right, #f59e0b, #fbbf24);
            color: #111827;
        }

        .rating {
            margin-top: auto;
            display: flex;
            align-items: center;
            border-top: 1px solid rgba(71, 85, 105, 0.3);
            padding-top: 1rem;
        }

        .rating-stars {
            color: #fbbf24;
            margin-right: 0.5rem;
        }

        .rating-value {
            font-weight: 600;
            color: var(--light-text);
        }

        .movie-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .movie-action-btn {
            flex: 1;
            text-align: center;
            padding: 0.6rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.5rem;
            background-color: rgba(51, 65, 85, 0.5);
            color: var(--light-text);
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid transparent;
        }

        .movie-action-btn:hover {
            background-color: rgba(37, 99, 235, 0.15);
            color: var(--primary);
            border-color: var(--primary);
            transform: translateY(-2px);
        }

        .movie-action-btn i {
            margin-right: 0.4rem;
        }

        /* Empty State */
        .empty-state {
            padding: 4rem 1.5rem;
            text-align: center;
            background-color: var(--card-bg);
            border-radius: 1rem;
            border: 1px solid var(--border-color);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--gray-text);
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.5rem;
            color: var(--light-text);
            margin-bottom: 0.75rem;
            font-weight: 600;
        }

        .empty-subtitle {
            color: var(--gray-text);
            margin-bottom: 1.5rem;
        }

        /* Alerts */
        .alert {
            border-radius: 0.75rem;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid;
        }

        .alert-success {
            background-color: rgba(16, 185, 129, 0.1);
            border-color: var(--success);
            color: #4ade80;
        }

        .alert-danger {
            background-color: rgba(239, 68, 68, 0.1);
            border-color: var(--danger);
            color: #f87171;
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
                grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .movie-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 1rem;
            }

            .movie-poster {
                height: 280px;
            }
        }

        @media (max-width: 576px) {
            .movie-grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                gap: 0.75rem;
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
    <jsp:include page="../includes/navbar.jsp" />

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