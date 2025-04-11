<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - FilmFlux</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #6C63FF;
            --primary-dark: #5A52E0;
            --secondary: #FF6584;
            --dark: #151419;
            --darker: #0F0E13;
            --light: #F3F3F4;
            --gray: #8B8B99;
            --success: #4BD1A0;
            --warning: #FFC965;
            --danger: #FF6B78;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dark);
            color: var(--light);
            min-height: 100vh;
            display: flex;
            align-items: center;
            background-image:
                radial-gradient(circle at 30% 100%, rgba(108, 99, 255, 0.2) 0%, transparent 40%),
                radial-gradient(circle at 80% 20%, rgba(255, 101, 132, 0.2) 0%, transparent 30%);
        }

        .register-container {
            padding: 40px 0;
        }

        .register-card {
            background: rgba(15, 14, 19, 0.7);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
        }

        .register-header {
            padding: 30px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .register-logo {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .register-title {
            font-size: 1.4rem;
            color: var(--light);
            font-weight: 600;
            margin-bottom: 0;
        }

        .register-body {
            padding: 40px;
        }

        .form-label {
            color: var(--light);
            font-weight: 500;
            margin-bottom: 10px;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--light);
            padding: 15px 20px;
            font-size: 1rem;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.08);
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(108, 99, 255, 0.25);
            color: var(--light);
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }

        .input-group-text {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--gray);
            border-radius: 10px;
        }

        .btn {
            padding: 15px 25px;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary), var(--primary-dark));
            border: none;
            box-shadow: 0 5px 15px rgba(108, 99, 255, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(108, 99, 255, 0.6);
            background: linear-gradient(45deg, var(--primary), var(--primary-dark));
        }

        .register-footer {
            text-align: center;
            padding: 20px 40px 40px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .login-link {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .login-link:hover {
            color: var(--secondary);
        }

        .back-home {
            display: inline-block;
            margin-top: 30px;
            color: var(--gray);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .back-home:hover {
            color: var(--primary);
            transform: translateX(-5px);
        }

        .back-home i {
            margin-right: 5px;
        }

        .alert {
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
            font-weight: 500;
        }

        .alert-danger {
            background-color: rgba(255, 107, 120, 0.2);
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }

        .password-requirements {
            background-color: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            padding: 15px;
            margin-top: 10px;
        }

        .requirement {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
            color: var(--gray);
            font-size: 0.85rem;
        }

        .requirement i {
            margin-right: 8px;
        }

        .requirement.valid {
            color: var(--success);
        }

        .requirement.invalid {
            color: var(--danger);
        }

        .password-toggle {
            cursor: pointer;
            padding: 0 15px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out forwards;
        }

        @media (max-width: 768px) {
            .register-body, .register-footer {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container register-container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="register-card fade-in">
                    <div class="register-header">
                        <div class="register-logo">FilmFlux</div>
                        <h1 class="register-title">Create Your Account</h1>
                    </div>

                    <div class="register-body">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/register" method="post" id="registerForm">
                            <div class="mb-4">
                                <label for="username" class="form-label">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" id="username" name="username"
                                           placeholder="Choose a username" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="fullName" class="form-label">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                                    <input type="text" class="form-control" id="fullName" name="fullName"
                                           placeholder="Enter your full name" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="email" class="form-label">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <input type="email" class="form-control" id="email" name="email"
                                           placeholder="Enter your email address" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Create a password" required>
                                    <span class="input-group-text password-toggle" onclick="togglePassword('password', 'togglePassword')">
                                        <i class="bi bi-eye" id="togglePassword"></i>
                                    </span>
                                </div>

                                <div class="password-requirements" id="passwordRequirements">
                                    <div class="requirement" id="length">
                                        <i class="bi bi-circle"></i> At least 8 characters
                                    </div>
                                    <div class="requirement" id="uppercase">
                                        <i class="bi bi-circle"></i> At least one uppercase letter
                                    </div>
                                    <div class="requirement" id="lowercase">
                                        <i class="bi bi-circle"></i> At least one lowercase letter
                                    </div>
                                    <div class="requirement" id="number">
                                        <i class="bi bi-circle"></i> At least one number
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                           placeholder="Confirm your password" required>
                                    <span class="input-group-text password-toggle" onclick="togglePassword('confirmPassword', 'toggleConfirmPassword')">
                                        <i class="bi bi-eye" id="toggleConfirmPassword"></i>
                                    </span>
                                </div>
                                <div id="passwordMatch" class="form-text mt-2"></div>
                            </div>

                            <div class="mb-4 form-check">
                                <input type="checkbox" class="form-check-input" id="termsAgreement" required>
                                <label class="form-check-label" for="termsAgreement">
                                    I agree to the <a href="#" class="login-link">Terms of Service</a> and <a href="#" class="login-link">Privacy Policy</a>
                                </label>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary" id="registerBtn">
                                    <i class="bi bi-person-plus me-2"></i>Create Account
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="register-footer">
                        <p>Already have an account? <a href="<%= request.getContextPath() %>/login" class="login-link">Login here</a></p>
                        <a href="<%= request.getContextPath() %>/" class="back-home">
                            <i class="bi bi-arrow-left"></i> Back to Home
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password visibility toggle
        function togglePassword(inputId, toggleId) {
            const passwordInput = document.getElementById(inputId);
            const toggleIcon = document.getElementById(toggleId);

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('bi-eye');
                toggleIcon.classList.add('bi-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('bi-eye-slash');
                toggleIcon.classList.add('bi-eye');
            }
        }

        // Password validation
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordMatch = document.getElementById('passwordMatch');
        const registerBtn = document.getElementById('registerBtn');

        // Password strength requirements
        const length = document.getElementById('length');
        const uppercase = document.getElementById('uppercase');
        const lowercase = document.getElementById('lowercase');
        const number = document.getElementById('number');

        password.addEventListener('input', function() {
            const value = password.value;

            // Check length
            if (value.length >= 8) {
                length.classList.add('valid');
                length.classList.remove('invalid');
                length.querySelector('i').classList.remove('bi-circle');
                length.querySelector('i').classList.add('bi-check-circle-fill');
            } else {
                length.classList.remove('valid');
                length.classList.add('invalid');
                length.querySelector('i').classList.remove('bi-check-circle-fill');
                length.querySelector('i').classList.add('bi-circle');
            }

            // Check uppercase
            if (/[A-Z]/.test(value)) {
                uppercase.classList.add('valid');
                uppercase.classList.remove('invalid');
                uppercase.querySelector('i').classList.remove('bi-circle');
                uppercase.querySelector('i').classList.add('bi-check-circle-fill');
            } else {
                uppercase.classList.remove('valid');
                uppercase.classList.add('invalid');
                uppercase.querySelector('i').classList.remove('bi-check-circle-fill');
                uppercase.querySelector('i').classList.add('bi-circle');
            }

            // Check lowercase
            if (/[a-z]/.test(value)) {
                lowercase.classList.add('valid');
                lowercase.classList.remove('invalid');
                lowercase.querySelector('i').classList.remove('bi-circle');
                lowercase.querySelector('i').classList.add('bi-check-circle-fill');
            } else {
                lowercase.classList.remove('valid');
                lowercase.classList.add('invalid');
                lowercase.querySelector('i').classList.remove('bi-check-circle-fill');
                lowercase.querySelector('i').classList.add('bi-circle');
            }

            // Check number
            if (/[0-9]/.test(value)) {
                number.classList.add('valid');
                number.classList.remove('invalid');
                number.querySelector('i').classList.remove('bi-circle');
                number.querySelector('i').classList.add('bi-check-circle-fill');
            } else {
                number.classList.remove('valid');
                number.classList.add('invalid');
                number.querySelector('i').classList.remove('bi-check-circle-fill');
                number.querySelector('i').classList.add('bi-circle');
            }

            // Check if passwords match
            checkPasswordMatch();
        });

        // Check if passwords match
        confirmPassword.addEventListener('input', checkPasswordMatch);

        function checkPasswordMatch() {
            if (confirmPassword.value === '') {
                passwordMatch.textContent = '';
                passwordMatch.className = 'form-text mt-2';
            } else if (password.value === confirmPassword.value) {
                passwordMatch.textContent = 'Passwords match';
                passwordMatch.style.color = 'var(--success)';
            } else {
                passwordMatch.textContent = 'Passwords do not match';
                passwordMatch.style.color = 'var(--danger)';
            }
        }

        // Form validation
        document.getElementById('registerForm').addEventListener('submit', function(event) {
            if (password.value !== confirmPassword.value) {
                event.preventDefault();
                passwordMatch.textContent = 'Passwords do not match';
                passwordMatch.style.color = 'var(--danger)';
                confirmPassword.focus();
            }
        });

        // Fade in animation when page loads
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('.register-card').classList.add('fade-in');
        });
    </script>
</body>
</html>