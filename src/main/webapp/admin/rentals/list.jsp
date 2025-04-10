<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Rentals" />
    <jsp:param name="activePage" value="rentals" />
</jsp:include>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title">
            <i class="fas fa-exchange-alt me-2"></i> Rental Transactions
        </h1>
    </div>

    <!-- Filter Buttons -->
    <div class="mb-4">
        <div class="btn-group" role="group">
            <a href="${pageContext.request.contextPath}/admin/rentals?filter=all"
               class="btn ${filter == 'all' || empty filter ? 'btn-primary' : 'btn-outline-primary'}">
                All Transactions
            </a>
            <a href="${pageContext.request.contextPath}/admin/rentals?filter=active"
               class="btn ${filter == 'active' ? 'btn-primary' : 'btn-outline-primary'}">
                Active Rentals
            </a>
            <a href="${pageContext.request.contextPath}/admin/rentals?filter=returned"
               class="btn ${filter == 'returned' ? 'btn-primary' : 'btn-outline-primary'}">
                Returned
            </a>
            <a href="${pageContext.request.contextPath}/admin/rentals?filter=canceled"
               class="btn ${filter == 'canceled' ? 'btn-primary' : 'btn-outline-primary'}">
                Canceled
            </a>
            <a href="${pageContext.request.contextPath}/admin/rentals?filter=overdue"
               class="btn ${filter == 'overdue' ? 'btn-danger' : 'btn-outline-danger'}">
                <i class="fas fa-exclamation-circle me-1"></i> Overdue
            </a>
        </div>
    </div>

    <!-- Search Form -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/rentals" class="row g-3">
                <input type="hidden" name="filter" value="${filter}">
                <div class="col-md-4">
                    <label for="searchQuery" class="form-label">Search</label>
                    <input type="text" class="form-control" id="searchQuery" name="searchQuery"
                           placeholder="Search by user or movie" value="${param.searchQuery}">
                </div>
                <div class="col-md-3">
                    <label for="dateType" class="form-label">Date Type</label>
                    <select class="form-select" id="dateType" name="dateType">
                        <option value="rental" ${param.dateType == 'rental' ? 'selected' : ''}>Rental Date</option>
                        <option value="due" ${param.dateType == 'due' ? 'selected' : ''}>Due Date</option>
                        <option value="return" ${param.dateType == 'return' ? 'selected' : ''}>Return Date</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="searchDate" class="form-label">Date</label>
                    <input type="date" class="form-control" id="searchDate" name="searchDate"
                           value="${param.searchDate}">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-1"></i> Search
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Transactions Table -->
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User</th>
                            <th>Movie</th>
                            <th>Rental Date</th>
                            <th>Due Date</th>
                            <th>Return Date</th>
                            <th>Rental Fee</th>
                            <th>Late Fee</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="transaction" items="${transactions}">
                            <tr>
                                <td>
                                    <span class="text-secondary">#</span>${transaction.transactionId.substring(0, 8)}...
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty userMap[transaction.userId]}">
                                            <div class="d-flex align-items-center">
                                                <div class="avatar bg-primary bg-opacity-10 rounded-circle me-2"
                                                     style="width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;">
                                                    <i class="fas fa-user text-primary"></i>
                                                </div>
                                                <div>
                                                    <span>${userMap[transaction.userId].username}</span>
                                                    <div class="small text-secondary">${userMap[transaction.userId].email}</div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>Unknown User</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty movieMap[transaction.movieId]}">
                                            <div class="d-flex align-items-center">
                                                <c:if test="${not empty movieMap[transaction.movieId].coverPhotoPath}">
                                                    <img src="${pageContext.request.contextPath}/image-servlet?movieId=${transaction.movieId}"
                                                         alt="${movieMap[transaction.movieId].title}" class="me-2"
                                                         style="width: 30px; height: 45px; object-fit: cover;">
                                                </c:if>
                                                <span>${movieMap[transaction.movieId].title}</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>Unknown Movie</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${transaction.rentalDate}" pattern="MM/dd/yyyy" /></td>
                                <td><fmt:formatDate value="${transaction.dueDate}" pattern="MM/dd/yyyy" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${transaction.returned}">
                                            <fmt:formatDate value="${transaction.returnDate}" pattern="MM/dd/yyyy" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>$<fmt:formatNumber value="${transaction.rentalFee}" pattern="#,##0.00" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${transaction.lateFee > 0}">
                                            <span class="text-danger">$<fmt:formatNumber value="${transaction.lateFee}" pattern="#,##0.00" /></span>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${transaction.returned}">
                                            <span class="badge bg-success">Returned</span>
                                        </c:when>
                                        <c:when test="${transaction.canceled}">
                                            <span class="badge bg-secondary">Canceled</span>
                                        </c:when>
                                        <c:when test="${transaction.isOverdue()}">
                                            <span class="badge bg-danger">Overdue</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-primary">Active</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-primary dropdown-toggle" type="button"
                                                id="dropdownMenuButton${transaction.transactionId}"
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                            Actions
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton${transaction.transactionId}">
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/rentals?action=view&id=${transaction.transactionId}">
                                                    <i class="fas fa-eye me-2"></i> View Details
                                                </a>
                                            </li>
                                            <c:if test="${!transaction.returned && !transaction.canceled}">
                                                <li>
                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/rentals?action=return&id=${transaction.transactionId}">
                                                        <i class="fas fa-undo me-2"></i> Mark as Returned
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/rentals?action=cancel&id=${transaction.transactionId}">
                                                        <i class="fas fa-ban me-2"></i> Cancel Rental
                                                    </a>
                                                </li>
                                            </c:if>
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <a class="dropdown-item text-danger" href="#"
                                                   data-bs-toggle="modal" data-bs-target="#deleteModal${transaction.transactionId}">
                                                    <i class="fas fa-trash-alt me-2"></i> Delete Record
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Delete Confirmation Modal -->
                                    <div class="modal fade" id="deleteModal${transaction.transactionId}" tabindex="-1"
                                         aria-labelledby="deleteModalLabel${transaction.transactionId}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content bg-dark">
                                                <div class="modal-header border-secondary">
                                                    <h5 class="modal-title" id="deleteModalLabel${transaction.transactionId}">Confirm Deletion</h5>
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
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty transactions}">
                            <tr>
                                <td colspan="10" class="text-center py-4">
                                    <i class="fas fa-exchange-alt fa-3x mb-3 text-secondary"></i>
                                    <p class="mb-0 text-secondary">No transactions found</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${not empty transactions && transactions.size() > 25}">
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