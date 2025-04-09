<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FilmHorizon - Your Path to Film Mastery</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
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
        <ul class="navbar-nav ms-auto">
          <li class="nav-item active">
            <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>

          <!-- Check if user is logged in -->
          <% if (session.getAttribute("user") != null) { %>
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
          <% } else { %>
            <!-- User is not logged in, show login button -->
            <li class="nav-item active">
              <a class="nav-link" href="${pageContext.request.contextPath}/login">
                <img src="${pageContext.request.contextPath}/img/brand/white-button-login.png" width="33" height="33" alt="Login">
              </a>
            </li>
          <% } %>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Hero Section Start -->
  <div class="hero-section" style="background-image: url(${pageContext.request.contextPath}/img/Home/homepage.png);">
    <div class="hero-overlay text-white">
      <div class="container">
        <div class="col-md-6">
          <span class="hero-subtitle">Your Path to Film Mastery</span>
          <h1 class="hero-title display-4">Discover <span class="hero-title-highlight">Film Horizon</span></h1>
          <p class="hero-description">At Film Horizon, we bring the magic of movies to your fingertips. Whether you're a fan of classic films or the latest blockbusters, our extensive collection caters to every taste and genre. Dive into reviews, trailers, and exclusive interviews that enrich your viewing experience. Join our community of film enthusiasts and explore the stories that shape our world. Ready to embark on your cinematic journey?</p>
          <div class="mt-5">
            <a href="${pageContext.request.contextPath}/search-movie" class="btn hero-btn text-white">Explore Movies</a>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Hero Section End -->

  <!-- Featured Movies Section Start (Optional) -->
  <div class="container section-padding">
    <div class="row mb-4">
      <div class="col-12">
        <h2 class="text-center mb-4">Featured Movies</h2>
      </div>
    </div>
    <div class="row">
      <!-- This would be dynamically populated with top rated movies -->
      <div class="col-md-4 mb-4">
        <div class="movie-card">
          <img src="${pageContext.request.contextPath}/img/movies/placeholder.jpg" class="movie-poster" alt="Movie Poster">
          <div class="movie-card-body">
            <h5 class="movie-title">Movie Title</h5>
            <div class="movie-info">Director | 2023 | Action</div>
            <div class="movie-rating">
              <i class="fas fa-star"></i>
              <i class="fas fa-star"></i>
              <i class="fas fa-star"></i>
              <i class="fas fa-star"></i>
              <i class="fas fa-star-half-alt"></i>
              8.5/10
            </div>
            <div class="movie-actions">
              <a href="#" class="btn btn-sm btn-primary">Rent Now</a>
              <a href="#" class="btn btn-sm btn-outline-light"><i class="fas fa-heart"></i></a>
            </div>
          </div>
        </div>
      </div>
      <!-- Repeated for multiple movies -->
    </div>
    <div class="text-center mt-4">
      <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-primary rounded-btn">View All Movies</a>
    </div>
  </div>
  <!-- Featured Movies Section End -->

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
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>
</html>