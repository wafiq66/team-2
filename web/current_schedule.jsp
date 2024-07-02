
<%@page import="com.ems.model.RestaurantManager" %>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.dao.ManagerDAO" %>
<%@page import="com.ems.dao.ManagerDAOImpl" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>
<%@page import="com.ems.dao.EmployeeScheduleDAO" %>
<%@page import="com.ems.dao.EmployeeScheduleDAOImpl" %>

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
    <div class="main-wrapper">
        <nav>
            <div class="page-title-box-1">
                <h3>REZEKY TOMYAM</h3>
            </div>
            <ul>
                <li><a href="main_manager.jsp">Home</a></li>
                <li><a href="report_update.jsp">Report</a></li>
                <li><a href="manage_schedule_main.jsp">Schedule</a></li>
                <li><a href="welcome.html">Log Out</a></li>
            </ul>
        </nav>

        <div class="content">
            <header class="header">
                <div class="page-title-box">
                    <h3>Schedule</h3>
                </div>
            </header>

            <main>
                <a href="manage_schedule_main.jsp" class="back-link">Back</a>
                <div class="schedule-table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Employee Name</th>
                                <th>Schedule Date</th>
                                <th>Start Shift</th>
                                <th>End Shift</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            RestaurantManager manager = (RestaurantManager) session.getAttribute("managerLog");
                            ManagerDAO managerDAO = new ManagerDAOImpl();
                            EmployeeDAO employeeDAO = new EmployeeDAOImpl();
                            Employee[] employees = employeeDAO.getAllEmployeeByBranch(managerDAO.getRestaurantManagerBranchId(manager)); // Replace with the desired employees
                            
                            ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
                            Schedule[] schedules = new Schedule[employees.length];
                            
                            for (int i = 0; i < employees.length; i++) {
                                schedules[i] = scheduleDAO.fetchLatestSchedule(employees[i]);
                            }
                            
                            EmployeeScheduleDAO employeeScheduleDAO = new EmployeeScheduleDAOImpl();
                            
                            for (int i = 0; i < employees.length; i++) { 
                                if(employees[i].getEmployeeStatus()){
                            %>
                            <tr>
                                <td><%= employees[i].getEmployeeName() %></td>
                                <td><%= schedules[i] != null ? schedules[i].getScheduleDate() : "" %></td>
                                <td><%= schedules[i] != null ? schedules[i].getStartShift() : "" %></td>
                                <td><%= schedules[i] != null ? schedules[i].getEndShift() : "" %></td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <footer>
            <p>&copy; rezky tomyam employee management system</p>
        </footer>
    </div>
</body>
</html>