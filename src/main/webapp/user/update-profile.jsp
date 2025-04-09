<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register - FilmHorizon</title>
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
          <li class="nav-item active">
            <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Register Section -->
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="auth-container">
          <div class="auth-header">
            <h2 class="auth-title">Create an Account</h2>
            <p class="auth-subtitle">Join FilmHorizon and start your cinematic journey</p>
          </div>

          <!-- Show error message if any -->
          <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" role="alert">
              <%= request.getAttribute("errorMessage") %>
            </div>
          <% } %>

          <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
            <div class="mb-3">
              <label for="fullName" class="form-label">Full Name</label>
              <div class="input-group">
                <span class="input-group-text bg-dark text-light"><i class="fas fa-user"></i></span>
                <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter your full name" required>
              </div>
            </div>

            <div class="mb-3">
              <label for="username" class="form-label">Username</label>
              <div class="input-group">
                <span class="input-group-text bg-dark text-light"><i class="fas fa-user-tag"></i></span>
                <input type="text" class="form-control" id="username" name="username" placeholder="Choose a username" required>
              </div>
              <small class="text-muted">Username must be 3-20 characters long and can only contain letters, numbers, and underscores.</small>
            </div>

            <div class="mb-3">
              <label for="email" class="form-label">Email Address</label>
              <div class="input-group">
                <span class="input-group-text bg-dark text-light"><i class="fas fa-envelope"></i></span>
                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email address" required>
              </div>
            </div>

            <div class="mb-3">
              <label for="password" class="form-label">Password</label>
              <div class="input-group">
                <span class="input-group-text bg-dark text-light"><i class="fas fa-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password" placeholder="Choose a password" required>
              </div>
              <small class="text-muted">Password must be at least 8 characters long.</small>
            </div>

            <div class="mb-3">
                          <label for="confirmPassword" class="form-label">Confirm Password</label>
                          <div class="input-group">
                            <span class="input-group-text bg-dark text-light"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                          </div>
                        </div>

                        <div class="mb-3 form-check">
                          <input type="checkbox" class="form-check-input" id="termsAgree" name="termsAgree" required>
                          <label class="form-check-label text-light" for="termsAgree">
                            I agree to the <a href="#" class="auth-link">Terms of Service</a> and <a href="#" class="auth-link">Privacy Policy</a>
                          </label>
                        </div>

                        <div class="d-grid gap-2">
                          <button type="submit" class="btn btn-primary btn-lg">Create Account</button>
                        </div>
                      </form>

                      <div class="auth-footer">
                        <p>Already have an account? <a href="${pageContext.request.contextPath}/login" class="auth-link">Login here</a></p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- Register Section End -->

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

              <!-- Form Validation Script -->
              <script>
                document.getElementById('registerForm').addEventListener('submit', function(event) {
                  const password = document.getElementById('password').value;
                  const confirmPassword = document.getElementById('confirmPassword').value;

                  if (password !== confirmPassword) {
                    event.preventDefault();
                    alert('Passwords do not match. Please try again.');
                  }
                });
              </script>
            </body>
            </html>