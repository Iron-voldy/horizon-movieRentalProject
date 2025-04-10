<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Delete Movie - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .delete-container {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 30px;
      margin-top: 30px;
      margin-bottom: 50px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .delete-header {
      text-align: center;
      margin-bottom: 30px;
    }
    .delete-icon {
      font-size: 4rem;
      color: #dc3545;
      margin-bottom: 20px;
    }
    .movie-info-container {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 30px;
    }
    .movie-poster {
      width: 100%;
      max-width: 200px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .movie-title {
      font-size: 1.5rem;
      font-weight: 600;
      margin-bottom: 10px;
    }
    .movie-details {
      font-size: 0.9rem;
      color: var(--c-gray);
      list-style-type: none;
      padding-left: 0;
    }
    .movie-details li {
      margin-bottom: 8px;
    }
    .warning-text {
      color: #dc3545;
      font-weight: 500;
      text-align: center;
      margin-bottom: 20px;
    }
    .btn-delete {
      background-color: #dc3545;
      border-color: #dc3545;
    }
    .btn-delete:hover {
      background-color: #bb2d3b;
      border-color: #b02a37;
    }
    .delete-actions {
      display: flex;
      justify-content: center;
      gap: 15px;
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

    <div class="delete-container">
      <div class="delete-header">
        <i class="fas fa-trash-alt delete-icon"></i>
        <h2>Delete Movie</h2>
        <p class="text-muted">You are about to delete this movie from the catalog.</p>
      </div>

      <div class="movie-info-container">
        <div class="row">
          <div class="col-md-4 text-center">
            <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}"
                 class="movie-poster" alt="${movie.title} Poster">
          </div>
          <div class="col-md-8">
            <h3 class="movie-title">${movie.title}</h3>
            <ul class="movie-details">
              <li><strong>Director:</strong> ${movie.director}</li>
              <li><strong>Genre:</strong> ${movie.genre}</li>
              <li><strong>Release Year:</strong> ${movie.releaseYear}</li>
              <li><strong>Rating:</strong> ${movie.rating}/10</li>
              <c:if test="${movie['class'].simpleName eq 'ClassicMovie'}">
                <li><strong>Type:</strong> Classic Movie</li>
                <li><strong>Significance:</strong> ${movie.significance}</li>
              </c:if>
              <c:if test="${movie['class'].simpleName eq 'NewRelease'}">
                <li><strong>Type:</strong> New Release</li>
                <li><strong>Release Date:</strong> <fmt:formatDate value="${movie.releaseDate}" pattern="MMMM dd, yyyy" /></li>
              </c:if>
              <c:if test="${movie['class'].simpleName eq 'Movie'}">
                <li><strong>Type:</strong> Regular Movie</li>
              </c:if>
            </ul>
          </div>
        </div>
      </div>

      <p class="warning-text">
        <i class="fas fa-exclamation-triangle me-2"></i>
        Warning: This action cannot be undone. All data associated with this movie,
        including rental history and reviews, will be permanently deleted.
      </p>

      <form action="${pageContext.request.contextPath}/delete-movie" method="post" class="mt-4">
        <input type="hidden" name="movieId" value="${movie.movieId}">
        <div class="form-check mb-4 d-flex justify-content-center">
          <input class="form-check-input me-2" type="checkbox" id="confirmDelete" name="confirmDelete" value="yes" required>
          <label class="form-check-label" for="confirmDelete">
            I confirm that I want to permanently delete this movie
          </label>
        </div>

        <div class="delete-actions">
          <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}" class="btn btn-outline-light">
            <i class="fas fa-arrow-left me-2"></i> Cancel
          </a>
          <button type="submit" class="btn btn-delete">
            <i class="fas fa-trash-alt me-2"></i> Delete Movie
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
</body>
</html>