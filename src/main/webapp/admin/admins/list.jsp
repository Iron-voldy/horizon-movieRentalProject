<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Management | Horizon Movie Rental</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">
    <!-- Custom Admin CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">

    <style>
        .action-buttons .btn {
            margin-right: 5px;
        }
        .badge-super-admin {
            background-color: #6f42c1;
        }
        .badge-admin {
            background-color: #20c997;
        }
        .dataTables_wrapper {
            padding: 20px 0;
        }
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
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
                <div class="admin-header">
                    <h2><i class="fas fa-users-cog"></i> Admin Management</h2>
                    <a href="${pageContext.request.contextPath}/admin/manage-admins?action=add" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i> Add New Admin
                    </a>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.successMessage}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.errorMessage}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Admin List -->
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-list"></i> Admin List</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="adminTable" class="table table-striped table-hover">
                                <thead class="thead-dark">
                                    <tr>
                                        <th>Username</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="admin" items="${admins}">
                                        <tr>
                                            <td>${admin.username}</td>
                                            <td>${admin.fullName}</td>
                                            <td>${admin.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${admin.role eq 'SUPER_ADMIN'}">
                                                        <span class="badge badge-super-admin">Super Admin</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-admin">Admin</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/manage-admins?action=edit&id=${admin.adminId}"
                                                   class="btn btn-sm btn-info" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>

                                                <!-- Don't show delete button for the current admin -->
                                                <c:if test="${admin.adminId ne sessionScope.adminId}">
                                                    <button class="btn btn-sm btn-danger"
                                                            onclick="confirmDelete('${admin.adminId}', '${admin.username}')"
                                                            title="Delete">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the admin: <strong id="adminToDelete"></strong>?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery and Bootstrap Bundle (includes Popper) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

    <script>
        $(document).ready(function() {
            // Initialize DataTable
            $('#adminTable').DataTable({
                "order": [[0, "asc"]], // Sort by username
                "pageLength": 10,
                "language": {
                    "lengthMenu": "Show _MENU_ admins per page",
                    "zeroRecords": "No admins found",
                    "info": "Showing page _PAGE_ of _PAGES_",
                    "infoEmpty": "No admins available",
                    "infoFiltered": "(filtered from _MAX_ total admins)"
                }
            });
        });

        // Function to setup the delete confirmation modal
        function confirmDelete(adminId, username) {
            $('#adminToDelete').text(username);
            $('#confirmDeleteBtn').attr('href', '${pageContext.request.contextPath}/admin/manage-admins?action=delete&id=' + adminId);
            $('#deleteConfirmModal').modal('show');
        }
    </script>
</body>
</html>