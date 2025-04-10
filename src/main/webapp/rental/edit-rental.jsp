<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Extend Rental - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .edit-container {
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
    .edit-card {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 20px;
      border: 1px solid #333;
    }
    .rental-info {
      display: flex;
      justify-content: space-between;
      margin-bottom: 8px;
    }
    .date-badge {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 4px;
      font-size: 0.9rem;
      margin-top: 5px;
    }
    .current-date {
      background-color: rgba(108, 117, 125, 0.2);
      color: #adb5bd;
      border: 1px solid #6c757d;
    }
    .new-date {
      background-color: rgba(25, 135, 84, 0.2);
      color: #198754;
      border: 1px solid #198754;
    }
    .pricing-details {
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
    .form-range::-webkit-slider-thumb {
      background: var(--c-accent);
    }
    .form-range::-moz-range-thumb {
      background: var(--c-accent);
    }
    .form-range::-ms-thumb {
      background: var(--c-accent);
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

    <div class="edit-container">
      <h2 class="mb-4">Extend Rental</h2>

      <div class="row">
        <div class="col-lg-8">
          <div class="edit-card mb-4">
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
                  <span>Current Due Date:</span>
                  <span>
                    <fmt:formatDate value="${transaction.dueDate}" pattern="MMMM dd, yyyy" />
                    <span class="date-badge current-date">Current</span>
                  </span>
                </div>
                <div class="rental-info">
                  <span>Current Rental Period:</span>
                  <span>${rentalDuration} days</span>
                </div>
                <div class="rental-info">
                  <span>Current Fee:</span>
                  <span>$${transaction.rentalFee}</span>
                </div>
              </div>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/edit-rental" method="post">
            <input type="hidden" name="transactionId" value="${transaction.transactionId}">

            <div class="mb-4">
              <h5>Extend Rental Period</h5>
              <p class="text-muted">Adjust the slider to extend your rental period.</p>

              <div class="mb-3">
                <label for="rentalDays" class="form-label">New Rental Period: <span id="daysValue">${rentalDuration}</span> days</label>
                <input type="range" class="form-range" id="rentalDays" name="rentalDays"
                       min="${rentalDuration}" max="30" value="${rentalDuration}">
                <div class="d-flex justify-content-between">
                  <small>${rentalDuration} days (current)</small>
                  <small>15 days</small>
                  <small>30 days</small>
                </div>
              </div>

              <div class="rental-info">
                <span>New Due Date:</span>
                <span id="newDueDate">
                  <fmt:formatDate value="${transaction.dueDate}" pattern="MMMM dd, yyyy" />
                  <span class="date-badge new-date">New</span>
                </span>
              </div>
            </div>

            <div class="pricing-details" id="pricingDetails">
              <h5 class="mb-3">Price Adjustment</h5>
              <div class="price-row">
                <span>Current rental fee:</span>
                <span id="currentFee">$${transaction.rentalFee}</span>
              </div>
              <div class="price-row">
                <span>Additional days:</span>
                <span id="additionalDays">0</span>
              </div>
              <div class="price-row">
                <span>Fee for additional days:</span>
                <span id="additionalFee">$0.00</span>
              </div>
              <c:if test="${sessionScope.user.class.simpleName eq 'PremiumUser'}">
                <div class="price-row">
                  <span>Premium discount (20%):</span>
                  <span id="discount" class="text-success">-$0.00</span>
                </div>
              </c:if>
              <div class="price-row total">
                <span>New total:</span>
                <span id="newTotal">$${transaction.rentalFee}</span>
              </div>
            </div>

            <div class="d-flex mt-4">
              <a href="${pageContext.request.contextPath}/rental-history" class="btn btn-outline-light me-3">
                <i class="fas fa-arrow-left me-2"></i> Cancel
              </a>
              <button type="submit" id="extendButton" class="btn btn-primary" disabled>
                <i class="fas fa-clock me-2"></i> Extend Rental
              </button>
            </div>
          </form>
        </div>

        <div class="col-lg-4 mt-4 mt-lg-0">
          <div class="card bg-dark border-dark">
            <div class="card-header bg-black">
              <h5 class="mb-0">Extension Information</h5>
            </div>
            <div class="card-body">
              <ul class="list-group list-group-flush bg-transparent">
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> You can extend your rental for up to 30 days total
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> Additional days are charged at the regular rate
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> Premium members receive the same discount on extensions
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> You can extend a rental multiple times if needed
                </li>
                <c:if test="${transaction.isOverdue()}">
                  <li class="list-group-item bg-transparent text-danger border-dark">
                    <i class="fas fa-exclamation-circle me-2"></i> Extending an overdue rental will not remove late fees
                  </li>
                </c:if>
              </ul>
            </div>
          </div>

          <div class="card bg-dark border-dark mt-4">
            <div class="card-header bg-black">
              <h5 class="mb-0">Need Help?</h5>
            </div>
            <div class="card-body">
              <p class="card-text">If you have any questions about extending your rental, please contact our customer support.</p>
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

  <!-- Custom JS for rental extension calculation -->
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const rentalDaysSlider = document.getElementById('rentalDays');
      const daysValueElement = document.getElementById('daysValue');
      const newDueDateElement = document.getElementById('newDueDate');
      const currentFeeElement = document.getElementById('currentFee');
      const additionalDaysElement = document.getElementById('additionalDays');
      const additionalFeeElement = document.getElementById('additionalFee');
      const discountElement = document.getElementById('discount');
      const newTotalElement = document.getElementById('newTotal');
      const extendButton = document.getElementById('extendButton');

      // Original rental details
      const currentRentalDays = ${rentalDuration};
      const currentFee = ${transaction.rentalFee};
      const originalDueDate = new Date("${transaction.dueDate}");

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

      // Function to update the pricing and due date
      function updatePricing() {
        const newRentalDays = parseInt(rentalDaysSlider.value);
        daysValueElement.textContent = newRentalDays;

        // Calculate additional days
        const additionalDays = newRentalDays - currentRentalDays;
        additionalDaysElement.textContent = additionalDays;

        // Calculate additional fee
        let additionalFee = additionalDays * baseDailyRate;

        // Format for display
        additionalFeeElement.textContent = '$' + additionalFee.toFixed(2);

        // Calculate new total
        let newTotal = currentFee + additionalFee;

        // Apply discount for premium users
        if (isPremiumUser && additionalFee > 0) {
          const discount = additionalFee * 0.2; // 20% discount on additional days
          if (discountElement) {
            discountElement.textContent = '-$' + discount.toFixed(2);
          }
          newTotal -= discount;
        }

        newTotalElement.textContent = '$' + newTotal.toFixed(2);

        // Calculate and display new due date
        const newDueDate = new Date(originalDueDate);
        newDueDate.setDate(newDueDate.getDate() + additionalDays);

        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        newDueDateElement.innerHTML = newDueDate.toLocaleDateString('en-US', options) +
                                     ' <span class="date-badge new-date">New</span>';

        // Enable/disable extend button
        extendButton.disabled = (additionalDays === 0);
      }

      // Set initial pricing
      updatePricing();

      // Update pricing when slider changes
      rentalDaysSlider.addEventListener('input', updatePricing);
    });
  </script>
</body>
</html>