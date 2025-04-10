<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${movie.title} - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .movie-details-container {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 30px;
      margin-top: 30px;
      margin-bottom: 50px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .movie-poster {
      width: 100%;
      max-width: 350px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .movie-title {
      font-size: 2.5rem;
      font-weight: 700;
      margin-bottom: 10px;
    }
    .movie-meta {
      color: var(--c-gray);
      margin-bottom: 20px;
    }
    .movie-rating {
      font-size: 1.2rem;
      margin-bottom: 20px;
    }
    .rating-stars {
      color: gold;
      margin-right: 10px;
    }
    .movie-badges {
      margin-bottom: 20px;
    }
    .movie-badge {
      background-color: var(--c-third);
      color: white;
      border-radius: 20px;
      padding: 5px 15px;
      margin-right: 10px;
      display: inline-block;
    }
    .movie-description {
      margin-bottom: 30px;
      line-height: 1.8;
    }
    .action-buttons {
      margin-bottom: 30px;
    }
    .section-title {
      font-size: 1.5rem;
      font-weight: 600;
      margin-bottom: 20px;
      color: var(--c-accent);
      border-bottom: 1px solid var(--c-dark-gray);
      padding-bottom: 10px;
    }
    .movie-info-table {
      margin-bottom: 30px;
    }
    .movie-info-table td {
      padding: 8px 0;
    }
    .movie-info-table td:first-child {
      font-weight: 600;
      width: 150px;
    }
    .review-card {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 20px;
    }
    .review-user {
      font-weight: 600;
      margin-bottom: 5px;
    }
    .review-date {
      color: var(--c-gray);
      font-size: 0.9rem;
      margin-bottom: 10px;
    }
    .review-stars {
      color: gold;
      margin-bottom: 10px;
    }
    .review-verified {
      background-color: var(--c-third);
      color: white;
      border-radius: 20px;
      padding: 3px 10px;
      font-size: 0.8rem;
      margin-left: 10px;
    }
    .all-reviews-link {
      display: block;
      text-align: center;
      margin-top: 20px;
    }
    .unavailable-badge {
      background-color: #dc3545;
      color: white;
      border-radius: 20px;
      padding: 5px 15px;
      margin-right: 10px;
      display: inline-block;
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

    <div class="movie-details-container">
      <div class="row mb-5">
        <!-- Movie Poster -->
        <div class="col-lg-4 mb-4 mb-lg-0 text-center">
          <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}" class="movie-poster" alt="${movie.title} Poster">
        </div>

        <!-- Movie Details -->
        <div class="col-lg-8">
          <h1 class="movie-title">${movie.title}</h1>

          <div class="movie-meta">
            <span>${movie.director}</span> | <span>${movie.releaseYear}</span> | <span>${movie.genre}</span>
          </div>

          <div class="movie-rating">
            <span class="rating-stars">
              <c:forEach begin="1" end="5" var="star">
                <c:choose>
                  <c:when test="${star <= movie.rating/2}">
                    <i class="fas fa-star"></i>
                  </c:when>
                  <c:when test="${star <= (movie.rating/2) + 0.5}">
                    <i class="fas fa-star-half-alt"></i>
                  </c:when>
                  <c:otherwise>
                    <i class="far fa-star"></i>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </span>
            <span>${movie.rating}/10</span>
          </div>

          <div class="movie-badges">
            <!-- Movie Type Badge -->
            <c:choose>
              <c:when test="${movieType eq 'newRelease'}">
                <span class="movie-badge bg-danger">New Release</span>
              </c:when>
              <c:when test="${movieType eq 'classic'}">
                <span class="movie-badge bg-warning">Classic</span>
              </c:when>
              <c:otherwise>
                <span class="movie-badge">Regular</span>
              </c:otherwise>
            </c:choose>

            <!-- Genre Badge -->
            <span class="movie-badge">${movie.genre}</span>

            <!-- Availability Badge -->
            <c:if test="${not movie.available}">
              <span class="unavailable-badge">Currently Unavailable</span>
            </c:if>
          </div>

          <!-- Classic Movie Specific Info -->
          <c:if test="${movieType eq 'classic'}">
            <div class="movie-description">
              <p><strong>Historical/Cultural Significance:</strong></p>
              <p>${movie.significance}</p>
              <c:if test="${movie.hasAwards}">
                <p><span class="badge bg-warning text-dark"><i class="fas fa-award"></i> Award Winning</span></p>
              </c:if>
            </div>
          </c:if>

          <!-- New Release Specific Info -->
          <c:if test="${movieType eq 'newRelease'}">
            <div class="movie-description">
              <p><strong>Release Date:</strong>
                <fmt:formatDate value="${movie.releaseDate}" pattern="MMMM d, yyyy" />
              </p>
            </div>
          </c:if>

          <!-- Action Buttons -->
          <div class="action-buttons">
            <c:choose>
              <c:when test="${movie.available}">
                <a href="${pageContext.request.contextPath}/rent-movie?id=${movie.movieId}" class="btn btn-primary">
                  <i class="fas fa-shopping-cart me-2"></i> Rent Movie
                </a>
              </c:when>
              <c:otherwise>
                <button class="btn btn-secondary" disabled>
                  <i class="fas fa-times-circle me-2"></i> Not Available
                </button>
              </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/add-to-watchlist?movieId=${movie.movieId}" class="btn btn-outline-light ms-2">
              <i class="fas fa-bookmark me-2"></i> Add to Watchlist
            </a>

            <a href="${pageContext.request.contextPath}/add-review?movieId=${movie.movieId}" class="btn btn-outline-light ms-2">
              <i class="fas fa-star me-2"></i> Write Review
            </a>
          </div>

          <!-- Movie Info Table -->
          <table class="movie-info-table">
            <tr>
              <td>Director:</td>
              <td>${movie.director}</td>
            </tr>
            <tr>
              <td>Release Year:</td>
              <td>${movie.releaseYear}</td>
            </tr>
            <tr>
              <td>Genre:</td>
              <td>${movie.genre}</td>
            </tr>
            <tr>
              <td>Rental Price:</td>
              <td>$<fmt:formatNumber value="${movie.calculateRentalPrice(1)}" pattern="#0.00" /> per day</td>
            </tr>
          </table>
        </div>
      </div>

      <!-- Reviews Section -->
      <div class="row">
        <div class="col-12">
          <h2 class="section-title">
            <i class="fas fa-comments me-2"></i> User Reviews
          </h2>

          <c:choose>
            <c:when test="${not empty reviews}">
              <c:forEach var="review" items="${reviews}" begin="0" end="2">
                <div class="review-card">
                  <div class="review-user">
                    ${review.userName}
                    <c:if test="${review.verified}">
                      <span class="review-verified">Verified Rental</span>
                    </c:if>
                  </div>

                  <div class="review-date">
                    <fmt:formatDate value="${review.reviewDate}" pattern="MMMM d, yyyy" />
                  </div>

                  <div class="review-stars">
                    <c:forEach begin="1" end="5" var="star">
                      <c:choose>
                        <c:when test="${star <= review.rating}">
                          <i class="fas fa-star"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="far fa-star"></i>
                        </c:otherwise>
                      </c:choose>
                    </c:forEach>
                  </div>

                  <div class="review-content">
                    ${review.comment}
                  </div>
                </div>
              </c:forEach>

              <a href="${pageContext.request.contextPath}/movie-reviews?movieId=${movie.movieId}" class="all-reviews-link">
                View All Reviews <i class="fas fa-arrow-right ms-2"></i>
              </a>
            </c:when>
            <c:otherwise>
              <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i> No reviews yet for this movie. Be the first to leave a review!
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- Similar Movies Section (if available) -->
      <c:if test="${not empty similarMovies}">
        <div class="row mt-5">
          <div class="col-12">
            <h2 class="section-title">
              <i class="fas fa-film me-2"></i> Similar Movies You Might Like
            </h2>

            <div class="row">
              <c:forEach var="similarMovie" items="${similarMovies}" begin="0" end="3">
                <div class="col-md-3 mb-4">
                  <div class="card h-100 movie-card">
                    <img src="${pageContext.request.contextPath}/image-servlet?movieId=${similarMovie.movieId}"
                         class="card-img-top movie-poster" alt="${similarMovie.title}">
                    <div class="card-body">
                      <h5 class="movie-title">${similarMovie.title}</h5>
                      <div class="movie-info">${similarMovie.director} | ${similarMovie.releaseYear}</div>
                      <div class="movie-rating">
                        <c:forEach begin="1" end="5" var="star">
                          <c:choose>
                            <c:when test="${star <= similarMovie.rating/2}">
                              <i class="fas fa-star"></i>
                            </c:when>
                            <c:when test="${star <= (similarMovie.rating/2) + 0.5}">
                              <i class="fas fa-star-half-alt"></i>
                            </c:when>
                            <c:otherwise>
                              <i class="far fa-star"></i>
                            </c:otherwise>
                          </c:choose>
                        </c:forEach>
                        ${similarMovie.rating}/10
                      </div>
                      <div class="movie-actions">
                        <a href="${pageContext.request.contextPath}/movie-details?id=${similarMovie.movieId}" class="btn btn-sm btn-primary">View Details</a>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </div>
        </div>
      </c:if>

      <!-- Edit/Delete Buttons for Admin -->
      <c:if test="${not empty sessionScope.admin}">
        <div class="row mt-4">
          <div class="col-12">
            <div class="d-flex justify-content-end">
              <a href="${pageContext.request.contextPath}/update-movie?id=${movie.movieId}" class="btn btn-warning me-2">
                <i class="fas fa-edit me-2"></i> Edit Movie
              </a>
              <a href="${pageContext.request.contextPath}/delete-movie?id=${movie.movieId}" class="btn btn-danger">
                <i class="fas fa-trash-alt me-2"></i> Delete Movie
              </a>
            </div>
          </div>
        </div>
      </c:if>
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