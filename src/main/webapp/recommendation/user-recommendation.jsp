<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Your Recommendations - FilmHorizon</title>
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
    .movie-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 20px;
      margin-top: 30px;
    }
    .movie-card {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      overflow: hidden;
      transition: transform 0.3s ease;
      height: 100%;
      position: relative;
    }
    .movie-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }
    .movie-poster {
      height: 250px;
      object-fit: cover;
      width: 100%;
    }
    .movie-card-body {
      padding: 15px;
    }
    .movie-title {
      font-weight: 600;
      margin-bottom: 5px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .movie-info {
      color: var(--c-gray);
      font-size: 0.9rem;
      margin-bottom: 5px;
    }
    .movie-rating {
      margin-bottom: 10px;
    }
    .movie-reason {
      font-style: italic;
      font-size: 0.85rem;
      color: var(--c-accent);
      margin-bottom: 10px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      min-height: 38px;
    }
    .movie-actions {
      display: flex;
      justify-content: space-between;
    }
    .match-badge {
      position: absolute;
      top: 10px;
      right: 10px;
      background-color: var(--c-accent);
      color: white;
      font-weight: 500;
      font-size: 0.8rem;
      padding: 4px 8px;
      border-radius: 4px;
    }
    .preference-form {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 30px;
    }
    .preference-title {
      font-weight: 500;
      color: var(--c-accent);
      margin-bottom: 15px;
    }
    .empty-state {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 40px;
      text-align: center;
      margin-top: 20px;
    }
    .genre-pill {
      display: inline-block;
      padding: 5px 10px;
      background-color: rgba(155, 93, 229, 0.1);
      color: var(--c-accent);
      border: 1px solid var(--c-accent);
      border-radius: 20px;
      font-size: 0.8rem;
      margin: 0 5px 5px 0;
    }
    .filter-section {
      border-top: 1px solid #333;
      margin-top: 20px;
      padding-top: 20px;
    }
    .filter-title {
      font-weight: 500;
      margin-bottom: 15px;
    }
    .filter-options {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }
    .filter-btn {
      background-color: var(--c-dark-gray);
      color: var(--c-gray);
      border: 1px solid #444;
      transition: all 0.3s ease;
    }
    .filter-btn:hover, .filter-btn.active {
      background-color: var(--c-accent);
      color: white;
      border-color: var(--c-accent);
    }
    .recommendation-banner {
      background: linear-gradient(to right, rgba(0,0,0,0.8), rgba(0,0,0,0.5)),
                  url('${pageContext.request.contextPath}/img/recommendation-banner.jpg');
      background-size: cover;
      background-position: center;
      border-radius: 10px;
      padding: 30px;
      margin-bottom: 20px;
      color: white;
    }
    .banner-title {
      font-size: 1.8rem;
      font-weight: 600;
      margin-bottom: 10px;
    }
    .banner-subtitle {
      color: var(--c-gray);
      margin-bottom: 20px;
    }
    .banner-highlight {
      color: var(--c-accent);
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

    <!-- Recommendation Banner -->
    <div class="recommendation-banner">
      <div class="row">
        <div class="col-md-8">
          <h1 class="banner-title">Your <span class="banner-highlight">Personalized</span> Movie Recommendations</h1>
          <p class="banner-subtitle">Discover movies tailored just for you, based on your preferences and viewing history.</p>
          <a href="${pageContext.request.contextPath}/recommendation-action?action=generate-personal" class="btn btn-primary">
            <i class="fas fa-sync-alt me-2"></i> Refresh Recommendations
          </a>
        </div>
      </div>
    </div>

    <!-- Recommendation Tabs -->
    <ul class="nav recommendation-tabs mb-4">
      <li class="nav-item">
        <a class="nav-link active" href="${pageContext.request.contextPath}/user-recommendation">
          <i class="fas fa-user me-2"></i> For You
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/view-recommendations?type=general">
          <i class="fas fa-globe me-2"></i> General Recommendations
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/top-rated">
          <i class="fas fa-star me-2"></i> Top Rated
        </a>
      </li>
    </ul>

    <!-- Genre Preferences Section -->
    <div class="preference-form">
      <h4 class="preference-title"><i class="fas fa-film me-2"></i> Your Movie Preferences</h4>

      <div class="row">
        <div class="col-md-6">
          <h5 class="mb-3">Favorite Genres</h5>
          <div class="mb-3">
            <c:forEach var="genre" items="${userGenres}">
              <span class="genre-pill">${genre}</span>
            </c:forEach>
            <c:if test="${empty userGenres}">
              <p class="text-muted">No preferred genres found. Start watching movies to build your preferences!</p>
            </c:if>
          </div>
        </div>

        <div class="col-md-6">
          <h5 class="mb-3">Recently Watched</h5>
          <c:if test="${not empty recentlyWatched && recentlyWatched.size() > 0}">
            <ul class="list-unstyled">
              <c:forEach var="movieId" items="${recentlyWatched.movieIds}" varStatus="status" end="2">
                <c:set var="movie" value="${movieMap[movieId]}" />
                <c:if test="${not empty movie}">
                  <li class="mb-2">
                    <i class="fas fa-check-circle text-success me-2"></i>
                    ${movie.title} (${movie.releaseYear})
                  </li>
                </c:if>
              </c:forEach>
            </ul>
            <a href="${pageContext.request.contextPath}/recently-watched" class="btn btn-sm btn-outline-light mt-2">
              <i class="fas fa-history me-1"></i> View All
            </a>
          </c:if>
          <c:if test="${empty recentlyWatched || recentlyWatched.size() == 0}">
            <p class="text-muted">No recently watched movies found. Start watching to get better recommendations!</p>
          </c:if>
        </div>
      </div>

      <div class="filter-section">
        <h5 class="filter-title">Filter Recommendations</h5>
        <div class="filter-options">
          <a href="${pageContext.request.contextPath}/user-recommendation?filter=all"
             class="btn btn-sm ${param.filter == null || param.filter == 'all' ? 'btn-primary' : 'filter-btn'}">
            All
          </a>
          <a href="${pageContext.request.contextPath}/user-recommendation?filter=genre"
             class="btn btn-sm ${param.filter == 'genre' ? 'btn-primary' : 'filter-btn'}">
            By Genre
          </a>
          <a href="${pageContext.request.contextPath}/user-recommendation?filter=new"
             class="btn btn-sm ${param.filter == 'new' ? 'btn-primary' : 'filter-btn'}">
            New Releases
          </a>
          <a href="${pageContext.request.contextPath}/user-recommendation?filter=high-match"
             class="btn btn-sm ${param.filter == 'high-match' ? 'btn-primary' : 'filter-btn'}">
            High Match (90%+)
          </a>
        </div>
      </div>
    </div>

    <!-- Recommendations Section -->
    <c:choose>
      <c:when test="${empty personalRecommendations || personalRecommendations.size() == 0}">
        <div class="empty-state">
          <i class="fas fa-film fa-3x mb-3 text-muted"></i>
          <h4>No personalized recommendations yet</h4>
          <p class="text-muted">We're still learning your preferences. Watch more movies, add to your watchlist, or write reviews to get personalized recommendations.</p>
          <a href="${pageContext.request.contextPath}/recommendation-action?action=generate-personal" class="btn btn-primary mt-3">
            <i class="fas fa-sync-alt me-2"></i> Generate Recommendations
          </a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="movie-grid">
          <c:forEach var="recommendation" items="${personalRecommendations}">
            <c:set var="movie" value="${movieMap[recommendation.movieId]}" />
            <c:if test="${not empty movie}">
              <div class="movie-card">
                <c:set var="relevance" value="${recommendation.relevanceScore * 100}" />
                <span class="match-badge">${relevance.intValue()}% match</span>
                <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}" class="movie-poster" alt="${movie.title} Poster">
                <div class="movie-card-body">
                  <h5 class="movie-title" title="${movie.title}">${movie.title}</h5>
                  <div class="movie-info">${movie.director} | ${movie.releaseYear} | ${movie.genre}</div>
                  <div class="movie-rating">
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
                  </div>
                  <div class="movie-reason" title="${recommendation.reason}">"${recommendation.reason}"</div>
                  <div class="movie-actions">
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
            </c:if>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>

    <!-- Similar Users Section -->
    <c:if test="${not empty similarUserRecs && similarUserRecs.size() > 0}">
      <div class="mt-5">
        <h4 class="mb-4"><i class="fas fa-users me-2"></i> People With Similar Tastes Enjoyed</h4>
        <div class="row">
          <c:forEach var="recommendation" items="${similarUserRecs}" varStatus="loop" end="3">
            <c:set var="movie" value="${movieMap[recommendation.movieId]}" />
            <c:if test="${not empty movie}">
              <div class="col-md-3">
                <div class="movie-card">
                  <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}" class="movie-poster" alt="${movie.title} Poster">
                  <div class="movie-card-body">
                    <h5 class="movie-title" title="${movie.title}">${movie.title}</h5>
                    <div class="movie-info">${movie.releaseYear} | ${movie.genre}</div>
                    <div class="movie-rating">
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
                    </div>
                    <div class="movie-actions mt-2">
                      <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}" class="btn btn-sm btn-outline-light w-100">
                        <i class="fas fa-info-circle me-1"></i> Details
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </c:if>
          </c:forEach>
        </div>
      </div>
    </c:if>
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