<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.MovieManager" %>
<%@ page import="com.movierental.model.review.Review" %>
<%@ page import="com.movierental.model.review.ReviewManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Get user from session
  User user = (User) session.getAttribute("user");

  // Redirect if not logged in
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  // Get reviews by the user
  ReviewManager reviewManager = new ReviewManager(application);
  List<Review> userReviews = reviewManager.getReviewsByUser(user.getUserId());

  // Get movies for each review
  MovieManager movieManager = new MovieManager(application);
  Map<String, Movie> movieMap = new HashMap<>();

  for (Review review : userReviews) {
    String movieId = review.getMovieId();
    if (!movieMap.containsKey(movieId)) {
      Movie movie = movieManager.getMovieById(movieId);
      if (movie != null) {
        movieMap.put(movieId, movie);
      }
    }
  }

  // Date formatter
  SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Reviews - FilmHorizon</title>
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

  <!-- User Reviews Section -->
  <div class="container py-5">
    <div class="row">
      <!-- Sidebar Navigation -->
      <div class="col-md-3 mb-4">
        <div class="list-group">
          <a href="${pageContext.request.contextPath}/profile" class="list-group-item list-group-item-action bg-dark text-white">
            <i class="fas fa-user me-2"></i> My Profile
          </a>
          <a href="${pageContext.request.contextPath}/update-profile" class="list-group-item list-group-item-action bg-dark text-white">
            <i class="fas fa-user-edit me-2"></i> Edit Profile
          </a>
          <a href="${pageContext.request.contextPath}/view-watchlist" class="list-group-item list-group-item-action bg-dark text-white">
            <i class="fas fa-heart me-2"></i> My Watchlist
          </a>
          <a href="${pageContext.request.contextPath}/rental-history" class="list-group-item list-group-item-action bg-dark text-white">
            <i class="fas fa-film me-2"></i> Rental History
          </a>
          <a href="${pageContext.request.contextPath}/user-reviews" class="list-group-item list-group-item-action active bg-dark text-white">
            <i class="fas fa-star me-2"></i> My Reviews
          </a>
          <a href="${pageContext.request.contextPath}/recently-watched" class="list-group-item list-group-item-action bg-dark text-white">
            <i class="fas fa-history me-2"></i> Recently Watched
          </a>
        </div>
      </div>

      <!-- Main Content -->
      <div class="col-md-9">
        <div class="profile-container">
          <div class="profile-header d-flex justify-content-between align-items-center">
            <h2 class="profile-title">
              <i class="fas fa-star me-2"></i> My Reviews
            </h2>
            <div class="dropdown">
              <button class="btn btn-outline-light dropdown-toggle" type="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-sort me-2"></i>Sort By
              </button>
              <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="sortDropdown">
                <li><a class="dropdown-item" href="#">Most Recent</a></li>
                <li><a class="dropdown-item" href="#">Highest Rated</a></li>
                <li><a class="dropdown-item" href="#">Lowest Rated</a></li>
                <li><a class="dropdown-item" href="#">Movie Title (A-Z)</a></li>
              </ul>
            </div>
          </div>

          <!-- Show success message if any -->
          <% if(session.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success" role="alert">
              <%= session.getAttribute("successMessage") %>
              <% session.removeAttribute("successMessage"); %>
            </div>
          <% } %>

          <!-- Show error message if any -->
          <% if(session.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" role="alert">
              <%= session.getAttribute("errorMessage") %>
              <% session.removeAttribute("errorMessage"); %>
            </div>
          <% } %>

          <% if (userReviews.isEmpty()) { %>
            <div class="alert alert-info mt-4">
              <i class="fas fa-info-circle me-2"></i>You haven't written any reviews yet.
            </div>
            <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-primary mt-2">
              <i class="fas fa-film me-2"></i>Explore Movies to Review
            </a>
          <% } else { %>
            <p class="text-muted mb-4">You have written <%= userReviews.size() %> review<%= userReviews.size() > 1 ? "s" : "" %>.</p>

            <div class="row">
              <% for (Review review : userReviews) { %>
                <%
                  Movie movie = movieMap.get(review.getMovieId());
                  if (movie == null) continue; // Skip if movie not found
                %>
                <div class="col-md-12 mb-4">
                  <div class="card bg-dark">
                    <div class="card-body">
                      <div class="row">
                        <div class="col-md-2 col-sm-3 mb-3 mb-md-0">
                          <img src="${pageContext.request.contextPath}/image-servlet?movieId=<%= movie.getMovieId() %>"
                            class="img-fluid rounded" alt="<%= movie.getTitle() %> Poster">
                        </div>
                        <div class="col-md-10 col-sm-9">
                          <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                              <h4 class="mb-0"><a href="${pageContext.request.contextPath}/movie-details?id=<%= movie.getMovieId() %>" class="text-white"><%= movie.getTitle() %></a></h4>
                              <p class="text-muted"><%= movie.getReleaseYear() %> • <%= movie.getGenre() %></p>
                            </div>
                            <div>
                              <% for (int i = 1; i <= 5; i++) { %>
                                <% if (i <= review.getRating()) { %>
                                  <i class="fas fa-star text-warning"></i>
                                <% } else { %>
                                  <i class="far fa-star text-warning"></i>
                                <% } %>
                              <% } %>
                            </div>
                          </div>

                          <p class="mb-3"><%= review.getComment() %></p>

                          <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted small">
                              <i class="far fa-calendar-alt me-1"></i> <%= dateFormat.format(review.getReviewDate()) %>
                              <% if (review.isVerified()) { %>
                                <span class="badge bg-success ms-2">Verified</span>
                              <% } %>
                            </div>
                            <div>
                              <a href="${pageContext.request.contextPath}/update-review?reviewId=<%= review.getReviewId() %>" class="btn btn-sm btn-outline-light me-2">
                                <i class="fas fa-edit me-1"></i>Edit
                              </a>
                              <a href="${pageContext.request.contextPath}/delete-review?reviewId=<%= review.getReviewId() %>&showDeleteConfirm=true" class="btn btn-sm btn-outline-danger">
                                <i class="fas fa-trash-alt me-1"></i>Delete
                              </a>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              <% } %>
            </div>
          <% } %>
        </div>
      </div>
    </div>
  </div>
  <!-- User Reviews Section End -->

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