<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FilmFlux Admin - ${param.pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <style>
        :root {
            --dark-bg: #121212;
            --darker-bg: #0a0a0a;
            --card-bg: #1e1e1e;
            --text-primary: #e0e0e0;
            --text-secondary: #aaaaaa;
            --primary: #bb86fc;
            --primary-hover: #9d4edd;
            --danger: #cf6679;
            --success: #03dac6;
            --warning: #ffb74d;
            --info: #64b5f6;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background-color: var(--darker-bg);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .navbar-brand {
            color: var(--primary);
            font-weight: bold;
        }

        .nav-link {
            color: var(--text-primary);
        }

        .nav-link:hover, .nav-link:focus {
            color: var(--primary);
        }

        .nav-link.active {
            color: var(--primary) !important;
            font-weight: bold;
        }

        .sidebar {
            background-color: var(--darker-bg);
            min-height: calc(100vh - 56px);
        }

        .sidebar .nav-link {
            padding: 0.75rem 1rem;
            border-radius: 5px;
            margin-bottom: 0.25rem;
        }

        .sidebar .nav-link:hover, .sidebar .nav-link:focus {
            background-color: rgba(187, 134, 252, 0.1);
        }

        .sidebar .nav-link.active {
            background-color: rgba(187, 134, 252, 0.2);
        }

        .card {
            background-color: var(--card-bg);
            border: none;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            margin-bottom: 1.5rem;
        }

        .card-header {
            background-color: rgba(0, 0, 0, 0.2);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            font-weight: bold;
        }

        .table {
            color: var(--text-primary);
        }

        .table thead th {
            border-bottom-color: rgba(255, 255, 255, 0.1);
            color: var(--primary);
        }

        .table td, .table th {
            border-top-color: rgba(255, 255, 255, 0.1);
        }

        .btn-primary {
            background-color: var(--primary);
            border-color: var(--primary);
        }

        .btn-primary:hover, .btn-primary:focus {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
        }

        .btn-danger {
            background-color: var(--danger);
            border-color: var(--danger);
        }

        .form-control, .form-select {
            background-color: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
            color: var(--text-primary);
        }

        .form-control:focus, .form-select:focus {
            background-color: rgba(255, 255, 255, 0.15);
            color: var(--text-primary);
            border-color: var(--primary);
            box-shadow: 0 0 0 0.25rem rgba(187, 134, 252, 0.25);
        }

        .form-select option {
            background-color: var(--dark-bg);
        }

        .badge.bg-success {
            background-color: var(--success) !important;
        }

        .badge.bg-danger {
            background-color: var(--danger) !important;
        }

        .badge.bg-warning {
            background-color: var(--warning) !important;
            color: #212529;
        }

        .badge.bg-info {
            background-color: var(--info) !important;
            color: #212529;
        }

        .alert-success {
            background-color: rgba(3, 218, 198, 0.2);
            color: var(--success);
            border-color: rgba(3, 218, 198, 0.3);
        }

        .alert-danger {
            background-color: rgba(207, 102, 121, 0.2);
            color: var(--danger);
            border-color: rgba(207, 102, 121, 0.3);
        }

        .page-title {
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--primary);
        }

        .stats-card {
            padding: 1.5rem;
            border-radius: 8px;
            text-align: center;
            height: 100%;
        }

        .stats-card .icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .stats-card .number {
            font-size: 2rem;
            font-weight: bold;
        }

        .stats-card .label {
            color: var(--text-secondary);
        }

        .movies-card { background-color: rgba(187, 134, 252, 0.1); }
        .users-card { background-color: rgba(3, 218, 198, 0.1); }
        .rentals-card { background-color: rgba(255, 183, 77, 0.1); }
        .reviews-card { background-color: rgba(100, 181, 246, 0.1); }

        .table-responsive {
            background-color: var(--card-bg);
            border-radius: 8px;
            padding: 1rem;
        }

        .dashboard-section {
            margin-bottom: 2rem;
        }

        .dropdown-menu {
            background-color: var(--card-bg);
            border-color: rgba(255, 255, 255, 0.1);
        }

        .dropdown-item {
            color: var(--text-primary);
        }

        .dropdown-item:hover, .dropdown-item:focus {
            background-color: rgba(187, 134, 252, 0.1);
            color: var(--primary);
        }

        .pagination .page-link {
            background-color: var(--card-bg);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--text-primary);
        }

        .pagination .page-link:hover {
            background-color: rgba(187, 134, 252, 0.1);
            color: var(--primary);
        }

        .pagination .page-item.active .page-link {
            background-color: var(--primary);
            border-color: var(--primary);
        }

        .main-content {
            flex: 1;
            padding: 2rem;
        }

        .movie-cover-preview {
            max-width: 150px;
            max-height: 200px;
            object-fit: cover;
        }

        .movie-cover-thumbnail {
            width: 50px;
            height: 75px;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-film me-2"></i>FilmFlux Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'movies' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/admin/movies">
                            <i class="fas fa-film me-1"></i> Movies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'users' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users me-1"></i> Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'rentals' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/admin/rentals">
                            <i class="fas fa-exchange-alt me-1"></i> Rentals
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'reviews' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/admin/reviews">
                            <i class="fas fa-star me-1"></i> Reviews
                        </a>
                    </li>
                    <c:if test="${admin.isSuperAdmin()}">
                        <li class="nav-item">
                            <a class="nav-link ${param.activePage == 'admins' ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/manage-admins">
                                <i class="fas fa-user-shield me-1"></i> Admins
                            </a>
                        </li>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i> ${adminUsername}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">
                                    <i class="fas fa-user-cog me-1"></i> Profile
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/logout">
                                    <i class="fas fa-sign-out-alt me-1"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Main Content -->
            <main class="col-md-12 main-content">
                <!-- Display success/error messages if available -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i> ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>