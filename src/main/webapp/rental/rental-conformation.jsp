<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Rental Confirmation - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .confirmation-container {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 40px;
      margin-top: 50px;
      margin-bottom: 50px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .confirmation-image {
      text-align: center;
      margin-bottom: 30px;
    }
    .success-icon {
      font-size: 80px;
      color: var(--c-accent);
      background-color: rgba(155, 93, 229, 0.1);
      width: 120px;
      height: 120px;
      border-radius: 60px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 20px;
      border: 2px solid var(--c-accent);
    }
    .confirmation-header {
      text-align: center;
      margin-bottom: 30px;
    }
    .confirmation-details {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 25px;
      margin-bottom: 30px;
    }
    .movie-thumb {
      width: 100px;
      height: 150px;
      object-fit: cover;
      border-radius: 5px;
    }
    .divider {
      height: 1px;
      background-color: var(--c-dark-gray);
      margin: 20px 0;
    }
    .rental-summary {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
    }
    .rental-summary.total {
      font-weight: 700;
      font-size: 1.1rem;
      margin-top: 15px;
    }
    .thank-you {
      text-align: center;
      margin-top: 30px;
    }
    .action-buttons {
      display: flex;
      justify-content: center;
      gap: 15px;
      margin-top: 30px;
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
    <div class="confirmation-container">
      <div class="confirmation-image">
        <div class="success-icon">
          <i class="fas fa-check"></i>
        </div>
      </div>

      <div class="confirmation-header">
        <h2>Rental Confirmed!</h2>
        <p class="text-muted">Your movie is ready to watch. Enjoy!</p>
      </div>

      <div class="row">
        <div class="col-md-8 offset-md-2">
          <div class="confirmation-details">
            <div class="row">
              <div class="col-md-3 text-center mb-3 mb-md-0">
                <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}" class="movie-thumb" alt="Movie Poster">
              </div>
              <div class="col-md-9">
                <h4 class="movie-title">${movie.title}</h4>
                <p class="text-muted mb-0">${movie.director} | ${movie.releaseYear} | ${movie.genre}</p>
                <div class="mb-2">
                  <c:forEach var="i" begin="1" end="5">
                    <c:choose>
                      <c:when test="${movie.rating >= i}">
                        <i class="fas fa-star text-warning"></i>
                      </c:when>
                      <c:when test="${movie.rating >= i - 0.5}">
                        <i class="fas fa-star-half-alt text-warning"></i>
                      </c:when>
                      <c:otherwise>
                        <i class="far fa-star text-warning"></i>
                      </c:otherwise>
                    </c:choose>
                  </c:forEach>
                  <span class="ms-1">${movie.rating}/10</span>
                </div>
              </div>
            </div>

            <div class="divider"></div>

            <h5 class="mb-3">Rental Details</h5>
            <div class="rental-summary">
              <span>Transaction ID:</span>
              <span>${transaction.transactionId}</span>
            </div>
            <div class="rental-summary">
              <span>Rental Date:</span>
              <span><fmt:formatDate value="${transaction.rentalDate}" pattern="MMMM dd, yyyy" /></span>
            </div>
            <div class="rental-summary">
              <span>Due Date:</span>
              <span><fmt:formatDate value="${transaction.dueDate}" pattern="MMMM dd, yyyy" /></span>
            </div>
            <div class="rental-summary">
              <span>Rental Period:</span>
              <span>${rentalDays} days</span>
            </div>

            <div class="divider"></div>

            <div class="rental-summary">
              <span>Base Rental Fee:</span>
              <span>$${transaction.rentalFee}</span>
            </div>
            <c:if test="${sessionScope.user.class.simpleName eq 'PremiumUser'}">
              <div class="rental-summary">
                <span>Premium Discount:</span>
                <span class="text-success">Applied</span>
              </div>
            </c:if>
            <div class="rental-summary total">
              <span>Total:</span>
              <span>$${transaction.rentalFee}</span>
            </div>
          </div>

          <div class="thank-you">
            <p>Thank you for renting with FilmHorizon. Your movie is now available to watch for the next ${rentalDays} days.</p>
            <p class="text-muted small">
              <i class="fas fa-info-circle me-1"></i>
              You will be notified before your rental period ends. Late returns may incur additional fees.
            </p>
          </div>

          <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}" class="btn btn-outline-light">
              <i class="fas fa-play-circle me-2"></i> Watch Now
            </a>
            <a href="${pageContext.request.contextPath}/rental-history" class="btn btn-primary">
              <i class="fas fa-history me-2"></i> My Rentals
            </a>
          </div>
        </div>
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