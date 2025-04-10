<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Admin Management" />
    <jsp:param name="activePage" value="admins" />
</jsp:include>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title">
            <i class="fas fa-user-shield me-2"></i> Admin Management
        </h1>
        <a href="${pageContext.request.contextPath}/admin/manage-admins?action=add" class="btn btn-primary">
            <i class="fas fa-plus-circle me-1"></i> Add New Admin
        </a>
    </div>

    <!-- Admin List Table -->
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Full Name</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="adminUser" items="${admins}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar
                                            ${adminUser.isSuperAdmin() ? 'bg-danger' : 'bg-primary'}
                                            bg-opacity-10 rounded-circle me-2"
                                             style="width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;">
                                            <i class="fas ${adminUser.isSuperAdmin() ? 'fa-user-cog text-danger' : 'fa-user-tie text-primary'}"></i>
                                        </div>
                                        ${adminUser.username}
                                        <c:if test="${adminUser.adminId eq sessionScope.adminId}">
                                            <span class="badge bg-info ms-2">You</span>
                                        </c:if>
                                    </div>
                                </td>
                                <td>${adminUser.email}</td>
                                <td>${adminUser.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${adminUser.isSuperAdmin()}">
                                            <span class="badge bg-danger">Super Admin</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-primary">Admin</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/admin/manage-admins?action=edit&id=${adminUser.adminId}"
                                           class="btn btn-sm btn-primary" data-bs-toggle="tooltip" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <c:if test="${adminUser.adminId ne sessionScope.adminId}">
                                            <button type="button" class="btn btn-sm btn-danger"
                                                    data-bs-toggle="modal" data-bs-target="#deleteModal${adminUser.adminId}"
                                                    title="Delete" ${admins.size() <= 1 ? 'disabled' : ''}>
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </c:if>
                                    </div>

                                    <c:if test="${adminUser.adminId ne sessionScope.adminId}">
                                        <!-- Delete Confirmation Modal -->
                                        <div class="modal fade" id="deleteModal${adminUser.adminId}" tabindex="-1"
                                             aria-labelledby="deleteModalLabel${adminUser.adminId}" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content bg-dark">
                                                    <div class="modal-header border-secondary">
                                                        <h5 class="modal-title" id="deleteModalLabel${adminUser.adminId}">Confirm Deletion</h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p>Are you sure you want to delete the admin "<strong>${adminUser.username}</strong>"?</p>
                                                        <p class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i> This action cannot be undone.</p>
                                                        <c:if test="${adminUser.isSuperAdmin() && countSuperAdmins <= 1}">
                                                            <div class="alert alert-warning">
                                                                <i class="fas fa-exclamation-circle me-2"></i>
                                                                Cannot delete the last Super Admin.
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <div class="modal-footer border-secondary">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                        <a href="${pageContext.request.contextPath}/admin/manage-admins?action=delete&id=${adminUser.adminId}"
                                                           class="btn btn-danger" ${adminUser.isSuperAdmin() && countSuperAdmins <= 1 ? 'disabled' : ''}>Delete</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty admins}">
                            <tr>
                                <td colspan="5" class="text-center py-4">
                                    <i class="fas fa-user-shield fa-3x mb-3 text-secondary"></i>
                                    <p class="mb-0 text-secondary">No admin users found</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />