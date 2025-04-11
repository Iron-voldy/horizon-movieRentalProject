<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.rental.Transaction" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Rental - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
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
            margin-bottom: 20px;
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
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--text-primary);
        }

        .movie-details {
            color: var(--text-secondary);
            margin-bottom: 15px;
        }

        .form-label {
            color: var(--neon-blue);
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
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
        }

        .btn-neon {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        .btn-neon:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(0, 200, 255, 0.6);
            color: white;
        }

        .btn-secondary {
            background-color: #444;
            border: none;
        }

        .btn-secondary:hover {
            background-color: #555;
        }

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        .rental-details {
            background: rgba(0, 200, 255, 0.05);
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            border: 1px dashed #444;
        }

        .rental-price {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--neon-blue);
            text-align: center;
            margin: 20px 0;
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

        .rental-info {
            margin-top: 20px;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .rental-note {
            margin-top: 15px;
            padding: 15px;
            background-color: rgba(255, 0, 255, 0.05);
            border-radius: 8px;
            border: 1px solid #444;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #333;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: var(--text-secondary);
        }

        .info-value {
            font-weight: 500;
        }

        .edit-icon {
            font-size: 3rem;
            color: var(--neon-blue);
            display: block;
            text-align: center;
            margin-bottom: 10px;
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

        // Get transaction and movie from request attributes
        Transaction transaction = (Transaction) request.getAttribute("transaction");
        Movie movie = (Movie) request.getAttribute("movie");
        Integer rentalDuration = (Integer) request.getAttribute("rentalDuration");

        if (transaction == null || movie == null) {
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
        String rentalDate = dateFormat.format(transaction.getRentalDate());
        String dueDate = dateFormat.format(transaction.getDueDate());

        // Calculate rental duration if not provided
        if (rentalDuration == null) {
            rentalDuration = transaction.getRentalDuration();
        }
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/rental-history">
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
                        <i class="bi bi-pencil-square"></i> Edit Rental
                    </div>
                    <div class="movie-info">
                        <h2 class="movie-title"><%= movie.getTitle() %></h2>
                        <div class="movie-details">
                            <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mb-4">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <i class="bi bi-calendar-check edit-icon"></i>

                        <div class="rental-details">
                            <div class="info-row">
                                <div class="info-label">Rental Date:</div>
                                <div class="info-value"><%= rentalDate %></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Current Due Date:</div>
                                <div class="info-value"><%= dueDate %></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Current Rental Fee:</div>
                                <div class="info-value">$<%= String.format("%.2f", transaction.getRentalFee()) %></div>
                            </div>
                        </div>

                        <form action="<%= request.getContextPath() %>/edit-rental" method="post">
                            <input type="hidden" name="transactionId" value="<%= transaction.getTransactionId() %>">

                            <div class="rental-details">
                                <h5 class="text-center mb-4">Update Rental Period</h5>

                                <div class="rental-days-selector btn-group" role="group">
                                    <input type="radio" class="btn-check" name="rentalDays" id="days1" value="1" <%= (rentalDuration == 1) ? "checked" : "" %> autocomplete="off">
                                    <label class="btn btn-outline-light" for="days1">1</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days3" value="3" <%= (rentalDuration == 3) ? "checked" : "" %> autocomplete="off">
                                    <label class="btn btn-outline-light" for="days3">3</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days5" value="5" <%= (rentalDuration == 5) ? "checked" : "" %> autocomplete="off">
                                    <label class="btn btn-outline-light" for="days5">5</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days7" value="7" <%= (rentalDuration == 7) ? "checked" : "" %> autocomplete="off">
                                    <label class="btn btn-outline-light" for="days7">7</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days14" value="14" <%= (rentalDuration == 14) ? "checked" : "" %> autocomplete="off">
                                    <label class="btn btn-outline-light" for="days14">14</label>

                                    <input type="radio" class="btn-check" name="rentalDays" id="days30" value="30" <%= (rentalDuration == 30) ? "checked" : "" %> autocomplete="off">
                                    <label class="btn btn-outline-light" for="days30">30</label>
                                </div>

                                <div class="rental-price">
                                    <span id="priceDisplay">$<%= String.format("%.2f", movie.calculateRentalPrice(rentalDuration)) %></span>
                                </div>

                                <div class="rental-info">
                                    <p>Base rental price is $<%= String.format("%.2f", movie.calculateRentalPrice(1)) %> per day.</p>
                                </div>

                                <div class="rental-note">
                                    <p class="mb-0"><i class="bi bi-info-circle me-2"></i> Changing the rental period will update the due date and may adjust the rental fee.</p>
                                </div>
                            </div>

                            <div class="mt-4 d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/rental-history" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-neon">
                                    <i class="bi bi-save"></i> Update Rental
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
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