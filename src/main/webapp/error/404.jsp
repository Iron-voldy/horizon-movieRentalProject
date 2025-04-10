<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | Horizon Movie Rental</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">

    <style>
        .error-template {
            padding: 40px 15px;
            text-align: center;
        }

        .error-actions {
            margin-top: 15px;
            margin-bottom: 15px;
        }

        .error-actions .btn {
            margin-right: 10px;
        }

        .error-details {
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .error-icon {
            font-size: 100px;
            color: #dc3545;
            margin-bottom: 20px;
        }

        .error-code {
            font-size: 36px;
            font-weight: bold;
            color: #343a40;
        }
    </style>
</head>
<body>
    <!-- Include Header/Navbar -->
    <jsp:include page="/includes/navbar.jsp" />

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="error-template">
                    <div class="error-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h1 class="error-code">404</h1>
                    <h2>Oops! Page Not Found</h2>
                    <div class="error-details">
                        Sorry, the page you're looking for cannot be found. It might have been removed,
                        had its name changed, or is temporarily unavailable.
                    </div>
                    <div class="error-actions">
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary btn-lg">
                            <i class="fas fa-home"></i> Back to Home
                        </a>
                        <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-secondary btn-lg">
                            <i class="fas fa-film"></i> Browse Movies
                        </a>
                    </div>
                    <div class="mt-4">
                        <p class="text-muted">
                            <small>Error path: ${pageContext.errorData.requestURI}</small>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white mt-5 py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Horizon Movie Rental</h5>
                    <p>Your premier destination for movie rentals.</p>
                </div>
                <div class="col-md-6 text-right">
                    <p>&copy; 2025 Horizon Movie Rental. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- jQuery and Bootstrap Bundle (includes Popper) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>