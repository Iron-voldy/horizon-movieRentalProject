<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.MovieManager" %>
<%@ page import="com.movierental.model.rental.Transaction" %>
<%@ page import="com.movierental.model.rental.RentalManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Get user from session
  User user = (User) session.getAttribute("user");

  // Redirect if not logged in
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  // Get transaction ID
  String transactionId = request.getParameter("id");

  if (transactionId == null || transactionId.trim().isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/rental-history");
    return;
  }

  // Get transaction details
  RentalManager rentalManager = new RentalManager(application);
  Transaction transaction = rentalManager.getTransactionById(transactionId);

  if (transaction == null) {
    session.setAttribute("errorMessage", "Rental transaction not found");
    response.sendRedirect(request.getContextPath() + "/rental-history");
    return;
  }

  // Verify user owns this transaction
  if (!transaction.getUserId().equals(user.getUserId())) {
    session.setAttribute("errorMessage", "You do not have permission to cancel this rental");
    response.sendRedirect(request.getContextPath() + "/rental-history");
    return;
  }

  // Check if already returned or canceled
  if (transaction.isReturned() || transaction.isCanceled()) {
    session.setAttribute("errorMessage", "This rental cannot be canceled because it is already returned or canceled");
    response.sendRedirect(request.getContextPath() + "/rental-history");
    return;
  }

  // Get movie details
  MovieManager movieManager = new MovieManager(application);
  Movie movie = movieManager.getMovieById(transaction.getMovieId());

  if (movie == null) {
    session.setAttribute("errorMessage", "Movie information not found");
    response.sendRedirect(request.getContextPath() + "/rental-history");
    return;
  }

  // Date formatter
  SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cancel Rental - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
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
        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>

          <!-- User dropdown menu -->
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              My Account
            </a>
            <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a></li>
              <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/rental-history">Rentals</a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
              <li><hr class="dropdown-divider"></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Cancel Rental Section -->
  <div class="container py-5">
    <div class="row">
      <div class="col-lg-8 mx-auto">
        <div class="profile-container">
          <div class="profile-header">
            <h2 class="profile-title text-danger">
              <i class="fas fa-times-circle me-2"></i> Cancel Rental
            </h2>
          </div>

          <!-- Rental Information -->
          <div class="row mb-4">
            <div class="col-md-4 mb-3 mb-md-0">
              <img src="${pageContext.request.contextPath}/image-servlet?movieId=<%= movie.getMovieId() %>"
                class="img-fluid rounded" alt="<%= movie.getTitle() %> Poster">
            </div>
            <div class="col-md-8">
              <h4><%= movie.getTitle() %> (<%= movie.getReleaseYear() %>)</h4>
              <p><strong>Genre:</strong> <%= movie.getGenre() %></p>

              <div class="card bg-dark mb-3">
                <div class="card-body py-2">
                  <div class="row g-2">
                    <div class="col-6">
                      <div class="text-muted small">Rental Date</div>
                      <div><%= dateFormat.format(transaction.getRentalDate()) %></div>
                    </div>
                    <div class="col-6">
                      <div class="text-muted small">Due Date</div>
                      <div><%= dateFormat.format(transaction.getDueDate()) %></div>
                    </div>
                    <div class="col-6">
                      <div class="text-muted small">Rental Fee</div>
                      <div>$<%= String.format("%.2f", transaction.getRentalFee()) %></div>
                    </div>
                    <div class="col-6">
                      <div class="text-muted small">Rental Period</div>
                      <div><%= transaction.getRentalDuration() %> days</div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle me-2"></i>
                Cancelling this rental will make the movie available for others to rent. Your rental period will end immediately.
              </div>
            </div>
          </div>

          <!-- Cancellation Form -->
          <form action="${pageContext.request.contextPath}/cancel-rental" method="post">
            <input type="hidden" name="transactionId" value="<%= transactionId %>">

            <div class="mb-3">
              <label for="reason" class="form-label">Reason for Cancellation</label>
              <select class="form-select" id="reason" name="reason" required>
                <option value="">Select a reason</option>
                <option value="Changed my mind">Changed my mind</option>
                <option value="Technical issues">Technical issues</option>
                <option value="Found a better option">Found a better option</option>
                <option value="Mistaken rental">Mistaken rental</option>
                <option value="Other">Other</option>
              </select>
            </div>

            <div class="form-check mb-4">
              <input class="form-check-input" type="checkbox" id="confirmCancel" name="confirmCancel" value="yes" required>
              <label class="form-check-label" for="confirmCancel">
                I confirm that I want to cancel this rental
              </label>
            </div>

            <div class="d-flex justify-content-between">
              <a href="${pageContext.request.contextPath}/rental-history" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i>Back to Rentals
              </a>
              <button type="submit" class="btn btn-danger">
                <i class="fas fa-times-circle me-2"></i>Cancel Rental
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
  <!-- Cancel Rental Section End -->

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
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>
</html>