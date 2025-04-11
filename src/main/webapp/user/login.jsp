<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FilmFlux</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --neon-blue: #00c8ff;
            --neon-purple: #8a2be2;
            --neon-pink: #ff00ff;
            --dark-bg: #121212;
            --card-bg: #1e1e1e;
            --text-primary: #e0e0e0;
            --text-secondary: #a0a0a0;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            background-image:
                radial-gradient(circle at 90% 10%, rgba(0, 200, 255, 0.15) 0%, transparent 30%),
                radial-gradient(circle at 10% 90%, rgba(255, 0, 255, 0.1) 0%, transparent 30%);
        }

        .login-container {
            margin-top: 2rem;
            margin-bottom: 2rem;
        }

        .card {
            background-color: var(--card-bg);
            border-radius: 15px;
            border: 1px solid #333;
            box-shadow: 0 0 30px rgba(0, 200, 255, 0.2);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, rgba(0, 200, 255, 0.2), rgba(138, 43, 226, 0.2));
            color: var(--neon-blue);
            font-weight: 700;
            text-align: center;
            padding: 1.5rem;
            border-bottom: 1px solid #333;
        }

        .card-body {
            padding: 2rem;
        }

        .login-logo {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 1rem;
            display: block;
            text-align: center;
        }

        .form-label {
            color: var(--neon-blue);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-control {
            background-color: #2d2d2d;
            border: 1px solid #444;
            color: var(--text-primary);
            border-radius: 8px;
            padding: 12px 15px;
        }

        .form-control:focus {
            background-color: #333;
            color: var(--text-primary);
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
        }

        .input-group-text {
            background-color: #2d2d2d;
            border: 1px solid #444;
            color: var(--neon-blue);
        }

        .btn-login {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            border: none;
            color: white;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            width: 100%;
            margin-top: 1rem;
            transition: all 0.3s;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 200, 255, 0.4);
        }

        .create-account {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--text-secondary);
        }

        .create-account a {
            color: var(--neon-blue);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }

        .create-account a:hover {
            color: var(--neon-pink);
            text-shadow: 0 0 8px rgba(0, 200, 255, 0.5);
        }

        .back-to-home {
            text-align: center;
            margin-top: 1.5rem;
        }

        .back-to-home a {
            color: var(--text-secondary);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s;
        }

        .back-to-home a:hover {
            color: var(--neon-blue);
        }

        .back-to-home i {
            margin-right: 0.5rem;
        }

        .alert {
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.2);
            color: #ff6b6b;
            border-color: #dc3545;
        }

        .alert-success {
            background-color: rgba(40, 167, 69, 0.2);
            color: #51cf66;
            border-color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">
                <div class="card">
                    <div class="card-header">
                        <span class="login-logo">FilmFlux</span>
                        <h4 class="mb-0">Sign In</h4>
                    </div>
                    <div class="card-body">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <% if(session.getAttribute("successMessage") != null) { %>
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                <%= session.getAttribute("successMessage") %>
                                <% session.removeAttribute("successMessage"); %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-login">
                                <i class="bi bi-box-arrow-in-right me-2"></i> Sign In
                            </button>
                        </form>

                        <div class="create-account">
                            Don't have an account? <a href="<%= request.getContextPath() %>/register">Create Account</a>
                        </div>

                        <div class="back-to-home">
                            <a href="<%= request.getContextPath() %>/">
                                <i class="bi bi-house-fill"></i> Back to Home
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>