<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Recommendation - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .form-container {
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
    .recommendation-type {
      display: inline-block;
      padding: 8px 15px;
      border-radius: 5px;
      font-weight: 500;
      font-size: 1rem;
      margin-bottom: 15px;
    }
    .type-personal {
      background-color: rgba(155, 93, 229, 0.1);
      color: var(--c-accent);
      border: 1px solid var(--c-accent);
    }
    .type-general {
      background-color: rgba(25, 135, 84, 0.1);
      color: #198754;
      border: 1px solid #198754;
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

    <div class="form-container">
      <div class="form-header">
        <h2>Add Recommendation</h2>
        <p class="text-muted">Create a new movie recommendation for users.</p>

        <c:choose>
          <c:when test="${recommendationType eq 'personal'}">
            <div class="recommendation-type type-personal">
              <i class="fas fa-user me-2"></i> Personal Recommendation
            </div>
          </c:when>
          <c:otherwise>
            <div class="recommendation-type type-general">
              <i class="fas fa-globe me-2"></i> General Recommendation
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <form action="${pageContext.request.contextPath}/manage-recommendations" method="post">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="recType" value="${recommendationType}">

        <div class="form-section">
          <h4 class="form-section-title">Movie Selection</h4>
          <div class="mb-3">
            <label for="movieId" class="form-label">Select Movie</label>
            <select class="form-select" id="movieId" name="movieId" required>
              <option value="">-- Select a Movie --</option>
              <c:forEach var="movie" items="${allMovies}">
                <option value="${movie.movieId}">${movie.title} (${movie.releaseYear})</option>
              </c:forEach>
            </select>
          </div>
        </div>

        <div class="form-section">
          <h4 class="form-section-title">Recommendation Details</h4>
          <div class="mb-3">
            <label for="reason" class="form-label">Recommendation Reason</label>
            <textarea class="form-control" id="reason" name="reason" rows="3" required
                      placeholder="Why is this movie recommended?"></textarea>
          </div>

          <div class="mb-3">
            <label for="score" class="form-label">Score (1-10)</label>
            <input type="number" class="form-control" id="score" name="score"
                  min="1" max="10" step="0.1" value="8.0" required>
            <div class="form-text text-muted">
              Recommendation score represents the strength of the recommendation.
            </div>
          </div>

          <c:if test="${recommendationType eq 'personal'}">
            <div class="mb-3">
              <label for="userId" class="form-label">Select User</label>
              <select class="form-select" id="userId" name="userId" required>
                <option value="">-- Select a User --</option>
                <c:forEach var="user" items="${allUsers}">
                  <option value="${user.userId}">${user.username} (${user.email})</option>
                </c:forEach>
              </select>
            </div>

            <div class="mb-3">
              <label for="baseSource" class="form-label">Recommendation Source</label>
              <select class="form-select" id="baseSource" name="baseSource" required>
                <option value="genre-preference">Genre Preference</option>
                <option value="watch-history">Watch History</option>
                <option value="similar-movies">Similar Movies</option>
                <option value="trending">Trending</option>
                <option value="manual">Manual Selection</option>
              </select>
            </div>

            <div class="mb-3">
              <label for="relevanceScore" class="form-label">Relevance Score (0-1)</label>
              <input type="number" class="form-control" id="relevanceScore" name="relevanceScore"
                    min="0" max="1" step="0.01" value="0.8" required>
              <div class="form-text text-muted">
                How relevant this recommendation is to the user's preferences.
              </div>
            </div>
          </c:if>

          <c:if test="${recommendationType eq 'general'}">
            <div class="mb-3">
              <label for="category" class="form-label">Category</label>
              <select class="form-select" id="category" name="category" required>
                <option value="top-rated">Top Rated</option>
                <option value="trending">Trending</option>
                <option value="new-releases">New Releases</option>
                <option value="classics">Classics</option>
                <option value="manual">Manual Selection</option>
              </select>
            </div>

            <div class="mb-3">
              <label for="rank" class="form-label">Rank</label>
              <input type="number" class="form-control" id="rank" name="rank"
                    min="1" step="1" value="1" required>
              <div class="form-text text-muted">
                Position in the recommendation list (lower numbers appear first).
              </div>
            </div>
          </c:if>
        </div>

        <div class="d-flex mt-4">
          <a href="${pageContext.request.contextPath}/manage-recommendations" class="btn btn-outline-light me-3">
            <i class="fas fa-arrow-left me-2"></i> Cancel
          </a>
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-save me-2"></i> Save Recommendation
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