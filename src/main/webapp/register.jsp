<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <!-- Using Font Awesome only for icons to reduce load time -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: white; /* Default background is white */
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        /* Create the right triangle with gradient background */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #ff5e62, #a445b2, #2d9cdb); /* Gradient like Stripe */
            clip-path: polygon(0 0, 100% 0, 0 100%); /* Creates a right triangle */
            z-index: -1; /* Place behind the content */
        }

        .ems {
            position: absolute;
            top: 20px;
            left: 20px;
            z-index: 1; /* Ensure it appears above the background */
        }

        .ems h1 {
            font-size: 24px; /* Match the size of the "stripe" logo */
            font-weight: 600;
            color: white; /* White to contrast with the gradient background */
            margin: 0;
            text-transform: lowercase; /* Match the lowercase style of "stripe" */
        }

        .register-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            font-size: 24px;
            font-weight: 600;
            color: #1a202c;
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-size: 14px;
            color: #67748e;
            margin-bottom: 5px;
            display: block;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 5px;
            font-size: 16px;
            color: #1a202c;
        }

        input:focus {
            outline: none;
            border-color: #635bff;
        }

        .btn-register {
            width: 100%;
            padding: 12px;
            background: #635bff;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-register:hover {
            background: #4c47d7;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
        }

        .login-link a {
            color: #635bff;
            text-decoration: none;
            font-size: 14px;
        }

        .error {
            color: #dc3545;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .error ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .error li {
            margin-bottom: 5px;
        }

        /* Responsive Design */
        @media (max-width: 576px) {
            .register-container {
                padding: 20px;
                margin: 20px;
                max-width: 90%;
            }

            .ems {
                top: 15px;
                left: 15px;
            }

            .ems h1 {
                font-size: 20px; /* Slightly smaller on mobile */
            }

            h2 {
                font-size: 20px;
            }

            input[type="text"],
            input[type="email"],
            input[type="password"] {
                font-size: 14px;
                padding: 8px;
            }

            .btn-register {
                font-size: 14px;
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="ems">
        <h1>EMS</h1>
    </div>

    <div class="register-container">
        <h2>Create an account</h2>

        <!-- Display Errors -->
        <c:if test="${not empty errors}">
            <div class="error">
                <ul>
                    <c:forEach var="error" items="${errors}">
                        <li>${error}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username">
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password">
            </div>
            <button type="submit" class="btn-register">Register</button>
        </form>

        <div class="login-link">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
        </div>
    </div>
</body>
</html>