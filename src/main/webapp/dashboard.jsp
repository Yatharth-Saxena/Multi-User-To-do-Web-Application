<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Dashboard - Multi User To-Do</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=2">
            <script>
                function openModal(modalId) {
                    document.getElementById(modalId).style.display = 'block';
                }

                function closeModal(modalId) {
                    document.getElementById(modalId).style.display = 'none';
                }

                function editTask(id, title, description, status, priority, dueDate) {
                    document.getElementById('edit-id').value = id;
                    document.getElementById('edit-title').value = title;
                    document.getElementById('edit-description').value = description;
                    document.getElementById('edit-status').value = status;
                    document.getElementById('edit-priority').value = priority;
                    // Format timestamp for datetime-local input (yyyy-MM-ddTHH:mm)
                    if (dueDate) {
                        // Assuming dueDate comes as "yyyy-MM-dd HH:mm:ss.S" or similar
                        // We need to replace space with T and cut off seconds if needed
                        var formatted = dueDate.replace(" ", "T").substring(0, 16);
                        document.getElementById('edit-dueDate').value = formatted;
                    }
                    openModal('editTaskModal');
                }

                function openReminders(taskId, status) {
                    document.getElementById('reminder-taskId').value = taskId;
                    var remindersDiv = document.getElementById('reminders-' + taskId);
                    var listContainer = document.getElementById('reminder-list');
                    listContainer.innerHTML = '';

                    if (remindersDiv && remindersDiv.children.length > 0) {
                        Array.from(remindersDiv.children).forEach(function (child) {
                            var div = document.createElement('div');
                            div.className = 'reminder-row';
                            div.style.padding = '5px';
                            div.style.borderBottom = '1px solid #eee';
                            div.innerHTML = child.innerHTML;
                            listContainer.appendChild(div);
                        });
                    } else {
                        listContainer.innerHTML = '<p>No reminders set.</p>';
                    }

                    var addForm = document.getElementById('add-reminder-form');
                    if (status === 'DONE') {
                        addForm.style.display = 'none';
                    } else {
                        addForm.style.display = 'block';
                    }

                    openModal('remindersModal');
                }

                // Close modal when clicking outside
                window.onclick = function (event) {
                    if (event.target.className === 'modal') {
                        event.target.style.display = "none";
                    }
                }

                // Calculate and render progress chart
                window.addEventListener('DOMContentLoaded', function () {
                    const tasks = document.querySelectorAll('.task-card');
                    let todoCount = 0,
                        progressCount = 0,
                        doneCount = 0;

                    tasks.forEach(task => {
                        const statusElement = task.querySelector('.task-status');
                        if (statusElement) {
                            const status = statusElement.textContent.trim();
                            if (status === 'TODO') todoCount++;
                            else if (status === 'IN_PROGRESS') progressCount++;
                            else if (status === 'DONE') doneCount++;
                        }
                    });

                    const total = todoCount + progressCount + doneCount;

                    // Update counts
                    document.getElementById('todoCount').textContent = todoCount;
                    document.getElementById('progressCount').textContent = progressCount;
                    document.getElementById('doneCount').textContent = doneCount;

                    // Calculate completion rate
                    const completionRate = total > 0 ? Math.round((doneCount / total) * 100) : 0;
                    document.getElementById('completionRate').textContent = completionRate + '%';
                    document.getElementById('completionFill').style.width = completionRate + '%';

                    // Draw Chart.js Donut Chart
                    const ctx = document.getElementById('taskChart').getContext('2d');

                    // Plugin to draw text in center
                    const centerTextPlugin = {
                        id: 'centerText',
                        beforeDraw: function (chart) {
                            if (chart.config.type !== 'doughnut') return;
                            var width = chart.width,
                                height = chart.height,
                                ctx = chart.ctx;

                            ctx.restore();
                            var fontSize = (height / 114).toFixed(2);
                            ctx.font = "bold " + fontSize + "em Inter";
                            ctx.textBaseline = "middle";
                            ctx.fillStyle = "#2d3748";

                            var text = total.toString(),
                                textX = Math.round((width - ctx.measureText(text).width) / 2),
                                textY = height / 2;

                            ctx.fillText(text, textX, textY);

                            // Draw 'Total' label above number
                            ctx.font = "600 " + (fontSize * 0.4).toFixed(2) + "em Inter";
                            ctx.fillStyle = "#718096";
                            var label = "Total";
                            var labelX = Math.round((width - ctx.measureText(label).width) / 2);
                            var labelY = height / 2 - (height * 0.15);
                            ctx.fillText(label, labelX, labelY);
                            ctx.save();
                        }
                    };

                    new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels: ['To Do', 'In Progress', 'Done'],
                            datasets: [{
                                data: [todoCount, progressCount, doneCount],
                                backgroundColor: [
                                    '#FF6384', // Red/Pink
                                    '#36A2EB', // Blue
                                    '#4BC0C0'  // Teal
                                ],
                                borderWidth: 0,
                                hoverOffset: 4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            cutout: '70%', // Thinner ring
                            plugins: {
                                legend: {
                                    display: false // Hide default legend
                                },
                                tooltip: {
                                    enabled: true
                                }
                            }
                        },
                        plugins: [centerTextPlugin]
                    });
                });
            </script>
        </head>

        <body class="dashboard-page">
            <div class="dashboard-wrapper">
                <div class="container">
                    <div class="header"
                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h2 style="margin: 0;">Welcome, ${user.username}!</h2>
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <a href="profile" title="My Profile"
                                style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50%; color: white; text-decoration: none; font-weight: bold; font-size: 18px;">
                                ${user.username.substring(0, 1).toUpperCase()}
                            </a>
                            <a href="logout" class="button"
                                style="background: #e74c3c; padding: 8px 15px; color: white; border-radius: 6px; text-decoration: none; font-weight: 600;">Logout</a>
                        </div>
                    </div>

                    <button onclick="openModal('addTaskModal')" style="margin-bottom: 20px; width: auto;">+ Add New
                        Task</button>

                    <div class="task-list">
                        <c:forEach var="task" items="${tasks}">
                            <div class="task-card">
                                <div class="task-header">
                                    <div>
                                        <h3>${task.title}</h3>
                                        <div class="task-meta">Due: ${task.dueDate} | Priority: ${task.priority}</div>
                                    </div>
                                    <span class="task-status status-${task.status}">${task.status}</span>
                                </div>
                                <p style="text-align: left; margin-top: 0;">${task.description}</p>
                                <div class="task-actions">
                                    <c:if test="${task.status != 'DONE'}">
                                        <form action="task" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="markDone">
                                            <input type="hidden" name="id" value="${task.id}">
                                            <button type="submit" class="btn-done">✓ Mark as Done</button>
                                        </form>
                                    </c:if>
                                    <button class="btn-edit"
                                        onclick="editTask('${task.id}', '${task.title}', '${task.description}', '${task.status}', '${task.priority}', '${task.dueDate}')">Edit</button>
                                    <button class="btn-edit" style="background-color: #f39c12;"
                                        onclick="openReminders('${task.id}', '${task.status}')">Reminders</button>
                                    <form action="task" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${task.id}">
                                        <button type="submit" class="btn-delete"
                                            onclick="return confirm('Are you sure?')">Delete</button>
                                    </form>

                                    <!-- Hidden reminders data -->
                                    <div id="reminders-${task.id}" style="display:none;">
                                        <c:forEach var="reminder" items="${task.reminders}">
                                            <div class="reminder-item">
                                                <span>${reminder.reminderTime}</span>
                                                <form action="task" method="post" style="display:inline; float:right;">
                                                    <input type="hidden" name="action" value="deleteReminder">
                                                    <input type="hidden" name="id" value="${reminder.id}">
                                                    <button type="submit"
                                                        style="background:none; border:none; color:red; cursor:pointer;">&times;</button>
                                                </form>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty tasks}">
                            <p style="grid-column: 1/-1; text-align: center; font-size: 1.2em;">No tasks found. Create
                                one to get started!</p>
                        </c:if>
                    </div>
                </div>

                <!-- Progress Graph Sidebar -->
                <div class="progress-sidebar">
                    <div class="progress-card">
                        <h3 style="margin-top: 0; color: #1a252f; font-weight: 700; font-size: 1.3rem;">Task Progress
                        </h3>

                        <div class="chart-container" style="position: relative; height: 220px; width: 100%;">
                            <canvas id="taskChart"></canvas>
                        </div>

                        <div class="stats-grid">
                            <div class="stat-item stat-todo">
                                <div class="stat-color"></div>
                                <div class="stat-info">
                                    <div class="stat-label">To Do</div>
                                    <div class="stat-value" id="todoCount">0</div>
                                </div>
                            </div>
                            <div class="stat-item stat-progress">
                                <div class="stat-color"></div>
                                <div class="stat-info">
                                    <div class="stat-label">In Progress</div>
                                    <div class="stat-value" id="progressCount">0</div>
                                </div>
                            </div>
                            <div class="stat-item stat-done">
                                <div class="stat-color"></div>
                                <div class="stat-info">
                                    <div class="stat-label">Done</div>
                                    <div class="stat-value" id="doneCount">0</div>
                                </div>
                            </div>
                        </div>

                        <div class="completion-bar">
                            <div class="completion-label">
                                <span>Completion Rate</span>
                                <span id="completionRate" style="font-weight: 700;">0%</span>
                            </div>
                            <div class="completion-progress">
                                <div class="completion-fill" id="completionFill"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Add Task Modal -->
            <div id="addTaskModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal('addTaskModal')">&times;</span>
                    <h3>Add New Task</h3>
                    <form action="task" method="post">
                        <input type="hidden" name="action" value="create">
                        <div class="form-group">
                            <label>Title:</label>
                            <input type="text" name="title" required>
                        </div>
                        <div class="form-group">
                            <label>Description:</label>
                            <input type="text" name="description">
                        </div>
                        <div class="form-group">
                            <label>Status:</label>
                            <select name="status">
                                <option value="TODO">To Do</option>
                                <option value="IN_PROGRESS">In Progress</option>
                                <option value="DONE">Done</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Priority:</label>
                            <select name="priority">
                                <option value="LOW">Low</option>
                                <option value="MEDIUM" selected>Medium</option>
                                <option value="HIGH">High</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Due Date:</label>
                            <input type="datetime-local" name="dueDate">
                        </div>
                        <button type="submit">Add Task</button>
                    </form>
                </div>
            </div>

            <!-- Edit Task Modal -->
            <div id="editTaskModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal('editTaskModal')">&times;</span>
                    <h3>Edit Task</h3>
                    <form action="task" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="edit-id">
                        <div class="form-group">
                            <label>Title:</label>
                            <input type="text" name="title" id="edit-title" required>
                        </div>
                        <div class="form-group">
                            <label>Description:</label>
                            <input type="text" name="description" id="edit-description">
                        </div>
                        <div class="form-group">
                            <label>Status:</label>
                            <select name="status" id="edit-status">
                                <option value="TODO">To Do</option>
                                <option value="IN_PROGRESS">In Progress</option>
                                <option value="DONE">Done</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Priority:</label>
                            <select name="priority" id="edit-priority">
                                <option value="LOW">Low</option>
                                <option value="MEDIUM">Medium</option>
                                <option value="HIGH">High</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Due Date:</label>
                            <input type="datetime-local" name="dueDate" id="edit-dueDate">
                        </div>
                        <button type="submit">Update Task</button>
                    </form>
                </div>
            </div>

            <!-- Reminders Modal -->
            <div id="remindersModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal('remindersModal')">&times;</span>
                    <h3>Manage Reminders</h3>
                    <div id="reminder-list" style="margin-bottom: 20px;">
                        <!-- Reminders will be loaded here -->
                    </div>

                    <div id="add-reminder-form">
                        <h4>Add Reminder</h4>
                        <form action="task" method="post">
                            <input type="hidden" name="action" value="addReminder">
                            <input type="hidden" name="taskId" id="reminder-taskId">
                            <div class="form-group">
                                <label>Reminder Time:</label>
                                <input type="datetime-local" name="reminderTime" required>
                            </div>
                            <button type="submit">Add Reminder</button>
                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>