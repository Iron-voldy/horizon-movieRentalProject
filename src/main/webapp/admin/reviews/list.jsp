<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Reviews" />
    <jsp:param name="activePage" value="reviews" />
</jsp:include>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title">
            <i class="fas fa-star me-2"></i> Movie Reviews
        </h1>
    </div>

    <!-- Filter and Search -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/reviews" class="row g-3">
                <div class="col-md-4">
                    <label for="searchQuery" class="form-label">Search</label>
                    <input type="text" class="form-control" id="searchQuery" name="searchQuery"
                           placeholder="Search by movie, user, or comment" value="${param.searchQuery}">
                </div>
                <div class="col-md-3">
                    <label for="reviewType" class="form-label">Review Type</label>
                    <select class="form-select" id="reviewType" name="reviewType">
                        <option value="">All Reviews</option>
                        <option value="verified" ${param.reviewType == 'verified' ? 'selected' : ''}>Verified Reviews</option>
                        <option value="guest" ${param.reviewType == 'guest' ? 'selected' : ''}>Guest Reviews</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="ratingFilter" class="form-label">Rating</label>
                    <select class="form-select" id="ratingFilter" name="ratingFilter">
                        <option value="">All Ratings</option>
                        <option value="5" ${param.ratingFilter == '5' ? 'selected' : ''}>5 Stars</option>
                        <option value="4" ${param.ratingFilter == '4' ? 'selected' : ''}>4 Stars</option>
                        <option value="3" ${param.ratingFilter == '3' ? 'selected' : ''}>3 Stars</option>
                        <option value="2" ${param.ratingFilter == '2' ? 'selected' : ''}>2 Stars</option>
                        <option value="1" ${param.ratingFilter == '1' ? 'selected' : ''}>1 Star</option>
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

    <!-- Reviews List -->
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Movie</th>
                            <th>User/Guest</th>
                            <th>Rating</th>
                            <th>Comment</th>
                            <th>Date</th>
                            <th>Type</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="review" items="${reviews}">
                            <tr>
                                <td>
                                    <span class="text-secondary">#</span>${review.reviewId.substring(0, 8)}...
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty movieMap[review.movieId]}">
                                            <div class="d-flex align-items-center">
                                                <c:if test="${not empty movieMap[review.movieId].coverPhotoPath}">
                                                    <img src="${pageContext.request.contextPath}/image-servlet?movieId=${review.movieId}"
                                                         alt="${movieMap[review.movieId].title}" class="me-2"
                                                         style="width: 30px; height: 45px; object-fit: cover;">
                                                </c:if>
                                                <span>${movieMap[review.movieId].title}</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>Unknown Movie</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${review.userId != null && not empty userMap[review.userId]}">
                                            <div class="d-flex align-items-center">
                                                <div class="avatar bg-primary bg-opacity-10 rounded-circle me-2"
                                                     style="width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;">
                                                    <i class="fas fa-user text-primary"></i>
                                                </div>
                                                <span>${userMap[review.userId].username}</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar bg-secondary bg-opacity-10 rounded-circle me-2"
                                                     style="width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;">
                                                    <i class="fas fa-user-alt text-secondary"></i>
                                                </div>
                                                <span>${review.userName} <small class="text-muted">(Guest)</small></span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="text-warning">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= review.rating}"><i class="fas fa-star"></i></c:when>
                                                <c:otherwise><i class="far fa-star"></i></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                </td>
                                <td>
                                    <div style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        ${review.comment}
                                    </div>
                                </td>
                                <td><fmt:formatDate value="${review.reviewDate}" pattern="MM/dd/yyyy" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${review.isVerified()}">
                                            <span class="badge bg-success">Verified</span>
                                        </c:when>
                                        <c:when test="${review['class'].simpleName == 'GuestReview'}">
                                            <span class="badge bg-secondary">Guest</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-primary">Regular</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-primary dropdown-toggle" type="button"
                                                id="dropdownMenuButton${review.reviewId}"
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                            Actions
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton${review.reviewId}">
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reviews?action=moderate&id=${review.reviewId}">
                                                    <i class="fas fa-edit me-2"></i> Moderate
                                                </a>
                                            </li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <a class="dropdown-item text-danger" href="#"
                                                   data-bs-toggle="modal" data-bs-target="#deleteModal${review.reviewId}">
                                                    <i class="fas fa-trash-alt me-2"></i> Delete
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Delete Confirmation Modal -->
                                    <div class="modal fade" id="deleteModal${review.reviewId}" tabindex="-1"
                                         aria-labelledby="deleteModalLabel${review.reviewId}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content bg-dark">
                                                <div class="modal-header border-secondary">
                                                    <h5 class="modal-title" id="deleteModalLabel${review.reviewId}">Confirm Deletion</h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <p>Are you sure you want to delete this review?</p>
                                                    <p class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i> This action cannot be undone.</p>
                                                </div>
                                                <div class="modal-footer border-secondary">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                    <a href="${pageContext.request.contextPath}/admin/reviews?action=delete&id=${review.reviewId}"
                                                       class="btn btn-danger">Delete</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty reviews}">
                            <tr>
                                <td colspan="8" class="text-center py-4">
                                    <i class="fas fa-star fa-3x mb-3 text-secondary"></i>
                                    <p class="mb-0 text-secondary">No reviews found</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${not empty reviews && reviews.size() > 25}">
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