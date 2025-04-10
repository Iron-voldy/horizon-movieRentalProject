<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.user.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add to Watchlist - FilmHorizon</title>
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
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile.jsp">Profile</a></li>
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
    // Get movie from request attribute
    Movie movie = (Movie) request.getAttribute("movie");

    // Check if movie exists
    if (movie == null) {
      response.sendRedirect(request.getContextPath() + "/search-movie");
      return;
    }

    // Set default values for form
    int defaultPriority = 3; // Medium priority
    String defaultNotes = "";
  %>

  <!-- Add to Watchlist Section -->
  <div class="container py-5">
    <div class="row">
      <div class="col-md-4">
        <!-- Movie Poster -->
        <div class="card bg-dark mb-4">
          <% if (movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty()) { %>
            <img src="${pageContext.request.contextPath}/image-servlet?movieId=<%= movie.getMovieId() %>"
                 class="card-img-top movie-poster" alt="<%= movie.getTitle() %> Poster">
          <% } else { %>
            <img src="${pageContext.request.contextPath}/img/movies/placeholder.jpg"
                 class="card-img-top movie-poster" alt="No Poster Available">
          <% } %>

          <div class="card-body">
            <h5 class="card-title text-white"><%= movie.getTitle() %></h5>
            <p class="card-text text-muted"><%= movie.getDirector() %> | <%= movie.getReleaseYear() %></p>
            <div class="movie-rating mb-2">
              <% for (int i = 1; i <= 5; i++) { %>
                <% if (i <= Math.round(movie.getRating()/2)) { %>
                  <i class="fas fa-star text-warning"></i>
                <% } else if (i - 0.5 <= movie.getRating()/2) { %>
                  <i class="fas fa-star-half-alt text-warning"></i>
                <% } else { %>
                  <i class="far fa-star text-warning"></i>
                <% } %>
              <% } %>
              <span class="ms-2 text-light"><%= movie.getRating() %>/10</span>
            </div>
            <p class="card-text text-white"><strong>Genre:</strong> <%= movie.getGenre() %></p>
          </div>
        </div>
      </div>

      <div class="col-md-8">
        <div class="card bg-dark text-white">
          <div class="card-header">
            <h4><i class="fas fa-heart me-2"></i>Add to Your Watchlist</h4>
          </div>
          <div class="card-body">
            <!-- Show error message if any -->
            <% if(request.getAttribute("errorMessage") != null) { %>
              <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("errorMessage") %>
              </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/add-to-watchlist" method="post">
              <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">

              <div class="mb-4">
                <label for="priority" class="form-label">Priority</label>
                <select class="form-select bg-dark text-white" id="priority" name="priority">
                  <option value="1" <%= (defaultPriority == 1) ? "selected" : "" %>>High Priority (1)</option>
                  <option value="2" <%= (defaultPriority == 2) ? "selected" : "" %>>Medium-High Priority (2)</option>
                  <option value="3" <%= (defaultPriority == 3) ? "selected" : "" %>>Medium Priority (3)</option>
                  <option value="4" <%= (defaultPriority == 4) ? "selected" : "" %>>Medium-Low Priority (4)</option>
                  <option value="5" <%= (defaultPriority == 5) ? "selected" : "" %>>Low Priority (5)</option>
                </select>
                <div class="form-text text-light-50">Set how important it is for you to watch this movie</div>
              </div>

              <div class="mb-4">
                <label for="notes" class="form-label">Notes (Optional)</label>
                <textarea class="form-control bg-dark text-white" id="notes" name="notes" rows="3"
                          placeholder="Add any notes about why you want to watch this movie..."><%= defaultNotes %></textarea>
              </div>

              <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-primary">
                  <i class="fas fa-heart me-2"></i>Add to Watchlist
                </button>
                <a href="${pageContext.request.contextPath}/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-outline-light">
                  <i class="fas fa-arrow-left me-2"></i>Back to Movie
                </a>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Add to Watchlist Section End -->

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