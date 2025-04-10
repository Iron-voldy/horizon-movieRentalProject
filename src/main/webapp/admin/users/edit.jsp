<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Edit User" />
    <jsp:param name="activePage" value="users" />
</jsp:include>

<div class="container-fluid">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/users">Users</a></li>
            <li class="breadcrumb-item active" aria-current="page">Edit User</li>
        </ol>
    </nav>

    <h1 class="page-title">
        <i class="fas fa-user-edit me-2"></i> Edit User: ${user.username}
    </h1>

    <div class="row">
        <!-- User Information Form -->
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">User Information</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/users" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="userId" value="${user.userId}">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username"
                                           value="${user.username}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="${user.email}" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName"
                                   value="${user.fullName}" required>
                        </div>

                        <div class="form-group mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword"
                                   placeholder="Leave blank to keep current password">
                            <small class="form-text text-muted">
                                Enter a new password only if you want to change the current one.
                            </small>
                        </div>

                        <div class="form-group mb-3">
                            <label for="accountType" class="form-label">Account Type <span class="text-danger">*</span></label>
                            <select class="form-select" id="accountType" name="accountType" required>
                                <option value="regular" ${!isPremium ? 'selected' : ''}>Regular</option>
                                <option value="premium" ${isPremium ? 'selected' : ''}>Premium</option>
                            </select>
                        </div>

                        <c:if test="${isPremium}">
                            <div id="premiumFields">
                                <div class="form-group mb-3">
                                    <label for="premiumExpiry" class="form-label">Premium Expiry Date</label>
                                    <input type="date" class="form-control" id="premiumExpiry" name="premiumExpiry"
                                           value="<fmt:formatDate value="${user.subscriptionExpiryDate}" pattern="yyyy-MM-dd" />">
                                </div>

                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="extendSubscription" name="extendSubscription">
                                    <label class="form-check-label" for="extendSubscription">
                                        Extend subscription by 30 days
                                    </label>
                                </div>
                            </div>
                        </c:if>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-1"></i> Back to Users
                            </a>
                            <div>
                                <button type="button" class="btn btn-danger me-2" data-bs-toggle="modal" data-bs-target="#deleteUserModal">
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

        <!-- User Stats and Actions -->
        <div class="col-md-4">
            <!-- User Stats -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> User Statistics</h5>
                </div>
                <div class="card-body">
                    <!-- We would normally fetch these stats from the backend -->
                    <div class="row text-center">
                        <div class="col-6 mb-3">
                            <div class="p-3 rounded bg-primary bg-opacity-10">
                                <div class="fs-4 fw-bold text-primary">0</div>
                                <div class="text-secondary">Active Rentals</div>
                            </div>
                        </div>
                        <div class="col-6 mb-3">
                            <div class="p-3 rounded bg-success bg-opacity-10">
                                <div class="fs-4 fw-bold text-success">0</div>
                                <div class="text-secondary">Completed Rentals</div>
                            </div>
                        </div>
                        <div class="col-6 mb-3">
                            <div class="p-3 rounded bg-warning bg-opacity-10">
                                <div class="fs-4 fw-bold text-warning">0</div>
                                <div class="text-secondary">Reviews</div>
                            </div>
                        </div>
                        <div class="col-6 mb-3">
                            <div class="p-3 rounded bg-info bg-opacity-10">
                                <div class="fs-4 fw-bold text-info">0</div>
                                <div class="text-secondary">Watchlist Items</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-bolt me-2"></i> Quick Actions</h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/admin/rentals?filter=all&userId=${user.userId}" class="btn btn-outline-primary">
                            <i class="fas fa-list me-1"></i> View Rental History
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/reviews?userId=${user.userId}" class="btn btn-outline-primary">
                            <i class="fas fa-star me-1"></i> View Reviews
                        </a>
                        <c:if test="${!isPremium}">
                            <a href="${pageContext.request.contextPath}/admin/users?action=upgrade&id=${user.userId}"
                               class="btn btn-warning" onclick="return confirm('Are you sure you want to upgrade this user to Premium?')">
                                <i class="fas fa-arrow-circle-up me-1"></i> Upgrade to Premium
                            </a>
                        </c:if>
                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#resetPasswordModal">
                            <i class="fas fa-key me-1"></i> Reset Password
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete User Modal -->
<div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark">
            <div class="modal-header border-secondary">
                <h5 class="modal-title" id="deleteUserModalLabel">Confirm Deletion</h5>
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

<!-- Reset Password Modal -->
<div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-labelledby="resetPasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark">
            <div class="modal-header border-secondary">
                <h5 class="modal-title" id="resetPasswordModalLabel">Reset Password</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to reset the password for "<strong>${user.username}</strong>"?</p>
                <p>A temporary password will be generated.</p>
                <form id="resetPasswordForm" action="${pageContext.request.contextPath}/admin/users" method="post">
                    <input type="hidden" name="action" value="resetPassword">
                    <input type="hidden" name="userId" value="${user.userId}">
                    <div class="form-group">
                        <label for="tempPassword" class="form-label">Temporary Password</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="tempPassword" name="tempPassword"
                                   value="Pass${System.currentTimeMillis() % 10000}" readonly>
                            <button class="btn btn-outline-secondary" type="button" onclick="generatePassword()">
                                <i class="fas fa-sync-alt"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-secondary">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" form="resetPasswordForm" class="btn btn-primary">Reset Password</button>
            </div>
        </div>
    </div>
</div>

<script>
    function generatePassword() {
        // Generate a random password
        const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        let password = "";
        for (let i = 0; i < 10; i++) {
            password += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        document.getElementById("tempPassword").value = password;
    }

    // Show/hide premium fields based on account type selection
    document.addEventListener('DOMContentLoaded', function() {
        const accountTypeSelect = document.getElementById('accountType');
        const premiumFields = document.getElementById('premiumFields');

        if (accountTypeSelect && premiumFields) {
            accountTypeSelect.addEventListener('change', function() {
                if (this.value === 'premium') {
                    premiumFields.classList.remove('d-none');
                } else {
                    premiumFields.classList.add('d-none');
                }
            });
        }
    });
</script>

<jsp:include page="../includes/footer.jsp" />