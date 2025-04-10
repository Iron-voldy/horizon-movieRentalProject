<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fas fa-film"></i> Horizon Movie Rental
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/search-movie">Movies</a>
                </li>
                <c:if test="${not empty sessionScope.userId}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="watchlistDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Watchlist
                        </a>
                        <div class="dropdown-menu" aria-labelledby="watchlistDropdown">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/view-watchlist">View Watchlist</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/recently-watched">Recently Watched</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="rentalDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Rentals
                        </a>
                        <div class="dropdown-menu" aria-labelledby="rentalDropdown">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/rental-history">Rental History</a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="recommendationsDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Recommendations
                        </a>
                        <div class="dropdown-menu" aria-labelledby="recommendationsDropdown">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/view-recommendations?type=personal">Personal Recommendations</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/view-recommendations?type=general">General Recommendations</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/top-rated">Top Rated Movies</a>
                        </div>
                    </li>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-user-circle"></i> ${sessionScope.username}
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/update-profile">My Profile</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/user-reviews">My Reviews</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Display success message if present -->
<c:if test="${not empty sessionScope.successMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.successMessage}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <c:remove var="successMessage" scope="session" />
</c:if>

<!-- Display error message if present -->
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.errorMessage}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <c:remove var="errorMessage" scope="session" />
</c:if>

<!-- Display info message if present -->
<c:if test="${not empty sessionScope.infoMessage}">
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        ${sessionScope.infoMessage}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <c:remove var="infoMessage" scope="session" />
</c:if>