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
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
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
                    document.getElementById('edit-dueDate').value = dueDate;
                    openModal('editTaskModal');
                }

                // Close modal when clicking outside
                window.onclick = function (event) {
                    if (event.target.className === 'modal') {
                        event.target.style.display = "none";
                    }
                }
            </script>
        </head>

        <body class="dashboard-page">
            <div class="container">
                <div class="header"
                    style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h2 style="margin: 0;">Welcome, ${user.username}!</h2>
                    <a href="logout" class="button"
                        style="background: #e74c3c; padding: 8px 15px; color: white; border-radius: 6px; text-decoration: none; font-weight: 600;">Logout</a>
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
                                <button class="btn-edit"
                                    onclick="editTask('${task.id}', '${task.title}', '${task.description}', '${task.status}', '${task.priority}', '${task.dueDate}')">Edit</button>
                                <form action="task" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${task.id}">
                                    <button type="submit" class="btn-delete"
                                        onclick="return confirm('Are you sure?')">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty tasks}">
                        <p style="grid-column: 1/-1; text-align: center; font-size: 1.2em;">No tasks found. Create one
                            to get started!</p>
                    </c:if>
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
                            <input type="date" name="dueDate">
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
                            <input type="date" name="dueDate" id="edit-dueDate">
                        </div>
                        <button type="submit">Update Task</button>
                    </form>
                </div>
            </div>
        </body>

        </html>