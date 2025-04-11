<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>

<style>
    :root {
        --primary-color: #6C63FF;
        --secondary-color: #FF6584;
        --background-dark: #121212;
        --navbar-bg: rgba(30, 30, 30, 0.8);
        --text-primary: #FFFFFF;
        --text-secondary: #B0B0B0;
        --accent-color: #00C8FF;
    }

    .navbar {
        background-color: var(--navbar-bg) !important;
        backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(255,255,255,0.1);
        transition: all 0.3s ease;
    }

    .navbar-brand {
        color: var(--text-primary) !important;
        font-weight: 700;
        background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        transition: all 0.3s ease;
    }

    .navbar-brand:hover {
        transform: scale(1.05);
    }

    .navbar-dark .navbar-nav .nav-link {
        color: var(--text-secondary) !important;
        transition: all 0.3s ease;
        position: relative;
    }

    .navbar-dark .navbar-nav .nav-link:hover,
    .navbar-dark .navbar-nav .nav-link.active {
        color: var(--text-primary) !important;
    }

    .navbar-dark .navbar-nav .nav-link::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 0;
        height: 2px;
        background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
        transition: width 0.3s ease;
    }

    .navbar-dark .navbar-nav .nav-link:hover::after,
    .navbar-dark .navbar-nav .nav-link.active::after {
        width: 100%;
    }

    .navbar-dark .navbar-toggler {
        border-color: rgba(255,255,255,0.1);
    }

    .navbar-dark .navbar-toggler-icon {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg viewBox='0 0 30 30' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='rgba(255,255,255,0.7)' stroke-width='2' stroke-linecap='round' stroke-miterlimit='10' d='M4 7h22M4 15h22M4 23h22'/%3E%3C/svg%3E");
    }

    .dropdown-menu {
        background-color: var(--background-dark);
        border: 1px solid rgba(255,255,255,0.1);
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    }

    .dropdown-menu .dropdown-item {
        color: var(--text-secondary);
        transition: all 0.3s ease;
    }

    .dropdown-menu .dropdown-item:hover,
    .dropdown-menu .dropdown-item:focus {
        background-color: rgba(255,255,255,0.1);
        color: var(--text-primary);
    }

    .dropdown-menu .dropdown-divider {
        border-top-color: rgba(255,255,255,0.1);
    }

    @media (max-width: 992px) {
        .navbar {
            background-color: var(--background-dark) !important;
            backdrop-filter: none;
        }
    }
</style>

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
                <%
                    String currentUri = request.getRequestURI();
                    boolean isRecommendationPage = currentUri.contains("/recommendation/") ||
                                                  request.getServletPath().contains("recommendations") ||
                                                  request.getServletPath().contains("top-rated") ||
                                                  request.getServletPath().contains("genre-recommendations");
                %>
               <li class="nav-item dropdown">
                   <a class="nav-link dropdown-toggle <%= isRecommendationPage ? "active" : "" %>" href="#" id="recommendationsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                       <i class="bi bi-lightning-fill"></i> Recommendations
                   </a>
                   <ul class="dropdown-menu" aria-labelledby="recommendationsDropdown">
                       <li><a class="dropdown-item" href="<%= request.getContextPath() %>/view-recommendations">View Recommendations</a></li>
                       <li><a class="dropdown-item" href="<%= request.getContextPath() %>/top-rated">Top Rated</a></li>
                       <li><hr class="dropdown-divider"></li>
                       <li><a class="dropdown-item" href="<%= request.getContextPath() %>/manage-recommendations">Manage Recommendations</a></li>
                       <li><a class="dropdown-item" href="<%= request.getContextPath() %>/manage-recommendations?action=add&type=general">Add Recommendation</a></li>
                   </ul>
               </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <%
                    User currentUser = (User) session.getAttribute("user");
                    if (currentUser != null) {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/user/profile.jsp">
                            <i class="bi bi-person-circle"></i> <%= currentUser.getUsername() %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/login">
                            <i class="bi bi-box-arrow-in-right"></i> Login
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/register">
                            <i class="bi bi-person-plus"></i> Register
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>