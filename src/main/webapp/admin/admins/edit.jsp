<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Edit Admin" />
    <jsp:param name="activePage" value="admins" />
</jsp:include>

<div class="container-fluid">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/manage-admins">Admin Management</a></li>
            <li class="breadcrumb-item active" aria-current="page">Edit Admin</li>
        </ol>
    </nav>

    <h1 class="page-title">
        <i class="fas fa-user-edit me-2"></i> Edit Admin: ${editAdmin.username}
    </h1>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Admin Information</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/manage-admins" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="adminId" value="${editAdmin.adminId}">

                        <c:if test="${editAdmin.adminId eq sessionScope.adminId}">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                You are editing your own account. Changes will affect your current session.
                            </div>
                        </c:if>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username"
                                           value="${editAdmin.username}" required>
                                    <div class="invalid-feedback">Please enter a username.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="${editAdmin.email}" required>
                                    <div class="invalid-feedback">Please enter a valid email address.</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName"
                                   value="${editAdmin.fullName}" required>
                            <div class="invalid-feedback">Please enter the full name.</div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="newPassword" name="newPassword">
                                        <button class="btn btn-outline-secondary" type="button" id="toggleNewPassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="form-text">Leave blank to keep current password.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                                        <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Passwords do not match.</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <label class="form-label">Admin Role <span class="text-danger">*</span></label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="role" id="roleAdmin" value="ADMIN"
                                       ${editAdmin.role eq 'ADMIN' ? 'checked' : ''}
                                       ${editAdmin.adminId eq sessionScope.adminId && editAdmin.role eq 'SUPER_ADMIN' ? 'disabled' : ''}>
                                <label class="form-check-label" for="roleAdmin">
                                    Regular Admin
                                </label>
                                <div class="form-text">Can manage movies, users, and rentals.</div>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="role" id="roleSuperAdmin" value="SUPER_ADMIN"
                                       ${editAdmin.role eq 'SUPER_ADMIN' ? 'checked' : ''}>
                                <label class="form-check-label" for="roleSuperAdmin">
                                    Super Admin
                                </label>
                                <div class="form-text">Can manage everything including other admin accounts.</div>
                            </div>

                            <c:if test="${editAdmin.adminId eq sessionScope.adminId && editAdmin.role eq 'SUPER_ADMIN'}">
                                <div class="form-text text-danger">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    You cannot demote yourself from Super Admin.
                                </div>
                                <!-- Add a hidden field to ensure the role stays SUPER_ADMIN -->
                                <input type="hidden" name="role" value="SUPER_ADMIN">
                            </c:if>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="${pageContext.request.contextPath}/admin/manage-admins" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-1"></i> Cancel
                            </a>
                            <div>
                                <c:if test="${editAdmin.adminId ne sessionScope.adminId}">
                                    <button type="button" class="btn btn-danger me-2" data-bs-toggle="modal" data-bs-target="#deleteAdminModal">
                                        <i class="fas fa-trash-alt me-1"></i> Delete
                                    </button>
                                </c:if>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i> Save Changes
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${editAdmin.adminId ne sessionScope.adminId}">
    <!-- Delete Admin Modal -->
    <div class="modal fade" id="deleteAdminModal" tabindex="-1" aria-labelledby="deleteAdminModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-dark">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title" id="deleteAdminModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the admin "<strong>${editAdmin.username}</strong>"?</p>
                    <p class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i> This action cannot be undone.</p>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-admins?action=delete&id=${editAdmin.adminId}"
                       class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>
</c:if>

<script>
    // Password visibility toggle
    document.addEventListener('DOMContentLoaded', function() {
        const toggleNewPassword = document.getElementById('toggleNewPassword');
        const newPassword = document.getElementById('newPassword');

        toggleNewPassword.addEventListener('click', function() {
            const type = newPassword.getAttribute('type') === 'password' ? 'text' : 'password';
            newPassword.setAttribute('type', type);
            this.querySelector('i').classList.toggle('fa-eye');
            this.querySelector('i').classList.toggle('fa-eye-slash');
        });

        const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
        const confirmPassword = document.getElementById('confirmPassword');

        toggleConfirmPassword.addEventListener('click', function() {
            const type = confirmPassword.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmPassword.setAttribute('type', type);
            this.querySelector('i').classList.toggle('fa-eye');
            this.querySelector('i').classList.toggle('fa-eye-slash');
        });

        // Form validation
        const form = document.querySelector('.needs-validation');

        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }

            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');

            // Only validate passwords if new password field is not empty
            if (newPassword.value) {
                if (newPassword.value !== confirmPassword.value) {
                    confirmPassword.setCustomValidity('Passwords do not match');
                    event.preventDefault();
                    event.stopPropagation();
                } else {
                    confirmPassword.setCustomValidity('');
                }
            }

            form.classList.add('was-validated');
        });

        // Clear custom validity on input
        if (confirmPassword) {
            confirmPassword.addEventListener('input', function() {
                if (newPassword.value === confirmPassword.value) {
                    confirmPassword.setCustomValidity('');
                } else {
                    confirmPassword.setCustomValidity('Passwords do not match');
                }
            });
        }
    });
</script>

<jsp:include page="../includes/footer.jsp" />