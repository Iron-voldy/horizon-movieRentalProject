<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>404 - Page Not Found</title>
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
            box-shadow: 0 0 20px rgba(0,200,255,0.3);
        }
        h1 {
            color: #00c8ff;
            font-size: 4rem;
        }
        p {
            color: #a0a0a0;
        }
        a {
            color: #8a2be2;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>404</h1>
        <h2>Page Not Found</h2>
        <p>Sorry, the page you are looking for might have been removed or is temporarily unavailable.</p>
        <a href="/">Return to Home</a>
    </div>
</body>
</html>