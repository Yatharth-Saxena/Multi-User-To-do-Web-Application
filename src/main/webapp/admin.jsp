<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Admin Panel - Multi User To-Do</title>
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="container" style="width: 800px;">
                <div class="header" style="display: flex; justify-content: space-between; align-items: center;">
                    <h2>Admin Panel</h2>
                    <div>
                        <a href="dashboard" class="button"
                            style="background: #007bff; padding: 5px 10px; color: white; border-radius: 3px; margin-right: 10px;">Dashboard</a>
                        <a href="logout" class="button"
                            style="background: #dc3545; padding: 5px 10px; color: white; border-radius: 3px;">Logout</a>
                    </div>
                </div>

                <h3>Registered Users</h3>
                <table border="1" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Created At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.id}</td>
                                <td>${u.username}</td>
                                <td>${u.email}</td>
                                <td>${u.role}</td>
                                <td>${u.createdAt}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </body>

        </html>