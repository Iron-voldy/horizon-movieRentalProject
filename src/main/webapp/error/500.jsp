<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>500 - Internal Server Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #121212;
            color: #e0e0e0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }
        .error-container {
            background-color: #1e1e1e;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(255,0,0,0.3);
        }
        h1 {
            color: #ff0000;
            font-size: 4rem;
        }
        p {
            color: #a0a0a0;
        }
        a {
            color: #8a2be2;
            text-decoration: none;
        }
        .error-details {
            margin-top: 20px;
            font-size: 0.8rem;
            color: #ff6666;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>500</h1>
        <h2>Internal Server Error</h2>
        <p>Something went wrong on our end. Our team has been notified.</p>
        <a href="/">Return to Home</a>

        <% if (exception != null) { %>
            <div class="error-details">
                <h3>Error Details:</h3>
                <p><%= exception.getMessage() %></p>
            </div>
        <% } %>
    </div>
</body>
</html>