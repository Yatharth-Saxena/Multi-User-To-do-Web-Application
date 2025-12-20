<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Register - Multi User To-Do</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body>
        <div class="container">
            <h2>Register</h2>
            <% if (request.getAttribute("error") !=null) { %>
                <div class="error">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                    <div id="validationError" class="error" style="display: none;"></div>

                    <form action="register" method="post" id="registerForm">
                        <div class="form-group">
                            <label>Username:</label>
                            <input type="text" name="username" id="username" placeholder="Choose a username"
                                minlength="3" maxlength="20" required onkeydown="if(event.key===' ') return false;">
                        </div>
                        <div class="form-group">
                            <label>Email:</label>
                            <input type="email" name="email" placeholder="Enter your email" maxlength="100" required>
                        </div>
                        <div class="form-group">
                            <label>Password:</label>
                            <div class="password-container">
                                <input type="password" name="password" id="password" placeholder="Choose a password"
                                    minlength="8" maxlength="128" required
                                    onkeydown="if(event.key===' ') return false;">
                                <span class="password-toggle"
                                    onclick="togglePassword('password', 'eye-icon-1', 'eye-slash-icon-1')">
                                    <!-- Eye Icon (Show) -->
                                    <svg id="eye-icon-1" xmlns="http://www.w3.org/2000/svg" fill="none"
                                        viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                    </svg>
                                    <!-- Eye Slash Icon (Hide) - Hidden by default -->
                                    <svg id="eye-slash-icon-1" style="display:none;" xmlns="http://www.w3.org/2000/svg"
                                        fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                    </svg>
                                </span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Confirm Password:</label>
                            <div class="password-container">
                                <input type="password" name="confirmPassword" id="confirmPassword"
                                    placeholder="Confirm your password" minlength="8" maxlength="128" required
                                    onkeydown="if(event.key===' ') return false;">
                                <span class="password-toggle"
                                    onclick="togglePassword('confirmPassword', 'eye-icon-2', 'eye-slash-icon-2')">
                                    <!-- Eye Icon (Show) -->
                                    <svg id="eye-icon-2" xmlns="http://www.w3.org/2000/svg" fill="none"
                                        viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                    </svg>
                                    <!-- Eye Slash Icon (Hide) - Hidden by default -->
                                    <svg id="eye-slash-icon-2" style="display:none;" xmlns="http://www.w3.org/2000/svg"
                                        fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                    </svg>
                                </span>
                            </div>
                        </div>
                        <button type="submit">Register</button>
                    </form>
                    <p>Already have an account? <a href="login">Login here</a></p>
        </div>

        <script>
            function togglePassword(inputId, eyeIconId, eyeSlashIconId) {
                var input = document.getElementById(inputId);
                var eyeIcon = document.getElementById(eyeIconId);
                var eyeSlashIcon = document.getElementById(eyeSlashIconId);

                if (input.type === "password") {
                    input.type = "text";
                    eyeIcon.style.display = "none";
                    eyeSlashIcon.style.display = "block";
                } else {
                    input.type = "password";
                    eyeIcon.style.display = "block";
                    eyeSlashIcon.style.display = "none";
                }
            }

            document.getElementById('registerForm').addEventListener('submit', function (e) {
                var username = document.getElementById('username').value;
                var password = document.getElementById('password').value;
                var confirmPassword = document.getElementById('confirmPassword').value;
                var errorDiv = document.getElementById('validationError');
                var errorMsg = "";

                // Username length validation
                if (username.length < 3 || username.length > 20) {
                    errorMsg = "Username must be between 3 and 20 characters.";
                }

                // Username validation: Alphanumeric only
                var usernameRegex = /^[a-zA-Z0-9]+$/;
                if (!usernameRegex.test(username)) {
                    if (errorMsg !== "") errorMsg += "<br>";
                    errorMsg += "Username must contain only letters and numbers (no spaces or special characters).";
                }

                // Password length validation
                if (password.length < 8 || password.length > 128) {
                    if (errorMsg !== "") errorMsg += "<br>";
                    errorMsg += "Password must be between 8 and 128 characters.";
                }

                // Password match validation
                if (password !== confirmPassword) {
                    if (errorMsg !== "") errorMsg += "<br>";
                    errorMsg += "Passwords do not match.";
                }

                if (errorMsg !== "") {
                    e.preventDefault();
                    errorDiv.innerHTML = errorMsg;
                    errorDiv.style.display = 'block';
                }
            });
        </script>
    </body>

    </html>