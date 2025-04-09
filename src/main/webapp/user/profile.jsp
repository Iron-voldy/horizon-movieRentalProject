<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.user.PremiumUser" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
  // Get user from session
  User user = (User) session.getAttribute("user");
  boolean isPremium = (user instanceof PremiumUser);
  SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");

  // Redirect if not logged in
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile - FilmHorizon</title>
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
              <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/profile">Profile</a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a></li>
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

  <!-- Profile Section -->
  <div class="container py-5">
    <div class="row">
      <!-- Sidebar Navigation -->
      <div class="col-md-3 mb-4">
        <div class="list-group">
          <a href="${pageContext.request.contextPath}/profile" class="list-group-item list-group-item-action active bg-dark text-white">
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
          <a href="${pageContext.request.contextPath}/user-reviews" class="list-group-item list-group-item-action bg-dark text-white">
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
          <!-- Show success message if any -->
          <% if(session.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success" role="alert">
              <%= session.getAttribute("successMessage") %>
              <% session.removeAttribute("successMessage"); %>
            </div>
          <% } %>

          <div class="profile-header d-flex align-items-center">
            <div class="me-4">
              <div class="bg-dark rounded-circle d-flex align-items-center justify-content-center" style="width: 80px; height: 80px;">
                <i class="fas fa-user-circle fa-4x text-light"></i>
              </div>
            </div>
            <div>
              <h2 class="profile-title mb-0">
                <%= user.getFullName() %>
                <% if (isPremium) { %>
                  <span class="badge bg-warning text-dark ms-2"><i class="fas fa-crown"></i> Premium</span>
                <% } %>
              </h2>
              <p class="text-muted mb-0">@<%= user.getUsername() %></p>
            </div>
          </div>

          <div class="profile-section">
            <h4 class="profile-section-title">Account Information</h4>
            <div class="row">
              <div class="col-md-6 mb-3">
                <div class="card bg-dark text-white">
                  <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-envelope me-2"></i>Email</h5>
                    <p class="card-text"><%= user.getEmail() %></p>
                  </div>
                </div>
              </div>
              <div class="col-md-6 mb-3">
                <div class="card bg-dark text-white">
                  <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-user-tag me-2"></i>Username</h5>
                    <p class="card-text"><%= user.getUsername() %></p>
                  </div>
                </div>
              </div>
              <div class="col-md-6 mb-3">
                <div class="card bg-dark text-white">
                  <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-film me-2"></i>Rental Limit</h5>
                    <p class="card-text"><%= user.getRentalLimit() %> movies at a time</p>
                  </div>
                </div>
              </div>
              <div class="col-md-6 mb-3">
                <div class="card bg-dark text-white">
                  <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-calendar-alt me-2"></i>Member Since</h5>
                    <p class="card-text">April 9, 2025</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <% if (isPremium) { %>
            <!-- Premium Membership Information -->
            <div class="profile-section">
              <h4 class="profile-section-title">Premium Membership</h4>
              <div class="card bg-dark text-white mb-3">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="card-title mb-0"><i class="fas fa-crown text-warning me-2"></i>Premium Status</h5>
                    <span class="badge bg-success">Active</span>
                  </div>
                  <p class="card-text">Your premium membership is active until <%= dateFormat.format(((PremiumUser)user).getSubscriptionExpiryDate()) %></p>
                  <div class="mt-3">
                    <h6 class="mb-2">Premium Benefits:</h6>
                    <ul>
                      <li>Rent up to <%= user.getRentalLimit() %> movies simultaneously</li>
                      <li>20% discount on all rentals</li>
                      <li>Reduced late fees</li>
                      <li>Exclusive access to premium content</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          <% } else { %>
            <!-- Premium Upgrade Information -->
            <div class="profile-section">
              <h4 class="profile-section-title">Premium Membership</h4>
              <div class="card bg-dark text-white mb-3">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="card-title mb-0"><i class="fas fa-crown text-warning me-2"></i>Premium Status</h5>
                    <span class="badge bg-secondary">Inactive</span>
                  </div>
                  <p class="card-text">Upgrade to Premium and enjoy exclusive benefits!</p>
                  <div class="mt-3">
                    <h6 class="mb-2">Premium Benefits:</h6>
                    <ul>
                      <li>Rent up to 10 movies simultaneously (instead of 3)</li>
                      <li>20% discount on all rentals</li>
                      <li>Reduced late fees</li>
                      <li>Exclusive access to premium content</li>
                    </ul>
                  </div>
                  <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/update-profile#upgradeSection" class="btn btn-warning">Upgrade Now</a>
                  </div>
                </div>
              </div>
            </div>
          <% } %>

          <!-- Activity Summary Section -->
          <div class="profile-section">
            <h4 class="profile-section-title">Activity Summary</h4>
            <div class="row">
              <div class="col-md-4 mb-3">
                <div class="card bg-dark text-white text-center">
                  <div class="card-body">
                    <h1 class="display-4 mb-0">0</h1>
                    <p class="card-text">Active Rentals</p>
                    <a href="${pageContext.request.contextPath}/rental-history" class="btn btn-outline-light btn-sm">View All</a>
                  </div>
                </div>
              </div>
              <div class="col-md-4 mb-3">
                <div class="card bg-dark text-white text-center">
                  <div class="card-body">
                    <h1 class="display-4 mb-0">0</h1>
                    <p class="card-text">Watchlist Items</p>
                    <a href="${pageContext.request.contextPath}/view-watchlist" class="btn btn-outline-light btn-sm">View All</a>
                  </div>
                </div>
              </div>
              <div class="col-md-4 mb-3">
                <div class="card bg-dark text-white text-center">
                  <div class="card-body">
                    <h1 class="display-4 mb-0">0</h1>
                    <p class="card-text">Reviews</p>
                    <a href="${pageContext.request.contextPath}/user-reviews" class="btn btn-outline-light btn-sm">View All</a>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <a href="${pageContext.request.contextPath}/update-profile" class="btn btn-primary">
              <i class="fas fa-user-edit me-2"></i>Edit Profile
            </a>
            <a href="${pageContext.request.contextPath}/delete-account" class="btn btn-outline-danger">
              <i class="fas fa-trash-alt me-2"></i>Delete Account
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Profile Section End -->

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