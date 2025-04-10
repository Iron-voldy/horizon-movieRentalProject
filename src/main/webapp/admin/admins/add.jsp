<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Admin | Horizon Movie Rental</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- Custom Admin CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">

    <style>
        .password-requirements {
            font-size: 0.85rem;
            color: #6c757d;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
            margin-top: 10px;
            border-left: 3px solid #20c997;
        }

        .form-group label.required::after {
            content: " *";
            color: red;
        }

        .card-form {
            max-width: 800px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <!-- Include Admin Navbar -->
    <jsp:include page="/admin/admin-navbar.jsp" />

    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/admin/admin-sidebar.jsp" />

            <!-- Main Content -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/manage-admins">Admin Management</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Add New Admin</li>
                    </ol>
                </nav>

                <h2><i class="fas fa-user-plus"></i> Add New Admin</h2>

                <!-- Alert Messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>

                <!-- Add Admin Form -->
                <div class="card shadow card-form mt-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-cog"></i> Admin Information</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/manage-admins" method="post" id="addAdminForm" onsubmit="return validateForm()">
                            <input type="hidden" name="action" value="add">

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="username" class="required">Username</label>
                                        <input type="text" class="form-control" id="username" name="username" required
                                               pattern="[a-zA-Z0-9_]{3,20}" title="Username must be 3-20 characters using only letters, numbers, and underscores">
                                        <small class="form-text text-muted">3-20 characters, letters, numbers, and underscores only.</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="fullName" class="required">Full Name</label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email" class="required">Email Address</label>
                                        <input type="email" class="form-control" id="email" name="email" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="role" class="required">Role</label>
                                        <select class="form-control" id="role" name="role" required>
                                            <option value="ADMIN">Admin</option>
                                            <option value="SUPER_ADMIN">Super Admin</option>
                                        </select>
                                        <small class="form-text text-muted">
                                            Super Admins can manage other admins, while regular Admins cannot.
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="password" class="required">Password</label>
                                        <input type="password" class="form-control" id="password" name="password" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="confirmPassword" class="required">Confirm Password</label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    </div>
                                </div>
                            </div>

                            <div class="password-requirements">
                                <p class="mb-2"><strong>Password Requirements:</strong></p>
                                <ul class="mb-0">
                                    <li>Minimum 8 characters in length</li>
                                    <li>Contains at least one uppercase letter</li>
                                    <li>Contains at least one lowercase letter</li>
                                    <li>Contains at least one number</li>
                                </ul>
                            </div>

                            <div class="form-group mt-4 text-right">
                                <a href="${pageContext.request.contextPath}/admin/manage-admins" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Add Admin
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- jQuery and Bootstrap Bundle (includes Popper) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Validate the form before submission
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;

            // Check if passwords match
            if (password !== confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }

            // Password validation
            var passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
            if (!passwordRegex.test(password)) {
                alert("Password does not meet the requirements!");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>