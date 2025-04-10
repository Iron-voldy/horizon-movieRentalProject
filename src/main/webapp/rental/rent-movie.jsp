<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Rent Movie - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .rent-container {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 30px;
      margin-top: 30px;
      margin-bottom: 30px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .movie-poster-lg {
      max-height: 350px;
      width: auto;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.4);
    }
    .rental-details {
      border-top: 1px solid var(--c-dark-gray);
      border-bottom: 1px solid var(--c-dark-gray);
      padding: 20px 0;
      margin: 20px 0;
    }
    .price-tag {
      font-size: 1.8rem;
      font-weight: 700;
      color: var(--c-accent);
    }
    .price-details {
      font-size: 0.9rem;
      color: var(--c-gray);
    }
    .price-period {
      font-size: 1rem;
      font-weight: normal;
    }
    .price-calculation {
      background-color: rgba(155, 93, 229, 0.1);
      border: 1px solid rgba(155, 93, 229, 0.3);
      border-radius: 10px;
      padding: 15px;
      margin-top: 20px;
    }
    .price-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
    }
    .price-row.total {
      border-top: 1px solid var(--c-dark-gray);
      padding-top: 10px;
      margin-top: 10px;
      font-weight: 700;
    }
    .form-range::-webkit-slider-thumb {
      background: var(--c-accent);
    }
    .form-range::-moz-range-thumb {
      background: var(--c-accent);
    }
    .form-range::-ms-thumb {
      background: var(--c-accent);
    }
    .special-badge {
      position: absolute;
      top: 20px;
      right: 20px;
      background-color: var(--c-third);
      color: white;
      padding: 5px 10px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 500;
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

    <div class="rent-container">
      <div class="row">
        <div class="col-lg-8">
          <h2 class="mb-4">Rent Movie</h2>

          <div class="row mb-4">
            <div class="col-md-4 text-center mb-3 mb-md-0">
              <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}" class="movie-poster-lg" alt="Movie Poster">
              <c:if test="${movie.class.simpleName eq 'NewRelease'}">
                <div class="special-badge">New Release</div>
              </c:if>
              <c:if test="${movie.class.simpleName eq 'ClassicMovie'}">
                <div class="special-badge">Classic</div>
              </c:if>
            </div>
            <div class="col-md-8">
              <h3 class="movie-title">${movie.title}</h3>
              <p class="text-muted">
                <span class="me-3"><i class="fas fa-film me-1"></i> ${movie.director}</span>
                <span class="me-3"><i class="fas fa-calendar me-1"></i> ${movie.releaseYear}</span>
                <span><i class="fas fa-tag me-1"></i> ${movie.genre}</span>
              </p>
              <p class="movie-rating">
                <c:forEach var="i" begin="1" end="5">
                  <c:choose>
                    <c:when test="${movie.rating >= i}">
                      <i class="fas fa-star"></i>
                    </c:when>
                    <c:when test="${movie.rating >= i - 0.5}">
                      <i class="fas fa-star-half-alt"></i>
                    </c:when>
                    <c:otherwise>
                      <i class="far fa-star"></i>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
                <span class="ms-2">${movie.rating}/10</span>
              </p>

              <c:choose>
                <c:when test="${movie.class.simpleName eq 'NewRelease'}">
                  <p><i class="fas fa-info-circle me-2"></i>This is a new release movie with premium pricing.</p>
                </c:when>
                <c:when test="${movie.class.simpleName eq 'ClassicMovie'}">
                  <p><i class="fas fa-info-circle me-2"></i>This is a classic movie from the golden age of cinema.</p>
                  <c:if test="${movie.hasAwards()}">
                    <p><i class="fas fa-award me-2 text-warning"></i>Award-winning classic film</p>
                  </c:if>
                </c:when>
              </c:choose>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/rent-movie" method="post">
            <input type="hidden" name="movieId" value="${movie.movieId}">

            <div class="rental-details">
              <h4>Rental Period</h4>
              <p class="text-muted">Select how many days you would like to rent this movie:</p>

              <div class="mb-3">
                <label for="rentalDays" class="form-label">Days: <span id="daysValue">7</span></label>
                <input type="range" class="form-range" id="rentalDays" name="rentalDays" min="1" max="30" value="7">
                <div class="d-flex justify-content-between">
                  <small>1 day</small>
                  <small>15 days</small>
                  <small>30 days</small>
                </div>
              </div>
            </div>

            <div id="priceSummary" class="price-calculation">
              <div class="price-row">
                <span>Base rental price:</span>
                <span id="basePrice">$0.00</span>
              </div>
              <c:if test="${sessionScope.user.class.simpleName eq 'PremiumUser'}">
                <div class="price-row">
                  <span>Premium member discount (20%):</span>
                  <span id="discount" class="text-success">-$0.00</span>
                </div>
              </c:if>
              <div class="price-row total">
                <span>Total:</span>
                <span id="totalPrice">$0.00</span>
              </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
              <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i> Back to Movie
              </a>
              <button type="submit" class="btn btn-primary">
                <i class="fas fa-shopping-cart me-2"></i> Rent Movie
              </button>
            </div>
          </form>
        </div>

        <div class="col-lg-4 mt-4 mt-lg-0">
          <div class="card bg-dark border-dark">
            <div class="card-header bg-black">
              <h5 class="mb-0">Rental Terms</h5>
            </div>
            <div class="card-body">
              <ul class="list-group list-group-flush bg-transparent">
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-check-circle text-success me-2"></i> Stream unlimited times during your rental period
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-check-circle text-success me-2"></i> HD and 4K quality when available
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-check-circle text-success me-2"></i> Watch on any device
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-check-circle text-success me-2"></i> Extend your rental when needed
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-check-circle text-success me-2"></i> 30-minute free preview before payment
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-exclamation-circle text-warning me-2"></i> Late returns will incur additional fees
                </li>
              </ul>
            </div>
          </div>

          <div class="card bg-dark border-dark mt-4">
            <div class="card-header bg-black">
              <h5 class="mb-0">Need Help?</h5>
            </div>
            <div class="card-body">
              <p class="card-text">If you have any questions about renting movies, please contact our customer support.</p>
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

  <!-- Custom JS for rental pricing calculation -->
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const rentalDaysSlider = document.getElementById('rentalDays');
      const daysValueElement = document.getElementById('daysValue');
      const basePriceElement = document.getElementById('basePrice');
      const discountElement = document.getElementById('discount');
      const totalPriceElement = document.getElementById('totalPrice');

      // Movie pricing constants based on movie type
      const movieType = "${movie.class.simpleName}";
      let baseDailyRate;

      if (movieType === "NewRelease") {
        baseDailyRate = 5.99;
      } else if (movieType === "ClassicMovie") {
        baseDailyRate = 2.99;
        // Add award bonus if applicable
        if (${movie.hasAwards()}) {
          baseDailyRate += 1.00 / 7; // Add $1 per week, divided per day
        }
      } else {
        // Regular movie
        baseDailyRate = 3.99;
      }

      // Premium user logic
      const isPremiumUser = "${sessionScope.user.class.simpleName}" === "PremiumUser";

      // Function to update the pricing display
      function updatePricing() {
        const days = parseInt(rentalDaysSlider.value);
        daysValueElement.textContent = days;

        const basePrice = baseDailyRate * days;
        basePriceElement.textContent = '$' + basePrice.toFixed(2);

        let totalPrice = basePrice;

        // Apply discount for premium users
        if (isPremiumUser) {
          const discount = basePrice * 0.2; // 20% discount
          discountElement.textContent = '-$' + discount.toFixed(2);
          totalPrice = basePrice - discount;
        }

        totalPriceElement.textContent = '$' + totalPrice.toFixed(2);
      }

      // Set initial pricing
      updatePricing();

      // Update pricing when slider changes
      rentalDaysSlider.addEventListener('input', updatePricing);
    });
  </script>
</body>
</html>