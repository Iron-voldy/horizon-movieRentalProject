<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add New Movie - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .movie-form-container {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 30px;
      margin-top: 30px;
      margin-bottom: 50px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .form-header {
      margin-bottom: 30px;
    }
    .form-section {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 20px;
    }
    .form-section-title {
      font-weight: 500;
      color: var(--c-accent);
      margin-bottom: 15px;
      border-bottom: 1px solid #333;
      padding-bottom: 10px;
    }
    .form-control, .form-select {
      background-color: var(--c-dark-gray);
      border: 1px solid #444;
      color: white;
    }
    .form-control:focus, .form-select:focus {
      background-color: var(--c-dark-gray);
      color: white;
      border-color: var(--c-accent);
      box-shadow: 0 0 0 0.25rem rgba(155, 93, 229, 0.25);
    }
    .form-select option {
      background-color: var(--c-dark-gray);
      color: white;
    }
    .preview-container {
      max-width: 200px;
      max-height: 300px;
      overflow: hidden;
      margin-top: 10px;
      border-radius: 5px;
      border: 1px solid #444;
    }
    .preview-container img {
      width: 100%;
      height: auto;
      display: block;
    }
    .checkbox-container {
      display: flex;
      align-items: center;
    }
    .checkbox-container input[type="checkbox"] {
      margin-right: 8px;
    }
    .movie-type-section {
      display: none;
    }
  </style>
</head>
<body>
  <!-- Navbar Start -->
  <div class="navbar-dark">
    <nav class="navbar navbar-expand-lg navbar-dark container">
      <a class="navbar-brand py-2" href="${pageContext.request.contextPath}/">
        <img src="${pageContext.request.contextPath}/img/brand/brand-logo.png" width="120" height="40" alt="Brand Logo">
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <div class="search-container mx-auto">
          <form class="d-flex" action="${pageContext.request.contextPath}/search-movie" method="get">
            <input class="form-control search-input me-2" type="search" name="searchQuery" placeholder="Search movies..." aria-label="Search">
            <button class="btn custom-search-btn" type="submit">
              <i class="fas fa-search"></i>
            </button>
          </form>
        </div>

        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/top-rated">Top Rated</a>
          </li>

          <!-- Check if user is logged in -->
          <c:if test="${not empty sessionScope.user}">
            <!-- User is logged in, show appropriate options -->
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                My Account
              </a>
              <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/update-profile">Profile</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/rental-history">Rentals</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
              </ul>
            </li>
          </c:if>
          <c:if test="${empty sessionScope.user}">
            <!-- User is not logged in, show login button -->
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/login">
                <i class="fas fa-sign-in-alt"></i> Login
              </a>
            </li>
          </c:if>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Main Content Start -->
  <div class="container">
    <!-- Alert Messages -->
    <c:if test="${not empty errorMessage}">
      <div class="alert alert-danger alert-dismissible fade show mt-4" role="alert">
        ${errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    </c:if>

    <div class="movie-form-container">
      <div class="form-header">
        <h2>Add New Movie</h2>
        <p class="text-muted">Complete the form below to add a new movie to the catalog.</p>
      </div>

      <form action="${pageContext.request.contextPath}/add-movie" method="post" enctype="multipart/form-data">
        <div class="form-section">
          <h4 class="form-section-title">Basic Information</h4>
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="title" class="form-label">Movie Title</label>
              <input type="text" class="form-control" id="title" name="title" required>
            </div>
            <div class="col-md-6 mb-3">
              <label for="director" class="form-label">Director</label>
              <input type="text" class="form-control" id="director" name="director" required>
            </div>
          </div>

          <div class="row">
            <div class="col-md-4 mb-3">
              <label for="genre" class="form-label">Genre</label>
              <select class="form-select" id="genre" name="genre" required>
                <option value="">-- Select Genre --</option>
                <option value="Action">Action</option>
                <option value="Adventure">Adventure</option>
                <option value="Animation">Animation</option>
                <option value="Biography">Biography</option>
                <option value="Comedy">Comedy</option>
                <option value="Crime">Crime</option>
                <option value="Documentary">Documentary</option>
                <option value="Drama">Drama</option>
                <option value="Family">Family</option>
                <option value="Fantasy">Fantasy</option>
                <option value="History">History</option>
                <option value="Horror">Horror</option>
                <option value="Music">Music</option>
                <option value="Mystery">Mystery</option>
                <option value="Romance">Romance</option>
                <option value="Sci-Fi">Sci-Fi</option>
                <option value="Sport">Sport</option>
                <option value="Thriller">Thriller</option>
                <option value="War">War</option>
                <option value="Western">Western</option>
              </select>
            </div>
            <div class="col-md-4 mb-3">
              <label for="releaseYear" class="form-label">Release Year</label>
              <input type="number" class="form-control" id="releaseYear" name="releaseYear" min="1900" max="2030" required>
            </div>
            <div class="col-md-4 mb-3">
              <label for="rating" class="form-label">Rating (1-10)</label>
              <input type="number" class="form-control" id="rating" name="rating" min="1" max="10" step="0.1" value="7.0" required>
            </div>
          </div>
        </div>

        <div class="form-section">
          <h4 class="form-section-title">Movie Type</h4>
          <div class="mb-3">
            <label class="form-label">Select Movie Type</label>
            <div class="d-flex gap-4">
              <div class="form-check">
                <input class="form-check-input" type="radio" name="movieType" id="regularMovie" value="regular" checked onclick="showMovieTypeSection('regular')">
                <label class="form-check-label" for="regularMovie">
                  Regular Movie
                </label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="movieType" id="newRelease" value="newRelease" onclick="showMovieTypeSection('newRelease')">
                <label class="form-check-label" for="newRelease">
                  New Release
                </label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="movieType" id="classicMovie" value="classic" onclick="showMovieTypeSection('classic')">
                <label class="form-check-label" for="classicMovie">
                  Classic Movie
                </label>
              </div>
            </div>
          </div>

          <!-- New Release Specific Fields -->
          <div id="newReleaseSection" class="movie-type-section">
            <div class="mb-3">
              <label for="releaseDate" class="form-label">Release Date</label>
              <input type="date" class="form-control" id="releaseDate" name="releaseDate">
            </div>
          </div>

          <!-- Classic Movie Specific Fields -->
          <div id="classicSection" class="movie-type-section">
            <div class="mb-3">
              <label for="significance" class="form-label">Historical/Cultural Significance</label>
              <textarea class="form-control" id="significance" name="significance" rows="3"></textarea>
            </div>
            <div class="mb-3 checkbox-container">
              <input type="checkbox" id="hasAwards" name="hasAwards">
              <label for="hasAwards">Has won major awards</label>
            </div>
          </div>
        </div>

        <div class="form-section">
          <h4 class="form-section-title">Cover Photo</h4>
          <div class="mb-3">
            <label for="coverPhoto" class="form-label">Upload Cover Photo</label>
            <input type="file" class="form-control" id="coverPhoto" name="coverPhoto" accept="image/*" onchange="previewImage()">
            <div class="form-text text-muted">
              Recommended size: 500px x 750px. Max file size: 5MB.
            </div>
          </div>
          <div class="preview-container" id="imagePreview" style="display: none;">
            <img id="preview" src="#" alt="Cover Preview">
          </div>
        </div>

        <div class="d-flex mt-4">
          <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-outline-light me-3">
            <i class="fas fa-arrow-left me-2"></i> Cancel
          </a>
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-save me-2"></i> Add Movie
          </button>
        </div>
      </form>
    </div>
  </div>
  <!-- Main Content End -->

  <!-- Footer Start -->
  <footer class="bg-dark text-white py-4 mt-5">
    <div class="container">
      <div class="row">
        <div class="col-md-4 mb-3">
          <h5>About FilmHorizon</h5>
          <p class="text-muted">Your one-stop destination for renting and enjoying the best of cinema.</p>
        </div>
        <div class="col-md-4 mb-3">
          <h5>Quick Links</h5>
          <ul class="list-unstyled">
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/search-movie">Movies</a></li>
            <li><a href="${pageContext.request.contextPath}/top-rated">Top Rated</a></li>
            <li><a href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a></li>
          </ul>
        </div>
        <div class="col-md-4 mb-3">
          <h5>Connect With Us</h5>
          <div class="d-flex gap-3 mt-3">
            <a href="#" class="text-white"><i class="fab fa-facebook fa-lg"></i></a>
            <a href="#" class="text-white"><i class="fab fa-twitter fa-lg"></i></a>
            <a href="#" class="text-white"><i class="fab fa-instagram fa-lg"></i></a>
            <a href="#" class="text-white"><i class="fab fa-youtube fa-lg"></i></a>
          </div>
        </div>
      </div>
      <hr>
      <div class="text-center">
        <p class="mb-0">&copy; 2025 FilmHorizon. All rights reserved.</p>
      </div>
    </div>
  </footer>
  <!-- Footer End -->

  <!-- Bootstrap JavaScript Bundle with Popper -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

  <!-- Custom JavaScript for Form -->
  <script>
    // Function to preview uploaded image
    function previewImage() {
      const preview = document.getElementById('preview');
      const file = document.getElementById('coverPhoto').files[0];
      const reader = new FileReader();

      reader.onloadend = function() {
        preview.src = reader.result;
        document.getElementById('imagePreview').style.display = 'block';
      }

      if (file) {
        reader.readAsDataURL(file);
      } else {
        preview.src = '';
        document.getElementById('imagePreview').style.display = 'none';
      }
    }

    // Function to show/hide movie type specific sections
    function showMovieTypeSection(type) {
      // Hide all sections first
      document.getElementById('newReleaseSection').style.display = 'none';
      document.getElementById('classicSection').style.display = 'none';

      // Show the selected section
      if (type === 'newRelease') {
        document.getElementById('newReleaseSection').style.display = 'block';
      } else if (type === 'classic') {
        document.getElementById('classicSection').style.display = 'block';
      }
    }
  </script>
</body>
</html>
