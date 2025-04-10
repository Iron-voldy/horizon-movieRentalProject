<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Movies - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .search-header {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 30px;
      margin-top: 30px;
      margin-bottom: 30px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .search-title {
      font-size: 2rem;
      font-weight: 600;
      margin-bottom: 20px;
      text-align: center;
    }
    .search-form {
      max-width: 800px;
      margin: 0 auto;
    }
    .results-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }
    .results-title {
      font-size: 1.5rem;
      font-weight: 600;
    }
    .sort-dropdown .dropdown-menu {
      background-color: var(--c-card-dark);
      border: 1px solid var(--c-dark-gray);
    }
    .sort-dropdown .dropdown-item {
      color: var(--c-secondary);
    }
    .sort-dropdown .dropdown-item:hover {
      background-color: var(--c-dark-gray);
    }
    .movie-grid {
      margin-bottom: 50px;
    }
    .movie-card {
      height: 100%;
      background-color: var(--c-card-dark);
      border-radius: 10px;
      overflow: hidden;
      transition: transform 0.3s ease;
      border: none;
    }
    .movie-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }
    .movie-card .card-img-top {
      height: 300px;
      object-fit: cover;
    }
    .movie-card .card-body {
      padding: 15px;
    }
    .movie-card .card-title {
      font-weight: 600;
      margin-bottom: 5px;
      font-size: 1.1rem;
    }
    .movie-card .card-text {
      color: var(--c-gray);
      font-size: 0.9rem;
    }
    .movie-badges {
      margin-bottom: 10px;
    }
    .filter-container {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 30px;
    }
    .filter-title {
      font-size: 1.2rem;
      font-weight: 600;
      margin-bottom: 15px;
      color: var(--c-secondary);
    }
    .filter-group {
      margin-bottom: 15px;
    }
    .filter-label {
      font-weight: 500;
      margin-bottom: 8px;
      color: var(--c-secondary);
    }
    .filter-check {
      margin-bottom: 5px;
    }
    .no-results {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 50px 20px;
      text-align: center;
      margin-bottom: 30px;
    }
    .no-results-icon {
      font-size: 3rem;
      color: var(--c-gray);
      margin-bottom: 20px;
    }
    .no-results-text {
      font-size: 1.2rem;
      color: var(--c-secondary);
      margin-bottom: 20px;
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
            <input class="form-control search-input me-2" type="search" name="searchQuery"
                   value="${searchQuery}" placeholder="Search movies..." aria-label="Search">
            <button class="btn custom-search-btn" type="submit">
              <i class="fas fa-search"></i>
            </button>
          </form>
        </div>

        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
          </li>
          <li class="nav-item active">
            <a class="nav-link active" href="${pageContext.request.contextPath}/search-movie">Movies</a>
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
    <c:if test="${not empty sessionScope.successMessage}">
      <div class="alert alert-success alert-dismissible fade show mt-4" role="alert">
        ${sessionScope.successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
      <c:remove var="successMessage" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
      <div class="alert alert-danger alert-dismissible fade show mt-4" role="alert">
        ${sessionScope.errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
      <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Search Header -->
    <div class="search-header">
      <h2 class="search-title">Find Your Perfect Movie</h2>
      <div class="search-form">
        <form action="${pageContext.request.contextPath}/search-movie" method="get">
          <div class="row g-3">
            <div class="col-md-6">
              <label for="searchQuery" class="form-label">Search</label>
              <input type="text" class="form-control" id="searchQuery" name="searchQuery"
                     value="${searchQuery}" placeholder="Enter movie title, director, or keyword...">
            </div>

            <div class="col-md-3">
              <label for="searchType" class="form-label">Search By</label>
              <select class="form-select" id="searchType" name="searchType">
                <option value="title" ${searchType == 'title' ? 'selected' : ''}>Title</option>
                <option value="director" ${searchType == 'director' ? 'selected' : ''}>Director</option>
                <option value="genre" ${searchType == 'genre' ? 'selected' : ''}>Genre</option>
              </select>
            </div>

            <div class="col-md-3 d-flex align-items-end">
              <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-search me-2"></i> Search
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>

    <div class="row">
      <!-- Filters Sidebar (Optional) -->
      <div class="col-lg-3 d-none d-lg-block">
        <div class="filter-container">
          <h3 class="filter-title">Filters</h3>

          <div class="filter-group">
            <label class="filter-label">Movie Type</label>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="typeRegular" name="type" value="regular">
              <label class="form-check-label" for="typeRegular">Regular</label>
            </div>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="typeNew" name="type" value="newRelease">
              <label class="form-check-label" for="typeNew">New Release</label>
            </div>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="typeClassic" name="type" value="classic">
              <label class="form-check-label" for="typeClassic">Classic</label>
            </div>
          </div>

          <div class="filter-group">
            <label class="filter-label">Availability</label>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="availableOnly" name="available" value="true" checked>
              <label class="form-check-label" for="availableOnly">Available Now</label>
            </div>
          </div>

          <div class="filter-group">
            <label class="filter-label">Rating</label>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="rating5plus" name="minRating" value="5">
              <label class="form-check-label" for="rating5plus">5+ Stars</label>
            </div>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="rating7plus" name="minRating" value="7">
              <label class="form-check-label" for="rating7plus">7+ Stars</label>
            </div>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="rating9plus" name="minRating" value="9">
              <label class="form-check-label" for="rating9plus">9+ Stars</label>
            </div>
          </div>

          <div class="filter-group">
            <label class="filter-label">Popular Genres</label>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="genreAction" name="genre" value="Action">
              <label class="form-check-label" for="genreAction">Action</label>
            </div>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="genreComedy" name="genre" value="Comedy">
              <label class="form-check-label" for="genreComedy">Comedy</label>
            </div>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="genreDrama" name="genre" value="Drama">
              <label class="form-check-label" for="genreDrama">Drama</label>
            </div>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="genreSciFi" name="genre" value="Sci-Fi">
              <label class="form-check-label" for="genreSciFi">Sci-Fi</label>
            </div>
            <div class="filter-check">
              <input class="form-check-input" type="checkbox" id="genreHorror" name="genre" value="Horror">
              <label class="form-check-label" for="genreHorror">Horror</label>
            </div>
          </div>

          <button type="button" class="btn btn-sm btn-primary w-100 mt-3">Apply Filters</button>
        </div>
      </div>

      <!-- Movie Results -->
      <div class="col-lg-9">
        <div class="results-header">
          <h3 class="results-title">
            <c:choose>
              <c:when test="${not empty searchQuery}">
                Search Results for: "${searchQuery}"
              </c:when>
              <c:otherwise>
                All Movies
              </c:otherwise>
            </c:choose>
            <c:if test="${not empty movies}">
              <small class="text-muted">(${movies.size()} results)</small>
            </c:if>
          </h3>

          <!-- Sort Dropdown -->
          <div class="dropdown sort-dropdown">
            <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="sortDropdown"
                    data-bs-toggle="dropdown" aria-expanded="false">
              <i class="fas fa-sort me-2"></i> Sort By
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="sortDropdown">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/search-movie?searchQuery=${searchQuery}&searchType=${searchType}&sort=rating-desc">
                <i class="fas fa-star me-2"></i> Rating (High to Low)
              </a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/search-movie?searchQuery=${searchQuery}&searchType=${searchType}&sort=rating-asc">
                <i class="fas fa-star-half-alt me-2"></i> Rating (Low to High)
              </a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/search-movie?searchQuery=${searchQuery}&searchType=${searchType}&sort=year-desc">
                <i class="fas fa-calendar-alt me-2"></i> Year (New to Old)
              </a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/search-movie?searchQuery=${searchQuery}&searchType=${searchType}&sort=year-asc">
                <i class="fas fa-calendar-alt me-2"></i> Year (Old to New)
              </a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/search-movie?searchQuery=${searchQuery}&searchType=${searchType}&sort=title-asc">
                <i class="fas fa-font me-2"></i> Title (A-Z)
              </a></li>
            </ul>
          </div>
        </div>

        <!-- Movie Grid -->
        <div class="row movie-grid">
          <c:choose>
            <c:when test="${not empty movies}">
              <c:forEach var="movie" items="${movies}">
                <div class="col-md-4 col-sm-6 mb-4">
                  <div class="card movie-card">
                    <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}"
                         class="card-img-top" alt="${movie.title}">
                    <div class="card-body">
                      <h5 class="card-title">${movie.title}</h5>
                      <p class="card-text">${movie.director} (${movie.releaseYear})</p>

                      <div class="movie-badges">
                        <span class="badge bg-primary">${movie.genre}</span>

                        <c:if test="${movie['class'].simpleName eq 'NewRelease'}">
                          <span class="badge bg-danger">New Release</span>
                        </c:if>

                        <c:if test="${movie['class'].simpleName eq 'ClassicMovie'}">
                          <span class="badge bg-warning text-dark">Classic</span>
                        </c:if>
                      </div>

                      <div class="d-flex justify-content-between align-items-center">
                        <div>
                          <c:forEach begin="1" end="5" var="star">
                            <c:choose>
                              <c:when test="${star <= movie.rating/2}">
                                <i class="fas fa-star text-warning"></i>
                              </c:when>
                              <c:when test="${star <= (movie.rating/2) + 0.5}">
                                <i class="fas fa-star-half-alt text-warning"></i>
                              </c:when>
                              <c:otherwise>
                                <i class="far fa-star text-warning"></i>
                              </c:otherwise>
                            </c:choose>
                          </c:forEach>
                        </div>
                        <span class="badge bg-secondary">${movie.rating}/10</span>
                      </div>

                      <c:if test="${not movie.available}">
                        <div class="mt-2">
                          <span class="badge bg-danger w-100">Currently Unavailable</span>
                        </div>
                      </c:if>

                      <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}"
                           class="btn btn-sm btn-primary w-100">
                          <i class="fas fa-info-circle me-1"></i> View Details
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="col-12">
                <div class="no-results">
                  <div class="no-results-icon">
                    <i class="fas fa-search"></i>
                  </div>
                  <div class="no-results-text">
                    <c:choose>
                      <c:when test="${not empty searchQuery}">
                        No movies found matching "${searchQuery}".
                      </c:when>
                      <c:otherwise>
                        No movies available at this time.
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-primary">
                    <i class="fas fa-redo me-2"></i> Clear Search
                  </a>
                </div>
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
          <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
              <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/search-movie?page=${currentPage - 1}&searchQuery=${searchQuery}&searchType=${searchType}" aria-label="Previous">
                  <span aria-hidden="true">&laquo;</span>
                </a>
              </li>

              <c:forEach begin="1" end="${totalPages}" var="pageNum">
                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                  <a class="page-link" href="${pageContext.request.contextPath}/search-movie?page=${pageNum}&searchQuery=${searchQuery}&searchType=${searchType}">
                    ${pageNum}
                  </a>
                </li>
              </c:forEach>

              <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/search-movie?page=${currentPage + 1}&searchQuery=${searchQuery}&searchType=${searchType}" aria-label="Next">
                  <span aria-hidden="true">&raquo;</span>
                </a>
              </li>
            </ul>
          </nav>
        </c:if>
      </div>
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