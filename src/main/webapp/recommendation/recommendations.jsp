<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Movie Recommendations - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .recommendation-container {
      margin-top: 30px;
      margin-bottom: 50px;
    }
    .recommendation-header {
      margin-bottom: 30px;
    }
    .recommendation-tabs .nav-link {
      color: var(--c-gray);
      border: none;
      border-bottom: 2px solid transparent;
      padding: 12px 20px;
      border-radius: 0;
    }
    .recommendation-tabs .nav-link.active {
      background-color: transparent;
      color: var(--c-accent);
      border-bottom: 2px solid var(--c-accent);
    }
    .recommendation-tabs .nav-link:hover:not(.active) {
      border-bottom: 2px solid var(--c-gray);
    }
    .recommendation-card {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      overflow: hidden;
      transition: transform 0.3s ease;
      height: 100%;
      border: 1px solid #333;
      margin-bottom: 20px;
    }
    .recommendation-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }
    .recommendation-poster {
      height: 250px;
      object-fit: cover;
      width: 100%;
    }
    .recommendation-body {
      padding: 15px;
    }
    .recommendation-title {
      font-weight: 600;
      margin-bottom: 5px;
    }
    .recommendation-info {
      color: var(--c-gray);
      font-size: 0.9rem;
      margin-bottom: 10px;
    }
    .recommendation-reason {
      font-size: 0.85rem;
      color: var(--c-accent);
      font-style: italic;
      margin-bottom: 15px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    .recommendation-rating {
      margin-bottom: 15px;
    }
    .recommendation-actions {
      display: flex;
      justify-content: space-between;
    }
    .badge-personalized {
      position: absolute;
      top: 10px;
      right: 10px;
      background-color: var(--c-accent);
      color: white;
      padding: 5px 8px;
      border-radius: 4px;
      font-size: 0.7rem;
      font-weight: 500;
    }
    .badge-relevance {
      display: inline-block;
      background-color: rgba(155, 93, 229, 0.1);
      color: var(--c-accent);
      padding: 3px 8px;
      border-radius: 4px;
      font-size: 0.75rem;
      margin-top: 5px;
    }
    .empty-recs {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 40px;
      text-align: center;
      margin-top: 20px;
    }
    .refresh-button {
      position: absolute;
      right: 15px;
      top: 15px;
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
  <div class="container recommendation-container">
    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
      <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
      <c:remove var="errorMessage" scope="session" />
    </c:if>

    <div class="recommendation-header position-relative">
      <h2>Movie Recommendations</h2>
      <p class="text-muted">Discover movies tailored for you based on your preferences and viewing history.</p>

      <a href="${pageContext.request.contextPath}/recommendation-action?action=generate-${recommendationType}" class="btn btn-sm btn-outline-light refresh-button">
        <i class="fas fa-sync-alt me-2"></i> Refresh Recommendations
      </a>
    </div>

    <!-- Recommendation Type Tabs -->
    <ul class="nav recommendation-tabs mb-4">
      <li class="nav-item">
        <a class="nav-link ${recommendationType == 'personal' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/view-recommendations?type=personal">
          <i class="fas fa-user me-2"></i> Personal Recommendations
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link ${recommendationType == 'general' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/view-recommendations?type=general">
          <i class="fas fa-globe me-2"></i> General Recommendations
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/top-rated">
          <i class="fas fa-star me-2"></i> Top Rated Movies
        </a>
      </li>
    </ul>

    <!-- Genre Filter Section -->
    <c:if test="${not empty allGenres}">
      <div class="mb-4">
        <div class="d-flex flex-wrap gap-2">
          <c:forEach var="genre" items="${allGenres}">
            <a href="${pageContext.request.contextPath}/genre-recommendations?genre=${genre}" class="btn btn-sm btn-outline-light">
              ${genre}
            </a>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <!-- Recommendations Section -->
    <div class="row">
      <c:choose>
        <c:when test="${empty recommendations || recommendations.size() == 0}">
          <div class="col-12">
            <div class="empty-recs">
              <i class="fas fa-film fa-3x mb-3 text-muted"></i>
              <h4>No recommendations available</h4>
              <p class="text-muted">We don't have any recommendations for you at the moment.</p>
              <a href="${pageContext.request.contextPath}/recommendation-action?action=generate-${recommendationType}" class="btn btn-primary mt-3">
                <i class="fas fa-sync-alt me-2"></i> Generate Recommendations
              </a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="recommendation" items="${recommendations}">
            <c:set var="movie" value="${movieMap[recommendation.movieId]}" />
            <c:if test="${not empty movie}">
              <div class="col-md-6 col-lg-4 mb-4">
                <div class="recommendation-card position-relative">
                  <c:if test="${recommendation.isPersonalized()}">
                    <span class="badge-personalized">Personalized</span>
                  </c:if>
                  <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}" class="recommendation-poster" alt="${movie.title} Poster">
                  <div class="recommendation-body">
                    <h5 class="recommendation-title">${movie.title}</h5>
                    <div class="recommendation-info">${movie.director} | ${movie.releaseYear} | ${movie.genre}</div>
                    <div class="recommendation-reason">"${recommendation.reason}"</div>
                    <div class="recommendation-rating">
                      <c:forEach var="i" begin="1" end="5">
                        <c:choose>
                          <c:when test="${movie.rating >= i*2}">
                            <i class="fas fa-star text-warning"></i>
                          </c:when>
                          <c:when test="${movie.rating >= i*2-1}">
                            <i class="fas fa-star-half-alt text-warning"></i>
                          </c:when>
                          <c:otherwise>
                            <i class="far fa-star text-warning"></i>
                          </c:otherwise>
                        </c:choose>
                      </c:forEach>
                      <span class="ms-1">${movie.rating}/10</span>

                      <c:if test="${recommendation.isPersonalized()}">
                        <div class="badge-relevance">
                          <i class="fas fa-bullseye me-1"></i>
                          <c:set var="relevance" value="${recommendation.relevanceScore * 100}" />
                          ${relevance.intValue()}% match
                        </div>
                      </c:if>
                    </div>
                    <div class="recommendation-actions">
                      <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}" class="btn btn-sm btn-outline-light">
                        <i class="fas fa-info-circle me-1"></i> Details
                      </a>
                      <c:choose>
                        <c:when test="${movie.available}">
                          <a href="${pageContext.request.contextPath}/rent-movie?id=${movie.movieId}" class="btn btn-sm btn-primary">
                            <i class="fas fa-shopping-cart me-1"></i> Rent
                          </a>
                        </c:when>
                        <c:otherwise>
                          <button class="btn btn-sm btn-secondary" disabled>
                            <i class="fas fa-clock me-1"></i> Unavailable
                          </button>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                </div>
              </div>
            </c:if>
          </c:forEach>
        </c:otherwise>
      </c:choose>
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