<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.MovieManager" %>
<%@ page import="com.movierental.model.review.Review" %>
<%@ page import="com.movierental.model.review.ReviewManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Get user from session
  User user = (User) session.getAttribute("user");

  // Get movieId parameter
  String movieId = request.getParameter("movieId");

  if (movieId == null || movieId.trim().isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/search-movie");
    return;
  }

  // Get movie details
  MovieManager movieManager = new MovieManager(application);
  Movie movie = movieManager.getMovieById(movieId);

  if (movie == null) {
    session.setAttribute("errorMessage", "Movie not found");
    response.sendRedirect(request.getContextPath() + "/search-movie");
    return;
  }

  // Get all reviews for the movie
  ReviewManager reviewManager = new ReviewManager(application);
  List<Review> reviews = reviewManager.getReviewsByMovie(movieId);

  // Get review statistics
  double averageRating = reviewManager.calculateAverageRating(movieId);
  int verifiedReviewsCount = reviewManager.countVerifiedReviews(movieId);
  int guestReviewsCount = reviewManager.countGuestReviews(movieId);
  Map<Integer, Integer> ratingDistribution = reviewManager.getRatingDistribution(movieId);

  // Check if the current user has already reviewed this movie
  boolean hasReviewed = false;
  Review userReview = null;

  if (user != null) {
    userReview = reviewManager.getUserReviewForMovie(user.getUserId(), movieId);
    hasReviewed = (userReview != null);
  }

  // Date formatter
  SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reviews for <%= movie.getTitle() %> - FilmHorizon</title>
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
          <li class="nav-item active">
            <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>

          <% if (user != null) { %>
            <!-- User dropdown menu -->
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                My Account
              </a>
              <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/rental-history">Rentals</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
                <li><hr class="dropdown-divider"></li>
               <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                             </ul>
                           </li>
                         <% } else { %>
                           <li class="nav-item">
                             <a class="nav-link" href="${pageContext.request.contextPath}/login">
                               <img src="${pageContext.request.contextPath}/img/brand/white-button-login.png" width="33" height="33" alt="Login">
                             </a>
                           </li>
                         <% } %>
                       </ul>
                     </div>
                   </nav>
                 </div>
                 <!-- Navbar End -->

                 <!-- Movie Reviews Section -->
                 <div class="container py-5">
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

                   <div class="row mb-5">
                     <div class="col-lg-4 mb-4">
                       <img src="${pageContext.request.contextPath}/image-servlet?movieId=<%= movie.getMovieId() %>"
                         class="img-fluid rounded" alt="<%= movie.getTitle() %> Poster">
                     </div>
                     <div class="col-lg-8">
                       <h2 class="mb-3"><%= movie.getTitle() %> (<%= movie.getReleaseYear() %>)</h2>
                       <div class="d-flex align-items-center mb-3">
                         <h4 class="mb-0 me-3">
                           <% for (int i = 1; i <= 5; i++) { %>
                             <% if (i <= Math.round(averageRating)) { %>
                               <i class="fas fa-star text-warning"></i>
                             <% } else { %>
                               <i class="far fa-star text-warning"></i>
                             <% } %>
                           <% } %>
                         </h4>
                         <h4 class="mb-0"><%= String.format("%.1f", averageRating) %>/5</h4>
                         <span class="ms-3 text-muted">(<%= reviews.size() %> reviews)</span>
                       </div>

                       <p><strong>Director:</strong> <%= movie.getDirector() %></p>
                       <p><strong>Genre:</strong> <%= movie.getGenre() %></p>

                       <div class="mb-4">
                         <div class="d-flex align-items-center">
                           <h5 class="me-3 mb-0">Review Breakdown:</h5>
                           <span class="badge bg-success"><%= verifiedReviewsCount %> Verified</span>
                           <span class="badge bg-secondary ms-2"><%= guestReviewsCount %> Guest</span>
                         </div>
                       </div>

                       <div class="d-flex">
                         <a href="${pageContext.request.contextPath}/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-outline-light me-2">
                           <i class="fas fa-info-circle me-2"></i>Movie Details
                         </a>
                         <a href="${pageContext.request.contextPath}/rent-movie?id=<%= movie.getMovieId() %>" class="btn btn-primary me-2">
                           <i class="fas fa-play me-2"></i>Rent Now
                         </a>
                         <a href="${pageContext.request.contextPath}/add-to-watchlist?movieId=<%= movie.getMovieId() %>" class="btn btn-outline-warning">
                           <i class="fas fa-heart me-2"></i>Add to Watchlist
                         </a>
                       </div>
                     </div>
                   </div>

                   <div class="row">
                     <!-- Rating Distribution -->
                     <div class="col-lg-4 mb-4">
                       <div class="profile-container h-100">
                         <h4 class="mb-4">Rating Distribution</h4>

                         <% for (int i = 5; i >= 1; i--) { %>
                           <div class="d-flex align-items-center mb-3">
                             <div class="me-2" style="width: 70px;">
                               <%= i %> <i class="fas fa-star text-warning"></i>
                             </div>
                             <div class="progress flex-grow-1" style="height: 18px; background-color: #333;">
                               <%
                                 int count = ratingDistribution.containsKey(i) ? ratingDistribution.get(i) : 0;
                                 int percentage = reviews.size() > 0 ? (count * 100 / reviews.size()) : 0;
                               %>
                               <div class="progress-bar bg-warning" role="progressbar" style="width: <%= percentage %>%;"
                                 aria-valuenow="<%= percentage %>" aria-valuemin="0" aria-valuemax="100"><%= count %></div>
                             </div>
                           </div>
                         <% } %>

                         <div class="mt-4">
                           <% if (hasReviewed) { %>
                             <div class="alert alert-info">
                               <i class="fas fa-info-circle me-2"></i>You've already reviewed this movie
                             </div>
                             <a href="${pageContext.request.contextPath}/update-review?reviewId=<%= userReview.getReviewId() %>" class="btn btn-primary w-100">
                               <i class="fas fa-edit me-2"></i>Edit Your Review
                             </a>
                           <% } else { %>
                             <a href="${pageContext.request.contextPath}/add-review?movieId=<%= movie.getMovieId() %>" class="btn btn-primary w-100">
                               <i class="fas fa-pen me-2"></i>Write a Review
                             </a>
                           <% } %>
                         </div>
                       </div>
                     </div>

                     <!-- Reviews List -->
                     <div class="col-lg-8">
                       <div class="profile-container">
                         <div class="d-flex justify-content-between mb-4">
                           <h4>Reviews (<%= reviews.size() %>)</h4>
                           <div class="dropdown">
                             <button class="btn btn-outline-light dropdown-toggle" type="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                               <i class="fas fa-sort me-2"></i>Sort By
                             </button>
                             <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="sortDropdown">
                               <li><a class="dropdown-item" href="#">Most Recent</a></li>
                               <li><a class="dropdown-item" href="#">Highest Rated</a></li>
                               <li><a class="dropdown-item" href="#">Lowest Rated</a></li>
                               <li><a class="dropdown-item" href="#">Verified Only</a></li>
                             </ul>
                           </div>
                         </div>

                         <% if (reviews.isEmpty()) { %>
                           <div class="alert alert-info">
                             <i class="fas fa-info-circle me-2"></i>There are no reviews for this movie yet. Be the first to write one!
                           </div>
                         <% } else { %>
                           <% for (Review review : reviews) { %>
                             <div class="card bg-dark mb-4">
                               <div class="card-body">
                                 <div class="d-flex justify-content-between mb-3">
                                   <div>
                                     <h5 class="card-title mb-0"><%= review.getUserName() %></h5>
                                     <div class="text-muted small">
                                       <%= dateFormat.format(review.getReviewDate()) %>
                                       <% if (review.isVerified()) { %>
                                         <span class="badge bg-success ms-2">Verified</span>
                                       <% } %>
                                     </div>
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

                                 <p class="card-text"><%= review.getComment() %></p>

                                 <% if (user != null && user.getUserId().equals(review.getUserId())) { %>
                                   <div class="text-end">
                                     <a href="${pageContext.request.contextPath}/update-review?reviewId=<%= review.getReviewId() %>" class="btn btn-sm btn-outline-light">
                                       <i class="fas fa-edit me-1"></i>Edit
                                     </a>
                                     <a href="${pageContext.request.contextPath}/delete-review?reviewId=<%= review.getReviewId() %>&showDeleteConfirm=true" class="btn btn-sm btn-outline-danger ms-2">
                                       <i class="fas fa-trash-alt me-1"></i>Delete
                                     </a>
                                   </div>
                                 <% } %>
                               </div>
                             </div>
                           <% } %>
                         <% } %>
                       </div>
                     </div>
                   </div>
                 </div>
                 <!-- Movie Reviews Section End -->

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