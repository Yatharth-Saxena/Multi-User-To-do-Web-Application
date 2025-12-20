<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Admin Panel - Multi User To-Do</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
            <style>
                .badge {
                    padding: 5px 10px;
                    border-radius: 20px;
                    font-size: 0.85em;
                    font-weight: 600;
                }

                .badge-admin {
                    background: #fed7d7;
                    color: #c53030;
                }

                .badge-user {
                    background: #bee3f8;
                    color: #2b6cb0;
                }

                .badge-active {
                    background: #c6f6d5;
                    color: #22543d;
                }

                .badge-inactive {
                    background: #fed7d7;
                    color: #742a2a;
                }

                .action-btn {
                    border: none;
                    padding: 8px 16px;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 0.85em;
                    margin-right: 8px;
                    margin-bottom: 5px;
                    color: white;
                    font-weight: 600;
                    transition: all 0.2s ease;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    display: inline-block;
                }

                .btn-success {
                    background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                }

                .btn-success:hover {
                    background: linear-gradient(135deg, #38a169 0%, #2f855a 100%);
                    transform: translateY(-1px);
                    box-shadow: 0 4px 8px rgba(56, 161, 105, 0.3);
                }

                .btn-danger {
                    background: linear-gradient(135deg, #fc8181 0%, #e53e3e 100%);
                }

                .btn-danger:hover {
                    background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
                    transform: translateY(-1px);
                    box-shadow: 0 4px 8px rgba(229, 62, 62, 0.3);
                }
            </style>
        </head>

        <body class="dashboard-page">
            <div class="container" style="max-width: 1400px;">
                <div class="header"
                    style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <h2 style="margin: 0;">Admin Panel</h2>
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <a href="profile" title="My Profile"
                            style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50%; color: white; text-decoration: none; font-weight: bold; font-size: 18px;">
                            ${user.username.substring(0, 1).toUpperCase()}
                        </a>
                        <a href="logout" class="button"
                            style="background: #dc3545; padding: 10px 20px; color: white; border-radius: 6px; text-decoration: none;">Logout</a>
                    </div>
                </div>

                <!-- Tabs -->
                <div class="tabs" style="display: flex; gap: 10px; margin-bottom: 20px;">
                    <button class="tab-btn active" onclick="openTab(event, 'usersTab')"
                        style="flex: 1; padding: 15px; background: white; border: none; border-radius: 10px; cursor: pointer; font-weight: 600; color: #4a5568; transition: all 0.3s;">Users</button>
                    <button class="tab-btn" onclick="openTab(event, 'tasksTab')"
                        style="flex: 1; padding: 15px; background: rgba(255,255,255,0.6); border: none; border-radius: 10px; cursor: pointer; font-weight: 600; color: #4a5568; transition: all 0.3s;">All
                        Tasks</button>
                    <button class="tab-btn" onclick="openTab(event, 'statsTab')"
                        style="flex: 1; padding: 15px; background: rgba(255,255,255,0.6); border: none; border-radius: 10px; cursor: pointer; font-weight: 600; color: #4a5568; transition: all 0.3s;">Analytics</button>
                </div>

                <!-- Users Tab -->
                <div id="usersTab" class="tab-content" style="display: block;">
                    <div class="card"
                        style="background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                        <h3 style="margin-top: 0;">User Management</h3>
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="border-bottom: 2px solid #edf2f7;">
                                    <th style="padding: 15px; text-align: left;">ID</th>
                                    <th style="padding: 15px; text-align: left;">Username</th>
                                    <th style="padding: 15px; text-align: left;">Email</th>
                                    <th style="padding: 15px; text-align: left;">Role</th>
                                    <th style="padding: 15px; text-align: left;">Status</th>
                                    <th style="padding: 15px; text-align: left;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr style="border-bottom: 1px solid #edf2f7;">
                                        <td style="padding: 15px;">${u.id}</td>
                                        <td style="padding: 15px;">${u.username}</td>
                                        <td style="padding: 15px;">${u.email}</td>
                                        <td style="padding: 15px;">
                                            <span class="badge ${u.role == 'ADMIN' ? 'badge-admin' : 'badge-user'}">
                                                ${u.role}
                                            </span>
                                        </td>
                                        <td style="padding: 15px;">
                                            <span class="badge ${u.active ? 'badge-active' : 'badge-inactive'}">
                                                ${u.active ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td style="padding: 15px;">
                                            <form action="admin" method="post" style="display:inline;">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <c:choose>
                                                    <c:when test="${u.role == 'ADMIN'}">
                                                        <button type="submit" name="action" value="revokeAdmin"
                                                            class="action-btn btn-danger">Revoke Admin</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" name="action" value="makeAdmin"
                                                            class="action-btn btn-success">Make Admin</button>
                                                    </c:otherwise>
                                                </c:choose>
                                                <button type="submit" name="action" value="deleteUser"
                                                    onclick="return confirm('Delete this user?')"
                                                    class="action-btn btn-danger">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Tasks Tab -->
                <div id="tasksTab" class="tab-content" style="display: none;">
                    <div class="card"
                        style="background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                        <h3 style="margin-top: 0;">All Tasks</h3>
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="border-bottom: 2px solid #edf2f7;">
                                    <th style="padding: 15px; text-align: left;">ID</th>
                                    <th style="padding: 15px; text-align: left;">Title</th>
                                    <th style="padding: 15px; text-align: left;">User ID</th>
                                    <th style="padding: 15px; text-align: left;">Status</th>
                                    <th style="padding: 15px; text-align: left;">Priority</th>
                                    <th style="padding: 15px; text-align: left;">Due Date</th>
                                    <th style="padding: 15px; text-align: left;">Reminders</th>
                                    <th style="padding: 15px; text-align: left;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="t" items="${tasks}">
                                    <tr style="border-bottom: 1px solid #edf2f7;">
                                        <td style="padding: 15px;">${t.id}</td>
                                        <td style="padding: 15px;">${t.title}</td>
                                        <td style="padding: 15px;">${t.userId}</td>
                                        <td style="padding: 15px;">
                                            <span class="badge ${t.status == 'DONE' ? 'badge-active' : 'badge-user'}">
                                                ${t.status}
                                            </span>
                                        </td>
                                        <td style="padding: 15px;">${t.priority}</td>
                                        <td style="padding: 15px;">${t.dueDate != null ? t.dueDate : 'N/A'}</td>
                                        <td style="padding: 15px;">
                                            <span
                                                title="<c:forEach var='r' items='${t.reminders}'>${r.reminderTime}&#10;</c:forEach>"
                                                style="cursor: help; border-bottom: 1px dotted #666;">
                                                ${t.reminders.size()}
                                            </span>
                                        </td>
                                        <td style="padding: 15px;">
                                            <form action="admin" method="post" style="display:inline;">
                                                <input type="hidden" name="taskId" value="${t.id}">
                                                <button type="submit" name="action" value="softDeleteTask"
                                                    onclick="return confirm('Delete this task?')"
                                                    class="action-btn btn-danger">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Analytics Tab -->
                <div id="statsTab" class="tab-content" style="display: none;">
                    <div
                        style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; max-width: 1200px; margin: 0 auto;">
                        <div
                            style="background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                            <h3 style="margin-top: 0; text-align: center;">User Role Distribution</h3>
                            <div style="height: 300px;"><canvas id="roleChart"></canvas></div>
                        </div>
                        <div
                            style="background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                            <h3 style="margin-top: 0; text-align: center;">Task Status Overview</h3>
                            <div style="height: 300px;"><canvas id="taskStatusChart"></canvas></div>
                        </div>
                        <div
                            style="background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); grid-column: 1 / -1;">
                            <h3 style="margin-top: 0; text-align: center;">System Statistics</h3>
                            <div
                                style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; text-align: center;">
                                <div style="padding: 20px; background: #ebf8ff; border-radius: 10px;">
                                    <div style="font-size: 2em; font-weight: bold; color: #2c5282;">${users.size()}
                                    </div>
                                    <div style="color: #4a5568; margin-top: 5px;">Total Users</div>
                                </div>
                                <div style="padding: 20px; background: #f0fff4; border-radius: 10px;">
                                    <div style="font-size: 2em; font-weight: bold; color: #22543d;">${tasks.size()}
                                    </div>
                                    <div style="color: #4a5568; margin-top: 5px;">Total Tasks</div>
                                </div>
                                <div style="padding: 20px; background: #fef5e7; border-radius: 10px;">
                                    <div style="font-size: 2em; font-weight: bold; color: #744210;">
                                        <c:set var="activeCount" value="0" />
                                        <c:forEach var="u" items="${users}">
                                            <c:if test="${u.active}">
                                                <c:set var="activeCount" value="${activeCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${activeCount}
                                    </div>
                                    <div style="color: #4a5568; margin-top: 5px;">Active Users</div>
                                </div>
                                <div style="padding: 20px; background: #fff5f5; border-radius: 10px;">
                                    <div style="font-size: 2em; font-weight: bold; color: #742a2a;">
                                        <c:set var="adminCount" value="0" />
                                        <c:forEach var="u" items="${users}">
                                            <c:if test="${u.role == 'ADMIN'}">
                                                <c:set var="adminCount" value="${adminCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${adminCount}
                                    </div>
                                    <div style="color: #4a5568; margin-top: 5px;">Admin Users</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                function openTab(evt, tabName) {
                    var i, tabcontent, tablinks;
                    tabcontent = document.getElementsByClassName("tab-content");
                    for (i = 0; i < tabcontent.length; i++) {
                        tabcontent[i].style.display = "none";
                    }
                    tablinks = document.getElementsByClassName("tab-btn");
                    for (i = 0; i < tablinks.length; i++) {
                        tablinks[i].className = tablinks[i].className.replace(" active", "");
                        tablinks[i].style.background = "rgba(255,255,255,0.6)";
                    }
                    document.getElementById(tabName).style.display = "block";
                    evt.currentTarget.className += " active";
                    evt.currentTarget.style.background = "white";
                }

                var adminCount = 0, userCount = 0;
                <c:forEach var="u" items="${users}">
                    if ("${u.role}" === "ADMIN") adminCount++;
                    else userCount++;
                </c:forEach>

                new Chart(document.getElementById('roleChart'), {
                    type: 'doughnut',
                    data: {
                        labels: ['Admin', 'User'],
                        datasets: [{
                            data: [adminCount, userCount],
                            backgroundColor: ['#e53e3e', '#3182ce'],
                            borderWidth: 2,
                            borderColor: '#ffffff',
                            hoverOffset: 10
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: { animateScale: true, animateRotate: true, duration: 1500 },
                        plugins: { legend: { position: 'bottom', labels: { padding: 15, font: { size: 13 } } } }
                    }
                });

                var todoCount = 0, inProgressCount = 0, doneCount = 0;
                <c:forEach var="t" items="${tasks}">
                    if ("${t.status}" === "TODO") todoCount++;
                    else if ("${t.status}" === "IN_PROGRESS") inProgressCount++;
                    else if ("${t.status}" === "DONE") doneCount++;
                </c:forEach>

                new Chart(document.getElementById('taskStatusChart'), {
                    type: 'bar',
                    data: {
                        labels: ['To Do', 'In Progress', 'Done'],
                        datasets: [{
                            label: 'Tasks',
                            data: [todoCount, inProgressCount, doneCount],
                            backgroundColor: ['#ffc107', '#17a2b8', '#28a745'],
                            borderWidth: 0,
                            borderRadius: 8
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: { duration: 1500, easing: 'easeOutQuart' },
                        plugins: { legend: { display: false } },
                        scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
                    }
                });
            </script>
        </body>

        </html>