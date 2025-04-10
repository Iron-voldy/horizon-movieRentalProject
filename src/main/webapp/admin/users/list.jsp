<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Users" />
    <jsp:param name="activePage" value="users" />
</jsp:include>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title">
            <i class="fas fa-users me-2"></i> User Management
        </h1>
    </div>

    <!-- Search and Filter -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/users" class="row g-3">
                <div class="col-md-4">
                    <label for="searchQuery" class="form-label">Search</label>
                    <input type="text" class="form-control" id="searchQuery" name="searchQuery"
                           placeholder="Search by username, email, or name" value="${param.searchQuery}">
                </div>
                <div class="col-md-3">
                    <label for="userType" class="form-label">User Type</label>
                    <select class="form-select" id="userType" name="userType">
                        <option value="">All Types</option>
                        <option value="regular" ${param.userType == 'regular' ? 'selected' : ''}>Regular</option>
                        <option value="premium" ${param.userType == 'premium' ? 'selected' : ''}>Premium</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="sortBy" class="form-label">Sort By</label>
                    <select class="form-select" id="sortBy" name="sortBy">
                        <option value="username" ${param.sortBy == 'username' ? 'selected' : ''}>Username</option>
                        <option value="email" ${param.sortBy == 'email' ? 'selected' : ''}>Email</option>
                        <option value="fullName" ${param.sortBy == 'fullName' ? 'selected' : ''}>Full Name</option>
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

    <!-- Users Table -->
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Full Name</th>
                            <th>Type</th>
                            <th>Rental Limit</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar
                                            ${user['class'].simpleName == 'PremiumUser' ? 'bg-warning' : 'bg-primary'}
                                            bg-opacity-10 rounded-circle me-2"
                                             style="width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-user
                                                ${user['class'].simpleName == 'PremiumUser' ? 'text-warning' : 'text-primary'}"></i>
                                        </div>
                                        ${user.username}
                                    </div>
                                </td>
                                <td>${user.email}</td>
                                <td>${user.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user['class'].simpleName == 'PremiumUser'}">
                                            <span class="badge bg-warning">Premium</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Regular</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${user.rentalLimit} movies</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user['class'].simpleName == 'PremiumUser' && user.subscriptionActive}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:when test="${user['class'].simpleName == 'PremiumUser' && !user.subscriptionActive}">
                                            <span class="badge bg-danger">Expired</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success">Active</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-primary dropdown-toggle" type="button"
                                                id="dropdownMenuButton${user.userId}"
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                            Actions
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton${user.userId}">
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.userId}">
                                                    <i class="fas fa-user-edit me-2"></i> Edit User
                                                </a>
                                            </li>
                                            <c:if test="${user['class'].simpleName != 'PremiumUser'}">
                                                <li>
                                                    <a class="dropdown-item" href="#"
                                                       data-bs-toggle="modal" data-bs-target="#upgradeModal${user.userId}">
                                                        <i class="fas fa-arrow-circle-up me-2"></i> Upgrade to Premium
                                                    </a>
                                                </li>
                                            </c:if>
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <a class="dropdown-item text-danger" href="#"
                                                   data-bs-toggle="modal" data-bs-target="#deleteModal${user.userId}">
                                                    <i class="fas fa-trash-alt me-2"></i> Delete User
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Delete User Modal -->
                                    <div class="modal fade" id="deleteModal${user.userId}" tabindex="-1"
                                         aria-labelledby="deleteModalLabel${user.userId}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content bg-dark">
                                                <div class="modal-header border-secondary">
                                                    <h5 class="modal-title" id="deleteModalLabel${user.userId}">Confirm Deletion</h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <p>Are you sure you want to delete the user "<strong>${user.username}</strong>"?</p>
                                                    <p class="text-danger">
                                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                                        This will remove all user data including rentals, reviews, and watchlists.
                                                    </p>
                                                </div>
                                                <div class="modal-footer border-secondary">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                    <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=${user.userId}"
                                                       class="btn btn-danger">Delete</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Upgrade User Modal -->
                                    <c:if test="${user['class'].simpleName != 'PremiumUser'}">
                                        <div class="modal fade" id="upgradeModal${user.userId}" tabindex="-1"
                                             aria-labelledby="upgradeModalLabel${user.userId}" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content bg-dark">
                                                    <div class="modal-header border-secondary">
                                                        <h5 class="modal-title" id="upgradeModalLabel${user.userId}">Upgrade to Premium</h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p>Are you sure you want to upgrade user "<strong>${user.username}</strong>" to Premium?</p>
                                                        <p>Premium benefits include:</p>
                                                        <ul>
                                                            <li>Increased rental limit (10 movies)</li>
                                                            <li>20% discount on rental fees</li>
                                                            <li>Lower late fees</li>
                                                        </ul>
                                                    </div>
                                                    <div class="modal-footer border-secondary">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                        <a href="${pageContext.request.contextPath}/admin/users?action=upgrade&id=${user.userId}"
                                                           class="btn btn-warning">Upgrade</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="7" class="text-center py-4">
                                    <i class="fas fa-users fa-3x mb-3 text-secondary"></i>
                                    <p class="mb-0 text-secondary">No users found</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${not empty users && users.size() > 25}">
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