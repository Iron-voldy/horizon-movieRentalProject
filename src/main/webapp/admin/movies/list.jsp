<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Movies" />
    <jsp:param name="activePage" value="movies" />
</jsp:include>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title">
            <i class="fas fa-film me-2"></i> Movies
        </h1>
        <a href="${pageContext.request.contextPath}/admin/movies?action=add" class="btn btn-primary">
            <i class="fas fa-plus-circle me-1"></i> Add New Movie
        </a>
    </div>

    <!-- Search and Filter Form -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/movies" class="row g-3">
                <div class="col-md-4">
                    <label for="searchQuery" class="form-label">Search</label>
                    <input type="text" class="form-control" id="searchQuery" name="searchQuery"
                           placeholder="Search by title, director, etc." value="${param.searchQuery}">
                </div>
                <div class="col-md-3">
                    <label for="genreFilter" class="form-label">Genre</label>
                    <select class="form-select" id="genreFilter" name="genreFilter">
                        <option value="">All Genres</option>
                        <option value="Action" ${param.genreFilter == 'Action' ? 'selected' : ''}>Action</option>
                        <option value="Comedy" ${param.genreFilter == 'Comedy' ? 'selected' : ''}>Comedy</option>
                        <option value="Drama" ${param.genreFilter == 'Drama' ? 'selected' : ''}>Drama</option>
                        <option value="Horror" ${param.genreFilter == 'Horror' ? 'selected' : ''}>Horror</option>
                        <option value="Sci-Fi" ${param.genreFilter == 'Sci-Fi' ? 'selected' : ''}>Sci-Fi</option>
                        <option value="Thriller" ${param.genreFilter == 'Thriller' ? 'selected' : ''}>Thriller</option>
                        <option value="Romance" ${param.genreFilter == 'Romance' ? 'selected' : ''}>Romance</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="movieType" class="form-label">Movie Type</label>
                    <select class="form-select" id="movieType" name="movieType">
                        <option value="">All Types</option>
                        <option value="regular" ${param.movieType == 'regular' ? 'selected' : ''}>Regular</option>
                        <option value="newRelease" ${param.movieType == 'newRelease' ? 'selected' : ''}>New Release</option>
                        <option value="classic" ${param.movieType == 'classic' ? 'selected' : ''}>Classic</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-1"></i> Search
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Movies List Table -->
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th width="70">Cover</th>
                            <th>Title</th>
                            <th>Director</th>
                            <th>Genre</th>
                            <th>Year</th>
                            <th>Rating</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="movie" items="${movies}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty movie.coverPhotoPath}">
                                            <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}"
                                                 alt="${movie.title}" class="movie-cover-thumbnail">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="movie-cover-thumbnail bg-secondary d-flex align-items-center justify-content-center">
                                                <i class="fas fa-film text-dark"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${movie.title}</td>
                                <td>${movie.director}</td>
                                <td>${movie.genre}</td>
                                <td>${movie.releaseYear}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <span class="me-2">${movie.rating}</span>
                                        <div class="text-warning">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= movie.rating}">
                                                        <i class="fas fa-star"></i>
                                                    </c:when>
                                                    <c:when test="${i > movie.rating && i <= movie.rating + 0.5}">
                                                        <i class="fas fa-star-half-alt"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${movie['class'].simpleName == 'NewRelease'}">
                                            <span class="badge bg-info">New Release</span>
                                        </c:when>
                                        <c:when test="${movie['class'].simpleName == 'ClassicMovie'}">
                                            <span class="badge bg-warning">Classic</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Regular</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${movie.available}">
                                            <span class="badge bg-success">Available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Rented</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/admin/movies?action=edit&id=${movie.movieId}"
                                           class="btn btn-sm btn-primary" data-bs-toggle="tooltip" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button type="button" class="btn btn-sm btn-danger"
                                                data-bs-toggle="modal" data-bs-target="#deleteModal${movie.movieId}"
                                                title="Delete">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>

                                    <!-- Delete Confirmation Modal -->
                                    <div class="modal fade" id="deleteModal${movie.movieId}" tabindex="-1"
                                         aria-labelledby="deleteModalLabel${movie.movieId}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content bg-dark">
                                                <div class="modal-header border-secondary">
                                                    <h5 class="modal-title" id="deleteModalLabel${movie.movieId}">Confirm Deletion</h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <p>Are you sure you want to delete the movie "<strong>${movie.title}</strong>"?</p>
                                                    <p class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i> This action cannot be undone.</p>
                                                </div>
                                                <div class="modal-footer border-secondary">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                    <a href="${pageContext.request.contextPath}/admin/movies?action=delete&id=${movie.movieId}"
                                                       class="btn btn-danger">Delete</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty movies}">
                            <tr>
                                <td colspan="9" class="text-center py-4">
                                    <i class="fas fa-film fa-3x mb-3 text-secondary"></i>
                                    <p class="mb-0 text-secondary">No movies found</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${not empty movies && movies.size() > 20}">
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item disabled">
                    <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Previous</a>
                </li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item">
                    <a class="page-link" href="#">Next</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<jsp:include page="../includes/footer.jsp" />