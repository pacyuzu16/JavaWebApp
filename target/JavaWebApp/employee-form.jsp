<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${employee == null ? 'Add Employee' : 'Edit Employee'}</title>
    <!-- Using Font Awesome only for icons -->
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
            min-height: 100vh;
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

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
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
        input[type="email"] {
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
            margin-top: 5px;
            display: block;
        }

        .error-list {
            color: #dc3545;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .error-list ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .error-list li {
            margin-bottom: 5px;
        }

        .btn-save,
        .btn-cancel {
            padding: 10px 16px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
            margin-right: 10px;
        }

        .btn-save {
            background: #28a745;
            color: white;
        }

        .btn-save:hover {
            background: #218838;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
            text-decoration: none;
        }

        .btn-cancel:hover {
            background: #5a6268;
        }

        .btn-save i,
        .btn-cancel i {
            margin-right: 8px;
        }

        /* Responsive Design */
        @media (max-width: 576px) {
            .form-container {
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
            input[type="email"] {
                font-size: 14px;
                padding: 8px;
            }

            .btn-save,
            .btn-cancel {
                font-size: 12px;
                padding: 8px 12px;
            }
        }
    </style>
</head>
<body>
    <div class="ems">
        <h1>EMS</h1>
    </div>

    <div class="form-container">
        <h2>${employee == null ? 'Add Employee' : 'Edit Employee'}</h2>

        <!-- Display Errors -->
        <c:if test="${not empty errors}">
            <div class="error-list">
                <ul>
                    <c:forEach var="error" items="${errors}">
                        <li>${error}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <form action="${employee == null ? pageContext.request.contextPath.concat('/insert') : pageContext.request.contextPath.concat('/update')}" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="id" value="${employee.id}"/>
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" id="name" name="name" value="${employee.name}" required>
                <span id="nameError" class="error"></span>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${employee.email}" required>
                <span id="emailError" class="error"></span>
            </div>
            <div class="form-group">
                <label for="country">Country</label>
                <input type="text" id="country" name="country" value="${employee.country}" required>
                <span id="countryError" class="error"></span>
            </div>
            <button type="submit" class="btn-save"><i class="fas fa-save"></i>Save</button>
            <a href="${pageContext.request.contextPath}/" class="btn-cancel"><i class="fas fa-times"></i>Cancel</a>
        </form>
    </div>

    <script>
        function validateForm() {
            let isValid = true;
            const name = document.getElementById("name").value.trim();
            const email = document.getElementById("email").value.trim();
            const country = document.getElementById("country").value.trim();

            // Reset error messages
            document.getElementById("nameError").innerText = "";
            document.getElementById("emailError").innerText = "";
            document.getElementById("countryError").innerText = "";

            // Validate Name
            if (name === "") {
                document.getElementById("nameError").innerText = "Name is required";
                isValid = false;
            }

            // Validate Email
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                document.getElementById("emailError").innerText = "Please enter a valid email";
                isValid = false;
            }

            // Validate Country
            if (country === "") {
                document.getElementById("countryError").innerText = "Country is required";
                isValid = false;
            }

            return isValid;
        }
    </script>
</body>
</html>