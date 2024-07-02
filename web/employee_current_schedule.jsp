<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.model.Branch" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>
<%@page import="com.ems.dao.BranchDAO" %>
<%@page import="com.ems.dao.BranchDAOImpl" %>
<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="css/schedule.css">
    <title>Schedule</title>
</head>
<body>
    <%
    final ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
    Employee employee = (Employee) session.getAttribute("employeeLog");
    Branch branch = null;
    Schedule schedule = scheduleDAO.fetchLatestSchedule(employee);
    %>
    <div class="main-wrapper"> 
        <!-- Navigation -->
        <nav>
            <div class="page-title-box-1"> 
                <h3>REZEKY TOMYAM</h3>
            </div>
                <ul>
                <li><a href="#">Home</a></li>
                <li><a href="employee_profile_main.jsp">Profile</a></li>
                <li><a href="employee_current_schedule.jsp">Schedule</a></li>
                <li><a href="employee_attendance.jsp">Attendance</a></li>
                <li><a href="employee_salary_main.jsp">Salary</a></li>
                <li><a href="welcome.html">Log Out</a></li>
            </ul>
        </nav>
        
        <!-- Content -->
        <div class="content"> 
            <header class="header"> 
                <div class="page-title-box"> 
                    <h3>Schedule</h3>
                </div>
            </header>
            
            <main>
                <a href="main_employee.jsp" class="back-link">Back</a> 
                <div class="schedule-table-container"> 
                    <table>
                        <thead>
                            <tr>
                                <th>Schedule Date</th>
                                <th>Start Shift</th>
                                <th>End Shift</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><%= schedule.getScheduleDate() %></td>
                                <td><%= schedule.getStartShift() %></td>
                                <td><%= schedule.getEndShift() %></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
    <footer> 
        <p>&copy; rezky tomyam employee management system</p>
    </footer>
</body>
</html>

