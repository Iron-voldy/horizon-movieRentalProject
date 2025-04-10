<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Top Rated Movies - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .top-rated-container {
      margin-top: 30px;
      margin-bottom: 50px;
    }
    .top-rated-header {
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
    .movie-card {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      overflow: hidden;
      transition: transform 0.3s ease;
      height: 100%;
      border: 1px solid #333;
      margin-bottom: 20px;
      position: relative;
    }
    .movie-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }
    .movie-poster {
      height: 250px;
      object-fit: cover;
      width: 100%;
    }
    .movie-card-body {
      padding: 15px;
    }
    .movie-title {
      font-weight: 600;
      margin-bottom: 5px;
    }
    .movie-info {
      color: var(--c-gray);
      font-size: 0.9rem;
      margin-bottom: 10px;
    }
    .movie-rating {
      margin-bottom: 15px;
    }
    .movie-actions {
      display: flex;
      justify-content: space-between;
    }
    .rank-badge {
      position: absolute;
      top: 10px;
      left: 10px;
      width: 30px;
      height: 30px;
      line-height: 30px;
      text-align: center;
      background-color: var(--c-accent);
      color: white;
      border-radius: 50%;
      font-weight: bold;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
    }
    .empty-recs {
      background-color: var(--c-card-dark);
      border-radius: 10px;
      padding: 40px;
      text-align: center;
      margin-top: 20px;
    }
    .refresh-button {
      position: absolute;
      right: 15px;
      top: 15px;
    }
    .hero-section {
      background-image: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), url('${pageContext.request.contextPath}/img/top-rated-banner.jpg');
      background-size: cover;
      background-position: center;
      height: 300px;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      margin-bottom: 40px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }
    .hero-content {
      max-width: 600px;
      padding: 20px;
    }
    .hero-title {
      font-size: 2.5rem;
      margin-bottom: 10px;
      color: white;
    }
    .hero-description {
      color: #ddd;
      margin-bottom: 0;
    }
    .highlight {
      color: var(--c-accent);
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/top-rated">Top Rated</a>
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
  <div class="container top-rated-container">
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

    <!-- Hero Section -->
    <div class="hero-section">
      <div class="hero-content">
        <h1 class="hero-title">Top Rated <span class="highlight">Movies</span></h1>
        <p class="hero-description">Discover our highest-rated films, curated based on user reviews and ratings. From timeless classics to modern masterpieces, these are the best of the best.</p>
      </div>
    </div>

    <div class="top-rated-header position-relative">
      <h2>Top Rated Films</h2>
      <p class="text-muted">Our most acclaimed movies with the highest ratings from our community.</p>

      <a href="${pageContext.request.contextPath}/recommendation-action?action=generate-top-rated" class="btn btn-sm btn-outline-light refresh-button">
        <i class="fas fa-sync-alt me-2"></i> Refresh List
      </a>
    </div>

    <!-- Recommendation Type Tabs -->
    <ul class="nav recommendation-tabs mb-4">
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/view-recommendations?type=personal">
          <i class="fas fa-user me-2"></i> Personal Recommendations
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/view-recommendations?type=general">
          <i class="fas fa-globe me-2"></i> General Recommendations
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link active" href="${pageContext.request.contextPath}/top-rated">
          <i class="fas fa-star me-2"></i> Top Rated Movies
        </a>
      </li>
    </ul>

    <!-- Genre Filter Section -->
    <c:if test="${not empty allGenres}">
      <div class="mb-4">
        <div class="d-flex flex-wrap gap-2">
          <c:forEach var="genre" items="${allGenres}">
            <a href="${pageContext.request.contextPath}/genre-recommendations?genre=${genre}" class="btn btn-sm btn-outline-light">
              ${genre}
            </a>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <!-- Top Rated Section -->
    <div class="row">
      <c:choose>
        <c:when test="${empty recommendations || recommendations.size() == 0}">
          <div class="col-12">
            <div class="empty-recs">
              <i class="fas fa-film fa-3x mb-3 text-muted"></i>
              <h4>No top rated movies available</h4>
              <p class="text-muted">We don't have any top rated recommendations at the moment.</p>
              <a href="${pageContext.request.contextPath}/recommendation-action?action=generate-top-rated" class="btn btn-primary mt-3">
                <i class="fas fa-sync-alt me-2"></i> Generate Top Rated List
              </a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="recommendation" items="${recommendations}" varStatus="status">
            <c:set var="movie" value="${movieMap[recommendation.movieId]}" />
            <c:if test="${not empty movie}">
              <div class="col-md-6 col-lg-4 col-xl-3 mb-4">
                <div class="movie-card">
                  <span class="rank-badge">${recommendation.rank}</span>
                  <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}" class="movie-poster" alt="${movie.title} Poster">
                  <div class="movie-card-body">
                    <h5 class="movie-title">${movie.title}</h5>
                    <div class="movie-info">${movie.director} | ${movie.releaseYear} | ${movie.genre}</div>
                    <div class="movie-rating">
                      <c:forEach var="i" begin="1" end="5">
                        <c:choose>
                          <c:when test="${movie.rating >= i*2}">
                            <i class="fas fa-star text-warning"></i>
                          </c:when>
                          <c:when test="${movie.rating >= i*2-1}">
                            <i class="fas fa-star-half-alt text-warning"></i>
                          </c:when>
                         <c:otherwise>
                                                     <i class="far fa-star text-warning"></i>
                                                   </c:otherwise>
                                                 </c:choose>
                                               </c:forEach>
                                               <span class="ms-1">${movie.rating}/10</span>
                                             </div>
                                             <div class="movie-actions">
                                               <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}" class="btn btn-sm btn-outline-light">
                                                 <i class="fas fa-info-circle me-1"></i> Details
                                               </a>
                                               <c:choose>
                                                 <c:when test="${movie.available}">
                                                   <a href="${pageContext.request.contextPath}/rent-movie?id=${movie.movieId}" class="btn btn-sm btn-primary">
                                                     <i class="fas fa-shopping-cart me-1"></i> Rent
                                                   </a>
                                                 </c:when>
                                                 <c:otherwise>
                                                   <button class="btn btn-sm btn-secondary" disabled>
                                                     <i class="fas fa-clock me-1"></i> Unavailable
                                                   </button>
                                                 </c:otherwise>
                                               </c:choose>
                                             </div>
                                           </div>
                                         </div>
                                       </div>
                                     </c:if>
                                   </c:forEach>
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