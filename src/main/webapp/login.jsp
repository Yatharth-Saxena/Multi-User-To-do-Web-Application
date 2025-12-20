<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Login - Multi User To-Do</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .tabs {
                display: flex;
                background: rgba(255, 255, 255, 0.5);
                padding: 5px;
                border-radius: 12px;
                margin-bottom: 25px;
                border: 1px solid rgba(255, 255, 255, 0.4);
            }

            .tab {
                flex: 1;
                padding: 12px;
                text-align: center;
                cursor: pointer;
                border-radius: 8px;
                color: #4a5568;
                font-weight: 500;
                transition: all 0.3s ease;
                border: none;
                background: transparent;
            }

            .tab:hover {
                background: rgba(255, 255, 255, 0.5);
                color: #2d3748;
            }

            .tab.active {
                background: #fff;
                color: #667eea;
                font-weight: 600;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                transform: scale(1.02);
            }

            .tab-content {
                display: none;
                animation: fadeIn 0.4s ease-out;
            }

            .tab-content.active {
                display: block;
            }

            .demo-creds {
                margin-top: 20px;
                padding: 15px;
                background: rgba(235, 248, 255, 0.6);
                border: 1px solid rgba(190, 227, 248, 0.5);
                border-radius: 10px;
                font-size: 0.9em;
                color: #2c5282;
                text-align: center;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .demo-creds strong {
                color: #2b6cb0;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <h2>Login</h2>
            <% if (request.getAttribute("error") !=null) { %>
                <div class="error">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>
                    <% if (request.getParameter("registered") !=null) { %>
                        <div class="success">Registration successful! Please login.</div>
                        <% } %>

                            <div class="tabs">
                                <div class="tab active" onclick="showTab('user')">User Login</div>
                                <div class="tab" onclick="showTab('admin')">Admin Login</div>
                            </div>

                            <!-- User Login Form -->
                            <div id="user-tab" class="tab-content active">
                                <form action="login" method="post">
                                    <div class="form-group">
                                        <label>Username:</label>
                                        <input type="text" name="username" placeholder="Enter user username" required
                                            onkeydown="if(event.key===' ') return false;">
                                    </div>
                                    <div class="form-group">
                                        <label>Password:</label>
                                        <div class="password-container">
                                            <input type="password" name="password" id="user-password"
                                                placeholder="Enter password" required
                                                onkeydown="if(event.key===' ') return false;">
                                            <span class="password-toggle"
                                                onclick="togglePassword('user-password', 'user-eye', 'user-eye-slash')">
                                                <svg id="user-eye" xmlns="http://www.w3.org/2000/svg" fill="none"
                                                    viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                </svg>
                                                <svg id="user-eye-slash" style="display:none;"
                                                    xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                                    stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                                </svg>
                                            </span>
                                        </div>
                                    </div>
                                    <button type="submit">Login as User</button>
                                    <input type="hidden" name="loginType" value="user">
                                </form>
                                <div class="demo-creds">
                                    <span>🔑</span>
                                    <div><strong>Demo User:</strong> user / user123</div>
                                </div>
                            </div>

                            <!-- Admin Login Form -->
                            <div id="admin-tab" class="tab-content">
                                <form action="login" method="post">
                                    <div class="form-group">
                                        <label>Username:</label>
                                        <input type="text" name="username" placeholder="Enter admin username" required
                                            onkeydown="if(event.key===' ') return false;">
                                    </div>
                                    <div class="form-group">
                                        <label>Password:</label>
                                        <div class="password-container">
                                            <input type="password" name="password" id="admin-password"
                                                placeholder="Enter password" required
                                                onkeydown="if(event.key===' ') return false;">
                                            <span class="password-toggle"
                                                onclick="togglePassword('admin-password', 'admin-eye', 'admin-eye-slash')">
                                                <svg id="admin-eye" xmlns="http://www.w3.org/2000/svg" fill="none"
                                                    viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                </svg>
                                                <svg id="admin-eye-slash" style="display:none;"
                                                    xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                                    stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                                </svg>
                                            </span>
                                        </div>
                                    </div>
                                    <button type="submit"
                                        style="background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%); box-shadow: 0 4px 15px rgba(197, 48, 48, 0.3);">Login
                                        as Admin</button>
                                    <input type="hidden" name="loginType" value="admin">
                                </form>
                                <div class="demo-creds"
                                    style="background: rgba(254, 215, 215, 0.6); border-color: rgba(254, 178, 178, 0.5); color: #742a2a;">
                                    <span>🛡️</span>
                                    <div><strong>Demo Admin:</strong> admin / admin123</div>
                                </div>
                            </div>

                            <p>Don't have an account? <a href="register">Register here</a></p>
        </div>

        <script>
            function showTab(type) {
                document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

                if (type === 'user') {
                    document.querySelector('.tab:nth-child(1)').classList.add('active');
                    document.getElementById('user-tab').classList.add('active');
                } else {
                    document.querySelector('.tab:nth-child(2)').classList.add('active');
                    document.getElementById('admin-tab').classList.add('active');
                }
            }

            function togglePassword(inputId, eyeId, slashId) {
                var passwordInput = document.getElementById(inputId);
                var eyeIcon = document.getElementById(eyeId);
                var eyeSlashIcon = document.getElementById(slashId);

                if (passwordInput.type === "password") {
                    passwordInput.type = "text";
                    eyeIcon.style.display = "none";
                    eyeSlashIcon.style.display = "block";
                } else {
                    passwordInput.type = "password";
                    eyeIcon.style.display = "block";
                    eyeSlashIcon.style.display = "none";
                }
            }
        </script>
    </body>

    </html>