<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!--bootstrap linked-->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>
<body>
  <!-- Navbar Start -->
  <div class="navbar-dark">
    <nav class="navbar navbar-expand-lg navbar-dark container">
      <a class="navbar-brand py-2" href="${pageContext.request.contextPath}/index.jsp">
        <img src="${pageContext.request.contextPath}/img/brand/brand-logo.png" width="120" height="40" alt="FilmHorizon">
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mx-auto">
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Display error message if any -->
  <c:if test="${not empty requestScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      ${requestScope.errorMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <!-- Register Section Start -->
  <div class="container my-5">
    <div class="auth-container">
      <h2 class="auth-title">Create an Account</h2>

      <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
        <div class="mb-3">
          <label for="username" class="form-label">Username</label>
          <input type="text" class="form-control" id="username" name="username" pattern="^[a-zA-Z0-9_]{3,20}$"
                 title="Username must be 3-20 characters and may contain letters, numbers, and underscores" required>
          <div class="form-text">Username must be 3-20 characters and may contain letters, numbers, and underscores.</div>
        </div>

        <div class="mb-3">
          <label for="email" class="form-label">Email</label>
          <input type="email" class="form-control" id="email" name="email" required>
        </div>

        <div class="mb-3">
          <label for="fullName" class="form-label">Full Name</label>
          <input type="text" class="form-control" id="fullName" name="fullName" required>
        </div>

        <div class="mb-3">
          <label for="password" class="form-label">Password</label>
          <input type="password" class="form-control" id="password" name="password"
                 pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"
                 title="Password must be at least 8 characters and include uppercase, lowercase, and numbers" required>
          <div class="form-text">Password must be at least 8 characters and include uppercase, lowercase, and numbers.</div>
        </div>

        <div class="mb-3">
          <label for="confirmPassword" class="form-label">Confirm Password</label>
          <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
          <div id="passwordMatchError" class="invalid-feedback">Passwords do not match</div>
        </div>

        <div class="mb-3 form-check">
          <input type="checkbox" class="form-check-input" id="termsAndConditions" name="termsAndConditions" required>
          <label class="form-check-label" for="termsAndConditions">
            I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms and Conditions</a>
          </label>
        </div>

        <div class="d-grid gap-2">
          <button type="submit" class="btn btn-primary py-2">Create Account</button>
        </div>
      </form>

      <div class="text-center mt-4">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/login" style="color: var(--c-third);">Sign In</a></p>
      </div>
    </div>
  </div>
  <!-- Register Section End -->

  <!-- Terms and Conditions Modal -->
  <div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="termsModalLabel">Terms and Conditions</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <h5>1. Acceptance of Terms</h5>
          <p>By accessing and using Film Horizon, you acknowledge and agree to these terms and conditions.</p>

          <h5>2. User Accounts</h5>
          <p>Users are responsible for maintaining the confidentiality of their account credentials and for all activities occurring under their accounts.</p>

          <h5>3. Rental Terms</h5>
          <p>All rentals are subject to availability. Rental periods begin at the time of transaction and end at the specified due date.</p>
          <p>Late returns may incur additional fees as outlined in our fee schedule.</p>

          <h5>4. Payment Terms</h5>
          <p>Payment is required at the time of rental. We accept major credit cards and digital payment methods.</p>

          <h5>5. User Conduct</h5>
          <p>Users agree not to use the service for any illegal purposes or in violation of any applicable local, state, national, or international law.</p>

          <h5>6. Content and Reviews</h5>
          <p>Users are solely responsible for the content they submit to the platform, including reviews and comments.</p>

          <h5>7. Privacy Policy</h5>
          <p>Our collection and use of personal information is governed by our Privacy Policy, which is incorporated into these Terms.</p>

          <h5>8. Changes to Terms</h5>
          <p>Film Horizon reserves the right to modify these terms at any time. Users will be notified of significant changes.</p>

          <h5>9. Termination</h5>
          <p>Film Horizon reserves the right to terminate or suspend accounts at its discretion for violations of these terms.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-bs-dismiss="modal">I Understand</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Footer Start -->
  <footer class="bg-dark text-white py-4">
    <div class="container">
      <div class="row">
        <div class="col-md-4 mb-3 mb-md-0">
          <h5>Film Horizon</h5>
          <p>Your premier movie rental platform with a vast collection of films from all genres and eras.</p>
        </div>
        <div class="col-md-4 mb-3 mb-md-0">
          <h5>Quick Links</h5>
          <ul class="list-unstyled">
            <li><a href="${pageContext.request.contextPath}/index.jsp" class="text-white">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/search-movie" class="text-white">Movies</a></li>
            <li><a href="${pageContext.request.contextPath}/top-rated" class="text-white">Top Rated</a></li>
            <li><a href="${pageContext.request.contextPath}/login" class="text-white">Login/Register</a></li>
          </ul>
        </div>
        <div class="col-md-4">
          <h5>Contact Us</h5>
          <address>
            <p>Email: support@filmhorizon.com</p>
            <p>Phone: (123) 456-7890</p>
            <p>Address: 123 Movie Street, Hollywood, CA 90210</p>
          </address>
        </div>
      </div>
      <hr>
      <div class="row">
        <div class="col-12 text-center">
          <p class="mb-0">&copy; 2025 Film Horizon. All rights reserved.</p>
        </div>
      </div>
    </div>
  </footer>
  <!-- Footer End -->

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

  <!-- Form validation script -->
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const form = document.getElementById('registerForm');
      const password = document.getElementById('password');
      const confirmPassword = document.getElementById('confirmPassword');
      const passwordMatchError = document.getElementById('passwordMatchError');

      // Check if passwords match
      function validatePassword() {
        if (password.value !== confirmPassword.value) {
          confirmPassword.setCustomValidity('Passwords do not match');
          passwordMatchError.style.display = 'block';
        } else {
          confirmPassword.setCustomValidity('');
          passwordMatchError.style.display = 'none';
        }
      }

      // Add event listeners
      password.addEventListener('change', validatePassword);
      confirmPassword.addEventListener('keyup', validatePassword);

      form.addEventListener('submit', function(event) {
        if (!form.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        }

        form.classList.add('was-validated');
      });
    });
  </script>
</body>
</html>