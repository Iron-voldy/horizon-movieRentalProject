<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.user.PremiumUser" %>
<%@ page import="com.movierental.model.user.RegularUser" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --neon-purple: #8a2be2;
            --neon-pink: #ff00ff;
            --dark-bg: #121212;
            --card-bg: #1e1e1e;
            --card-secondary: #2d2d2d;
            --text-primary: #e0e0e0;
            --text-secondary: #aaaaaa;
            --input-bg: #333;
            --input-border: #444;
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

        .update-container {
            margin-top: 30px;
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

        .form-label {
            color: var(--neon-pink);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-control:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-purple);
            box-shadow: 0 0 0 0.25rem rgba(138, 43, 226, 0.25);
        }

        .form-text {
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        .alert-success {
            background-color: rgba(0, 51, 0, 0.7);
            color: #66ff66;
            border-color: #005500;
            border-radius: 8px;
        }

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
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

        .premium-benefits {
            background: linear-gradient(135deg, rgba(138, 43, 226, 0.1), rgba(255, 0, 255, 0.1));
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
            border: 1px dashed #444;
        }

        .premium-benefits ul {
            list-style-type: none;
            padding-left: 0;
        }

        .premium-benefits li {
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .premium-benefits li i {
            color: var(--neon-pink);
            margin-right: 10px;
        }

        .premium-badge {
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            color: white;
            font-weight: 700;
            padding: 3px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-bottom: 15px;
            display: inline-block;
            box-shadow: 0 0 15px rgba(138, 43, 226, 0.3);
        }

        .form-check-input {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
        }

        .form-check-input:checked {
            background-color: var(--neon-purple);
            border-color: var(--neon-purple);
        }

        .divider {
            border-top: 1px solid #333;
            margin: 30px 0;
        }

        .password-section {
            background-color: rgba(138, 43, 226, 0.05);
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/movie/search-movie.jsp">
                            <i class="bi bi-film"></i> Movies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/rental/rental-history.jsp">
                            <i class="bi bi-collection-play"></i> My Rentals
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/watchlist/watchlist.jsp">
                            <i class="bi bi-bookmark-star"></i> Watchlist
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/user/profile.jsp">
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

    <div class="container update-container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-pencil-square"></i> Update Your Profile
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("successMessage") != null) { %>
                            <div class="alert alert-success mb-4">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                <%= request.getAttribute("successMessage") %>
                            </div>
                        <% } %>

                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/update-profile" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" value="<%= user.getUsername() %>" disabled>
                                    <div class="form-text">Username cannot be changed</div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="<%= user.getFullName() %>" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>" required>
                            </div>

                            <% if (!isPremium) { %>
                                <div class="premium-benefits">
                                    <span class="premium-badge">Premium Benefits</span>
                                    <ul>
                                        <li><i class="bi bi-check-circle-fill"></i> Rent up to 10 movies at once (vs. 3 for regular users)</li>
                                        <li><i class="bi bi-check-circle-fill"></i> Lower rental fees per movie</li>
                                        <li><i class="bi bi-check-circle-fill"></i> Reduced late fees</li>
                                        <li><i class="bi bi-check-circle-fill"></i> Access to exclusive new releases</li>
                                        <li><i class="bi bi-check-circle-fill"></i> Enhanced recommendation algorithm</li>
                                    </ul>

                                    <div class="form-check mt-3">
                                        <input class="form-check-input" type="checkbox" id="upgradeAccount" name="upgradeAccount" value="yes">
                                        <label class="form-check-label" for="upgradeAccount">
                                            Upgrade to Premium account
                                        </label>
                                    </div>
                                </div>
                            <% } %>

                            <div class="divider"></div>

                            <h5 class="mb-3 text-neon-pink">Change Password</h5>
                            <div class="password-section">
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Current Password</label>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                                    <div class="form-text">Leave blank if you don't want to change your password</div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="newPassword" class="form-label">New Password</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword">
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4 d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/user/profile.jsp" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Back to Profile
                                </a>
                                <button type="submit" class="btn btn-neon">
                                    <i class="bi bi-save"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>