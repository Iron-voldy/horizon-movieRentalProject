<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Add Movie" />
    <jsp:param name="activePage" value="movies" />
</jsp:include>

<div class="container-fluid">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/movies">Movies</a></li>
            <li class="breadcrumb-item active" aria-current="page">Add Movie</li>
        </ol>
    </nav>

    <h1 class="page-title">
        <i class="fas fa-plus-circle me-2"></i> Add New Movie
    </h1>

    <div class="card">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/movies" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <!-- Basic Info -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="form-group mb-3">
                            <label for="title" class="form-label">Movie Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="director" class="form-label">Director <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="director" name="director" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="genre" class="form-label">Genre <span class="text-danger">*</span></label>
                                    <select class="form-select" id="genre" name="genre" required>
                                        <option value="">Select Genre</option>
                                        <option value="Action">Action</option>
                                        <option value="Adventure">Adventure</option>
                                        <option value="Animation">Animation</option>
                                        <option value="Comedy">Comedy</option>
                                        <option value="Crime">Crime</option>
                                        <option value="Documentary">Documentary</option>
                                        <option value="Drama">Drama</option>
                                        <option value="Family">Family</option>
                                        <option value="Fantasy">Fantasy</option>
                                        <option value="Horror">Horror</option>
                                        <option value="Mystery">Mystery</option>
                                        <option value="Romance">Romance</option>
                                        <option value="Sci-Fi">Sci-Fi</option>
                                        <option value="Thriller">Thriller</option>
                                        <option value="War">War</option>
                                        <option value="Western">Western</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="releaseYear" class="form-label">Release Year <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="releaseYear" name="releaseYear"
                                           min="1900" max="2099" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="rating" class="form-label">Rating (0-10) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="rating" name="rating"
                                           min="0" max="10" step="0.1" required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group mb-3">
                            <label for="coverPhoto" class="form-label">Cover Photo</label>
                            <input type="file" class="form-control" id="coverPhoto" name="coverPhoto"
                                   accept="image/*" onchange="previewImage(this, 'coverPreview')">
                        </div>
                        <div class="text-center mt-3">
                            <img id="coverPreview" src="#" alt="Cover Preview"
                                 class="movie-cover-preview border border-secondary p-1" style="display: none;">
                        </div>
                    </div>
                </div>

                <!-- Movie Type Selection -->
                <div class="form-group mb-3">
                    <label class="form-label">Movie Type <span class="text-danger">*</span></label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="movieType" id="typeRegular"
                               value="regular" checked onchange="toggleMovieTypeFields()">
                        <label class="form-check-label" for="typeRegular">
                            Regular Movie
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="movieType" id="typeNew"
                               value="newRelease" onchange="toggleMovieTypeFields()">
                        <label class="form-check-label" for="typeNew">
                            New Release
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="movieType" id="typeClassic"
                               value="classic" onchange="toggleMovieTypeFields()">
                        <label class="form-check-label" for="typeClassic">
                            Classic Movie
                        </label>
                    </div>
                </div>

                <!-- New Release Fields -->
                <div id="newReleaseFields" class="movie-type-fields mb-3 d-none">
                    <div class="card bg-dark border-primary mb-3">
                        <div class="card-header bg-primary bg-opacity-25 text-primary">
                            <h5 class="mb-0">New Release Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="releaseDate" class="form-label">Release Date</label>
                                <input type="date" class="form-control" id="releaseDate" name="releaseDate">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Classic Movie Fields -->
                <div id="classicFields" class="movie-type-fields mb-3 d-none">
                    <div class="card bg-dark border-warning mb-3">
                        <div class="card-header bg-warning bg-opacity-25 text-warning">
                            <h5 class="mb-0">Classic Movie Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3">
                                <label for="significance" class="form-label">Historical/Cultural Significance</label>
                                <textarea class="form-control" id="significance" name="significance" rows="3"></textarea>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="hasAwards" name="hasAwards">
                                <label class="form-check-label" for="hasAwards">
                                    This movie has won major awards
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="d-flex justify-content-between mt-4">
                    <a href="${pageContext.request.contextPath}/admin/movies" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Save Movie
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function toggleMovieTypeFields() {
        // Hide all movie type specific fields
        document.querySelectorAll('.movie-type-fields').forEach(el => {
            el.classList.add('d-none');
        });

        // Show fields based on selected movie type
        if (document.getElementById('typeNew').checked) {
            document.getElementById('newReleaseFields').classList.remove('d-none');
        } else if (document.getElementById('typeClassic').checked) {
            document.getElementById('classicFields').classList.remove('d-none');
        }
    }
</script>

<jsp:include page="../includes/footer.jsp" />