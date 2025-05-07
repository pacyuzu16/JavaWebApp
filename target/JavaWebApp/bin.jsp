<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Recycle Bin</title>
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

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .btn-back {
            background: #635bff;
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
        }

        .btn-back:hover {
            background: #4c47d7;
        }

        .btn-back i {
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

        .btn-restore,
        .btn-permanent-delete {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
        }

        .btn-restore {
            background: #28a745;
            color: white;
            margin-right: 5px;
        }

        .btn-restore:hover {
            background: #218838;
        }

        .btn-permanent-delete {
            background: #dc3545;
            color: white;
        }

        .btn-permanent-delete:hover {
            background: #c82333;
        }

        .btn-restore i,
        .btn-permanent-delete i {
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
            background: #dc3545;
            color: white;
        }

        .btn-modal-confirm:hover {
            background: #c82333;
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

            .action-buttons {
                flex-direction: column;
            }

            .btn-back {
                width: 100%;
                text-align: center;
            }

            .table th,
            .table td {
                font-size: 12px;
                padding: 8px;
            }

            .btn-restore,
            .btn-permanent-delete {
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

            .btn-restore,
            .btn-permanent-delete {
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
        <h1>Recycle Bin</h1>

        <!-- Back to Employee Management Button -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/" class="btn-back"><i class="fas fa-arrow-left"></i>Back to Employee Management</a>
        </div>

        <!-- Deleted Employees Table -->
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Country</th>
                    <th>Deleted At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty deletedEmployees}">
                        <tr>
                            <td colspan="6" class="no-employees">No deleted employees found.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="employee" items="${deletedEmployees}">
                            <tr>
                                <td><c:out value="${employee.id}" /></td>
                                <td><c:out value="${employee.name}" /></td>
                                <td><c:out value="${employee.email}" /></td>
                                <td><c:out value="${employee.country}" /></td>
                                <td><c:out value="${employee.deletedAt}" /></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/restore?id=${employee.id}" class="btn-restore"><i class="fas fa-undo"></i>Restore</a>
                                    <a href="#" class="btn-permanent-delete" data-bs-toggle="modal" data-bs-target="#permanentDeleteModal" data-delete-url="${pageContext.request.contextPath}/permanentDelete?id=${employee.id}"><i class="fas fa-trash-alt"></i>Permanent Delete</a>
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
                    <a class="page-link" href="${pageContext.request.contextPath}/bin?page=${currentPage - 1}"><i class="fas fa-chevron-left"></i> Previous</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/bin?page=${i}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/bin?page=${currentPage + 1}">Next <i class="fas fa-chevron-right"></i></a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- Permanent Delete Confirmation Modal -->
    <div class="modal fade" id="permanentDeleteModal" tabindex="-1" aria-labelledby="permanentDeleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="permanentDeleteModalLabel">Confirm Permanent Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">×</button>
                </div>
                <div class="modal-body">
                    Are you sure you want to permanently delete this employee? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-cancel" data-bs-dismiss="modal"><i class="fas fa-times"></i>Cancel</button>
                    <a id="permanentDeleteConfirmLink" href="#" class="btn-modal-confirm"><i class="fas fa-trash-alt"></i>Permanent Delete</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS for modals -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // JavaScript to dynamically set the permanent delete URL in the modal
        const permanentDeleteModal = document.getElementById('permanentDeleteModal');
        permanentDeleteModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget; // Button that triggered the modal
            const deleteUrl = button.getAttribute('data-delete-url'); // Extract URL from data-delete-url
            const deleteConfirmLink = permanentDeleteModal.querySelector('#permanentDeleteConfirmLink');
            deleteConfirmLink.setAttribute('href', deleteUrl); // Set the href of the Permanent Delete button
        });
    </script>
</body>
</html>