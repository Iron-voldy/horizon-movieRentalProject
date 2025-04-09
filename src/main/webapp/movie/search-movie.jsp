<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Movies - FilmHorizon</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
  <!--bootstrap linked-->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <!-- Font Awesome icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
          <li class="nav-item active">
            <a class="nav-link active" href="${pageContext.request.contextPath}/search-movie">Movies</a>
          </li>
          <c:if test="${not empty sessionScope.userId}">
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/view-watchlist">Watchlist</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/rental-history">Rentals</a>
            </li>
          </c:if>
        </ul>

        <!-- Search bar -->
        <div class="search-container me-3">
          <form class="d-flex" action="${pageContext.request.contextPath}/search-movie" method="get">
            <input class="form-control me-2 search-input" type="search" name="searchQuery" placeholder="Search movies..."
                   value="${searchQuery}" aria-label="Search">
            <button class="btn custom-search-btn" type="submit">Search</button>
          </form>
        </div>

        <!-- User Login/Profile -->
        <ul class="navbar-nav">
          <c:choose>
            <c:when test="${empty sessionScope.userId}">
              <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                  <img src="${pageContext.request.contextPath}/img/brand/white-button-login.png" width="33" height="33" alt="Login">
                </a>
              </li>
            </c:when>
            <c:otherwise>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  <span class="me-2">${sessionScope.username}</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/update-profile">Profile</a></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/recently-watched">Recently Watched</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </ul>
              </li>
            </c:otherwise>
          </c:choose>
        </ul>
      </div>
    </nav>
  </div>
  <!-- Navbar End -->

  <!-- Display success/error message if any -->
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

  <!-- Search Section Start -->
  <div class="container my-5">
    <div class="row mb-4">
      <div class="col-12">
        <h2 class="text-center mb-4">Find Your Perfect Movie</h2>

        <!-- Advanced Search Form -->
        <div class="card mb-4">
          <div class="card-body">
            <form action="${pageContext.request.contextPath}/search-movie" method="get">
              <div class="row g-3">
                <div class="col-md-6">
                  <label for="searchQuery" class="form-label">Search</label>
                  <input type="text" class="form-control" id="searchQuery" name="searchQuery"
                         value="${searchQuery}" placeholder="Enter title, director, or keyword...">
                </div>

                <div class="col-md-3">
                  <label for="searchType" class="form-label">Search By</label>
                  <select class="form-select" id="searchType" name="searchType">
                    <option value="title" ${searchType == 'title' ? 'selected' : ''}>Title</option>
                    <option value="director" ${searchType == 'director' ? 'selected' : ''}>Director</option>
                    <option value="genre" ${searchType == 'genre' ? 'selected' : ''}>Genre</option>
                  </select>
                </div>

                <div class="col-md-3 d-flex align-items-end">
                  <button type="submit" class="btn custom-search-btn w-100">Search</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Search Results Section -->
    <div class="row mb-3">
      <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
          <h3>
            <c:choose>
              <c:when test="${not empty searchQuery}">
                Search Results for: "${searchQuery}"
              </c:when>
              <c:otherwise>
                All Movies
              </c:otherwise>
            </c:choose>
          </h3>

          <!-- Filter and Sort Options -->
          <div class="dropdown">
            <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="sortDropdown"
                    data-bs-toggle="dropdown" aria-expanded="false">
              Sort By
            </button>
            <ul class="dropdown-menu" aria-labelledby="sortDropdown">
              <li><a class="dropdown-item" href="${currentUrl}&sort=rating-desc">Rating (High to Low)</a></li>
              <li><a class="dropdown-item" href="${currentUrl}&sort=rating-asc">Rating (Low to High)</a></li>
              <li><a class="dropdown-item" href="${currentUrl}&sort=year-desc">Year (New to Old)</a></li>
              <li><a class="dropdown-item" href="${currentUrl}&sort=year-asc">Year (Old to New)</a></li>
              <li><a class="dropdown-item" href="${currentUrl}&sort=title-asc">Title (A-Z)</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <!-- Movies Grid -->
    <div class="row">
      <c:choose>
        <c:when test="${not empty movies}">
          <c:forEach var="movie" items="${movies}">
            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
              <div class="card h-100 movie-card">
                <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}"
                     class="card-img-top" alt="${movie.title}">
                <div class="card-body">
                  <h5 class="card-title">${movie.title}</h5>
                  <p class="card-text"><small>${movie.director} (${movie.releaseYear})</small></p>
                  <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="badge bg-primary">${movie.genre}</span>
                    <span class="badge bg-warning">${movie.rating}/10</span>
                  </div>
                  <c:if test="${not movie.available}">
                    <div class="mb-2">
                      <span class="badge bg-danger">Currently Unavailable</span>
                    </div>
                  </c:if>
                </div>
                <div class="card-footer bg-transparent border-top-0">
                  <a href="${pageContext.request.contextPath}/movie-details?id=${movie.movieId}"
                     class="btn btn-sm btn-outline-primary w-100">More Info</a>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="col-12 text-center py-5">
            <div class="alert alert-info">
              <i class="fas fa-info-circle me-2"></i>
              <c:choose>
                <c:when test="${not empty searchQuery}">
                  No movies found matching "${searchQuery}". Try a different search term.
                </c:when>
                <c:otherwise>
                  No movies available at the moment. Check back later!
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Pagination if needed -->
    <c:if test="${totalPages > 1}">
      <div class="row mt-4">
        <div class="col-12">
          <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
              <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/search-movie?page=${currentPage - 1}${paginationParams}" aria-label="Previous">
                  <span aria-hidden="true">&laquo;</span>
                </a>
              </li>

              <c:forEach begin="1" end="${totalPages}" var="pageNum">
                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                  <a class="page-link" href="${pageContext.request.contextPath}/search-movie?page=${pageNum}${paginationParams}">${pageNum}</a>
                </li>
              </c:forEach>

              <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/search-movie?page=${currentPage + 1}${paginationParams}" aria-label="Next">
                  <span aria-hidden="true">&raquo;</span>
                </a>
              </li>
            </ul>
          </nav>
        </div>
      </div>
    </c:if>
  </div>
  <!-- Search Section End -->

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
</body>
</html>