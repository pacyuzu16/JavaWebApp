<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: white;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #ff5e62, #a445b2, #2d9cdb);
            clip-path: polygon(0 0, 100% 0, 0 100%);
            z-index: -1;
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

        .reset-container {
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

        .error {
            color: #dc3545;
            font-size: 14px;
            margin-bottom: 20px;
            text-align: center;
        }

        .btn-reset {
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

        .btn-reset:hover {
            background: #4c47d7;
        }

        .back-to-login {
            text-align: center;
            margin-top: 20px;
        }

        .back-to-login a {
            color: #635bff;
            text-decoration: none;
            font-size: 14px;
        }

        @media (max-width: 576px) {
            .reset-container {
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

            input[type="password"] {
                font-size: 14px;
                padding: 8px;
            }

            .btn-reset {
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

    <div class="reset-container">
        <h2>Reset Your Password</h2>

        <!-- Display Error Messages -->
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <input type="hidden" name="token" value="${param.token}"/>
            <div class="form-group">
                <label for="password">New Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="btn-reset">Reset Password</button>
        </form>

        <div class="back-to-login">
            <p><a href="${pageContext.request.contextPath}/login">Back to Sign in</a></p>
        </div>
    </div>
</body>
</html>