<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.NewRelease" %>
<%@ page import="com.movierental.model.movie.ClassicMovie" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rent Movie - FilmFlux</title>
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
                radial-gradient(circle at 90% 10%, rgba(0, 200, 255, 0.15) 0%, transparent 30%),
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
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
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
            color: var(--neon-blue);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            bottom: 0;
            left: 0;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            transform: scaleX(0);
            transform-origin: bottom right;
            transition: transform 0.3s;
        }

        .nav-link:hover::after {
            transform: scaleX(1);
            transform-origin: bottom left;
        }

        .container {
            margin-top: 30px;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid #333;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .card-header {
            background-color: var(--card-secondary);
            color: var(--neon-blue);
            font-weight: 600;
            border-bottom: 1px solid #444;
            padding: 15px 20px;
            display: flex;
            align-items: center;
        }

        .card-header i {
            margin-right: 10px;
            color: var(--neon-purple);
            font-size: 1.2rem;
        }

        .movie-info {
            padding: 20px;
            border-bottom: 1px solid #333;
        }

        .movie-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--text-primary);
        }

        .movie-details {
            color: var(--text-secondary);
            margin-bottom: 15px;
        }

        .movie-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-right: 8px;
            margin-bottom: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .badge-blue {
            background: linear-gradient(to right, #0277bd, #00c8ff);
            color: white;
        }

        .badge-purple {
            background: linear-gradient(to right, #8a2be2, #ff00ff);
            color: white;
        }

        .btn-neon {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 12px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        .btn-neon:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 200, 255, 0.5);
            color: white;
        }

        .btn-secondary {
            background-color: #333;
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary:hover {
            background-color: #444;
            transform: translateY(-3px);
        }

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        .rental-details {
            background: rgba(0, 200, 255, 0.05);
            border-radius: 12px;
            padding: 25px;
            margin: 20px 0;
            border: 1px dashed #444;
        }

        .rental-price {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--neon-blue);
            text-align: center;
            margin: 20px 0;
            text-shadow: 0 0 10px rgba(0, 200, 255, 0.5);
        }

        .rental-days-selector {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }

        .rental-days-selector .btn {
            margin: 0 5px;
            min-width: 45px;
        }

        .btn-check:checked + .btn-outline-light {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            border-color: transparent;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.4);
        }

        .btn-outline-light {
            color: var(--text-primary);
            border-color: #444;
            background-color: var(--card-secondary);
        }

        .btn-outline-light:hover {
            background-color: #444;
            color: var(--text-primary);
            border-color: #555;
        }

        .rental-info {
            margin-top: 20px;
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .rental-info p {
            margin-bottom: 8px;
        }

        .rental-info p i {
            color: var(--neon-blue);
            margin-right: 8px;
        }

        .rental-note {
            margin-top: 20px;
            padding: 15px;
            background-color: rgba(255, 0, 255, 0.05);
            border-radius: 8px;
            border: 1px solid #444;
            display: flex;
            align-items: flex-start;
        }

        .rental-note i {
            color: #ff9800;
            margin-right: 10px;
            font-size: 1.2rem;
            margin-top: 2px;
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

        // Get movie from request attribute
        Movie movie = (Movie) request.getAttribute("movie");
        if (movie == null) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        boolean isNewRelease = movie instanceof NewRelease;
        boolean isClassic = movie instanceof ClassicMovie;
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/search-movie">
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/user/profile.jsp">
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

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-cart-plus"></i> Rent Movie
                    </div>
                    <div class="movie-info">
                        <h2 class="movie-title"><%= movie.getTitle() %></h2>
                        <div class="movie-details">
                            <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                        </div>
                        <div>
                            <span class="movie-badge badge-blue"><%= movie.getGenre() %></span>
                            <% if(isNewRelease) { %>
                                <span class="movie-badge badge-purple">New Release</span>
                            <% } else if(isClassic) { %>
                                <span class="movie-badge badge-purple">Classic</span>
                            <% } %>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/rent-movie" method="post">
                            <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">

                            <div class="rental-details">
                                <h5 class="text-center mb-4">Select Rental Period</h5>

                                <div class="rental-days-selector btn-group" role="group">
                                    <input type="radio" class="btn-check" name="rentalDays" id="days1" value="1" autocomplete="off" checked>
                                    <label class="btn btn-outline-light" for="days1">1</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days3" value="3" autocomplete="off">
                                    <label class="btn btn-outline-light" for="days3">3</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days5" value="5" autocomplete="off">
                                    <label class="btn btn-outline-light" for="days5">5</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days7" value="7" autocomplete="off">
                                    <label class="btn btn-outline-light" for="days7">7</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days14" value="14" autocomplete="off">
                                    <label class="btn btn-outline-light" for="days14">14</label>
                                </div>

                                <div class="rental-price">
                                    <span id="priceDisplay">$<%= String.format("%.2f", movie.calculateRentalPrice(1)) %></span>
                                </div>

                                <div class="rental-info">
                                    <p><i class="bi bi-info-circle"></i> Base rental price is $<%= String.format("%.2f", movie.calculateRentalPrice(1)) %> per day.</p>
                                    <% if(isNewRelease) { %>
                                        <p><i class="bi bi-star"></i> New releases have a premium rental rate.</p>
                                    <% } else if(isClassic) { %>
                                        <p><i class="bi bi-award"></i> Classic movies have a special rental pricing.</p>
                                    <% } %>
                                </div>

                                <div class="rental-note">
                                    <i class="bi bi-exclamation-circle"></i>
                                    <p class="mb-0">Late returns will incur additional fees. Please return the movie by the due date.</p>
                                </div>
                            </div>

                            <div class="mt-4 d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-neon">
                                    <i class="bi bi-cart-check"></i> Confirm Rental
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update price display based on rental days selection
        document.addEventListener('DOMContentLoaded', function() {
            const basePricePerDay = <%= movie.calculateRentalPrice(1) %>;
            const radios = document.querySelectorAll('input[name="rentalDays"]');
            const priceDisplay = document.getElementById('priceDisplay');

            radios.forEach(radio => {
                radio.addEventListener('change', function() {
                    const days = parseInt(this.value);
                    const totalPrice = (basePricePerDay * days).toFixed(2);
                    priceDisplay.textContent = '$' + totalPrice;
                });
            });
        });
    </script>
</body>
</html>