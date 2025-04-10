<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.watchlist.Watchlist" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Watchlist - FilmHorizon</title>
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
    // Get watchlist and movie from request attribute
    Watchlist watchlist = (Watchlist) request.getAttribute("watchlist");
    Movie movie = (Movie) request.getAttribute("movie");

    // Check if watchlist and movie exist
    if (watchlist == null || movie == null) {
      response.sendRedirect(request.getContextPath() + "/view-watchlist");
      return;
    }

    // Format dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    String addedDate = dateFormat.format(watchlist.getAddedDate());
    String watchedDate = watchlist.getWatchedDate() != null ? dateFormat.format(watchlist.getWatchedDate()) : "Not watched yet";
  %>

  <!-- Manage Watchlist Section -->
  <div class="container py-5">
    <div class="row">
      <div class="col-md-4">
        <!-- Movie Information Card -->
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

            <!-- Watchlist Details -->
            <div class="card mt-3 bg-secondary text-white">
              <div class="card-body">
                <h6 class="card-subtitle mb-2">Watchlist Details</h6>
                <p class="mb-1"><strong>Added:</strong> <%= addedDate %></p>
                <p class="mb-1">
                  <strong>Status:</strong>
                  <% if (watchlist.isWatched()) { %>
                    <span class="badge bg-success">Watched</span>
                  <% } else { %>
                    <span class="badge bg-warning text-dark">Not Watched</span>
                  <% } %>
                </p>
                <% if (watchlist.isWatched()) { %>
                  <p class="mb-1"><strong>Watched On:</strong> <%= watchedDate %></p>
                <% } %>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-8">
        <div class="card bg-dark text-white">
          <div class="card-header">
            <h4><i class="fas fa-edit me-2"></i>Manage Watchlist Entry</h4>
          </div>
          <div class="card-body">
            <!-- Show error message if any -->
            <% if(request.getAttribute("errorMessage") != null) { %>
              <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("errorMessage") %>
              </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/manage-watchlist" method="post">
              <input type="hidden" name="watchlistId" value="<%= watchlist.getWatchlistId() %>">

              <div class="mb-4">
                <label for="priority" class="form-label">Priority</label>
                <select class="form-select bg-dark text-white" id="priority" name="priority">
                  <option value="1" <%= (watchlist.getPriority() == 1) ? "selected" : "" %>>High Priority (1)</option>
                  <option value="2" <%= (watchlist.getPriority() == 2) ? "selected" : "" %>>Medium-High Priority (2)</option>
                  <option value="3" <%= (watchlist.getPriority() == 3) ? "selected" : "" %>>Medium Priority (3)</option>
                  <option value="4" <%= (watchlist.getPriority() == 4) ? "selected" : "" %>>Medium-Low Priority (4)</option>
                  <option value="5" <%= (watchlist.getPriority() == 5) ? "selected" : "" %>>Low Priority (5)</option>
                </select>
              </div>

              <div class="mb-4">
                <div class="form-check form-switch">
                  <input class="form-check-input" type="checkbox" id="watched" name="watched"
                         <%= watchlist.isWatched() ? "checked" : "" %>>
                  <label class="form-check-label" for="watched">
                    Mark as watched
                  </label>
                </div>
                <div class="form-text text-light-50">
                  If checked, this movie will be marked as watched and added to your recently watched list.
                </div>
              </div>

              <div class="mb-4">
                <label for="notes" class="form-label">Notes</label>
                <textarea class="form-control bg-dark text-white" id="notes" name="notes" rows="3"><%= watchlist.getNotes() != null ? watchlist.getNotes() : "" %></textarea>
              </div>

              <div class="d-flex justify-content-between">
                <div>
                  <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i>Save Changes
                  </button>
                  <a href="${pageContext.request.contextPath}/view-watchlist" class="btn btn-outline-light ms-2">
                    <i class="fas fa-arrow-left me-2"></i>Back to Watchlist
                  </a>
                </div>
                <a href="${pageContext.request.contextPath}/remove-from-watchlist?id=<%= watchlist.getWatchlistId() %>"
                   class="btn btn-danger">
                  <i class="fas fa-trash-alt me-2"></i>Remove from Watchlist
                </a>
              </div>
            </form>

            <!-- Quick Actions -->
            <div class="card mt-4 bg-dark border border-secondary">
              <div class="card-header">
                <h5>Quick Actions</h5>
              </div>
              <div class="card-body">
                <div class="d-flex flex-wrap gap-2">
                  <a href="${pageContext.request.contextPath}/movie-details?id=<%= movie.getMovieId() %>"
                     class="btn btn-outline-info">
                    <i class="fas fa-info-circle me-2"></i>View Movie Details
                  </a>

                  <% if (movie.isAvailable()) { %>
                    <a href="${pageContext.request.contextPath}/rent-movie?id=<%= movie.getMovieId() %>"
                       class="btn btn-outline-success">
                      <i class="fas fa-shopping-cart me-2"></i>Rent Now
                    </a>
                  <% } else { %>
                    <button class="btn btn-outline-secondary" disabled>
                      <i class="fas fa-shopping-cart me-2"></i>Currently Unavailable
                    </button>
                  <% } %>

                  <a href="${pageContext.request.contextPath}/movie-reviews?movieId=<%= movie.getMovieId() %>"
                     class="btn btn-outline-warning">
                    <i class="fas fa-star me-2"></i>See Reviews
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Manage Watchlist Section End -->

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