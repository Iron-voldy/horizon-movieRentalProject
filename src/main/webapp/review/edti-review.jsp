<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.MovieManager" %>
<%@ page import="com.movierental.model.review.Review" %>
<%@ page import="com.movierental.model.review.ReviewManager" %>
<%
  // Get user from session
  User user = (User) session.getAttribute("user");

  // Redirect if not logged in
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  // Get reviewId parameter
  String reviewId = request.getParameter("reviewId");

  if (reviewId == null || reviewId.trim().isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/user-reviews");
    return;
  }

  // Get review details
  ReviewManager reviewManager = new ReviewManager(application);
  Review review = reviewManager.getReviewById(reviewId);

  if (review == null) {
    session.setAttribute("errorMessage", "Review not found");
    response.sendRedirect(request.getContextPath() + "/user-reviews");
    return;
  }

  // Verify the user owns this review
  if (!user.getUserId().equals(review.getUserId())) {
    session.setAttribute("errorMessage", "You do not have permission to edit this review");
    response.sendRedirect(request.getContextPath() + "/user-reviews");
    return;
  }

  // Get movie details
  MovieManager movieManager = new MovieManager(application);
  Movie movie = movieManager.getMovieById(review.getMovieId());

  if (movie == null) {
    session.setAttribute("errorMessage", "Movie not found");
    response.sendRedirect(request.getContextPath() + "/user-reviews");
    return;
  }

  // Check if delete confirmation dialog should be shown
  boolean showDeleteConfirm = "true".equals(request.getParameter("showDeleteConfirm"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Review - <%= movie.getTitle() %> - FilmHorizon</title>
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
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/rental-history">Rentals</a></li>
              <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
              <li><hr class="dropdown-divider"></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Edit Review Section -->
  <div class="container py-5">
    <div class="row">
      <div class="col-lg-8 mx-auto">
        <div class="profile-container">
          <div class="profile-header">
            <h2 class="profile-title">
              <i class="fas fa-edit me-2"></i> Edit Review
            </h2>
            <p class="text-muted">for <%= movie.getTitle() %> (<%= movie.getReleaseYear() %>)</p>
          </div>

          <!-- Show error message if any -->
          <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" role="alert">
              <%= request.getAttribute("errorMessage") %>
            </div>
          <% } %>

          <!-- Delete Confirmation Modal -->
          <% if (showDeleteConfirm) { %>
            <div class="alert alert-danger" role="alert">
              <h5><i class="fas fa-exclamation-triangle me-2"></i>Delete Review?</h5>
              <p>Are you sure you want to delete this review? This action cannot be undone.</p>
              <form action="${pageContext.request.contextPath}/delete-review" method="post" class="d-inline">
                <input type="hidden" name="reviewId" value="<%= reviewId %>">
                <input type="hidden" name="confirmDelete" value="yes">
                <input type="hidden" name="redirectTo" value="user">
                <button type="submit" class="btn btn-danger">Yes, Delete Review</button>
                <a href="${pageContext.request.contextPath}/update-review?reviewId=<%= reviewId %>" class="btn btn-secondary ms-2">Cancel</a>
              </form>
            </div>
          <% } %>

          <div class="row mb-4">
            <div class="col-md-4">
              <img src="${pageContext.request.contextPath}/image-servlet?movieId=<%= movie.getMovieId() %>"
                class="img-fluid rounded" alt="<%= movie.getTitle() %> Poster">
            </div>
            <div class="col-md-8">
              <h4><%= movie.getTitle() %></h4>
              <p><strong>Director:</strong> <%= movie.getDirector() %></p>
              <p><strong>Genre:</strong> <%= movie.getGenre() %></p>
              <p><strong>Release Year:</strong> <%= movie.getReleaseYear() %></p>
              <p><strong>Rating:</strong> <%= movie.getRating() %>/10</p>

              <% if (review.isVerified()) { %>
                <div class="alert alert-success" role="alert">
                  <i class="fas fa-check-circle me-2"></i> This is a verified review.
                </div>
              <% } %>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/update-review" method="post">
            <input type="hidden" name="reviewId" value="<%= reviewId %>">
            <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">

            <div class="mb-3">
              <label class="form-label">Your Rating</label>
              <div class="star-rating">
                <div class="btn-group" role="group" aria-label="Rating">
                  <% for (int i = 1; i <= 5; i++) { %>
                    <input type="radio" class="btn-check" name="rating" id="rating<%= i %>" value="<%= i %>" <%= i == review.getRating() ? "checked" : "" %>>
                    <label class="btn btn-outline-warning" for="rating<%= i %>">
                      <%= i %> <i class="fas fa-star"></i>
                    </label>
                  <% } %>
                </div>
              </div>
            </div>

            <div class="mb-4">
              <label for="comment" class="form-label">Your Review</label>
              <textarea class="form-control" id="comment" name="comment" rows="6" required><%= review.getComment() %></textarea>
            </div>

            <div class="d-flex justify-content-between">
              <div>
                <a href="${pageContext.request.contextPath}/user-reviews" class="btn btn-outline-light me-2">
                  <i class="fas fa-arrow-left me-2"></i>Back to My Reviews
                </a>
                <a href="${pageContext.request.contextPath}/delete-review?reviewId=<%= reviewId %>&showDeleteConfirm=true" class="btn btn-outline-danger">
                  <i class="fas fa-trash-alt me-2"></i>Delete
                </a>
              </div>
              <button type="submit" class="btn btn-primary">
                <i class="fas fa-save me-2"></i>Save Changes
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
  <!-- Edit Review Section End -->

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