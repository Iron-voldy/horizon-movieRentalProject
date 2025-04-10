<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Rental Details" />
    <jsp:param name="activePage" value="rentals" />
</jsp:include>

<div class="container-fluid">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/rentals">Rentals</a></li>
            <li class="breadcrumb-item active" aria-current="page">Transaction Details</li>
        </ol>
    </nav>

    <h1 class="page-title">
        <i class="fas fa-info-circle me-2"></i> Rental Transaction Details
    </h1>

    <div class="row">
        <!-- Transaction Info -->
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Transaction Information</h5>
                    <span class="badge
                        <c:choose>
                            <c:when test="${transaction.returned}">bg-success</c:when>
                            <c:when test="${transaction.canceled}">bg-secondary</c:when>
                            <c:when test="${transaction.isOverdue()}">bg-danger</c:when>
                            <c:otherwise>bg-primary</c:otherwise>
                        </c:choose>">
                        <c:choose>
                            <c:when test="${transaction.returned}">Returned</c:when>
                            <c:when test="${transaction.canceled}">Canceled</c:when>
                            <c:when test="${transaction.isOverdue()}">Overdue</c:when>
                            <c:otherwise>Active</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-4 text-secondary">Transaction ID:</div>
                        <div class="col-md-8">${transaction.transactionId}</div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4 text-secondary">Rental Date:</div>
                        <div class="col-md-8"><fmt:formatDate value="${transaction.rentalDate}" pattern="MMMM dd, yyyy" /></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4 text-secondary">Due Date:</div>
                        <div class="col-md-8">
                            <fmt:formatDate value="${transaction.dueDate}" pattern="MMMM dd, yyyy" />
                            <c:if test="${transaction.isActive() && transaction.calculateDaysRemaining() > 0}">
                                <span class="badge bg-info ms-2">${transaction.calculateDaysRemaining()} days remaining</span>
                            </c:if>
                            <c:if test="${transaction.isOverdue()}">
                                <span class="badge bg-danger ms-2">${transaction.calculateDaysOverdue()} days overdue</span>
                            </c:if>
                        </div>
                    </div>
                    <c:if test="${transaction.returned}">
                        <div class="row mb-3">
                            <div class="col-md-4 text-secondary">Return Date:</div>
                            <div class="col-md-8"><fmt:formatDate value="${transaction.returnDate}" pattern="MMMM dd, yyyy" /></div>
                        </div>
                    </c:if>
                    <c:if test="${transaction.canceled}">
                        <div class="row mb-3">
                            <div class="col-md-4 text-secondary">Cancellation Date:</div>
                            <div class="col-md-8"><fmt:formatDate value="${transaction.cancellationDate}" pattern="MMMM dd, yyyy" /></div>
                        </div>
                        <c:if test="${not empty transaction.cancellationReason}">
                            <div class="row mb-3">
                                <div class="col-md-4 text-secondary">Cancellation Reason:</div>
                                <div class="col-md-8">${transaction.cancellationReason}</div>
                            </div>
                        </c:if>
                    </c:if>
                    <div class="row mb-3">
                        <div class="col-md-4 text-secondary">Rental Fee:</div>
                        <div class="col-md-8">$<fmt:formatNumber value="${transaction.rentalFee}" pattern="#,##0.00" /></div>
                    </div>
                    <c:if test="${transaction.lateFee > 0}">
                        <div class="row mb-3">
                            <div class="col-md-4 text-secondary">Late Fee:</div>
                            <div class="col-md-8 text-danger">$<fmt:formatNumber value="${transaction.lateFee}" pattern="#,##0.00" /></div>
                        </div>
                    </c:if>
                    <c:if test="${transaction.lateFee > 0 || transaction.rentalFee > 0}">
                        <div class="row mb-3">
                            <div class="col-md-4 text-secondary">Total:</div>
                            <div class="col-md-8 fw-bold">$<fmt:formatNumber value="${transaction.rentalFee + transaction.lateFee}" pattern="#,##0.00" /></div>
                        </div>
                    </c:if>
                </div>
                <div class="card-footer bg-transparent border-secondary">
                    <div class="d-flex justify-content-between">
                        <c:if test="${!transaction.returned && !transaction.canceled}">
                            <div>
                                <a href="${pageContext.request.contextPath}/admin/rentals?action=return&id=${transaction.transactionId}"
                                   class="btn btn-success me-2">
                                    <i class="fas fa-undo me-1"></i> Mark as Returned
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/rentals?action=cancel&id=${transaction.transactionId}"
                                   class="btn btn-secondary">
                                    <i class="fas fa-ban me-1"></i> Cancel Rental
                                </a>
                            </div>
                        </c:if>
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteTransactionModal">
                            <i class="fas fa-trash-alt me-1"></i> Delete Record
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- User and Movie Info -->
        <div class="col-md-4">
            <!-- User Info -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-user me-2"></i> User Information</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty user}">
                            <div class="text-center mb-3">
                                <div class="avatar bg-primary bg-opacity-10 rounded-circle d-inline-flex align-items-center justify-content-center mb-2"
                                     style="width: 60px; height: 60px;">
                                    <i class="fas fa-user fa-2x text-primary"></i>
                                </div>
                                <h5 class="mb-0">${user.username}</h5>
                                <p class="text-secondary mb-0">${user.email}</p>
                            </div>
                            <hr class="border-secondary">
                            <div class="row mb-2">
                                <div class="col-6 text-secondary">Full Name:</div>
                                <div class="col-6">${user.fullName}</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-6 text-secondary">User Type:</div>
                                <div class="col-6">
                                    <c:choose>
                                        <c:when test="${user['class'].simpleName == 'PremiumUser'}">
                                            <span class="badge bg-warning">Premium</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Regular</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-6 text-secondary">Rental Limit:</div>
                                <div class="col-6">${user.rentalLimit} movies</div>
                            </div>
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.userId}"
                                   class="btn btn-sm btn-primary w-100">
                                    <i class="fas fa-user-edit me-1"></i> View User Profile
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-user-slash fa-3x text-secondary mb-3"></i>
                                <p class="text-secondary">User information not available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Movie Info -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-film me-2"></i> Movie Information</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty movie}">
                            <div class="text-center mb-3">
                                <c:choose>
                                    <c:when test="${not empty movie.coverPhotoPath}">
                                        <img src="${pageContext.request.contextPath}/image-servlet?movieId=${movie.movieId}"
                                             alt="${movie.title}" class="img-fluid rounded mb-2"
                                             style="max-height: 150px;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-secondary rounded d-inline-flex align-items-center justify-content-center mb-2"
                                             style="width: 100px; height: 150px;">
                                            <i class="fas fa-film fa-2x text-dark"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <h5 class="mb-0">${movie.title}</h5>
                                <p class="text-secondary mb-0">${movie.releaseYear}</p>
                            </div>
                            <hr class="border-secondary">
                            <div class="row mb-2">
                                <div class="col-4 text-secondary">Director:</div>
                                <div class="col-8">${movie.director}</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-4 text-secondary">Genre:</div>
                                <div class="col-8">${movie.genre}</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-4 text-secondary">Rating:</div>
                                <div class="col-8">
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
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-4 text-secondary">Type:</div>
                                <div class="col-8">
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
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-4 text-secondary">Status:</div>
                                <div class="col-8">
                                    <c:choose>
                                        <c:when test="${movie.available}">
                                            <span class="badge bg-success">Available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Rented</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/admin/movies?action=edit&id=${movie.movieId}"
                                   class="btn btn-sm btn-primary w-100">
                                    <i class="fas fa-edit me-1"></i> Edit Movie
                                </a>
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
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteTransactionModal" tabindex="-1" aria-labelledby="deleteTransactionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark">
            <div class="modal-header border-secondary">
                <h5 class="modal-title" id="deleteTransactionModalLabel">Confirm Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this transaction record?</p>
                <p class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i> This action cannot be undone.</p>
            </div>
            <div class="modal-footer border-secondary">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <a href="${pageContext.request.contextPath}/admin/rentals?action=delete&id=${transaction.transactionId}"
                   class="btn btn-danger">Delete</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />