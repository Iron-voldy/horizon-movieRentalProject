<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Edit Movie" />
    <jsp:param name="activePage" value="movies" />
</jsp:include>

<div class="container-fluid">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/movies">Movies</a></li>
            <li class="breadcrumb-item active" aria-current="page">Edit Movie</li>
        </ol>
    </nav>

    <h1 class="page-title">
        <i class="fas fa-edit me-2"></i> Edit Movie: ${movie.title}
    </h1>

    <div class="card">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/movies" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="movieId" value="${movie.movieId}">
                <input type="hidden" name="movieType" value="${movieType}">

                <!-- Basic Info -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="form-group mb-3">
                            <label for="title" class="form-label">Movie Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" value="${movie.title}" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="director" class="form-label">Director <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="director" name="director" value="${movie.director}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="genre" class="form-label">Genre <span class="text-danger">*</span></label>
                                    <select class="form-select" id="genre" name="genre" required>
                                        <option value="">Select Genre</option>
                                        <option value="Action" ${movie.genre == 'Action' ? 'selected' : ''}>Action</option>
                                        <option value="Adventure" ${movie.genre == 'Adventure' ? 'selected' : ''}>Adventure</option>
                                        <option value="Animation" ${movie.genre == 'Animation' ? 'selected' : ''}>Animation</option>
                                        <option value="Comedy" ${movie.genre == 'Comedy' ? 'selected' : ''}>Comedy</option>
                                        <option value="Crime" ${movie.genre == 'Crime' ? 'selected' : ''}>Crime</option>
                                        <option value="Documentary" ${movie.genre == 'Documentary' ? 'selected' : ''}>Documentary</option>
                                        <option value="Drama" ${movie.genre == 'Drama' ? 'selected' : ''}>Drama</option>
                                        <option value="Family" ${movie.genre == 'Family' ? 'selected' : ''}>Family</option>
                                        <option value="Fantasy" ${movie.genre == 'Fantasy' ? 'selected' : ''}>Fantasy</option>
                                        <option value="Horror" ${movie.genre == 'Horror' ? 'selected' : ''}>Horror</option>
                                        <option value="Mystery" ${movie.genre == 'Mystery' ? 'selected' : ''}>Mystery</option>
                                        <option value="Romance" ${movie.genre == 'Romance' ? 'selected' : ''}>Romance</option>
                                        <option value="Sci-Fi" ${movie.genre == 'Sci-Fi' ? 'selected' : ''}>Sci-Fi</option>
                                        <option value="Thriller" ${movie.genre == 'Thriller' ? 'selected' : ''}>Thriller</option>
                                        <option value="War" ${movie.genre == 'War' ? 'selected' : ''}>War</option>
                                        <option value="Western" ${movie.genre == 'Western' ? 'selected' : ''}>Western</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="releaseYear" class="form-label">Release Year <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="releaseYear" name="releaseYear"
                                           min="1900" max="2099" value="${movie.releaseYear}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="rating" class="form-label">Rating (0-10) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="rating" name="rating"
                                           min="0" max="10" step="0.1" value="${movie.rating}" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="available" name="available"
                                       ${movie.available ? 'checked' : ''}>
                                <label class="form-check-label" for="available">
                                    Available for rental
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group mb-3">
                            <label for="coverPhoto" class="form-label">Cover Photo</label>
                            <input type="file" class="form-control" id="coverPhoto" name="coverPhoto"
                                   accept="image/*" onchange="previewImage(this, 'coverPreview')">
                            <small class="form-text text-muted">Leave empty to keep current cover</small>
                        </div>
                        <div class="text-center mt-3">
                            <c:choose>
                                <c:when test="${not empty movie.coverPhotoPath}">
                                    <img id="coverPreview"
                                         src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}"
                                         alt="${movie.title}" class="movie-cover-preview border border-secondary p-1">
                                </c:when>
                                <c:otherwise>
                                    <img id="coverPreview" src="#" alt="Cover Preview"
                                         class="movie-cover-preview border border-secondary p-1" style="display: none;">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Movie Type Specific Fields -->
                <c:choose>
                    <c:when test="${movieType == 'newRelease'}">
                        <!-- New Release Fields -->
                        <div class="card bg-dark border-primary mb-3">
                            <div class="card-header bg-primary bg-opacity-25 text-primary">
                                <h5 class="mb-0">New Release Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="form-group">
                                    <label for="releaseDate" class="form-label">Release Date</label>
                                    <input type="date" class="form-control" id="releaseDate" name="releaseDate"
                                           value="<fmt:formatDate value="${movie.releaseDate}" pattern="yyyy-MM-dd" />">
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:when test="${movieType == 'classic'}">
                        <!-- Classic Movie Fields -->
                        <div class="card bg-dark border-warning mb-3">
                            <div class="card-header bg-warning bg-opacity-25 text-warning">
                                <h5 class="mb-0">Classic Movie Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="form-group mb-3">
                                    <label for="significance" class="form-label">Historical/Cultural Significance</label>
                                    <textarea class="form-control" id="significance" name="significance" rows="3">${movie.significance}</textarea>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="hasAwards" name="hasAwards"
                                           ${movie.hasAwards() ? 'checked' : ''}>
                                    <label class="form-check-label" for="hasAwards">
                                        This movie has won major awards
                                    </label>
                                </div>
                            </div>
                        </div>
                    </c:when>
                </c:choose>

                <!-- Submit Button -->
                <div class="d-flex justify-content-between mt-4">
                    <a href="${pageContext.request.contextPath}/admin/movies" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Cancel
                    </a>
                    <div>
                        <button type="button" class="btn btn-danger me-2" data-bs-toggle="modal" data-bs-target="#deleteModal">
                            <i class="fas fa-trash-alt me-1"></i> Delete
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i> Save Changes
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark">
            <div class="modal-header border-secondary">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
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

<jsp:include page="../includes/footer.jsp" />