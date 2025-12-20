# Multi-User To-Do Application

A modern, web-based multi-user To-Do list application built with Java, featuring user authentication, task management, and a beautiful, responsive interface.

## 📋 Features

- **User Authentication**: Secure registration and login system
- **Task Management**: Create, Read, Update, and Delete tasks
- **Task Organization**: Filter and sort tasks by various criteria
- **Admin Panel**: User management capabilities for administrators
- **Modern UI**: Responsive design with smooth animations and a visually appealing interface
- **Password Visibility Toggle**: Convenient password viewing during login

## 🎯 Prerequisites

Before you begin, ensure you have the following installed on your system:

1. **Java JDK 8 or higher**
   - Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://openjdk.org/)
   - Verify installation: Open Command Prompt and run `java -version`
   - **IMPORTANT**: Make sure `JAVA_HOME` environment variable is set correctly
     - Right-click "This PC" → Properties → Advanced System Settings → Environment Variables
     - Add new System Variable: `JAVA_HOME` = path to your JDK (e.g., `C:\Program Files\Java\jdk-17`)

2. **MySQL Server**
   - Download from [MySQL Official Site](https://dev.mysql.com/downloads/mysql/)
   - Remember your root password during installation
   - Verify installation: Run `mysql --version` in Command Prompt

## 📥 Download & Setup Instructions

### Step 1: Download the Project

1. Download all project files from GitHub
2. Extract to a folder of your choice (e.g., `C:\Projects\multi-to-do`)
3. Ensure all files and folders are extracted properly

### Step 2: Database Setup

1. **Start MySQL Server** (if not already running)

2. **Create the Database**:
   - Open MySQL Command Line Client or MySQL Workbench
   - Log in with your MySQL root credentials
   - Run the following commands:
   ```sql
   CREATE DATABASE todo_db;
   USE todo_db;
   ```

3. **Import the Database Schema**:
   - Locate the `init.sql` file in the project folder
   - Execute it in MySQL:
     - **Option A** (MySQL Command Line): 
       ```sql
       SOURCE C:/path/to/your/project/init.sql;
       ```
     - **Option B** (MySQL Workbench): 
       - File → Run SQL Script → Select `init.sql` → Run

### Step 3: Configure Database Connection

1. Navigate to `src/main/resources/` folder in the project
2. Open `db.properties` file in a text editor (Notepad, VS Code, etc.)
3. Update the following properties with **your MySQL credentials**:
   ```properties
   db.url=jdbc:mysql://localhost:3306/todo_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
   db.user=root
   db.password=YOUR_MYSQL_PASSWORD
   ```
   - Replace `YOUR_MYSQL_PASSWORD` with your actual MySQL root password
   - If you're using a different username, replace `root` accordingly
   - If MySQL is running on a different port, change `3306` to your port number

4. Save the file

## 🚀 Running the Application

### Running the Application

1. Navigate to the project folder
2. **Double-click** `run.bat`
3. The script will:
   - Check your Java installation
   - Display reminder about database setup
   - Build the project (first time downloads dependencies - requires internet)
   - Start the embedded Tomcat server
   - **Automatically open the application in your default browser**


4. If the browser doesn't open automatically, go to:
   - `http://localhost:8080/MultiUserTodoApp`

### Manual Run (Alternative)

If the automatic method doesn't work:

1. Open Command Prompt in the project directory
2. Run the following commands:
   ```bash
   # On Windows (if mvnw.cmd exists)
   mvnw.cmd clean package
   mvnw.cmd tomcat7:run
   ```

3. Open your browser and go to: `http://localhost:8080/MultiUserTodoApp`

## 👤 Using the Application

### First-Time User

1. **Register an Account**:
   - Click on "Register" or "Sign Up"
   - Fill in your details (username, email, password)
   - Submit the form

2. **Login**:
   - Use your registered credentials to log in
   - Use the eye icon to toggle password visibility

3. **Manage Tasks**:
   - Add new tasks using the "Add Task" button
   - Edit or delete existing tasks
   - Filter and sort tasks as needed

## 🛠️ Technologies Used

- **Backend**: Java Servlets, JSP (JavaServer Pages)
- **Database**: MySQL
- **Build Tool**: Maven
- **Server**: Embedded Tomcat 7
- **Frontend**: HTML, CSS, JavaScript


## 📁 Project Structure

```
multi-to-do/
├── src/
│   ├── main/
│   │   ├── java/          # Java source files (Servlets, Models, Utils)
│   │   ├── resources/     # Configuration files (db.properties)
│   │   └── webapp/        # Web resources (JSP, CSS, images)
├── .mvn/                  # Maven wrapper configuration
├── init.sql               # Database schema
├── pom.xml                # Maven configuration
├── mvnw.cmd               # Maven wrapper script
├── run.bat                # Windows run script
└── README.md              # This file
```

## ❗ Troubleshooting

### Problem: "`JAVA_HOME` is not set" error

**Solution**: 
- Set the `JAVA_HOME` environment variable to your JDK installation path
- Restart Command Prompt and try again

### Problem: Database connection error

**Solution**:
- Verify MySQL is running
- Check credentials in `src/main/resources/db.properties`
- Ensure database `todo_db` exists
- Verify MySQL port (default: 3306)

### Problem: Port 8080 already in use

**Solution**:
- Close any application using port 8080
- Or modify `pom.xml` to use a different port:
  ```xml
  <configuration>
    <port>8081</port>  <!-- Change to your preferred port -->
  </configuration>
  ```

### Problem: Application won't build

**Solution**:
- Ensure you have internet connection (Maven needs to download dependencies)
- Delete the `target` folder and try again
- Run `mvnw.cmd clean` before running `run.bat`

### Problem: Browser doesn't open automatically

**Solution**:
- Open manually: `http://localhost:8080/MultiUserTodoApp`
- Check if any antivirus/firewall is blocking the connection

## 📝 Notes

- The first run may take longer as Maven downloads all dependencies
- Default admin credentials (if pre-configured): Check with your administrator
- Make sure to backup your database regularly if using in production
- For production deployment, consider changing the database password and securing the application

