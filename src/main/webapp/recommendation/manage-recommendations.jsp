<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Recommendations - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .manage-container {
      margin-top: 30px;
      margin-bottom: 50px;
    }
    .manage-header {
      margin-bottom: 30px;
    }
    .recommendation-tabs .nav-link {
      color: var(--c-gray);
      border: none;
      border-bottom: 2px solid transparent;
      padding: 12px 20px;
      border-radius: 0;
    }
    .recommendation-tabs .nav-link.active {
      background-color: transparent;
      color: var(--c-accent);
      border-bottom: 2px solid var(--c-accent);
    }
    .recommendation-tabs .nav-link:hover:not(.active) {
      border-bottom: 2px solid var(--c-gray);
    }
    .recommendation-table {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      overflow: hidden;
    }
    .recommendation-table th {
      background-color: rgba(0, 0, 0, 0.2);
      color: var(--c-accent);
      font-weight: 500;
      border-color: #333;
    }
    .recommendation-table td {
      border-color: #333;
      vertical-align: middle;
    }
    .recommendation-type {
      display: inline-block;
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 0.75rem;
      font-weight: 500;
    }
    .type-personal {
      background-color: rgba(155, 93, 229, 0.1);
      color: var(--c-accent);
      border: 1px solid var(--c-accent);
    }
    .type-general {
      background-color: rgba(25, 135, 84, 0.1);
      color: #198754;
      border: 1px solid #198754;
    }
    .empty-recs {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 40px;
      text-align: center;
      margin-top: 20px;
    }
    .add-buttons {
      position: absolute;
      right: 15px;
      top: 15px;
    }
    .movie-thumb {
      width: 50px;
      height: 70px;
      object-fit: cover;
      border-radius: 4px;
    }
    .btn-action {
      padding: 0.25rem 0.5rem;
      font-size: 0.75rem;
    }
    .table-container {
      overflow-x: auto;
    }
    .recommendation-reason {
      max-width: 250px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
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
        <div class="search-container mx-auto">
          <form class="d-flex" action="${pageContext.request.contextPath}/search-movie" method="get">
            <input class="form-control search-input me-2" type="search" name="searchQuery" placeholder="Search movies..." aria-label="Search">
            <button class="btn custom-search-btn" type="submit">
              <i class="fas fa-search"></i>
            </button>
          </form>
        </div>

        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/top-rated">Top Rated</a>
          </li>

          <!-- Check if user is logged in -->
          <c:if test="${not empty sessionScope.user}">
            <!-- User is logged in, show appropriate options -->
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                My Account
              </a>
              <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDropdown">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/update-profile">Profile</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/rental-history">Rentals</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
              </ul>
            </li>
          </c:if>
          <c:if test="${empty sessionScope.user}">
            <!-- User is not logged in, show login button -->
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/login">
                <i class="fas fa-sign-in-alt"></i> Login
              </a>
            </li>
          </c:if>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Main Content Start -->
  <div class="container manage-container">
    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
      <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
      <c:remove var="errorMessage" scope="session" />
    </c:if>

    <div class="manage-header position-relative">
      <h2>Manage Recommendations</h2>
      <p class="text-muted">Create, edit, and delete movie recommendations for users.</p>

      <div class="add-buttons">
        <a href="${pageContext.request.contextPath}/manage-recommendations?action=add&type=general" class="btn btn-sm btn-outline-light me-2">
          <i class="fas fa-plus me-1"></i> Add General
        </a>
        <a href="${pageContext.request.contextPath}/manage-recommendations?action=add&type=personal" class="btn btn-sm btn-primary">
          <i class="fas fa-plus me-1"></i> Add Personal
        </a>
      </div>
    </div>

    <!-- Recommendations List -->
    <div class="table-container">
      <c:choose>
        <c:when test="${empty recommendations || recommendations.size() == 0}">
          <div class="empty-recs">
            <i class="fas fa-film fa-3x mb-3 text-muted"></i>
            <h4>No recommendations available</h4>
            <p class="text-muted">There are no recommendations in the system.</p>
            <div class="mt-3">
              <a href="${pageContext.request.contextPath}/manage-recommendations?action=add&type=general" class="btn btn-outline-light me-2">
                <i class="fas fa-plus me-1"></i> Create General Recommendation
              </a>
              <a href="${pageContext.request.contextPath}/manage-recommendations?action=add&type=personal" class="btn btn-primary">
                <i class="fas fa-plus me-1"></i> Create Personal Recommendation
              </a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <table class="table table-dark recommendation-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Movie</th>
                <th>Type</th>
                <th>User</th>
                <th>Reason</th>
                <th>Score</th>
                <th>Date</th>
                <th>Actions</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="recommendation" items="${recommendations}">
                                <c:set var="movie" value="${movieMap[recommendation.movieId]}" />
                                <tr>
                                  <td><small>${recommendation.recommendationId.substring(0, 8)}...</small></td>
                                  <td>
                                    <c:if test="${not empty movie}">
                                      <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}" class="movie-thumb me-2" alt="Movie Poster">
                                        <div>
                                          <div class="fw-bold">${movie.title}</div>
                                          <small class="text-muted">${movie.releaseYear}</small>
                                        </div>
                                      </div>
                                    </c:if>
                                    <c:if test="${empty movie}">
                                      <span class="text-danger">Movie not found</span>
                                    </c:if>
                                  </td>
                                  <td>
                                    <c:choose>
                                      <c:when test="${recommendation.isPersonalized()}">
                                        <span class="recommendation-type type-personal">Personal</span>
                                      </c:when>
                                      <c:otherwise>
                                        <span class="recommendation-type type-general">General</span>
                                      </c:otherwise>
                                    </c:choose>
                                  </td>
                                  <td>
                                    <c:choose>
                                      <c:when test="${recommendation.isPersonalized() && not empty recommendation.userId}">
                                        <c:set var="user" value="${null}" />
                                        <c:forEach var="userEntry" items="${allUsers}">
                                          <c:if test="${userEntry.userId eq recommendation.userId}">
                                            <c:set var="user" value="${userEntry}" />
                                          </c:if>
                                        </c:forEach>
                                        <c:choose>
                                          <c:when test="${not empty user}">
                                            ${user.username}
                                          </c:when>
                                          <c:otherwise>
                                            <span class="text-danger">User not found</span>
                                          </c:otherwise>
                                        </c:choose>
                                      </c:when>
                                      <c:otherwise>
                                        <span class="text-muted">N/A</span>
                                      </c:otherwise>
                                    </c:choose>
                                  </td>
                                  <td><div class="recommendation-reason">${recommendation.reason}</div></td>
                                  <td>${recommendation.score}</td>
                                  <td><fmt:formatDate value="${recommendation.generatedDate}" pattern="MMM dd, yyyy" /></td>
                                  <td>
                                    <div class="d-flex">
                                      <a href="${pageContext.request.contextPath}/manage-recommendations?action=edit&id=${recommendation.recommendationId}" class="btn btn-sm btn-outline-light btn-action me-1">
                                        <i class="fas fa-edit"></i>
                                      </a>
                                      <a href="${pageContext.request.contextPath}/manage-recommendations?action=delete&id=${recommendation.recommendationId}"
                                         class="btn btn-sm btn-outline-danger btn-action"
                                         onclick="return confirm('Are you sure you want to delete this recommendation?');">
                                        <i class="fas fa-trash"></i>
                                      </a>
                                    </div>
                                  </td>
                                </tr>
                              </c:forEach>
                            </tbody>
                          </table>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                  <!-- Main Content End -->

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
                  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
                </body>
                </html>