<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Horizon - Your Ultimate Movie Experience</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #7B68EE;
            --primary-dark: #6A5ACD;
            --secondary: #FF5252;
            --dark: #141414;
            --darker: #0D0D0D;
            --light: #F5F5F5;
            --gray: #888888;
            --success: #4CAF50;
            --warning: #FFC107;
            --danger: #FF5252;
            --card-bg: #1E1E1E;
            --card-border: #333333;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--darker);
            color: var(--light);
            min-height: 100vh;
            overflow-x: hidden;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
        }

        /* Navbar Styles */
        .navbar {
            background-color: rgba(13, 13, 13, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 700;
            letter-spacing: 1px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-right: 30px;
        }

        .nav-link {
            font-weight: 500;
            color: var(--light);
            margin: 0 15px;
            position: relative;
            transition: all 0.3s ease;
            opacity: 0.8;
        }

        .nav-link:hover, .nav-link.active {
            opacity: 1;
            color: var(--primary);
        }

        .nav-link:after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            transition: width 0.3s ease;
        }

        .nav-link:hover:after, .nav-link.active:after {
            width: 100%;
        }

        /* Hero Section */
        .hero-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 100px 0 60px;
            position: relative;
            overflow: hidden;
        }

        .hero-section:before {
            content: '';
            position: absolute;
            top: -50%;
            left: -20%;
            width: 70%;
            height: 120%;
            background: radial-gradient(circle, rgba(123, 104, 238, 0.15) 0%, transparent 70%);
            z-index: -1;
        }

        .hero-section:after {
            content: '';
            position: absolute;
            bottom: -50%;
            right: -20%;
            width: 70%;
            height: 120%;
            background: radial-gradient(circle, rgba(255, 82, 82, 0.1) 0%, transparent 70%);
            z-index: -1;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            line-height: 1.2;
            margin-bottom: 25px;
        }

        .hero-title span {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-subtitle {
            font-size: 1.1rem;
            color: var(--gray);
            margin-bottom: 40px;
            max-width: 80%;
        }

        .btn {
            padding: 12px 24px;
            font-weight: 600;
            border-radius: 6px;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary), var(--primary-dark));
            box-shadow: 0 4px 15px rgba(123, 104, 238, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(123, 104, 238, 0.6);
        }

        .btn-outline-light {
            border: 2px solid rgba(255, 255, 255, 0.2);
            color: var(--light);
        }

        .btn-outline-light:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--light);
            transform: translateY(-3px);
        }

        .hero-image {
            animation: float 6s ease-in-out infinite;
            max-width: 100%;
            height: auto;
        }

        /* Features Section */
        .features-section {
            padding: 100px 0;
            background-color: var(--dark);
        }

        .section-title {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 15px;
            text-align: center;
        }

        .section-title span {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .section-subtitle {
            color: var(--gray);
            text-align: center;
            margin-bottom: 60px;
        }

        .feature-card {
            background: linear-gradient(to bottom right, rgba(30, 30, 30, 0.9), rgba(20, 20, 20, 0.9));
            border-radius: 12px;
            padding: 30px 25px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            height: 100%;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            border-color: rgba(123, 104, 238, 0.3);
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            margin: 0 auto 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(45deg, rgba(123, 104, 238, 0.15), rgba(255, 82, 82, 0.15));
            border-radius: 50%;
            font-size: 2rem;
        }

        .feature-icon i {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .feature-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--light);
        }

        .feature-description {
            color: var(--gray);
            font-size: 0.95rem;
            line-height: 1.6;
        }

        /* How It Works Section */
        .how-it-works {
            padding: 100px 0;
            background-color: var(--darker);
            position: relative;
            overflow: hidden;
        }

        .how-it-works:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 1px;
            background: linear-gradient(to right, transparent, rgba(123, 104, 238, 0.3), transparent);
        }

        .step-card {
            background: linear-gradient(to bottom right, rgba(30, 30, 30, 0.9), rgba(20, 20, 20, 0.9));
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 25px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            display: flex;
            transition: all 0.3s ease;
        }

        .step-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            border-color: rgba(123, 104, 238, 0.3);
        }

        .step-number {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1;
            margin-right: 25px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            opacity: 0.8;
        }

        .step-content h3 {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 12px;
            color: var(--light);
        }

        .step-content p {
            color: var(--gray);
            line-height: 1.6;
        }

        /* Footer */
        footer {
            background-color: var(--dark);
            padding: 60px 0 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        .footer-logo {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 20px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .footer-text {
            color: var(--gray);
            margin-bottom: 30px;
            max-width: 300px;
        }

        .footer-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 25px;
            color: var(--light);
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 15px;
        }

        .footer-links a {
            color: var(--gray);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--primary);
        }

        .social-links {
            display: flex;
            gap: 15px;
        }

        .social-link {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: rgba(123, 104, 238, 0.1);
            color: var(--primary);
            transition: all 0.3s ease;
        }

        .social-link:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-3px);
        }

        .copyright {
            text-align: center;
            color: var(--gray);
            margin-top: 50px;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        /* Animation */
        @keyframes float {
            0% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
            100% { transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 992px) {
            .hero-title {
                font-size: 2.8rem;
            }

            .hero-image {
                margin-top: 50px;
            }

            .feature-card {
                margin-bottom: 30px;
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.2rem;
            }

            .hero-subtitle {
                max-width: 100%;
            }

            .section-title {
                font-size: 1.8rem;
            }

            .step-card {
                flex-direction: column;
            }

            .step-number {
                margin-right: 0;
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
    %>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg fixed-top navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">HORIZON</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#how-it-works">How It Works</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <% if (user == null) { %>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/login" class="nav-link">Login</a>
                        </li>
                        <li class="nav-item d-grid">
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Sign Up</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/search-movie" class="nav-link">Browse Movies</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/user/profile.jsp" class="nav-link">
                                <i class="bi bi-person-circle me-2"></i><%= user.getUsername() %>
                            </a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section" id="home">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="hero-title">Experience Cinema <span>Excellence</span> at Home</h1>
                    <p class="hero-subtitle">
                        Discover a premium collection of movies from classics to blockbusters.
                        Stream instantly with our seamless platform designed for movie enthusiasts.
                    </p>
                    <div class="d-flex gap-3">
                        <% if (user == null) { %>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Get Started</a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light">Login</a>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-primary">Browse Movies</a>
                            <a href="${pageContext.request.contextPath}/rental-history" class="btn btn-outline-light">My Rentals</a>
                        <% } %>
                    </div>
                </div>
                <div class="col-lg-6">
                    <img src="https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80" alt="Hero Image" class="img-fluid hero-image rounded-3">
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="container">
            <h2 class="section-title">Why Choose <span>Horizon</span></h2>
            <p class="section-subtitle">Experience the best of modern movie rental services</p>

            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-collection-play"></i>
                        </div>
                        <h3 class="feature-title">Extensive Library</h3>
                        <p class="feature-description">
                            Access thousands of titles across multiple genres, from classic gems to the latest blockbusters.
                        </p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-stars"></i>
                        </div>
                        <h3 class="feature-title">Personalized Recommendations</h3>
                        <p class="feature-description">
                            Get movie suggestions tailored to your viewing history and preferences for a better experience.
                        </p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-speedometer2"></i>
                        </div>
                        <h3 class="feature-title">Instant Streaming</h3>
                        <p class="feature-description">
                            Rent and stream movies instantly with just a few clicks, no downloads or additional software required.
                        </p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-bookmark-star"></i>
                        </div>
                        <h3 class="feature-title">Watchlist Management</h3>
                        <p class="feature-description">
                            Keep track of movies you want to watch with our intuitive watchlist feature.
                        </p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-star"></i>
                        </div>
                        <h3 class="feature-title">Ratings & Reviews</h3>
                        <p class="feature-description">
                            Share your thoughts and read what others think about your favorite films.
                        </p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <h3 class="feature-title">Premium Membership</h3>
                        <p class="feature-description">
                            Enjoy exclusive benefits with our premium membership including reduced rates and early access.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="how-it-works" id="how-it-works">
        <div class="container">
            <h2 class="section-title">How <span>Horizon</span> Works</h2>
            <p class="section-subtitle">Start your cinematic journey in just a few simple steps</p>

            <div class="row mt-5">
                <div class="col-lg-12">
                    <div class="step-card">
                        <div class="step-number">01</div>
                        <div class="step-content">
                            <h3>Create Your Account</h3>
                            <p>Sign up for a free account to get started. Provide your basic details to personalize your experience.</p>
                        </div>
                    </div>

                    <div class="step-card">
                        <div class="step-number">02</div>
                        <div class="step-content">
                            <h3>Browse & Search Movies</h3>
                            <p>Explore our vast collection of movies. Use filters to find exactly what you're looking for by genre, release year, or ratings.</p>
                        </div>
                    </div>

                    <div class="step-card">
                        <div class="step-number">03</div>
                        <div class="step-content">
                            <h3>Rent Your Favorites</h3>
                            <p>Choose your desired rental period and make a secure payment. Enjoy immediate access to your selected movies.</p>
                        </div>
                    </div>

                    <div class="step-card">
                        <div class="step-number">04</div>
                        <div class="step-content">
                            <h3>Watch & Enjoy</h3>
                            <p>Stream your movies anytime during the rental period. Rate and review them to help other movie enthusiasts.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-5">
                    <div class="footer-logo">HORIZON</div>
                    <p class="footer-text">
                        The ultimate destination for movie lovers. Rent, watch, and discover the magic of cinema.
                    </p>
                    <div class="social-links">
                        <a href="#" class="social-link"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="social-link"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="social-link"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="social-link"><i class="bi bi-youtube"></i></a>
                    </div>
                </div>

                <div class="col-lg-2 col-md-6 mb-5">
                    <h5 class="footer-title">Quick Links</h5>
                    <ul class="footer-links">
                        <li><a href="#home">Home</a></li>
                        <li><a href="#features">Features</a></li>
                        <li><a href="#how-it-works">How It Works</a></li>
                        <li><a href="${pageContext.request.contextPath}/search-movie">Browse Movies</a></li>
                    </ul>
                </div>

                <div class="col-lg-2 col-md-6 mb-5">
                    <h5 class="footer-title">Support</h5>
                    <ul class="footer-links">
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">Contact Us</a></li>
                        <li><a href="#">FAQs</a></li>
                        <li><a href="#">Community</a></li>
                    </ul>
                </div>

                <div class="col-lg-4 col-md-6 mb-5">
                    <h5 class="footer-title">Legal</h5>
                    <ul class="footer-links">
                        <li><a href="#">Terms of Service</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Cookie Policy</a></li>
                        <li><a href="#">Content Guidelines</a></li>
                    </ul>
                </div>
            </div>

            <div class="copyright">
                <p>&copy; 2025 Horizon. All Rights Reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();

                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });

        // Navbar active state based on scroll position
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('section');
            const navLinks = document.querySelectorAll('.navbar-nav .nav-link');

            let current = '';

            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;

                if (pageYOffset >= sectionTop - 200) {
                    current = section.getAttribute('id');
                }
            });

            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href').substring(1) === current) {
                    link.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>