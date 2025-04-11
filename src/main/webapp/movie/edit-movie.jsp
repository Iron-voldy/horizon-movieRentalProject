<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.NewRelease" %>
<%@ page import="com.movierental.model.movie.ClassicMovie" %>
<%@ page import="com.movierental.model.movie.MovieManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Movie - FilmFlux</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
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
            margin-bottom: 25px;
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

        .edit-movie-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 25px;
            color: var(--neon-blue);
            text-align: center;
        }

        .form-label {
            color: var(--neon-blue);
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 12px 15px;
        }

        .form-control:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
        }

        .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 12px 15px;
        }

        .form-select:focus {
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

        .form-text {
            color: var(--text-secondary);
            font-size: 0.85rem;
            margin-top: 5px;
        }

        .btn-neon {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 12px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        .btn-neon:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 200, 255, 0.5);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(to right, #F44336, #FF5722);
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 12px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(244, 67, 54, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(244, 67, 54, 0.5);
            color: white;
        }

        .btn-secondary {
            background-color: #333;
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary:hover {
            background-color: #444;
            transform: translateY(-3px);
        }

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        /* Cover photo preview styles */
        .cover-photo-preview {
            width: 100%;
            height: 300px;
            border-radius: 10px;
            border: 2px dashed #444;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            overflow: hidden;
            position: relative;
            background-color: #2d2d2d;
        }

        .cover-photo-preview img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .cover-photo-preview .placeholder-icon {
            font-size: 4rem;
            color: #555;
        }

        .file-input-container {
            position: relative;
            margin-bottom: 20px;
        }

        .file-input-container input[type="file"] {
            opacity: 0;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .file-input-label {
            display: block;
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: var(--text-primary);
            border-radius: 8px;
            padding: 12px 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .file-input-label:hover {
            background-color: #3a3a3a;
            transform: translateY(-2px);
        }

        .file-input-label i {
            margin-right: 8px;
        }

        .selected-file-name {
            margin-top: 8px;
            font-size: 0.85rem;
            color: var(--text-secondary);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .current-photo-info {
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .current-photo-info i {
            margin-right: 5px;
            color: var(--neon-blue);
        }

        .movie-type-section {
            background: rgba(0, 200, 255, 0.05);
            border-radius: 12px;
            padding: 20px;
            margin: 25px 0;
            border: 1px dashed #444;
        }

        .type-badge {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            color: white;
            font-weight: 700;
            padding: 3px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-bottom: 15px;
            display: inline-block;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
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

        // Get movie from request attribute
        Movie movie = (Movie) request.getAttribute("movie");
        String movieType = (String) request.getAttribute("movieType");

        if (movie == null || movieType == null) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        boolean isNewRelease = "newRelease".equals(movieType);
        boolean isClassic = "classic".equals(movieType);

        // Create MovieManager to get the movie cover photo URL
        MovieManager movieManager = new MovieManager(application);
        String coverPhotoUrl = movieManager.getCoverPhotoUrl(movie);
        boolean hasCoverPhoto = coverPhotoUrl != null && !coverPhotoUrl.isEmpty();

        // Get specific movie properties
        String releaseDate = "";
        if (isNewRelease) {
            NewRelease newRelease = (NewRelease) movie;
            releaseDate = new SimpleDateFormat("yyyy-MM-dd").format(newRelease.getReleaseDate());
        }

        String significance = "";
        boolean hasAwards = false;
        if (isClassic) {
            ClassicMovie classicMovie = (ClassicMovie) movie;
            significance = classicMovie.getSignificance();
            hasAwards = classicMovie.hasAwards();
        }
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
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-pencil-square"></i> Edit Movie
                    </div>
                    <div class="card-body p-4">
                        <h2 class="edit-movie-title"><%= movie.getTitle() %></h2>

                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/update-movie" method="post" enctype="multipart/form-data">
                            <!-- Hidden field for movie ID -->
                            <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">
                            <input type="hidden" name="movieType" value="<%= movieType %>">

                            <div class="row">
                                <div class="col-md-6">
                                    <!-- Cover Photo Upload Section -->
                                    <div class="mb-4">
                                        <label class="form-label">Movie Cover Photo</label>
                                        <div class="cover-photo-preview" id="coverPhotoPreview">
                                            <% if(hasCoverPhoto) { %>
                                                <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>" alt="<%= movie.getTitle() %>">
                                            <% } else { %>
                                                <i class="bi bi-image placeholder-icon"></i>
                                            <% } %>
                                        </div>
                                        <% if(hasCoverPhoto) { %>
                                            <div class="current-photo-info">
                                                <i class="bi bi-info-circle"></i> Current cover photo will be kept unless you choose a new one
                                            </div>
                                        <% } %>
                                        <div class="file-input-container">
                                            <label class="file-input-label">
                                                <i class="bi bi-upload"></i> <%= hasCoverPhoto ? "Change Cover Photo" : "Choose Cover Photo" %>
                                                <input type="file" name="coverPhoto" id="coverPhotoInput" accept="image/*">
                                            </label>
                                            <div class="selected-file-name" id="selectedFileName">No file selected</div>
                                        </div>
                                        <div class="form-text">Recommended size: 300x450 pixels, Max file size: 5MB</div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <!-- Basic Movie Information -->
                                    <div class="mb-3">
                                        <label for="title" class="form-label">Movie Title</label>
                                        <input type="text" class="form-control" id="title" name="title"
                                               value="<%= movie.getTitle() %>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="director" class="form-label">Director</label>
                                        <input type="text" class="form-control" id="director" name="director"
                                               value="<%= movie.getDirector() %>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="genre" class="form-label">Genre</label>
                                        <select class="form-select" id="genre" name="genre" required>
                                            <option value="Action" <%= "Action".equals(movie.getGenre()) ? "selected" : "" %>>Action</option>
                                            <option value="Adventure" <%= "Adventure".equals(movie.getGenre()) ? "selected" : "" %>>Adventure</option>
                                            <option value="Comedy" <%= "Comedy".equals(movie.getGenre()) ? "selected" : "" %>>Comedy</option>
                                            <option value="Drama" <%= "Drama".equals(movie.getGenre()) ? "selected" : "" %>>Drama</option>
                                            <option value="Fantasy" <%= "Fantasy".equals(movie.getGenre()) ? "selected" : "" %>>Fantasy</option>
                                            <option value="Horror" <%= "Horror".equals(movie.getGenre()) ? "selected" : "" %>>Horror</option>
                                            <option value="Mystery" <%= "Mystery".equals(movie.getGenre()) ? "selected" : "" %>>Mystery</option>
                                            <option value="Romance" <%= "Romance".equals(movie.getGenre()) ? "selected" : "" %>>Romance</option>
                                            <option value="Science Fiction" <%= "Science Fiction".equals(movie.getGenre()) ? "selected" : "" %>>Science Fiction</option>
                                            <option value="Thriller" <%= "Thriller".equals(movie.getGenre()) ? "selected" : "" %>>Thriller</option>
                                            <option value="Western" <%= "Western".equals(movie.getGenre()) ? "selected" : "" %>>Western</option>
                                            <option value="Documentary" <%= "Documentary".equals(movie.getGenre()) ? "selected" : "" %>>Documentary</option>
                                            <option value="Animation" <%= "Animation".equals(movie.getGenre()) ? "selected" : "" %>>Animation</option>
                                        </select>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <label for="releaseYear" class="form-label">Release Year</label>
                                            <input type="number" class="form-control" id="releaseYear" name="releaseYear"
                                                   value="<%= movie.getReleaseYear() %>" min="1900" max="2099" required>
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <label for="rating" class="form-label">Rating (0-10)</label>
                                            <input type="number" class="form-control" id="rating" name="rating"
                                                   value="<%= movie.getRating() %>" min="0" max="10" step="0.1" required>
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <label class="form-label">Availability</label>
                                            <div class="form-check mt-2">
                                                <input class="form-check-input" type="checkbox" id="available" name="available"
                                                       <%= movie.isAvailable() ? "checked" : "" %>>
                                                <label class="form-check-label" for="available">
                                                    Available for rent
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Type-specific Fields -->
                            <% if(isNewRelease) { %>
                                <!-- New Release Fields -->
                                <div class="movie-type-section">
                                    <span class="type-badge">New Release Details</span>
                                    <div class="mb-3">
                                        <label for="releaseDate" class="form-label">Release Date</label>
                                        <input type="date" class="form-control" id="releaseDate" name="releaseDate"
                                               value="<%= releaseDate %>">
                                    </div>
                                </div>
                            <% } else if(isClassic) { %>
                                <!-- Classic Movie Fields -->
                                <div class="movie-type-section">
                                    <span class="type-badge">Classic Movie Details</span>
                                    <div class="mb-3">
                                        <label for="significance" class="form-label">Historical/Cultural Significance</label>
                                        <textarea class="form-control" id="significance" name="significance"
                                                  rows="3"><%= significance %></textarea>
                                    </div>
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="checkbox" id="hasAwards" name="hasAwards"
                                               <%= hasAwards ? "checked" : "" %>>
                                        <label class="form-check-label" for="hasAwards">
                                            Won major awards (Oscar, Golden Globe, etc.)
                                        </label>
                                    </div>
                                </div>
                            <% } %>

                            <div class="mt-4 d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <div>
                                    <a href="<%= request.getContextPath() %>/delete-movie?id=<%= movie.getMovieId() %>" class="btn btn-danger me-2">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                    <button type="submit" class="btn btn-neon">
                                        <i class="bi bi-save"></i> Save Changes
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Handle cover photo preview
        document.addEventListener('DOMContentLoaded', function() {
            const coverPhotoInput = document.getElementById('coverPhotoInput');
            const coverPhotoPreview = document.getElementById('coverPhotoPreview');
            const selectedFileName = document.getElementById('selectedFileName');

            coverPhotoInput.addEventListener('change', function() {
                if (this.files && this.files[0]) {
                    const file = this.files[0];
                    const reader = new FileReader();

                    reader.onload = function(e) {
                        // Clear the preview
                        coverPhotoPreview.innerHTML = '';

                        // Create image element
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        coverPhotoPreview.appendChild(img);

                        // Update file name display
                        selectedFileName.textContent = file.name;
                    };

                    reader.readAsDataURL(file);
                } else {
                    // If no new file is selected and there's an existing image, keep it
                    <% if(hasCoverPhoto) { %>
                    coverPhotoPreview.innerHTML = '<img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>" alt="<%= movie.getTitle() %>">';
                    <% } else { %>
                    coverPhotoPreview.innerHTML = '<i class="bi bi-image placeholder-icon"></i>';
                    <% } %>
                    selectedFileName.textContent = 'No file selected';
                }
            });
        });
    </script>
</body>
</html>