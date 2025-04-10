<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Return Movie - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .return-container {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 30px;
      margin-top: 30px;
      margin-bottom: 30px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .movie-thumb {
      width: 120px;
      height: 180px;
      object-fit: cover;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.4);
    }
    .return-card {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 20px;
    }
    .rental-info {
      display: flex;
      justify-content: space-between;
      margin-bottom: 8px;
    }
    .overdue-badge {
      background-color: rgba(220, 53, 69, 0.2);
      color: #dc3545;
      border: 1px solid #dc3545;
      padding: 5px 10px;
      border-radius: 5px;
      font-size: 0.9rem;
      display: inline-flex;
      align-items: center;
    }
    .overdue-details {
      background-color: rgba(220, 53, 69, 0.1);
      border: 1px solid rgba(220, 53, 69, 0.2);
      border-radius: 10px;
      padding: 15px;
      margin-top: 20px;
    }
    .latefee-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
    }
    .latefee-row.total {
      border-top: 1px solid var(--c-dark-gray);
      padding-top: 10px;
      margin-top: 10px;
      font-weight: 700;
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
    <div class="return-container">
      <h2 class="mb-4">Return Movie</h2>

      <div class="row">
        <div class="col-lg-8">
          <div class="return-card mb-4">
            <div class="row">
              <div class="col-md-3 text-center mb-3 mb-md-0">
                <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}" class="movie-thumb" alt="Movie Poster">
              </div>
              <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <h4 class="movie-title mb-0">${movie.title}</h4>
                  <c:if test="${transaction.isOverdue()}">
                    <span class="overdue-badge">
                      <i class="fas fa-exclamation-circle me-1"></i> Overdue
                    </span>
                  </c:if>
                </div>
                <p class="text-muted">${movie.director} | ${movie.releaseYear} | ${movie.genre}</p>

                <div class="rental-info">
                  <span>Rental Date:</span>
                  <span><fmt:formatDate value="${transaction.rentalDate}" pattern="MMMM dd, yyyy" /></span>
                </div>
                <div class="rental-info">
                  <span>Due Date:</span>
                  <span><fmt:formatDate value="${transaction.dueDate}" pattern="MMMM dd, yyyy" /></span>
                </div>
                <div class="rental-info">
                  <span>Rental Period:</span>
                  <span>${transaction.getRentalDuration()} days</span>
                </div>
                <div class="rental-info">
                  <span>Rental Fee:</span>
                  <span>$${transaction.rentalFee}</span>
                </div>

                <c:if test="${transaction.isOverdue()}">
                  <div class="overdue-details mt-3">
                    <h5><i class="fas fa-exclamation-circle me-2 text-danger"></i> Late Return</h5>
                    <p>This movie is overdue by <strong>${transaction.calculateDaysOverdue()} days</strong>.</p>

                    <div class="latefee-row">
                      <span>Late fee (per day):</span>
                      <c:choose>
                        <c:when test="${sessionScope.user.class.simpleName eq 'PremiumUser'}">
                          <span>$0.75</span>
                        </c:when>
                        <c:otherwise>
                          <span>$1.50</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div class="latefee-row">
                      <span>Days overdue:</span>
                      <span>${transaction.calculateDaysOverdue()}</span>
                    </div>
                    <div class="latefee-row total">
                      <span>Estimated late fee:</span>
                      <c:choose>
                        <c:when test="${sessionScope.user.class.simpleName eq 'PremiumUser'}">
                          <span>$${0.75 * transaction.calculateDaysOverdue()}</span>
                        </c:when>
                        <c:otherwise>
                          <span>$${1.50 * transaction.calculateDaysOverdue()}</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                </c:if>
              </div>
            </div>
          </div>

          <h5>Return Confirmation</h5>
          <p>Are you sure you want to return this movie? This action cannot be undone.</p>

          <form action="${pageContext.request.contextPath}/return-movie" method="post">
            <input type="hidden" name="transactionId" value="${transaction.transactionId}">
            <input type="hidden" name="confirmReturn" value="yes">

            <div class="d-flex mt-4">
              <a href="${pageContext.request.contextPath}/rental-history" class="btn btn-outline-light me-3">
                <i class="fas fa-arrow-left me-2"></i> Cancel
              </a>
              <button type="submit" class="btn btn-primary">
                <i class="fas fa-check-circle me-2"></i> Confirm Return
              </button>
            </div>
          </form>
        </div>

        <div class="col-lg-4 mt-4 mt-lg-0">
          <div class="card bg-dark border-dark">
            <div class="card-header bg-black">
              <h5 class="mb-0">Return Policy</h5>
            </div>
            <div class="card-body">
              <ul class="list-group list-group-flush bg-transparent">
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> Once returned, you will no longer have access to the movie
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> Late fees are automatically calculated based on the due date
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> Premium members enjoy reduced late fees
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> You can always rent the movie again after returning
                </li>
                <c:if test="${not transaction.isOverdue()}">
                  <li class="list-group-item bg-transparent text-light border-dark">
                    <i class="fas fa-star text-warning me-2"></i> You're returning on time - thanks for being a great customer!
                  </li>
                </c:if>
              </ul>
            </div>
            <div class="card-footer bg-black border-dark">
              <p class="mb-0 small text-muted">Please ensure you've finished watching the movie before returning.</p>
            </div>
          </div>

          <div class="card bg-dark border-dark mt-4">
            <div class="card-header bg-black">
              <h5 class="mb-0">Need Help?</h5>
            </div>
            <div class="card-body">
              <p class="card-text">If you have any questions about your rental or return, please contact our customer support.</p>
              <a href="#" class="btn btn-outline-light">
                <i class="fas fa-headset me-2"></i> Contact Support
              </a>
            </div>
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
