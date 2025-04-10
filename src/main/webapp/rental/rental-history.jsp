<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Rental History - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .rental-card {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      border: 1px solid #333;
      padding: 20px;
      margin-bottom: 20px;
      transition: transform 0.3s ease;
    }
    .rental-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }
    .rental-status {
      position: absolute;
      top: 20px;
      right: 20px;
      padding: 5px 10px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 500;
    }
    .status-active {
      background-color: rgba(25, 135, 84, 0.2);
      border: 1px solid #198754;
      color: #198754;
    }
    .status-returned {
      background-color: rgba(13, 110, 253, 0.2);
      border: 1px solid #0d6efd;
      color: #0d6efd;
    }
    .status-overdue {
      background-color: rgba(220, 53, 69, 0.2);
      border: 1px solid #dc3545;
      color: #dc3545;
    }
    .status-canceled {
      background-color: rgba(108, 117, 125, 0.2);
      border: 1px solid #6c757d;
      color: #6c757d;
    }
    .rental-date {
      color: var(--c-gray);
      font-size: 0.9rem;
    }
    .rental-fee {
      font-weight: 600;
      font-size: 1.2rem;
      color: var(--c-accent);
    }
    .rental-movie-img {
      height: 150px;
      width: 100px;
      object-fit: cover;
      border-radius: 5px;
    }
    .rental-tabs .nav-link {
      color: var(--c-gray);
      border: none;
      border-bottom: 2px solid transparent;
      padding: 12px 20px;
      border-radius: 0;
    }
    .rental-tabs .nav-link.active {
      background-color: transparent;
      color: var(--c-accent);
      border-bottom: 2px solid var(--c-accent);
    }
    .rental-tabs .nav-link:hover:not(.active) {
      border-bottom: 2px solid var(--c-gray);
    }
    .empty-rentals {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 40px;
      text-align: center;
    }
    .rental-badge {
      position: relative;
    }
    .rental-badge .badge {
      position: absolute;
      top: -5px;
      right: -10px;
      background-color: var(--c-accent);
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
  <div class="container mt-5 mb-5">
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

    <div class="row mb-4">
      <div class="col">
        <h2 class="mb-4">My Rentals</h2>

        <!-- Tabs for filtering rentals -->
        <ul class="nav rental-tabs mb-4">
          <li class="nav-item">
            <a class="nav-link ${empty param.filter || param.filter eq 'all' ? 'active' : ''}" href="${pageContext.request.contextPath}/rental-history?filter=all">
              All Rentals
            </a>
          </li>
          <li class="nav-item rental-badge">
            <a class="nav-link ${param.filter eq 'active' ? 'active' : ''}" href="${pageContext.request.contextPath}/rental-history?filter=active">
              Active Rentals
              <c:if test="${not empty activeRentals && activeRentals.size() > 0}">
                <span class="badge rounded-pill">${activeRentals.size()}</span>
              </c:if>
            </a>
          </li>
          <li class="nav-item rental-badge">
            <a class="nav-link ${param.filter eq 'overdue' ? 'active' : ''}" href="${pageContext.request.contextPath}/rental-history?filter=overdue">
              Overdue
              <c:if test="${not empty overdueRentals && overdueRentals.size() > 0}">
                <span class="badge rounded-pill">${overdueRentals.size()}</span>
              </c:if>
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link ${param.filter eq 'returned' ? 'active' : ''}" href="${pageContext.request.contextPath}/rental-history?filter=returned">
              Returned
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link ${param.filter eq 'canceled' ? 'active' : ''}" href="${pageContext.request.contextPath}/rental-history?filter=canceled">
              Canceled
            </a>
          </li>
        </ul>

        <!-- Active Rentals Section -->
        <c:if test="${empty param.filter || param.filter eq 'all' || param.filter eq 'active'}">
          <c:if test="${not empty activeRentals && activeRentals.size() > 0}">
            <h4 class="mt-4 mb-3">Active Rentals</h4>
            <div class="row">
              <c:forEach var="transaction" items="${activeRentals}">
                <div class="col-lg-6 mb-4">
                  <div class="rental-card position-relative">
                    <div class="rental-status ${transaction.isOverdue() ? 'status-overdue' : 'status-active'}">
                      ${transaction.isOverdue() ? 'Overdue' : 'Active'}
                    </div>
                    <div class="row">
                      <div class="col-md-4 text-center mb-3 mb-md-0">
                        <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}" class="rental-movie-img" alt="Movie Poster">
                      </div>
                      <div class="col-md-8">
                        <h5 class="movie-title">${movieMap[transaction.movieId].title}</h5>
                        <p class="rental-date">
                          <strong>Rented:</strong> <fmt:formatDate value="${transaction.rentalDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-date">
                          <strong>Due:</strong> <fmt:formatDate value="${transaction.dueDate}" pattern="MMM dd, yyyy" />
                          <c:if test="${transaction.isOverdue()}">
                            <span class="text-danger">(${transaction.calculateDaysOverdue()} days overdue)</span>
                          </c:if>
                          <c:if test="${not transaction.isOverdue()}">
                            <span class="text-success">(${transaction.calculateDaysRemaining()} days remaining)</span>
                          </c:if>
                        </p>
                        <p class="rental-fee">
                          $${transaction.rentalFee}
                          <c:if test="${transaction.isOverdue()}">
                            <span class="text-danger">+ late fees apply</span>
                          </c:if>
                        </p>
                        <div class="d-flex mt-3">
                          <a href="${pageContext.request.contextPath}/return-movie?id=${transaction.transactionId}" class="btn btn-sm btn-primary me-2">Return</a>
                          <a href="${pageContext.request.contextPath}/edit-rental?id=${transaction.transactionId}" class="btn btn-sm btn-outline-light me-2">Extend</a>
                          <a href="${pageContext.request.contextPath}/cancel-rental?id=${transaction.transactionId}" class="btn btn-sm btn-outline-danger">Cancel</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:if>
          <c:if test="${empty activeRentals || activeRentals.size() == 0}">
            <c:if test="${param.filter eq 'active'}">
              <div class="empty-rentals">
                <i class="fas fa-film fa-3x mb-3 text-muted"></i>
                <h5>No active rentals</h5>
                <p class="text-muted">You don't have any active movie rentals at the moment.</p>
                <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-primary mt-3">Browse Movies</a>
              </div>
            </c:if>
          </c:if>
        </c:if>

        <!-- Overdue Rentals Section -->
        <c:if test="${param.filter eq 'overdue'}">
          <c:if test="${not empty overdueRentals && overdueRentals.size() > 0}">
            <h4 class="mt-4 mb-3">Overdue Rentals</h4>
            <div class="row">
              <c:forEach var="transaction" items="${overdueRentals}">
                <div class="col-lg-6 mb-4">
                  <div class="rental-card position-relative">
                    <div class="rental-status status-overdue">Overdue</div>
                    <div class="row">
                      <div class="col-md-4 text-center mb-3 mb-md-0">
                        <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}" class="rental-movie-img" alt="Movie Poster">
                      </div>
                      <div class="col-md-8">
                        <h5 class="movie-title">${movieMap[transaction.movieId].title}</h5>
                        <p class="rental-date">
                          <strong>Rented:</strong> <fmt:formatDate value="${transaction.rentalDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-date">
                          <strong>Due:</strong> <fmt:formatDate value="${transaction.dueDate}" pattern="MMM dd, yyyy" />
                          <span class="text-danger">(${transaction.calculateDaysOverdue()} days overdue)</span>
                        </p>
                        <p class="rental-fee">
                          $${transaction.rentalFee}
                          <span class="text-danger">+ late fees apply</span>
                        </p>
                        <div class="d-flex mt-3">
                          <a href="${pageContext.request.contextPath}/return-movie?id=${transaction.transactionId}" class="btn btn-sm btn-primary me-2">Return Now</a>
                          <a href="${pageContext.request.contextPath}/edit-rental?id=${transaction.transactionId}" class="btn btn-sm btn-outline-light me-2">Extend</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:if>
          <c:if test="${empty overdueRentals || overdueRentals.size() == 0}">
            <div class="empty-rentals">
              <i class="fas fa-check-circle fa-3x mb-3 text-success"></i>
              <h5>No overdue rentals</h5>
              <p class="text-muted">Good job! You don't have any overdue rentals.</p>
            </div>
          </c:if>
        </c:if>

        <!-- Returned Rentals Section -->
        <c:if test="${param.filter eq 'returned'}">
          <c:if test="${not empty rentalHistory && rentalHistory.size() > 0}">
            <h4 class="mt-4 mb-3">Rental History</h4>
            <div class="row">
              <c:forEach var="transaction" items="${rentalHistory}">
                <div class="col-lg-6 mb-4">
                  <div class="rental-card position-relative">
                    <div class="rental-status status-returned">Returned</div>
                    <div class="row">
                      <div class="col-md-4 text-center mb-3 mb-md-0">
                        <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}" class="rental-movie-img" alt="Movie Poster">
                      </div>
                      <div class="col-md-8">
                        <h5 class="movie-title">${movieMap[transaction.movieId].title}</h5>
                        <p class="rental-date">
                          <strong>Rented:</strong> <fmt:formatDate value="${transaction.rentalDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-date">
                          <strong>Returned:</strong> <fmt:formatDate value="${transaction.returnDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-fee">
                          $${transaction.rentalFee}
                          <c:if test="${transaction.lateFee > 0}">
                            <span class="text-danger">+ $${transaction.lateFee} late fee</span>
                          </c:if>
                        </p>
                        <div class="d-flex mt-3">
                          <a href="${pageContext.request.contextPath}/movie-details?id=${transaction.movieId}" class="btn btn-sm btn-outline-light me-2">View Movie</a>
                          <a href="${pageContext.request.contextPath}/rent-movie?id=${transaction.movieId}" class="btn btn-sm btn-primary">Rent Again</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:if>
          <c:if test="${empty rentalHistory || rentalHistory.size() == 0}">
            <div class="empty-rentals">
              <i class="fas fa-history fa-3x mb-3 text-muted"></i>
              <h5>No rental history</h5>
              <p class="text-muted">You haven't returned any movies yet.</p>
              <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-primary mt-3">Browse Movies</a>
            </div>
          </c:if>
        </c:if>

        <!-- Canceled Rentals Section -->
        <c:if test="${param.filter eq 'canceled'}">
          <c:if test="${not empty canceledRentals && canceledRentals.size() > 0}">
            <h4 class="mt-4 mb-3">Canceled Rentals</h4>
            <div class="row">
              <c:forEach var="transaction" items="${canceledRentals}">
                <div class="col-lg-6 mb-4">
                  <div class="rental-card position-relative">
                    <div class="rental-status status-canceled">Canceled</div>
                    <div class="row">
                      <div class="col-md-4 text-center mb-3 mb-md-0">
                        <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}" class="rental-movie-img" alt="Movie Poster">
                      </div>
                      <div class="col-md-8">
                        <h5 class="movie-title">${movieMap[transaction.movieId].title}</h5>
                        <p class="rental-date">
                          <strong>Rented:</strong> <fmt:formatDate value="${transaction.rentalDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-date">
                          <strong>Canceled:</strong> <fmt:formatDate value="${transaction.cancellationDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-date">
                          <strong>Reason:</strong> ${transaction.cancellationReason}
                        </p>
                        <div class="d-flex mt-3">
                          <a href="${pageContext.request.contextPath}/movie-details?id=${transaction.movieId}" class="btn btn-sm btn-outline-light me-2">View Movie</a>
                          <a href="${pageContext.request.contextPath}/rent-movie?id=${transaction.movieId}" class="btn btn-sm btn-primary">Rent Again</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:if>
          <c:if test="${empty canceledRentals || canceledRentals.size() == 0}">
            <div class="empty-rentals">
              <i class="fas fa-ban fa-3x mb-3 text-muted"></i>
              <h5>No canceled rentals</h5>
              <p class="text-muted">You don't have any canceled rentals.</p>
            </div>
          </c:if>
        </c:if>

        <!-- All Rentals Section (when filter is 'all' or not specified) -->
        <c:if test="${empty param.filter || param.filter eq 'all'}">
          <!-- Overdue Rentals Section -->
          <c:if test="${not empty overdueRentals && overdueRentals.size() > 0}">
            <h4 class="mt-4 mb-3">Overdue Rentals</h4>
            <div class="row">
              <c:forEach var="transaction" items="${overdueRentals}">
                <div class="col-lg-6 mb-4">
                  <div class="rental-card position-relative">
                    <div class="rental-status status-overdue">Overdue</div>
                    <div class="row">
                      <div class="col-md-4 text-center mb-3 mb-md-0">
                        <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}" class="rental-movie-img" alt="Movie Poster">
                      </div>
                      <div class="col-md-8">
                        <h5 class="movie-title">${movieMap[transaction.movieId].title}</h5>
                        <p class="rental-date">
                          <strong>Rented:</strong> <fmt:formatDate value="${transaction.rentalDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-date">
                          <strong>Due:</strong> <fmt:formatDate value="${transaction.dueDate}" pattern="MMM dd, yyyy" />
                          <span class="text-danger">(${transaction.calculateDaysOverdue()} days overdue)</span>
                        </p>
                        <p class="rental-fee">
                          $${transaction.rentalFee}
                          <span class="text-danger">+ late fees apply</span>
                        </p>
                        <div class="d-flex mt-3">
                          <a href="${pageContext.request.contextPath}/return-movie?id=${transaction.transactionId}" class="btn btn-sm btn-primary me-2">Return Now</a>
                          <a href="${pageContext.request.contextPath}/edit-rental?id=${transaction.transactionId}" class="btn btn-sm btn-outline-light me-2">Extend</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:if>

          <!-- Active Rentals shown above -->

          <!-- Rental History -->
          <c:if test="${not empty rentalHistory && rentalHistory.size() > 0}">
            <h4 class="mt-4 mb-3">Rental History</h4>
            <div class="row">
              <c:forEach var="transaction" items="${rentalHistory}" begin="0" end="3">
                <div class="col-lg-6 mb-4">
                  <div class="rental-card position-relative">
                    <div class="rental-status status-returned">Returned</div>
                    <div class="row">
                      <div class="col-md-4 text-center mb-3 mb-md-0">
                        <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}" class="rental-movie-img" alt="Movie Poster">
                      </div>
                      <div class="col-md-8">
                        <h5 class="movie-title">${movieMap[transaction.movieId].title}</h5>
                        <p class="rental-date">
                          <strong>Rented:</strong> <fmt:formatDate value="${transaction.rentalDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-date">
                          <strong>Returned:</strong> <fmt:formatDate value="${transaction.returnDate}" pattern="MMM dd, yyyy" />
                        </p>
                        <p class="rental-fee">
                          $${transaction.rentalFee}
                          <c:if test="${transaction.lateFee > 0}">
                            <span class="text-danger">+ $${transaction.lateFee} late fee</span>
                          </c:if>
                        </p>
                        <div class="d-flex mt-3">
                          <a href="${pageContext.request.contextPath}/movie-details?id=${transaction.movieId}" class="btn btn-sm btn-outline-light me-2">View Movie</a>
                          <a href="${pageContext.request.contextPath}/rent-movie?id=${transaction.movieId}" class="btn btn-sm btn-primary">Rent Again</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
            <c:if test="${rentalHistory.size() > 4}">
              <div class="text-center mt-2">
                <a href="${pageContext.request.contextPath}/rental-history?filter=returned" class="btn btn-outline-light">
                  View All History <i class="fas fa-arrow-right ms-2"></i>
                </a>
              </div>
            </c:if>
          </c:if>

          <!-- No rentals message -->
          <c:if test="${(empty activeRentals || activeRentals.size() == 0) &&
                          (empty rentalHistory || rentalHistory.size() == 0) &&
                          (empty canceledRentals || canceledRentals.size() == 0) &&
                          (empty overdueRentals || overdueRentals.size() == 0)}">
            <div class="empty-rentals">
              <i class="fas fa-film fa-3x mb-3 text-muted"></i>
              <h5>No rental history</h5>
              <p class="text-muted">You haven't rented any movies yet. Start exploring our collection!</p>
              <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-primary mt-3">Browse Movies</a>
            </div>
          </c:if>
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