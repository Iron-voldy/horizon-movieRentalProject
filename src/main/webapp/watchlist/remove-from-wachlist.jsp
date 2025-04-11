<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.watchlist.Watchlist" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Remove from Watchlist - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .confirmation-container {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 30px;
      margin-top: 30px;
      margin-bottom: 50px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .confirmation-header {
      text-align: center;
      margin-bottom: 30px;
    }
    .confirmation-icon {
      font-size: 4rem;
      color: #dc3545;
      margin-bottom: 20px;
    }
    .movie-info-container {
      background-color: rgba(0, 0, 0, 0.2);
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 30px;
    }
    .movie-poster {
      width: 100%;
      max-width: 200px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .movie-title {
      font-size: 1.5rem;
      font-weight: 600;
      margin-bottom: 10px;
    }
    .movie-details {
      font-size: 0.9rem;
      color: var(--c-gray);
      list-style-type: none;
      padding-left: 0;
    }
    .movie-details li {
      margin-bottom: 8px;
    }
    .warning-text {
      color: #dc3545;
      font-weight: 500;
      text-align: center;
      margin-bottom: 20px;
    }
    .btn-remove {
      background-color: #dc3545;
      border-color: #dc3545;
    }
    .btn-remove:hover {
      background-color: #bb2d3b;
      border-color: #b02a37;
    }
    .confirmation-actions {
      display: flex;
      justify-content: center;
      gap: 15px;
    }
    .badge-watchlist-info {
      background-color: var(--c-accent);
      color: white;
      border-radius: 20px;
      padding: 5px 15px;
      margin-right: 10px;
      display: inline-block;
      font-size: 0.9rem;
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
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/update-profile">Profile</a></li>
              <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/rental-history">Rentals</a></li>
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

  <%
    // Get watchlist and movie from request attribute
    Watchlist watchlist = (Watchlist) request.getAttribute("watchlist");
    Movie movie = (Movie) request.getAttribute("movie");

    // Check if watchlist and movie exist
    if (watchlist == null || movie == null) {
      response.sendRedirect(request.getContextPath() + "/view-watchlist");
      return;
    }

    // Format watchlist status
    String watchlistStatus = watchlist.isWatched() ? "Watched" : "Not watched yet";
    String priorityText = "";
    switch (watchlist.getPriority()) {
      case 1: priorityText = "High priority"; break;
      case 2: priorityText = "Medium-high priority"; break;
      case 3: priorityText = "Medium priority"; break;
      case 4: priorityText = "Medium-low priority"; break;
      case 5: priorityText = "Low priority"; break;
      default: priorityText = "Medium priority"; break;
    }
  %>

  <!-- Confirmation Section -->
  <div class="container">
    <!-- Alert Messages -->
    <% if(request.getAttribute("errorMessage") != null) { %>
      <div class="alert alert-danger alert-dismissible fade show mt-4" role="alert">
        <%= request.getAttribute("errorMessage") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% } %>

    <div class="confirmation-container">
      <div class="confirmation-header">
        <i class="fas fa-trash-alt confirmation-icon"></i>
        <h2>Remove from Watchlist</h2>
        <p class="text-muted">You are about to remove this movie from your watchlist.</p>
      </div>

      <div class="movie-info-container">
        <div class="row">
          <div class="col-md-4 text-center">
            <img src="${pageContext.request.contextPath}/image-servlet?movieId=<%= movie.getMovieId() %>"
                 class="movie-poster" alt="<%= movie.getTitle() %> Poster">
          </div>
          <div class="col-md-8">
            <h3 class="movie-title"><%= movie.getTitle() %></h3>
            <div class="mb-3">
              <span class="badge-watchlist-info"><i class="fas fa-layer-group me-1"></i> <%= priorityText %></span>
              <span class="badge-watchlist-info"><i class="fas fa-eye me-1"></i> <%= watchlistStatus %></span>
            </div>
            <ul class="movie-details">
              <li><strong>Director:</strong> <%= movie.getDirector() %></li>
              <li><strong>Genre:</strong> <%= movie.getGenre() %></li>
              <li><strong>Release Year:</strong> <%= movie.getReleaseYear() %></li>
              <li><strong>Rating:</strong> <%= movie.getRating() %>/10</li>
              <% if (watchlist.getNotes() != null && !watchlist.getNotes().isEmpty()) { %>
                <li><strong>Your Notes:</strong> <%= watchlist.getNotes() %></li>
              <% } %>
            </ul>
          </div>
        </div>
      </div>

      <p class="warning-text">
        <i class="fas fa-exclamation-triangle me-2"></i>
        Are you sure you want to remove this movie from your watchlist?
      </p>

      <form action="${pageContext.request.contextPath}/remove-from-watchlist" method="post" class="mt-4">
        <input type="hidden" name="watchlistId" value="<%= watchlist.getWatchlistId() %>">

        <div class="form-check mb-4 d-flex justify-content-center">
          <input class="form-check-input me-2" type="checkbox" id="confirmRemove" name="confirmRemove" value="yes" required>
          <label class="form-check-label" for="confirmRemove">
            Yes, I want to remove this movie from my watchlist
          </label>
        </div>

        <div class="confirmation-actions">
          <a href="${pageContext.request.contextPath}/manage-watchlist?id=<%= watchlist.getWatchlistId() %>" class="btn btn-outline-light">
            <i class="fas fa-arrow-left me-2"></i> Cancel
          </a>
          <button type="submit" class="btn btn-remove">
            <i class="fas fa-trash-alt me-2"></i> Remove from Watchlist
          </button>
        </div>
      </form>
    </div>
  </div>
  <!-- Confirmation Section End -->

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