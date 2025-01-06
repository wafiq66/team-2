<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>
<%@page import="com.ems.model.RestaurantManager" %>
<%@page import="com.ems.dao.ManagerDAO" %>
<%@page import="com.ems.dao.ManagerDAOImpl" %>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>

<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule</title>
    <meta name="description" content="Smarthr - Bootstrap Admin Template">
	<meta name="keywords" content="admin, estimates, bootstrap, business, corporate, creative, management, minimal, modern, accounts, invoice, html5, responsive, CRM, Projects">
    <meta name="author" content="Dreamguys - Bootstrap Admin Template">
    <meta name="robots" content="noindex, nofollow">
    <link rel="shortcut icon" type="image/x-icon" href="favicon.png">
    <link rel="stylesheet" href="bootstrap.min.css">
    <link rel="stylesheet" href="font-awesome.min.css">
    <link rel="stylesheet" href="line-awesome.min.css">
    <link rel="stylesheet" href="select2.min.css">
    <link rel="stylesheet" href="bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" href="bootstrap-tagsinput/bootstrap-tagsinput.css">
    <link rel="stylesheet" href="css/manage-schedule.css">
</head>
<body>
    <%      
        RestaurantManager manager = (RestaurantManager) session.getAttribute("managerLog");
        ManagerDAO managerDAO = new ManagerDAOImpl();
        int branchID = managerDAO.getRestaurantManagerBranchId(manager); // Replace with the desired branch ID (commented out for now)
        ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
        Schedule[] schedules = scheduleDAO.getAllActiveScheduleByBranchID(branchID);
        
        
        EmployeeDAO employeeDAO = new EmployeeDAOImpl();
        Employee[] employees = employeeDAO.getAllEmployeeByBranch(branchID);
        
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");

    %>
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
                    <h2>Schedule</h2>
                </div>
            </header>
            <main>
                <div class="schedule-container"> 
                    
                    <table class="scheduleTable" border="1">
                        <thead>
                            <tr>
                                <th>Employee Name</th>
                                <th>Off Date</th>
                                <th>Start Shift</th>
                                <th>End Shift</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Employee employee : employees) {
                                    boolean hasSchedule = false; // Flag to check if the employee has a schedule
                                    if(employee.getEmployeeStatus()){
                                    for (Schedule schedule : schedules) {
                                        if (employee.getEmployeeID() == schedule.getEmployeeID()) {
                                            hasSchedule = true; // Employee has a schedule
                            %> 
                                            <tr>
                                                <td><%= employee.getEmployeeName() %></td>
                                                <td><%= schedule.getOffDay() %></td>
                                                <td><%= sdf.format(schedule.getStartShift()) %></td>
                                                <td><%= sdf.format(schedule.getEndShift()) %></td>
                                                <td>
                                                    <form action="manage_schedule.do" method="post">
                                                        <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
                                                        <input type="hidden" name="action" value="viewSpecificSchedule">
                                                        <button type="submit" class="view-button">View</button>
                                                    </form>
                                                </td>
                                            </tr>
                            <%
                                        }
                                    }

                                    // If the employee does not have any schedule, display the message
                                    if (!hasSchedule) {
                            %>
                                        <tr>
                                            <td><%= employee.getEmployeeName() %></td>
                                            <td colspan="3" style="text-align: center;">
                                                Schedule is not available
                                            </td>
                                            <td>
                                                <form action="manage_schedule.do" method="post">
                                                    <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
                                                    <input type="hidden" name="action" value="viewSpecificSchedule">
                                                    <button type="submit" class="view-button">View</button>
                                                </form>
                                            </td>
                                        </tr>
                            <%
                                    }
                                }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </main>
            <footer>
                <p>&copy; rezky tomyam employee management system</p>
            </footer>
        </div>
    </div>
</body>
</html>