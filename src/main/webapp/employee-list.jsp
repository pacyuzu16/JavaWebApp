<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Management</title>
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
            position: relative;
            overflow-x: hidden;
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

        .container {
            padding: 30px;
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
        }

        h1 {
            font-size: 28px;
            font-weight: 600;
            color: #1a202c;
            margin-bottom: 20px;
        }

        .welcome-section {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
        }

        .welcome-section p {
            font-size: 14px;
            color: black;
            margin: 0;
        }

        .btn-logout {
            background: #635bff;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
            margin-left: 10px;
            text-decoration: none;
        }

        .btn-logout:hover {
            background: #4c47d7;
        }

        .btn-logout i {
            margin-right: 8px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-input {
            flex: 1;
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 5px;
            font-size: 14px;
            color: #1a202c;
        }

        .search-input:focus {
            outline: none;
            border-color: #635bff;
        }

        .btn-search,
        .btn-clear,
        .btn-add,
        .btn-bin {
            padding: 10px 16px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-search {
            background: #28a745;
            color: white;
        }

        .btn-search:hover {
            background: #218838;
        }

        .btn-clear {
            background: #6c757d;
            color: white;
        }

        .btn-clear:hover {
            background: #5a6268;
        }

        .btn-add {
            background: #28a745;
            color: white;
            text-decoration: none;
        }

        .btn-add:hover {
            background: #218838;
        }

        .btn-bin {
            background: #dc3545;
            color: white;
            text-decoration: none;
        }

        .btn-bin:hover {
            background: #c82333;
        }

        .btn-search i,
        .btn-clear i,
        .btn-add i,
        .btn-bin i {
            margin-right: 8px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .table th,
        .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #d1d5db;
        }

        .table th {
            background: #1a202c;
            color: white;
            font-weight: 500;
        }

        .table td {
            color: #1a202c;
        }

        .table a {
            color: white;
            text-decoration: none;
        }

        .table a:hover {
            text-decoration: underline;
        }

        .sort-icon {
            display: inline-block;
            margin-left: 5px;
            color: #a0aec0;
        }

        .btn-edit,
        .btn-delete {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
        }

        .btn-edit {
            background: #28a745;
            color: white;
            margin-right: 5px;
        }

        .btn-edit:hover {
            background: #218838;
        }

        .btn-delete {
            background: #6c757d;
            color: white;
        }

        .btn-delete:hover {
            background: #5a6268;
        }

        .btn-edit i,
        .btn-delete i {
            margin-right: 8px;
        }

        .no-employees {
            text-align: center;
            color: #67748e;
            padding: 20px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 5px;
        }

        .page-item {
            list-style: none;
        }

        .page-link {
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 5px;
            color: #1a202c;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
        }

        .page-link:hover {
            background: #f1f1f1;
            border-color: #ccc;
        }

        .page-item.active .page-link {
            background: #635bff;
            color: white;
            border-color: #635bff;
        }

        .page-item.disabled .page-link {
            color: #6c757d;
            background: #e9ecef;
            border-color: #ddd;
            cursor: not-allowed;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }

        .modal.show {
            display: block;
        }

        .modal-dialog {
            max-width: 500px;
            margin: 100px auto;
        }

        .modal-content {
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        .modal-header {
            padding: 15px 20px;
            border-bottom: 1px solid #d1d5db;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a202c;
        }

        .btn-close {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #67748e;
        }

        .modal-body {
            padding: 20px;
            font-size: 14px;
            color: #1a202c;
        }

        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #d1d5db;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-modal-cancel,
        .btn-modal-confirm {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-modal-cancel {
            background: #28a745;
            color: white;
        }

        .btn-modal-cancel:hover {
            background: #218838;
        }

        .btn-modal-confirm {
            background: #635bff;
            color: white;
        }

        .btn-modal-confirm:hover {
            background: #4c47d7;
        }

        .btn-modal-cancel i,
        .btn-modal-confirm i {
            margin-right: 8px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            h1 {
                font-size: 24px;
            }

            .search-form {
                flex-direction: column;
            }

            .btn-search,
            .btn-clear {
                width: 100%;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-add,
            .btn-bin {
                width: 100%;
                text-align: center;
            }

            .table th,
            .table td {
                font-size: 12px;
                padding: 8px;
            }

            .btn-edit,
            .btn-delete {
                font-size: 12px;
                padding: 4px 8px;
            }

            .page-link {
                font-size: 12px;
                padding: 6px 10px;
            }
        }

        @media (max-width: 576px) {
            .table {
                font-size: 10px;
            }

            .table th,
            .table td {
                padding: 6px;
            }

            .btn-edit,
            .btn-delete {
                font-size: 10px;
                padding: 3px 6px;
            }

            .ems {
                top: 15px;
                left: 15px;
            }

            .ems h1 {
                font-size: 20px; /* Slightly smaller on mobile */
            }
        }
    </style>
</head>
<body>
    <div class="ems">
        <h1>ems</h1>
    </div>

    <div class="container">
        <h1>
            
             <!-- Display Welcome Message and Logout Link -->
        <c:if test="${not empty sessionScope.user}">
            <div class="welcome-section">
                <p>Welcome, ${sessionScope.user.username}!</p>
                <a href="#" class="btn-logout" data-bs-toggle="modal" data-bs-target="#logoutModal"><i class="fas fa-sign-out-alt"></i>Logout</a>
            </div>
        </c:if>
            
        </h1>

       

        <!-- Search Bar -->
        <form action="${pageContext.request.contextPath}/" method="get" class="search-form">
            <input type="text" name="search" class="search-input" placeholder="Search by name, email, or country" value="${search}">
            <button type="submit" class="btn-search"><i class="fas fa-search"></i>Search</button>
            <a href="${pageContext.request.contextPath}/" class="btn-clear"><i class="fas fa-times"></i>Clear</a>
        </form>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/new" class="btn-add"><i class="fas fa-plus"></i>Add New Employee</a>
            <a href="${pageContext.request.contextPath}/bin" class="btn-bin"><i class="fas fa-trash-alt"></i>Recycle Bin</a>
        </div>

        <!-- Employee Table -->
        <table class="table">
            <thead>
                <tr>
                    <th>
                        <a href="${pageContext.request.contextPath}/?page=${currentPage}&search=${search}&sortBy=id&sortOrder=${sortOrder == 'asc' && sortBy == 'id' ? 'desc' : 'asc'}">
                            ID <span class="sort-icon">${sortBy == 'id' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}</span>
                        </a>
                    </th>
                    <th>
                        <a href="${pageContext.request.contextPath}/?page=${currentPage}&search=${search}&sortBy=name&sortOrder=${sortOrder == 'asc' && sortBy == 'name' ? 'desc' : 'asc'}">
                            Name <span class="sort-icon">${sortBy == 'name' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}</span>
                        </a>
                    </th>
                    <th>
                        <a href="${pageContext.request.contextPath}/?page=${currentPage}&search=${search}&sortBy=email&sortOrder=${sortOrder == 'asc' && sortBy == 'email' ? 'desc' : 'asc'}">
                            Email <span class="sort-icon">${sortBy == 'email' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}</span>
                        </a>
                    </th>
                    <th>
                        <a href="${pageContext.request.contextPath}/?page=${currentPage}&search=${search}&sortBy=country&sortOrder=${sortOrder == 'asc' && sortBy == 'country' ? 'desc' : 'asc'}">
                            Country <span class="sort-icon">${sortBy == 'country' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}</span>
                        </a>
                    </th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty listEmployees}">
                        <tr>
                            <td colspan="5" class="no-employees">No employees found.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="employee" items="${listEmployees}">
                            <tr>
                                <td><c:out value="${employee.id}" /></td>
                                <td><c:out value="${employee.name}" /></td>
                                <td><c:out value="${employee.email}" /></td>
                                <td><c:out value="${employee.country}" /></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/edit?id=${employee.id}" class="btn-edit"><i class="fas fa-edit"></i>Edit</a>
                                    <a href="#" class="btn-delete" data-bs-toggle="modal" data-bs-target="#deleteModal" data-delete-url="${pageContext.request.contextPath}/delete?id=${employee.id}"><i class="fas fa-trash"></i>Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <!-- Pagination -->
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/?page=${currentPage - 1}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}"><i class="fas fa-chevron-left"></i> Previous</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/?page=${i}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/?page=${currentPage + 1}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next <i class="fas fa-chevron-right"></i></a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- Logout Confirmation Modal -->
    <div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="logoutModalLabel">Confirm Logout</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">×</button>
                </div>
                <div class="modal-body">
                    Are you sure you want to logout?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-cancel" data-bs-dismiss="modal"><i class="fas fa-times"></i>Cancel</button>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-modal-confirm"><i class="fas fa-sign-out-alt"></i>Logout</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">×</button>
                </div>
                <div class="modal-body">
                    Are you sure you want to move this employee to the recycle bin? They will be permanently deleted after 30 days.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-cancel" data-bs-dismiss="modal"><i class="fas fa-times"></i>Cancel</button>
                    <a id="deleteConfirmLink" href="#" class="btn-modal-confirm"><i class="fas fa-trash"></i>Delete</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS for modals -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // JavaScript to dynamically set the delete URL in the modal
        const deleteModal = document.getElementById('deleteModal');
        deleteModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget; // Button that triggered the modal
            const deleteUrl = button.getAttribute('data-delete-url'); // Extract URL from data-delete-url
            const deleteConfirmLink = deleteModal.querySelector('#deleteConfirmLink');
            deleteConfirmLink.setAttribute('href', deleteUrl); // Set the href of the Delete button
        });
    </script>
</body>
</html>