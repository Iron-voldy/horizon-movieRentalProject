<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cancel Rental - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .cancel-container {
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
    .cancel-card {
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
    .reason-group {
      margin-top: 20px;
      padding: 15px;
      border-radius: 10px;
      background-color: rgba(0, 0, 0, 0.2);
    }
    .reason-option {
      background-color: var(--c-card-dark);
      border: 1px solid #333;
      border-radius: 5px;
      padding: 10px 15px;
      margin-bottom: 10px;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    .reason-option:hover {
      border-color: var(--c-accent);
    }
    .reason-option.selected {
      border-color: var(--c-accent);
      background-color: rgba(155, 93, 229, 0.1);
    }
    .warning-box {
      background-color: rgba(220, 53, 69, 0.1);
      border: 1px solid rgba(220, 53, 69, 0.2);
      border-radius: 10px;
      padding: 15px;
      margin-top: 20px;
    }
    /* Remove spin buttons from number input */
    input[type=number]::-webkit-inner-spin-button,
    input[type=number]::-webkit-outer-spin-button {
      -webkit-appearance: none;
      margin: 0;
    }
    input[type=number] {
      -moz-appearance: textfield;
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
    <div class="cancel-container">
      <h2 class="mb-4">Cancel Rental</h2>

      <div class="row">
        <div class="col-lg-8">
          <div class="cancel-card mb-4">
            <div class="row">
              <div class="col-md-3 text-center mb-3 mb-md-0">
                <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}" class="movie-thumb" alt="Movie Poster">
              </div>
              <div class="col-md-9">
                <h4 class="movie-title">${movie.title}</h4>
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
              </div>
            </div>
          </div>

          <div class="warning-box mb-4">
            <h5 class="text-danger mb-2"><i class="fas fa-exclamation-triangle me-2"></i> Cancellation Warning</h5>
            <p class="mb-1">Please note the following before proceeding:</p>
            <ul class="mb-0">
              <li>Once canceled, you will lose access to this movie immediately.</li>
              <li>Cancellations cannot be undone.</li>
              <li>You will need to rent the movie again if you wish to watch it.</li>
            </ul>
          </div>

          <form action="${pageContext.request.contextPath}/cancel-rental" method="post">
            <input type="hidden" name="transactionId" value="${transaction.transactionId}">
            <input type="hidden" name="confirmCancel" value="yes">

            <div class="reason-group">
              <h5 class="mb-3">Why are you canceling?</h5>

              <div class="reason-option" onclick="selectReason(this, 'Changed my mind')">
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="reasonOption" id="reason1" value="Changed my mind">
                  <label class="form-check-label" for="reason1">
                    Changed my mind
                  </label>
                </div>
              </div>

              <div class="reason-option" onclick="selectReason(this, 'Technical issues')">
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="reasonOption" id="reason2" value="Technical issues">
                  <label class="form-check-label" for="reason2">
                    Technical issues
                  </label>
                </div>
              </div>

              <div class="reason-option" onclick="selectReason(this, 'Rented by mistake')">
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="reasonOption" id="reason3" value="Rented by mistake">
                  <label class="form-check-label" for="reason3">
                    Rented by mistake
                  </label>
                </div>
              </div>

              <div class="reason-option" onclick="selectReason(this, 'No time to watch')">
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="reasonOption" id="reason4" value="No time to watch">
                  <label class="form-check-label" for="reason4">
                    No time to watch
                  </label>
                </div>
              </div>

              <div class="reason-option" onclick="selectReason(this, 'Other reason')">
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="reasonOption" id="reason5" value="Other reason">
                  <label class="form-check-label" for="reason5">
                    Other reason
                  </label>
                </div>
              </div>

              <div class="mt-3" id="otherReasonDiv" style="display:none;">
                <label for="otherReason" class="form-label">Please specify:</label>
                <textarea id="otherReason" name="otherReason" class="form-control" rows="3"></textarea>
              </div>

              <input type="hidden" name="reason" id="reasonInput" value="">
            </div>

            <div class="d-flex mt-4">
              <a href="${pageContext.request.contextPath}/rental-history" class="btn btn-outline-light me-3">
                <i class="fas fa-arrow-left me-2"></i> Back
              </a>
              <button type="submit" id="cancelButton" class="btn btn-danger" disabled>
                <i class="fas fa-times-circle me-2"></i> Cancel Rental
              </button>
            </div>
          </form>
        </div>

        <div class="col-lg-4 mt-4 mt-lg-0">
          <div class="card bg-dark border-dark">
            <div class="card-header bg-black">
              <h5 class="mb-0">Cancellation Policy</h5>
            </div>
            <div class="card-body">
              <ul class="list-group list-group-flush bg-transparent">
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> You can cancel a rental within 24 hours of the rental date
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> Cancellations after 24 hours may be subject to our review
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> Premium members get priority for cancellation requests
                </li>
                <li class="list-group-item bg-transparent text-light border-dark">
                  <i class="fas fa-info-circle text-info me-2"></i> You will need to rent the movie again after cancellation
                </li>
              </ul>
            </div>
          </div>

          <div class="card bg-dark border-dark mt-4">
            <div class="card-header bg-black">
              <h5 class="mb-0">Need Help?</h5>
            </div>
            <div class="card-body">
              <p class="card-text">If you have any issues with your rental or cancellation, please contact our customer support.</p>
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

  <!-- Custom JS for reason selection -->
  <script>
    function selectReason(element, reason) {
      // Remove 'selected' class from all options
      document.querySelectorAll('.reason-option').forEach(option => {
        option.classList.remove('selected');
      });

      // Add 'selected' class to clicked option
      element.classList.add('selected');

      // Check the radio button
      element.querySelector('input[type="radio"]').checked = true;

      // Show/hide other reason textarea
      const otherReasonDiv = document.getElementById('otherReasonDiv');
      if (reason === 'Other reason') {
        otherReasonDiv.style.display = 'block';
        document.getElementById('reasonInput').value = '';
        document.getElementById('otherReason').focus();
      } else {
        otherReasonDiv.style.display = 'none';
        document.getElementById('reasonInput').value = reason;
      }

      // Enable the cancel button
      document.getElementById('cancelButton').disabled = false;
    }

    // Update reason input when "Other reason" textarea changes
    document.addEventListener('DOMContentLoaded', function() {
      const otherReasonTextarea = document.getElementById('otherReason');
      otherReasonTextarea.addEventListener('input', function() {
        document.getElementById('reasonInput').value = this.value;
        // Disable button if other reason is empty
        document.getElementById('cancelButton').disabled = (this.value.trim() === '');
      });
    });
  </script>
</body>
</html>