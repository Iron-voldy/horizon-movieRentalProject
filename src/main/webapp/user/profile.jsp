<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.user.PremiumUser" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        /* Your existing CSS styles */
        :root {
            --neon-purple: #8a2be2;
            --neon-pink: #ff00ff;
            --dark-bg: #121212;
            --card-bg: #1e1e1e;
            --card-secondary: #2d2d2d;
            --text-primary: #e0e0e0;
            --text-secondary: #aaaaaa;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding-bottom: 60px;
            background-image:
                radial-gradient(circle at 90% 10%, rgba(138, 43, 226, 0.15) 0%, transparent 30%),
                radial-gradient(circle at 10% 90%, rgba(255, 0, 255, 0.1) 0%, transparent 30%);
        }

        .navbar {
            background-color: rgba(30, 30, 30, 0.8);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #333;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-weight: bold;
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            font-size: 1.5rem;
        }

        .nav-link {
            color: var(--text-primary);
            margin: 0 10px;
            position: relative;
        }

        .nav-link:hover {
            color: var(--neon-pink);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            bottom: 0;
            left: 0;
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            transform: scaleX(0);
            transform-origin: bottom right;
            transition: transform 0.3s;
        }

        .nav-link:hover::after {
            transform: scaleX(1);
            transform-origin: bottom left;
        }

        .profile-container {
            margin-top: 30px;
        }

        .profile-header {
            background: linear-gradient(135deg, rgba(138, 43, 226, 0.2), rgba(255, 0, 255, 0.2));
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid #333;
            box-shadow: 0 0 30px rgba(138, 43, 226, 0.3);
        }

        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            margin-right: 20px;
            box-shadow: 0 0 20px rgba(138, 43, 226, 0.5);
        }

        .user-info h2 {
            margin-bottom: 5px;
        }

        .user-type-badge {
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            color: white;
            border-radius: 20px;
            padding: 5px 15px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
            box-shadow: 0 0 15px rgba(138, 43, 226, 0.4);
        }

        .regular-badge {
            background: linear-gradient(to right, #3498db, #2980b9);
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid #333;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .card-header {
            background-color: var(--card-secondary);
            color: var(--neon-pink);
            font-weight: 600;
            border-bottom: 1px solid #444;
            padding: 15px 20px;
        }

        .card-header i {
            margin-right: 10px;
            color: var(--neon-purple);
        }

        .btn-neon {
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(138, 43, 226, 0.3);
        }

        .btn-neon:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(138, 43, 226, 0.6);
            color: white;
        }

        .btn-danger-neon {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            box-shadow: 0 0 15px rgba(255, 65, 108, 0.3);
        }

        .btn-danger-neon:hover {
            box-shadow: 0 0 20px rgba(255, 65, 108, 0.6);
        }

        .info-item {
            padding: 12px 0;
            border-bottom: 1px solid #333;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .info-value {
            font-weight: 500;
        }

        .activity-item {
            border-left: 3px solid var(--neon-purple);
            padding: 10px 15px;
            margin-bottom: 15px;
            background-color: rgba(138, 43, 226, 0.05);
            border-radius: 0 8px 8px 0;
        }

        .activity-item:hover {
            background-color: rgba(138, 43, 226, 0.1);
        }

        .activity-date {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .premium-expiry {
            color: #ff9900;
            font-weight: 500;
        }

        .stat-card {
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            background-color: var(--card-secondary);
            border: 1px solid #333;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: block;
            margin-bottom: 5px;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
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
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/">FilmFlux</a>
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

    <div class="container profile-container">
        <!-- Profile Header -->
        <div class="profile-header d-flex align-items-center">
            <div class="avatar">
                <%= userInitial %>
            </div>
            <div class="user-info ms-3">
                <h2><%= user.getFullName() %></h2>
                <p class="mb-1"><%= user.getUsername() %></p>
                <span class="user-type-badge <%= isPremium ? "" : "regular-badge" %>">
                    <%= isPremium ? "Premium Member" : "Regular Member" %>
                </span>
                <% if (isPremium) { %>
                    <p class="mt-2 mb-0 premium-expiry">
                        <i class="bi bi-calendar-check"></i>
                        Premium expires: <%= new SimpleDateFormat("MMMM dd, yyyy").format(((PremiumUser)user).getSubscriptionExpiryDate()) %>
                    </p>
                <% } %>
            </div>
            <div class="ms-auto">
                <a href="<%= request.getContextPath() %>/update-profile" class="btn btn-neon">
                    <i class="bi bi-pencil-square"></i> Edit Profile
                </a>
            </div>
        </div>

        <div class="row">
            <!-- User Details Card -->
            <div class="col-md-4">
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
                            <div class="info-value"><%= isPremium ? "Premium" : "Regular" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Rental Limit</div>
                            <div class="info-value"><%= user.getRentalLimit() %> movies</div>
                        </div>
                        <% if (!isPremium) { %>
                            <div class="mt-3">
                                <a href="<%= request.getContextPath() %>/update-profile" class="btn btn-neon w-100">
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
                        <div class="row">
                            <div class="col-6 mb-3">
                                <div class="stat-card">
                                    <span class="stat-number">0</span>
                                    <span class="stat-label">Movies Rented</span>
                                </div>
                            </div>
                            <div class="col-6 mb-3">
                                <div class="stat-card">
                                    <span class="stat-number">0</span>
                                    <span class="stat-label">Reviews</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stat-card">
                                    <span class="stat-number">0</span>
                                    <span class="stat-label">Watchlist</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stat-card">
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
                    <div class="card-body d-grid gap-2">
                        <a href="<%= request.getContextPath() %>/update-profile" class="btn btn-neon">
                            <i class="bi bi-pencil-square"></i> Edit Profile
                        </a>
                        <a href="<%= request.getContextPath() %>/delete-account" class="btn btn-danger-neon">
                            <i class="bi bi-trash"></i> Delete Account
                        </a>
                    </div>
                </div>
            </div>

            <!-- Activity Column -->
            <div class="col-md-8">
                <!-- Recent Rentals Card -->
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-collection-play"></i> Recent Rentals
                    </div>
                    <div class="card-body">
                        <div class="text-center py-5">
                            <i class="bi bi-film" style="font-size: 3rem; color: #444;"></i>
                            <p class="mt-3 text-secondary">You haven't rented any movies yet</p>
                            <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-neon mt-2">
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
                        <div class="text-center py-5">
                            <i class="bi bi-chat-square-text" style="font-size: 3rem; color: #444;"></i>
                            <p class="mt-3 text-secondary">You haven't written any reviews yet</p>
                            <a href="<%= request.getContextPath() %>/user-reviews" class="btn btn-neon mt-2">
                                <i class="bi bi-pencil"></i> View Your Reviews
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
                        <div class="text-center py-5">
                            <i class="bi bi-bookmarks" style="font-size: 3rem; color: #444;"></i>
                            <p class="mt-3 text-secondary">Your watchlist is empty</p>
                            <a href="<%= request.getContextPath() %>/view-watchlist" class="btn btn-neon mt-2">
                                <i class="bi bi-plus-circle"></i> Manage Watchlist
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>