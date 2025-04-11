<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.rental.Transaction" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Rentals - Movie Rental System</title>
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

        .btn-sm {
            padding: 5px 10px;
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

        .rental-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .rental-table th {
            color: var(--neon-blue);
            font-weight: 600;
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #333;
        }

        .rental-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #333;
            vertical-align: middle;
        }

        .rental-table tr:last-child td {
            border-bottom: none;
        }

        .rental-table tbody tr {
            transition: background-color 0.2s;
        }

        .rental-table tbody tr:hover {
            background-color: rgba(0, 200, 255, 0.05);
        }

        .movie-title {
            font-weight: 600;
            color: var(--text-primary);
        }

        .movie-director {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .badge-blue {
            background: linear-gradient(to right, #0277bd, #00c8ff);
            color: white;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-green {
            background: linear-gradient(to right, #4CAF50, #8BC34A);
            color: white;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-red {
            background: linear-gradient(to right, #F44336, #FF5722);
            color: white;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-yellow {
            background: linear-gradient(to right, #FFC107, #FFD54F);
            color: #333;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-purple {
            background: linear-gradient(to right, #9C27B0, #673AB7);
            color: white;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .action-button {
            padding: 5px 10px;
            border-radius: 5px;
            transition: all 0.2s;
            text-decoration: none;
            color: var(--text-primary);
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
        }

        .action-button i {
            margin-right: 5px;
        }

        .action-button.return {
            background-color: var(--neon-blue);
            color: white;
        }

        .action-button.return:hover {
            background-color: #0099cc;
            transform: translateY(-2px);
        }

        .action-button.edit {
            background-color: #9C27B0;
            color: white;
        }

        .action-button.edit:hover {
            background-color: #7B1FA2;
            transform: translateY(-2px);
        }

        .action-button.cancel {
            background-color: #F44336;
            color: white;
        }

        .action-button.cancel:hover {
            background-color: #D32F2F;
            transform: translateY(-2px);
        }

        .action-button.view {
            background-color: #444;
        }

        .action-button.view:hover {
            background-color: #555;
            transform: translateY(-2px);
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
        }

        .empty-state i {
            font-size: 4rem;
            color: #444;
            margin-bottom: 20px;
        }

        .empty-message {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--neon-blue);
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: var(--neon-purple);
        }

        .section-divider {
            border-top: 1px solid #333;
            margin: 30px 0;
        }

        .date-info, .fee-info {
            color: var(--text-secondary);
            font-size: 0.85rem;
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

        // Get data from request attributes
        List<Transaction> activeRentals = (List<Transaction>) request.getAttribute("activeRentals");
        List<Transaction> rentalHistory = (List<Transaction>) request.getAttribute("rentalHistory");
        List<Transaction> overdueRentals = (List<Transaction>) request.getAttribute("overdueRentals");
        List<Transaction> canceledRentals = (List<Transaction>) request.getAttribute("canceledRentals");
        Map<String, Movie> movieMap = (Map<String, Movie>) request.getAttribute("movieMap");

        // Ensure the lists are not null
        activeRentals = activeRentals != null ? activeRentals : new ArrayList<>();
        rentalHistory = rentalHistory != null ? rentalHistory : new ArrayList<>();
        overdueRentals = overdueRentals != null ? overdueRentals : new ArrayList<>();
        canceledRentals = canceledRentals != null ? canceledRentals : new ArrayList<>();

        // Date formatter
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
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
        <!-- Flash messages -->
        <%
            // Check for messages from session
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");

            if(successMessage != null) {
                out.println("<div class='alert alert-success'>");
                out.println("<i class='bi bi-check-circle-fill me-2'></i>");
                out.println(successMessage);
                out.println("</div>");
                session.removeAttribute("successMessage");
            }

            if(errorMessage != null) {
                out.println("<div class='alert alert-danger'>");
                out.println("<i class='bi bi-exclamation-triangle-fill me-2'></i>");
                out.println(errorMessage);
                out.println("</div>");
                session.removeAttribute("errorMessage");
            }
        %>

        <div class="card">
            <div class="card-header">
                <i class="bi bi-collection-play"></i> My Rentals
            </div>
            <div class="card-body p-4">
                <% if (overdueRentals != null && !overdueRentals.isEmpty()) { %>
                    <h2 class="section-title text-danger">
                        <i class="bi bi-exclamation-triangle-fill"></i> Overdue Rentals
                    </h2>
                    <div class="table-responsive">
                        <table class="rental-table">
                            <thead>
                                <tr>
                                    <th>Movie</th>
                                    <th>Rental Date</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Transaction rental : overdueRentals) {
                                    if (movieMap != null) {
                                        Movie movie = movieMap.get(rental.getMovieId());
                                        if (movie != null) {

                                            // Calculate days overdue
                                            long diffInMillies = new Date().getTime() - rental.getDueDate().getTime();
                                            int daysOverdue = (int) (diffInMillies / (1000 * 60 * 60 * 24)) + 1; // +1 to include the due date
                                %>
                                    <tr>
                                        <td>
                                            <div class="movie-title"><%= movie.getTitle() %></div>
                                            <div class="movie-director"><%= movie.getDirector() %> (<%= movie.getReleaseYear() %>)</div>
                                        </td>
                                        <td>
                                            <div><%= dateFormat.format(rental.getRentalDate()) %></div>
                                            <div class="date-info">Rental ID: <%= rental.getTransactionId().substring(0, 8) %>...</div>
                                        </td>
                                        <td>
                                            <div><%= dateFormat.format(rental.getDueDate()) %></div>
                                            <div class="date-info text-danger"><%= daysOverdue %> days overdue</div>
                                        </td>
                                        <td><span class="badge-red">Overdue</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="<%= request.getContextPath() %>/return-movie?id=<%= rental.getTransactionId() %>" class="action-button return">
                                                    <i class="bi bi-box-arrow-in-left"></i> Return
                                                </a>
                                                <a href="<%= request.getContextPath() %>/edit-rental?id=<%= rental.getTransactionId() %>" class="action-button edit">
                                                    <i class="bi bi-pencil"></i> Edit
                                                </a>
                                                <a href="<%= request.getContextPath() %>/cancel-rental?id=<%= rental.getTransactionId() %>" class="action-button cancel">
                                                    <i class="bi bi-x-circle"></i> Cancel
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                } %>
                            </tbody>
                        </table>
                    </div>
                    <div class="section-divider"></div>
                <% } %>

                <h2 class="section-title">
                    <i class="bi bi-film"></i> Currently Rented
                </h2>
                <% if (activeRentals != null && !activeRentals.isEmpty() && movieMap != null) { %>
                    <div class="table-responsive">
                        <table class="rental-table">
                            <thead>
                                <tr>
                                    <th>Movie</th>
                                    <th>Rental Date</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Transaction rental : activeRentals) {
                                    // Skip if already in overdue section
                                    if (rental.isOverdue()) {
                                        continue;
                                    }

                                    Movie movie = movieMap.get(rental.getMovieId());
                                    if (movie != null) {

                                        // Calculate days remaining
                                        long diffInMillies = rental.getDueDate().getTime() - new Date().getTime();
                                        int daysRemaining = (int) (diffInMillies / (1000 * 60 * 60 * 24)) + 1; // +1 to include today
                                        String daysRemainingText = daysRemaining + " day" + (daysRemaining > 1 ? "s" : "") + " remaining";
                                %>
                                    <tr>
                                        <td>
                                            <div class="movie-title"><%= movie.getTitle() %></div>
                                            <div class="movie-director"><%= movie.getDirector() %> (<%= movie.getReleaseYear() %>)</div>
                                        </td>
                                        <td>
                                            <div><%= dateFormat.format(rental.getRentalDate()) %></div>
                                            <div class="date-info">Rental ID: <%= rental.getTransactionId().substring(0, 8) %>...</div>
                                        </td>
                                        <td>
                                            <div><%= dateFormat.format(rental.getDueDate()) %></div>
                                            <div class="date-info">
                                                <% if (daysRemaining > 3) { %>
                                                    <span class="text-success"><%= daysRemainingText %></span>
                                                <% } else { %>
                                                    <span class="text-warning"><%= daysRemainingText %></span>
                                                <% } %>
                                            </div>
                                        </td>
                                        <td>
                                            <% if (daysRemaining > 3) { %>
                                                <span class="badge-green">Active</span>
                                            <% } else { %>
                                                <span class="badge-yellow">Due Soon</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="<%= request.getContextPath() %>/return-movie?id=<%= rental.getTransactionId() %>" class="action-button return">
                                                    <i class="bi bi-box-arrow-in-left"></i> Return
                                                </a>
                                                <a href="<%= request.getContextPath() %>/edit-rental?id=<%= rental.getTransactionId() %>" class="action-button edit">
                                                    <i class="bi bi-pencil"></i> Edit
                                                </a>
                                                <a href="<%= request.getContextPath() %>/cancel-rental?id=<%= rental.getTransactionId() %>" class="action-button cancel">
                                                    <i class="bi bi-x-circle"></i> Cancel
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                    }
                                } %>
                            </tbody>
                        </table>
                    </div>
                <% } else if (overdueRentals == null || overdueRentals.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-collection-play"></i>
                        <p class="empty-message">You don't have any active rentals</p>
                        <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-neon">
                            <i class="bi bi-search"></i> Browse Movies
                        </a>
                    </div>
                <% } %>

                <% if (canceledRentals != null && !canceledRentals.isEmpty() && movieMap != null) { %>
                    <div class="section-divider"></div>
                    <h2 class="section-title">
                        <i class="bi bi-x-circle"></i> Canceled Rentals
                    </h2>
                    <div class="table-responsive">
                        <table class="rental-table">
                            <thead>
                                <tr>
                                    <th>Movie</th>
                                    <th>Rental Period</th>
                                    <th>Cancellation Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Transaction rental : canceledRentals) {
                                    Movie movie = movieMap.get(rental.getMovieId());
                                    if (movie != null) {
                                %>
                                    <tr>
                                        <td>
                                            <div class="movie-title"><%= movie.getTitle() %></div>
                                            <div class="movie-director"><%= movie.getDirector() %> (<%= movie.getReleaseYear() %>)</div>
                                        </td>
                                        <td>
                                            <div><%= dateFormat.format(rental.getRentalDate()) %></div>
                                            <div class="date-info">Due: <%= dateFormat.format(rental.getDueDate()) %></div>
                                        </td>
                                        <td>
                                            <div><%= dateFormat.format(rental.getCancellationDate()) %></div>
                                            <div class="date-info">
                                                <% if(rental.getCancellationReason() != null && !rental.getCancellationReason().isEmpty()) { %>
                                                    <span>Reason: <%= rental.getCancellationReason() %></span>
                                                <% } else { %>
                                                    <span>No reason provided</span>
                                                <% } %>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge-purple">Canceled</span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="action-button view">
                                                    <i class="bi bi-info-circle"></i> Details
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                    }
                                } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>

                <% if (rentalHistory != null && !rentalHistory.isEmpty() && movieMap != null) { %>
                    <div class="section-divider"></div>
                    <h2 class="section-title">
                        <i class="bi bi-clock-history"></i> Rental History
                    </h2>
                    <div class="table-responsive">
                        <table class="rental-table">
                            <thead>
                                <tr>
                                    <th>Movie</th>
                                    <th>Rental Period</th>
                                    <th>Return Date</th>
                                    <th>Fees</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Transaction rental : rentalHistory) {
                                    Movie movie = movieMap.get(rental.getMovieId());
                                    if (movie != null) {
                                %>
                                    <tr>
                                        <td>
                                            <div class="movie-title"><%= movie.getTitle() %></div>
                                            <div class="movie-director"><%= movie.getDirector() %> (<%= movie.getReleaseYear() %>)</div>
                                        </td>
                                        <td>
                                            <div><%= dateFormat.format(rental.getRentalDate()) %></div>
                                            <div class="date-info">Due: <%= dateFormat.format(rental.getDueDate()) %></div>
                                        </td>
                                        <td>
                                            <div><%= dateFormat.format(rental.getReturnDate()) %></div>
                                            <div class="date-info">
                                                <% if(rental.calculateDaysOverdue() > 0) { %>
                                                    <span class="text-danger"><%= rental.calculateDaysOverdue() %> days late</span>
                                                <% } else { %>
                                                    <span class="text-success">On time</span>
                                                <% } %>
                                            </div>
                                        </td>
                                        <td>
                                            <div>Rental: $<%= String.format("%.2f", rental.getRentalFee()) %></div>
                                            <% if(rental.getLateFee() > 0) { %>
                                                <div class="fee-info text-danger">Late fee: $<%= String.format("%.2f", rental.getLateFee()) %></div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="action-button view">
                                                    <i class="bi bi-info-circle"></i> Details
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                    }
                                } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>