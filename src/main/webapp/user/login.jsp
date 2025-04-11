<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Horizon</title>
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
            --input-bg: #334155;
            --border-color: #475569;
            --success: #10b981;
            --danger: #ef4444;
        }

        body {
            background-color: var(--darker);
            color: var(--light-text);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            background-image: 
                radial-gradient(circle at 90% 10%, rgba(37, 99, 235, 0.1) 0%, transparent 30%),
                radial-gradient(circle at 10% 90%, rgba(236, 72, 153, 0.1) 0%, transparent 30%);
        }

        .login-container {
            margin-top: 2rem;
            margin-bottom: 2rem;
        }

        .card {
            background-color: var(--card-bg);
            border-radius: 1rem;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(to right, rgba(37, 99, 235, 0.1), rgba(236, 72, 153, 0.1));
            border-bottom: 1px solid var(--border-color);
            padding: 2rem 1.5rem;
            text-align: center;
        }

        .card-body {
            padding: 2.5rem;
        }

        .brand-logo {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 0.5rem;
            display: block;
        }

        .auth-title {
            color: var(--light-text);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-label {
            color: var(--light-text);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--light-text);
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: var(--input-bg);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.3);
            border-color: var(--primary);
            color: var(--light-text);
        }

        .input-group-text {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--primary);
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary), #3b82f6);
            border: none;
            color: white;
            font-weight: 600;
            padding: 0.75rem;
            border-radius: 0.5rem;
            width: 100%;
            margin-top: 1.5rem;
            transition: all 0.3s;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.25);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px rgba(37, 99, 235, 0.35);
            background: linear-gradient(to right, var(--primary-hover), #2563eb);
        }

        .auth-links {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--gray-text);
        }

        .auth-links a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }

        .auth-links a:hover {
            color: var(--secondary);
        }

        .back-to-home {
            text-align: center;
            margin-top: 1.5rem;
        }

        .back-to-home a {
            color: var(--gray-text);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s;
        }

        .back-to-home a:hover {
            color: var(--primary);
        }

        .back-to-home i {
            margin-right: 0.5rem;
        }

        .alert {
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border: none;
        }

        .alert-danger {
            background-color: rgba(239, 68, 68, 0.15);
            color: #f87171;
            border-left: 4px solid var(--danger);
        }

        .alert-success {
            background-color: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border-left: 4px solid var(--success);
        }
    </style>
</head>
<body>
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">
                <div class="card">
                    <div class="card-header">
                        <span class="brand-logo">Horizon</span>
                        <h4 class="auth-title">Welcome Back</h4>
                        <p class="text-muted mb-0">Sign in to your account</p>
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

                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-box-arrow-in-right me-2"></i> Sign In
                            </button>
                        </form>

                        <div class="auth-links">
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
