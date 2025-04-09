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
  <!--bootstrap linked-->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <!-- Font Awesome icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
  <!-- Navbar Start -->
  <div class="navbar-dark">
    <nav class="navbar navbar-expand-lg navbar-dark container">
      <a class="navbar-brand py-2" href="${pageContext.request.contextPath}/index.jsp">
        <img src="${pageContext.request.contextPath}/img/brand/brand-logo.png" width="120" height="40" alt="FilmHorizon">
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mx-auto">
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>
          <c:if test="${not empty sessionScope.userId}">
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a>
            </li>
            <li class="nav-item active">
              <a class="nav-link active" href="${pageContext.request.contextPath}/rental-history">Rentals</a>
            </li>
          </c:if>
        </ul>

        <!-- User Profile -->
        <ul class="navbar-nav">
          <c:choose>
            <c:when test="${empty sessionScope.userId}">
              <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                  <img src="${pageContext.request.contextPath}/img/brand/white-button-login.png" width="33" height="33" alt="Login">
                </a>
              </li>
            </c:when>
            <c:otherwise>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  <span class="me-2">${sessionScope.username}</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/update-profile">Profile</a></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/recently-watched">Recently Watched</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </ul>
              </li>
            </c:otherwise>
          </c:choose>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Display error message if any -->
  <c:if test="${not empty requestScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      ${requestScope.errorMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <!-- Rent Movie Section -->
  <div class="container my-5">
    <div class="row">
      <div class="col-lg-8 mx-auto">
        <div class="card shadow">
          <div class="card-header bg-primary text-white">
            <h4 class="mb-0">Rent Movie: ${movie.title}</h4>
          </div>
          <div class="card-body">
            <div class="row mb-4">
              <div class="col-md-4 text-center mb-3 mb-md-0">
                <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}"
                     class="img-fluid rounded" alt="${movie.title}" style="max-height: 250px;">
              </div>
              <div class="col-md-8">
                <h4>${movie.title} (${movie.releaseYear})</h4>
                <p><strong>Director:</strong> ${movie.director}</p>
                <p><strong>Genre:</strong> ${movie.genre}</p>
                <p><strong>Rating:</strong> ${movie.rating}/10</p>

                <c:choose>
                  <c:when test="${movieType == 'newRelease'}">
                    <p><span class="badge bg-danger">New Release</span></p>
                  </c:when>
                  <c:when test="${movieType == 'classic'}">
                    <p><span class="badge bg-warning text-dark">Classic</span></p>
                  </c:when>
                </c:choose>
              </div>
            </div>

            <form action="${pageContext.request.contextPath}/rent-movie" method="post" id="rentForm">
              <input type="hidden" name="movieId" value="${movie.movieId}">

              <div class="mb-4">
                <label for="rentalDays" class="form-label">Rental Period (days)</label>
                <div class="d-flex align-items-center">
                  <input type="range" class="form-range me-3" id="rentalDays" name="rentalDays"
                         min="1" max="14" value="3" oninput="updateRentalDetails()">
                  <span id="selectedDays" class="badge bg-primary px-3 py-2">3 days</span>
                </div>
              </div>

              <div class="card mb-4">
                <div class="card-header bg-light">
                  <h5 class="mb-0">Rental Details</h5>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-6 mb-3 mb-md-0">
                      <p><strong>Daily Rate:</strong> $<fmt:formatNumber value="${movie.calculateRentalPrice(1)}" pattern="#0.00" /></p>
                      <p><strong>Rental Period:</strong> <span id="rentalPeriodText">3 days</span></p>
                      <p><strong>Pickup Date:</strong> <span id="pickupDate">
                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM d, yyyy" />
                      </span></p>
                    </div>
                    <div class="col-md-6">
                      <p><strong>Due Date:</strong> <span id="dueDate">
                        <jsp:useBean id="dueDate" class="java.util.Date" />
                        <c:set target="${dueDate}" property="time" value="${dueDate.time + 3*24*60*60*1000}" />
                        <fmt:formatDate value="${dueDate}" pattern="MMMM d, yyyy" />
                      </span></p>
                      <p><strong>Late Fee (per day):</strong> $<fmt:formatNumber value="${lateFeePerDay}" pattern="#0.00" /></p>
                      <p class="fw-bold">Total: $<span id="totalCost">
                        <fmt:formatNumber value="${movie.calculateRentalPrice(3)}" pattern="#0.00" />
                      </span></p>
                    </div>
                  </div>
                </div>
              </div>

              <div class="card mb-4">
                <div class="card-header bg-light">
                  <h5 class="mb-0">Rental Agreement</h5>
                </div>
                <div class="card-body">
                  <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="agreement" required>
                    <label class="form-check-label" for="agreement">
                      I agree to return this movie by the due date. I understand that failing to do so will result in
                      late fees of $<fmt:formatNumber value="${lateFeePerDay}" pattern="#0.00" /> per day.
                    </label>
                  </div>
                </div>
              </div>

              <div class="mb-4">
                <h5>Payment Method</h5>
                <div class="form-check mb-2">
                  <input class="form-check-input" type="radio" name="paymentMethod" id="credit" value="credit" checked>
                  <label class="form-check-label" for="credit">
                    <i class="far fa-credit-card me-2"></i> Credit Card
                  </label>
                </div>
                <div class="form-check mb-2">
                  <input class="form-check-input" type="radio" name="paymentMethod" id="paypal" value="paypal">
                  <label class="form-check-label" for="paypal">
                    <i class="fab fa-paypal me-2"></i> PayPal
                  </label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="paymentMethod" id="wallet" value="wallet">
                  <label class="form-check-label" for="wallet">
                    <i class="fas fa-wallet me-2"></i> Store Credits
                  </label>
                </div>
              </div>

              <div class="d-grid gap-2 d-md-flex justify-content-md-between">
                <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}" class="btn btn-secondary">
                  <i class="fas fa-arrow-left me-1"></i> Back to Movie Details
                </a>
                <button type="submit" class="btn btn-primary">
                  <i class="fas fa-shopping-cart me-1"></i> Complete Rental
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Footer Start -->
  <footer class="bg-dark text-white py-4">
    <div class="container">
      <div class="row">
        <div class="col-md-4 mb-3 mb-md-0">
          <h5>Film Horizon</h5>
          <p>Your premier movie rental platform with a vast collection of films from all genres and eras.</p>
        </div>
        <div class="col-md-4 mb-3 mb-md-0">
          <h5>Quick Links</h5>
          <ul class="list-unstyled">
            <li><a href="${pageContext.request.contextPath}/index.jsp" class="text-white">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/search-movie" class="text-white">Movies</a></li>
            <li><a href="${pageContext.request.contextPath}/top-rated" class="text-white">Top Rated</a></li>
            <li><a href="${pageContext.request.contextPath}/login" class="text-white">Login/Register</a></li>
          </ul>
        </div>
        <div class="col-md-4">
          <h5>Contact Us</h5>
          <address>
            <p>Email: support@filmhorizon.com</p>
            <p>Phone: (123) 456-7890</p>
            <p>Address: 123 Movie Street, Hollywood, CA 90210</p>
          </address>
        </div>
      </div>
      <hr>
      <div class="row">
        <div class="col-12 text-center">
          <p class="mb-0">&copy; 2025 Film Horizon. All rights reserved.</p>
        </div>
      </div>
    </div>
  </footer>
  <!-- Footer End -->

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

  <!-- Rental calculation script -->
  <script>
    // Base rates from the server-side
    const dailyRate = ${movie.calculateRentalPrice(1)};

    function updateRentalDetails() {
      const days = document.getElementById('rentalDays').value;
      const totalCost = (dailyRate * days).toFixed(2);

      document.getElementById('selectedDays').innerText = days + ' days';
      document.getElementById('rentalPeriodText').innerText = days + ' days';
      document.getElementById('totalCost').innerText = totalCost;

      // Update due date
      const pickupDate = new Date();
      const dueDate = new Date();
      dueDate.setDate(pickupDate.getDate() + parseInt(days));

      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      document.getElementById('dueDate').innerText = dueDate.toLocaleDateString('en-US', options);
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
      updateRentalDetails();
    });
  </script>
</body>
</html>