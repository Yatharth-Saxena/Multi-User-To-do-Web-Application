@echo off
rem =============================================================
rem Multi-User To-Do Application Run Script
rem This script automates the build and run process for convenience.
rem It performs the following steps:
rem 1. Cleans up any old running instances to avoid port conflicts
rem 2. Checks for Java installation
rem 3. Builds the project using Maven Wrapper (mvnw)
rem 4. Starts the embedded Tomcat server
rem 5. Opens the browser automatically
rem =============================================================

echo ========================================
echo Multi-User To-Do Application
echo ========================================
echo.

echo Cleaning up previous instances...
taskkill /F /IM java.exe /T >nul 2>&1
timeout /t 2 /nobreak >nul

rem Auto-detect JAVA_HOME if not set
if "%JAVA_HOME%" == "" (
    echo JAVA_HOME is not set. Attempting to auto-detect...
    set "JAVA_EXE="
    
    rem Look in standard Java installation directories
    for /d %%i in ("C:\Program Files\Java\jdk*") do (
        if exist "%%i\bin\javac.exe" (
            set "JAVA_HOME=%%i"
            goto :JavaFound
        )
    )
    
    rem Look for Java in PATH
    for /f "tokens=*" %%i in ('where java 2^>nul') do (
        if exist "%%~dpi\javac.exe" (
            set "JAVA_EXE=%%i"
            goto :ResolveJavaHome
        )
        rem Check parent directory
        if exist "%%~dpi\..\bin\javac.exe" (
            set "JAVA_EXE=%%i"
            goto :ResolveJavaHome
        )
    )
    
    goto :NoJavaFound
)

:ResolveJavaHome
if defined JAVA_EXE (
    for %%j in ("%JAVA_EXE%\..\..") do set "JAVA_HOME=%%~fj"
)

:JavaFound
if not "%JAVA_HOME%" == "" (
    echo Auto-detected JAVA_HOME: %JAVA_HOME%
    echo.
    goto :RunApp
)

:NoJavaFound
echo ERROR: Could not find Java installation!
echo Please install Java JDK 8 or higher and set JAVA_HOME.
echo.
pause
exit /b 1

:RunApp
echo Java found at: %JAVA_HOME%
echo.

echo Checking database setup...
echo Make sure you have:
echo 1. Created database 'todo_db' in MySQL
echo 2. Executed init.sql to create tables
echo 3. Updated db.properties with your MySQL credentials
echo.

echo Building and starting application...
echo This may take a few minutes on first run...
echo.

echo Launching browser in 15 seconds...
start "" cmd /c "timeout /t 15 >nul && start http://localhost:8080/MultiUserTodoApp"

call mvnw.cmd package tomcat7:run

echo.
echo Application stopped.
pause
