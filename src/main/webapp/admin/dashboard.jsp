<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard" />
    <jsp:param name="activePage" value="dashboard" />
</jsp:include>

<div class="container-fluid">
    <h1 class="page-title">
        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
    </h1>

    <!-- Stats Cards -->
    <div class="row dashboard-section">
        <div class="col-md-3 mb-4">
            <div class="card stats-card movies-card">
                <div class="icon text-primary">
                    <i class="fas fa-film"></i>
                </div>
                <div class="number">${totalMovies}</div>
                <div class="label">Total Movies</div>
                <div class="mt-2">
                    <span class="badge bg-success">
                        ${availableMovies} Available
                    </span>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-4">
            <div class="card stats-card users-card">
                <div class="icon text-success">
                    <i class="fas fa-users"></i>
                </div>
                <div class="number">${totalUsers}</div>
                <div class="label">Registered Users</div>
            </div>
        </div>

        <div class="col-md-3 mb-4">
            <div class="card stats-card rentals-card">
                <div class="icon text-warning">
                    <i class="fas fa-exchange-alt"></i>
                </div>
                <div class="number">${activeRentals}</div>
                <div class="label">Active Rentals</div>
                <div class="mt-2">
                    <span class="badge bg-danger">
                        ${overdueRentals} Overdue
                    </span>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-4">
            <div class="card stats-card reviews-card">
                <div class="icon text-info">
                    <i class="fas fa-star"></i>
                </div>
                <div class="number">${totalReviews}</div>
                <div class="label">Total Reviews</div>
            </div>
        </div>
    </div>

    <!-- Recent Rentals Section -->
    <div class="dashboard-section">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-history me-2"></i> Recent Transactions</h5>
                <a href="${pageContext.request.contextPath}/admin/rentals" class="btn btn-sm btn-primary">
                    <i class="fas fa-eye me-1"></i> View All
                </a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Movie</th>
                                <th>Date</th>
                                <th>Due Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="transaction" items="${recentTransactions}" varStatus="loop">
                                <c:if test="${loop.index < 10}">
                                    <tr>
                                        <td>${transaction.transactionId.substring(0, 8)}...</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty userMap[transaction.userId]}">
                                                    ${userMap[transaction.userId].username}
                                                </c:when>
                                                <c:otherwise>Unknown User</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty movieMap[transaction.movieId]}">
                                                    ${movieMap[transaction.movieId].title}
                                                </c:when>
                                                <c:otherwise>Unknown Movie</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatDate value="${transaction.rentalDate}" pattern="MM/dd/yyyy" /></td>
                                        <td><fmt:formatDate value="${transaction.dueDate}" pattern="MM/dd/yyyy" /></td>
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
                                            <a href="${pageContext.request.contextPath}/admin/rentals?action=view&id=${transaction.transactionId}"
                                               class="btn btn-sm btn-primary me-1" data-bs-toggle="tooltip" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty recentTransactions}">
                                <tr>
                                    <td colspan="7" class="text-center py-3">No transactions found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Links Section -->
    <div class="dashboard-section">
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-bolt me-2"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/admin/movies?action=add" class="btn btn-primary">
                                <i class="fas fa-plus-circle me-2"></i> Add New Movie
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                                <i class="fas fa-user-friends me-2"></i> Manage Users
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/rentals?filter=overdue" class="btn btn-danger">
                                <i class="fas fa-exclamation-triangle me-2"></i> View Overdue Rentals
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/reviews" class="btn btn-primary">
                                <i class="fas fa-star me-2"></i> Moderate Reviews
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i> System Statistics</h5>
                    </div>
                    <div class="card-body">
                        <ul class="list-group list-group-flush bg-transparent">
                            <li class="list-group-item d-flex justify-content-between align-items-center bg-transparent border-bottom border-secondary">
                                <span><i class="fas fa-film me-2"></i> Available Movies</span>
                                <span class="badge bg-success rounded-pill">${availableMovies} / ${totalMovies}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center bg-transparent border-bottom border-secondary">
                                <span><i class="fas fa-exchange-alt me-2"></i> Total Transactions</span>
                                <span class="badge bg-primary rounded-pill">${totalRentals}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center bg-transparent border-bottom border-secondary">
                                <span><i class="fas fa-clock me-2"></i> Active Rentals</span>
                                <span class="badge bg-primary rounded-pill">${activeRentals}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center bg-transparent">
                                <span><i class="fas fa-exclamation-circle me-2"></i> Overdue Rentals</span>
                                <span class="badge bg-danger rounded-pill">${overdueRentals}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />