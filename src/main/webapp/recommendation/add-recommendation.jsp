<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Recommendation - Movie Rental System</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #6C63FF;
            --secondary-color: #FF6584;
            --background-dark: #121212;
            --card-background: #1E1E1E;
            --text-primary: #FFFFFF;
            --text-secondary: #B0B0B0;
            --accent-color: #00C8FF;
        }

        body {
            background-color: var(--background-dark);
            color: var(--text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .page-header {
            background: linear-gradient(135deg, rgba(108, 99, 255, 0.1), rgba(255, 101, 132, 0.1));
            padding: 4rem 0;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .page-header h1 {
            font-weight: 700;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
        }

        .card {
            background-color: var(--card-background);
            border: 1px solid rgba(255,255,255,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.3);
        }

        .card-header {
            background-color: rgba(30,30,30,0.8);
            color: var(--text-primary);
            border-bottom: 1px solid rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
        }

        .card-header i {
            margin-right: 10px;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .form-label {
            color: var(--accent-color);
            font-weight: 500;
        }

        .form-control, .form-select {
            background-color: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            color: var(--text-primary);
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            background-color: rgba(255,255,255,0.1);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(108, 99, 255, 0.25);
            color: var(--text-primary);
        }

        .form-text {
            color: var(--text-secondary);
        }

        .additional-settings {
            background-color: rgba(30,30,30,0.5);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .additional-settings h5 {
            color: var(--accent-color);
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .additional-settings h5 i {
            margin-right: 10px;
            color: var(--primary-color);
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(108, 99, 255, 0.3);
        }

        .btn-secondary {
            background-color: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.1);
            color: var(--text-secondary);
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: rgba(255,255,255,0.2);
            color: var(--text-primary);
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.2);
            border-color: rgba(220, 53, 69, 0.3);
            color: #ff6b6b;
        }

        @media (max-width: 768px) {
            .page-header {
                padding: 2rem 0;
            }
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
        String recommendationType = (String) request.getAttribute("recommendationType");
        List<Movie> allMovies = (List<Movie>) request.getAttribute("allMovies");

        boolean isPersonal = "personal".equals(recommendationType);
        List<User> allUsers = null;

        if (isPersonal) {
            allUsers = (List<User>) request.getAttribute("allUsers");
        }
    %>

    <!-- Navigation Bar -->
    <jsp:include page="../includes/navbar.jsp" />

    <div class="container mt-4">
        <!-- Error message -->
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if(errorMessage != null) {
                out.println("<div class='alert alert-danger'>");
                out.println("<i class='bi bi-exclamation-triangle-fill me-2'></i>");
                out.println(errorMessage);
                out.println("</div>");
            }
        %>

        <!-- Page Header -->
        <div class="page-header mb-4">
            <h1>
                Add <%= isPersonal ? "Personal" : "General" %> Recommendation
            </h1>
            <p class="text-muted">
                <%= isPersonal ? "Create a personalized movie recommendation for a specific user" :
                                "Create a general movie recommendation for all users" %>
            </p>
        </div>

        <!-- Add Recommendation Form -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-<%= isPersonal ? "person-plus" : "plus-circle" %>"></i>
                Add New <%= isPersonal ? "Personal" : "General" %> Recommendation
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/manage-recommendations" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="recType" value="<%= recommendationType %>">

                    <div class="mb-3">
                        <label for="movieId" class="form-label">Movie</label>
                        <select class="form-select" id="movieId" name="movieId" required>
                            <option value="">-- Select a Movie --</option>
                            <% if (allMovies != null) {
                                for (Movie movie : allMovies) { %>
                                    <option value="<%= movie.getMovieId() %>">
                                        <%= movie.getTitle() %> (<%= movie.getReleaseYear() %>) - <%= movie.getDirector() %>
                                    </option>
                                <% }
                            } %>
                        </select>
                    </div>

                    <% if (isPersonal) { %>
                        <div class="mb-3">
                            <label for="userId" class="form-label">User</label>
                            <select class="form-select" id="userId" name="userId" required>
                                <option value="">-- Select a User --</option>
                                <% if (allUsers != null) {
                                    for (User u : allUsers) { %>
                                        <option value="<%= u.getUserId() %>">
                                            <%= u.getUsername() %> (<%= u.getFullName() %>)
                                        </option>
                                    <% }
                                } %>
                            </select>
                        </div>
                    <% } %>

                    <div class="mb-3">
                        <label for="reason" class="form-label">Recommendation Reason</label>
                        <textarea class="form-control" id="reason" name="reason" rows="3"
                                  placeholder="Why are you recommending this movie?" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="score" class="form-label">Recommendation Score (0.0-10.0)</label>
                        <input type="number" class="form-control" id="score" name="score"
                               min="0" max="10" step="0.1" value="8.0" required>
                    </div>

                    <!-- Additional fields based on recommendation type -->
                    <div class="additional-settings">
                        <h5 class="mb-3">
                            <i class="bi bi-sliders"></i>
                            Additional <%= isPersonal ? "Personal" : "General" %> Recommendation Settings
                        </h5>

                        <% if (isPersonal) { %>
                            <div class="mb-3">
                                <label for="baseSource" class="form-label">Recommendation Source</label>
                                <select class="form-select" id="baseSource" name="baseSource">
                                    <option value="manual">Manual</option>
                                    <option value="genre-preference">Genre Preference</option>
                                    <option value="watch-history">Watch History</option>
                                    <option value="top-rated">Top Rated</option>
                                    <option value="similar-movies">Similar Movies</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="relevanceScore" class="form-label">Relevance Score (0.0-1.0)</label>
                                <input type="number" class="form-control" id="relevanceScore" name="relevanceScore"
                                       min="0" max="1" step="0.1" value="0.7">
                                <div class="form-text small">
                                    How relevant this recommendation is to the user (higher value = more relevant)
                                </div>
                            </div>
                        <% } else { %>
                            <div class="mb-3">
                                <label for="category" class="form-label">Category</label>
                                <select class="form-select" id="category" name="category">
                                    <option value="manual">Manual</option>
                                    <option value="top-rated">Top Rated</option>
                                    <option value="new-release">New Release</option>
                                    <option value="classic">Classic</option>
                                    <option value="trending">Trending</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="rank" class="form-label">Rank</label>
                                <input type="number" class="form-control" id="rank" name="rank"
                                       min="1" max="100" step="1" value="50">
                                <div class="form-text small">
                                    Ranking position for this recommendation (lower number = higher rank)
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="<%= request.getContextPath() %>/manage-recommendations" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Add Recommendation
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>