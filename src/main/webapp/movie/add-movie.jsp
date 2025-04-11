<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Movie - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        /* Keep all the existing CSS styles */
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

        .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-select:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
        }

        .form-text {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        .form-check-input {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
        }

        .form-check-input:checked {
            background-color: var(--neon-blue);
            border-color: var(--neon-blue);
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

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        .divider {
            border-top: 1px solid #333;
            margin: 30px 0;
        }

        .movie-type-section {
            background: rgba(0, 200, 255, 0.05);
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            border: 1px dashed #444;
        }

        .type-badge {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            color: white;
            font-weight: 700;
            padding: 3px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-bottom: 15px;
            display: inline-block;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        /* New styles for file upload */
        .cover-photo-preview {
            width: 100%;
            height: 300px;
            border-radius: 8px;
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
            padding: 10px 15px;
            text-align: center;
            cursor: pointer;
        }

        .file-input-label:hover {
            background-color: #3a3a3a;
        }

        .file-input-label i {
            margin-right: 8px;
        }

        .selected-file-name {
            margin-top: 5px;
            font-size: 0.85rem;
            color: var(--text-secondary);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in and is an admin (for example purposes)
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/rental/rental-history.jsp">
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
            <div class="col-lg-10">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-plus-circle-fill"></i> Add New Movie
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/add-movie" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-6">
                                    <!-- Cover Photo Upload Section -->
                                    <div class="mb-4">
                                        <label class="form-label">Movie Cover Photo</label>
                                        <div class="cover-photo-preview" id="coverPhotoPreview">
                                            <i class="bi bi-image placeholder-icon"></i>
                                        </div>
                                        <div class="file-input-container">
                                            <label class="file-input-label">
                                                <i class="bi bi-upload"></i> Choose Cover Photo
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
                                        <input type="text" class="form-control" id="title" name="title" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="director" class="form-label">Director</label>
                                        <input type="text" class="form-control" id="director" name="director" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="genre" class="form-label">Genre</label>
                                        <select class="form-select" id="genre" name="genre" required>
                                            <option value="" selected disabled>Select genre</option>
                                            <option value="Action">Action</option>
                                            <option value="Adventure">Adventure</option>
                                            <option value="Comedy">Comedy</option>
                                            <option value="Drama">Drama</option>
                                            <option value="Fantasy">Fantasy</option>
                                            <option value="Horror">Horror</option>
                                            <option value="Mystery">Mystery</option>
                                            <option value="Romance">Romance</option>
                                            <option value="Science Fiction">Science Fiction</option>
                                            <option value="Thriller">Thriller</option>
                                            <option value="Western">Western</option>
                                            <option value="Documentary">Documentary</option>
                                            <option value="Animation">Animation</option>
                                        </select>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="releaseYear" class="form-label">Release Year</label>
                                            <input type="number" class="form-control" id="releaseYear" name="releaseYear" min="1900" max="2099" required>
                                        </div>

                                        <div class="col-md-6 mb-3">
                                            <label for="rating" class="form-label">Rating (0-10)</label>
                                            <input type="number" class="form-control" id="rating" name="rating" min="0" max="10" step="0.1" required>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Movie Type Selection -->
                            <div class="mb-4">
                                <label class="form-label">Movie Type</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="movieType" id="typeRegular" value="regular" checked>
                                    <label class="form-check-label" for="typeRegular">Regular Movie</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="movieType" id="typeNewRelease" value="newRelease">
                                    <label class="form-check-label" for="typeNewRelease">New Release</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="movieType" id="typeClassic" value="classic">
                                    <label class="form-check-label" for="typeClassic">Classic Movie</label>
                                </div>
                            </div>

                            <!-- New Release Fields -->
                            <div class="movie-type-section" id="newReleaseFields" style="display: none;">
                                <span class="type-badge">New Release Details</span>
                                <div class="mb-3">
                                    <label for="releaseDate" class="form-label">Release Date</label>
                                    <input type="date" class="form-control" id="releaseDate" name="releaseDate">
                                    <div class="form-text">Leave blank to use current date</div>
                                </div>
                            </div>

                            <!-- Classic Movie Fields -->
                            <div class="movie-type-section" id="classicFields" style="display: none;">
                                <span class="type-badge">Classic Movie Details</span>
                                <div class="mb-3">
                                    <label for="significance" class="form-label">Historical/Cultural Significance</label>
                                    <textarea class="form-control" id="significance" name="significance" rows="3"></textarea>
                                </div>
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="hasAwards" name="hasAwards">
                                    <label class="form-check-label" for="hasAwards">
                                        Won major awards (Oscar, Golden Globe, etc.)
                                    </label>
                                </div>
                            </div>

                            <div class="mt-4 d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Back to Movies
                                </a>
                                <button type="submit" class="btn btn-neon">
                                    <i class="bi bi-plus-circle"></i> Add Movie
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Show/hide additional fields based on movie type selection
        document.addEventListener('DOMContentLoaded', function() {
            const typeRadios = document.querySelectorAll('input[name="movieType"]');
            const newReleaseFields = document.getElementById('newReleaseFields');
            const classicFields = document.getElementById('classicFields');

            function updateFields() {
                const selectedType = document.querySelector('input[name="movieType"]:checked').value;

                if (selectedType === 'newRelease') {
                    newReleaseFields.style.display = 'block';
                    classicFields.style.display = 'none';
                } else if (selectedType === 'classic') {
                    newReleaseFields.style.display = 'none';
                    classicFields.style.display = 'block';
                } else {
                    newReleaseFields.style.display = 'none';
                    classicFields.style.display = 'none';
                }
            }

            // Set initial state
            updateFields();

            // Add event listeners to radio buttons
            typeRadios.forEach(radio => {
                radio.addEventListener('change', updateFields);
            });

            // Handle cover photo preview
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
                    // Reset to placeholder
                    coverPhotoPreview.innerHTML = '<i class="bi bi-image placeholder-icon"></i>';
                    selectedFileName.textContent = 'No file selected';
                }
            });
        });
    </script>
</body>
</html>