<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Moderate Review" />
    <jsp:param name="activePage" value="reviews" />
</jsp:include>

<div class="container-fluid">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/reviews">Reviews</a></li>
            <li class="breadcrumb-item active" aria-current="page">Moderate Review</li>
        </ol>
    </nav>

    <h1 class="page-title">
        <i class="fas fa-edit me-2"></i> Moderate Review
    </h1>

    <div class="row">
        <!-- Edit Review Form -->
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Review Content</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/reviews" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="reviewId" value="${review.reviewId}">

                        <div class="form-group mb-3">
                            <label for="rating" class="form-label">Rating</label>
                            <select class="form-select" id="rating" name="rating" required>
                                <option value="5" ${review.rating == 5 ? 'selected' : ''}>5 Stars</option>
                                <option value="4" ${review.rating == 4 ? 'selected' : ''}>4 Stars</option>
                                <option value="3" ${review.rating == 3 ? 'selected' : ''}>3 Stars</option>
                                <option value="2" ${review.rating == 2 ? 'selected' : ''}>2 Stars</option>
                                <option value="1" ${review.rating == 1 ? 'selected' : ''}>1 Star</option>
                            </select>
                        </div>

                        <div class="form-group mb-3">
                            <label for="comment" class="form-label">Review Comment</label>
                            <textarea class="form-control" id="comment" name="comment" rows="5" required>${review.comment}</textarea>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="${pageContext.request.contextPath}/admin/reviews" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-1"></i> Back to Reviews
                            </a>
                            <div>
                                <button type="button" class="btn btn-danger me-2" data-bs-toggle="modal" data-bs-target="#deleteReviewModal">
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

        <!-- Review Info -->
        <div class="col-md-4">
            <!-- Movie Info -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-film me-2"></i> Movie</h5>
                </div>
                <div class="card-body text-center">
                    <c:choose>
                        <c:when test="${not empty movie}">
                            <c:if test="${not empty movie.coverPhotoPath}">
                                <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}"
                                     alt="${movie.title}" class="img-fluid rounded mb-3" style="max-height: 150px;">
                            </c:if>
                            <h5>${movie.title} (${movie.releaseYear})</h5>
                            <p class="text-secondary mb-1">${movie.director}</p>
                            <p class="mb-0">
                                <span class="badge bg-secondary">${movie.genre}</span>
                                <span class="badge
                                    <c:choose>
                                        <c:when test="${movie['class'].simpleName == 'NewRelease'}">bg-info</c:when>
                                        <c:when test="${movie['class'].simpleName == 'ClassicMovie'}">bg-warning</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>">
                                    <c:choose>
                                        <c:when test="${movie['class'].simpleName == 'NewRelease'}">New Release</c:when>
                                        <c:when test="${movie['class'].simpleName == 'ClassicMovie'}">Classic</c:when>
                                        <c:otherwise>Regular</c:otherwise>
                                    </c:choose>
                                </span>
                            </p>
                            <div class="d-flex align-items-center justify-content-center mt-2">
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
                                <span class="ms-2">${movie.rating}/10</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-film fa-3x text-secondary mb-3"></i>
                                <p class="text-secondary">Movie information not available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Review Details -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i> Review Details</h5>
                </div>
                <div class="card-body">
                    <div class="row mb-2">
                        <div class="col-5 text-secondary">Review ID:</div>
                        <div class="col-7 text-truncate" title="${review.reviewId}">${review.reviewId.substring(0, 8)}...</div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-5 text-secondary">Reviewer:</div>
                        <div class="col-7">
                            <c:choose>
                                <c:when test="${review.userId != null && not empty user}">
                                    ${user.username}
                                </c:when>
                                <c:otherwise>
                                    ${review.userName} <small class="text-muted">(Guest)</small>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-5 text-secondary">Date:</div>
                        <div class="col-7"><fmt:formatDate value="${review.reviewDate}" pattern="MM/dd/yyyy" /></div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-5 text-secondary">Type:</div>
                        <div class="col-7">
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
                        </div>
                    </div>

                    <c:if test="${review['class'].simpleName == 'VerifiedReview'}">
                        <div class="row mb-2">
                            <div class="col-5 text-secondary">Transaction:</div>
                            <div class="col-7 text-truncate" title="${review.transactionId}">
                                <a href="${pageContext.request.contextPath}/admin/rentals?action=view&id=${review.transactionId}">
                                    ${review.transactionId.substring(0, 8)}...
                                </a>
                            </div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-5 text-secondary">Watch Date:</div>
                            <div class="col-7"><fmt:formatDate value="${review.watchDate}" pattern="MM/dd/yyyy" /></div>
                        </div>
                    </c:if>

                    <c:if test="${review['class'].simpleName == 'GuestReview'}">
                        <div class="row mb-2">
                            <div class="col-5 text-secondary">Email:</div>
                            <div class="col-7">${review.emailAddress}</div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-5 text-secondary">IP Address:</div>
                            <div class="col-7">${review.ipAddress}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteReviewModal" tabindex="-1" aria-labelledby="deleteReviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark">
            <div class="modal-header border-secondary">
                <h5 class="modal-title" id="deleteReviewModalLabel">Confirm Deletion</h5>
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

<jsp:include page="../includes/footer.jsp" />