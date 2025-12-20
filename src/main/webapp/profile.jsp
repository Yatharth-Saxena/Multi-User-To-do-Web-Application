<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Profile - Multi User To-Do</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
            <style>
                .profile-container {
                    max-width: 600px;
                    margin: 50px auto;
                    background: white;
                    padding: 30px;
                    border-radius: 12px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                .profile-header {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .profile-icon-large {
                    width: 80px;
                    height: 80px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-size: 32px;
                    font-weight: bold;
                    margin: 0 auto 15px;
                }

                .form-section {
                    margin-bottom: 30px;
                    padding-bottom: 20px;
                    border-bottom: 1px solid #eee;
                }

                .form-section:last-child {
                    border-bottom: none;
                }

                .alert {
                    padding: 10px 15px;
                    border-radius: 6px;
                    margin-bottom: 20px;
                }

                .alert-error {
                    background: #fed7d7;
                    color: #c53030;
                }

                .alert-success {
                    background: #c6f6d5;
                    color: #2f855a;
                }

                .btn-back {
                    display: inline-block;
                    margin-bottom: 20px;
                    color: #4a5568;
                    text-decoration: none;
                    font-weight: 500;
                }

                .btn-back:hover {
                    color: #2d3748;
                    text-decoration: underline;
                }
            </style>
        </head>

        <body class="dashboard-page">
            <div class="container">
                <a href="${user.role == 'ADMIN' ? 'admin' : 'dashboard'}" class="btn-back">← Back to Dashboard</a>

                <div class="profile-container">
                    <div class="profile-header">
                        <div class="profile-icon-large">
                            ${user.username.substring(0, 1).toUpperCase()}
                        </div>
                        <h2>My Profile</h2>
                        <p style="color: #666;">Manage your account settings</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>

                    <!-- Update Info Form -->
                    <div class="form-section">
                        <h3>Update Contact Info</h3>
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" name="username" value="${user.username}" required>
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" value="${user.email}" required>
                            </div>
                            <div class="form-group">
                                <label style="color: #e53e3e;">Confirm Password (Required to save changes)</label>
                                <input type="password" name="oldPassword" required placeholder="Enter current password">
                            </div>
                            <button type="submit">Save Changes</button>
                        </form>
                    </div>

                    <!-- Change Password Form -->
                    <div class="form-section">
                        <h3>Change Password</h3>
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="changePassword">
                            <div class="form-group">
                                <label>Current Password</label>
                                <input type="password" name="oldPassword" required>
                            </div>
                            <div class="form-group">
                                <label>New Password</label>
                                <input type="password" name="newPassword" required>
                            </div>
                            <div class="form-group">
                                <label>Confirm New Password</label>
                                <input type="password" name="confirmPassword" required>
                            </div>
                            <button type="submit" style="background: #4a5568;">Update Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>