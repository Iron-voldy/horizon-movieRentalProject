<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.user.PremiumUser" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Horizon</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --secondary: #ec4899;
            --dark: #0f172a;
            --darker: #020617;
            --light-text: #f1f5f9;
            --dark-text: #1e293b;
            --gray-text: #94a3b8;
            --card-bg: #1e293b;
            --card-secondary: #0f172a;
            --border-color: #475569;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
        }

        body {
            background-color: var(--darker);
            color: var(--light-text);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            padding-bottom: 3rem;
            background-image: 
                radial-gradient(circle at 90% 10%, rgba(37, 99, 235, 0.1) 0%, transparent 40%),
                radial-gradient(circle at 10% 90%, rgba(236, 72, 153, 0.1) 0%, transparent 40%);
        }

        /* Navbar */
        .navbar {
            background-color: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 0;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .nav-link {
            color: var(--light-text);
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .nav-link:hover, .nav-link.active {
            background-color: rgba(37, 99, 235, 0.15);
            color: var(--primary);
        }

        .nav-link i {
            margin-right: 0.5rem;
        }

        /* Profile section */
        .profile-header {
            background: linear-gradient(to right, rgba(37, 99, 235, 0.1), rgba(236, 72, 153, 0.1));
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            font-weight: 600;
            margin-right: 1.5rem;
            box-shadow: 0 0 20px rgba(37, 99, 235, 0.5);
        }

        .user-info h2 {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--light-text);
        }

        .username {
            color: var(--gray-text);
            margin-bottom: 0.75rem;
            font-size: 1.1rem;
        }

        .user-type-badge {
            display: inline-block;
            padding: 0.4rem 1rem;
            border-radius: 2rem;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .premium-badge {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            box-shadow: 0 0 15px rgba(37, 99, 235, 0.4);
        }

        .regular-badge {
            background: linear-gradient(to right, #64748b, #94a3b8);
            color: white;
        }

        .premium-expiry {
            color: var(--warning);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
        }

        .premium-expiry i {
            margin-right: 0.5rem;
        }

        .btn-edit-profile {
            background: linear-gradient(to right, var(--primary), #3b82f6);
            border: none;
            color: white;
            font-weight: 600;
            padding: 0.6rem 1.5rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.25);
        }

        .btn-edit-profile:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px rgba(37, 99, 235, 0.35);
            color: white;
        }

        .btn-edit-profile i {
            margin-right: 0.5rem;
        }

        /* Cards */
        .card {
            background-color: var(--card-bg);
            border-radius: 1rem;
            border: 1px solid var(--border-color);
            margin-bottom: 1.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
        }

        .card-header {
            background-color: var(--card-secondary);
            color: var(--primary);
            font-weight: 600;
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
        }

        .card-header i {
            margin-right: 0.75rem;
            color: var(--secondary);
            font-size: 1.2rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Account info */
        .info-item {
            padding: 1rem 0;
            border-bottom: 1px solid rgba(71, 85, 105, 0.5);
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            color: var(--gray-text);
            font-size: 0.9rem;
            margin-bottom: 0.3rem;
        }

        .info-value {
            font-weight: 500;
            color: var(--light-text);
        }

        /* Stats */
        .stats-card {
            text-align: center;
            padding: 1.2rem;
            border-radius: 0.75rem;
            background-color: rgba(15, 23, 42, 0.6);
            border: 1px solid var(--border-color);
            height: 100%;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            background-color: rgba(30, 41, 59, 0.7);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: block;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--gray-text);
            font-size: 0.9rem;
        }

        /* Action buttons */
        .btn-action {
            background: linear-gradient(to right, var(--primary), #3b82f6);
            border: none;
            color: white;
            font-weight: 600;
            padding: 0.8rem 1.2rem;
            border-radius: 0.5rem;
            width: 100%;
            transition: all 0.3s;
            margin-bottom: 1rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.25);
        }

        .btn-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px rgba(37, 99, 235, 0.35);
            color: white;
        }

        .btn-action i {
            margin-right: 0.5rem;
        }

        .btn-danger {
            background: linear-gradient(to right, var(--danger), #f87171);
            box-shadow: 0 4px 6px rgba(239, 68, 68, 0.25);
        }

        .btn-danger:hover {
            box-shadow: 0 10px 15px rgba(239, 68, 68, 0.35);
        }

        /* Empty states */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
        }

        .empty-state i {
            font-size: 3rem;
            color: rgba(71, 85, 105, 0.6);
            margin-bottom: 1rem;
        }

        .empty-message {
            color: var(--gray-text);
            margin-bottom: 1.5rem;
        }

        .btn-cta {
            background: linear-gradient(to right, var(--primary), #3b82f6);
            border: none;
            color: white;
            font-weight: 600;
            padding: 0.8rem 1.5rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.25);
        }

        .btn-cta:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px rgba(37, 99, 235, 0.35);
            color: white;
        }

        .btn-cta i {
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
    <%
        // Get user from session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean isPremium = user instanceof PremiumUser;
        String userInitial = user.getFullName().substring(0, 1).toUpperCase();
    %>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/">Horizon</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/">
                            <i class="bi bi-house-fill"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/search-movie">
                            <i class="bi bi-film"></i> Movies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/rental-history">
                            <i class="bi bi-collection-play"></i> My Rentals
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/view-watchlist">
                            <i class="bi bi-bookmark-star"></i> Watchlist
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">
                            <i class="bi bi-person-circle"></i> <%= user.getUsername() %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Profile Header -->
        <div class="profile-header d-flex align-items-center">
            <div class="avatar">
                <%= userInitial %>
            </div>
            <div class="user-info flex-grow-1">
                <h2><%= user.getFullName() %></h2>
                <div class="username">@<%= user.getUsername() %></div>
                <span class="user-type-badge <%= isPremium ? "premium-badge" : "regular-badge" %>">
                    <%= isPremium ? "Premium Member" : "Standard Member" %>
                </span>
                <% if (isPremium) { %>
                    <div class="premium-expiry mt-2">
                        <i class="bi bi-calendar-check"></i>
                        Premium expires: <%= new SimpleDateFormat("MMMM dd, yyyy").format(((PremiumUser)user).getSubscriptionExpiryDate()) %>
                    </div>
                <% } %>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/update-profile" class="btn btn-edit-profile">
                    <i class="bi bi-pencil-square"></i> Edit Profile
                </a>
            </div>
        </div>

        <div class="row">
            <!-- User Details Card -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-person-badge"></i> Account Information
                    </div>
                    <div class="card-body">
                        <div class="info-item">
                            <div class="info-label">User ID</div>
                            <div class="info-value"><%= user.getUserId() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Email Address</div>
                            <div class="info-value"><%= user.getEmail() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Account Type</div>
                            <div class="info-value"><%= isPremium ? "Premium" : "Standard" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Rental Limit</div>
                            <div class="info-value"><%= user.getRentalLimit() %> movies</div>
                        </div>
                        <% if (!isPremium) { %>
                            <div class="mt-3">
                                <a href="<%= request.getContextPath() %>/update-profile" class="btn btn-action">
                                    <i class="bi bi-stars"></i> Upgrade to Premium
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Stats Card -->
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-bar-chart-line"></i> Your Stats
                    </div>
                    <div class="card-body">
                        <div class="row gy-3">
                            <div class="col-6">
                                <div class="stats-card">
                                    <span class="stat-number">0</span>
                                    <span class="stat-label">Movies Rented</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stats-card">
                                    <span class="stat-number">0</span>
                                    <span class="stat-label">Reviews</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stats-card">
                                    <span class="stat-number">0</span>
                                    <span class="stat-label">Watchlist</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stats-card">
                                    <span class="stat-number">0</span>
                                    <span class="stat-label">Favorites</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions Card -->
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-gear-fill"></i> Account Actions
                    </div>
                    <div class="card-body">
                        <a href="<%= request.getContextPath() %>/update-profile" class="btn btn-action">
                            <i class="bi bi-pencil-square"></i> Edit Profile
                        </a>
                        <a href="<%= request.getContextPath() %>/delete-account" class="btn btn-action btn-danger">
                            <i class="bi bi-trash"></i> Delete Account
                        </a>
                    </div>
                </div>
            </div>

            <!-- Activity Column -->
            <div class="col-lg-8">
                <!-- Recent Rentals Card -->
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-collection-play"></i> Recent Rentals
                    </div>
                    <div class="card-body">
                        <div class="empty-state">
                            <i class="bi bi-film"></i>
                            <p class="empty-message">You haven't rented any movies yet</p>
                            <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-cta">
                                <i class="bi bi-search"></i> Browse Movies
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Recent Reviews Card -->
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-star-fill"></i> Recent Reviews
                    </div>
                    <div class="card-body">
                        <div class="empty-state">
                            <i class="bi bi-chat-square-text"></i>
                            <p class="empty-message">You haven't written any reviews yet</p>
                            <a href="<%= request.getContextPath() %>/user-reviews" class="btn btn-cta">
                                <i class="bi bi-pencil"></i> Write Reviews
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Watchlist Sneak Peek -->
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-bookmark-heart"></i> From Your Watchlist
                    </div>
                    <div class="card-body">
                        <div class="empty-state">
                            <i class="bi bi-bookmarks"></i>
                            <p class="empty-message">Your watchlist is empty</p>
                            <a href="<%= request.getContextPath() %>/view-watchlist" class="btn btn-cta">
                                <i class="bi bi-plus-circle"></i> Browse Movies
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>