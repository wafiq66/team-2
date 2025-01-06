<%@page import="java.time.LocalDate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.ems.model.Attendance"%>
<%@page import="com.ems.model.Branch"%>
<%@page import="com.ems.dao.AttendanceDAO"%>
<%@page import="com.ems.dao.AttendanceDAOImpl"%>
<%@page import="com.ems.dao.BranchDAO"%>
<%@page import="com.ems.dao.BranchDAOImpl"%>
<%@page import="com.ems.model.RestaurantManager"%>
<%@page import="com.ems.dao.ManagerDAO"%>
<%@page import="com.ems.dao.ManagerDAOImpl"%>
<%@page import="com.ems.model.Employee"%>
<%@page import="com.ems.dao.EmployeeDAO"%>
<%@page import="com.ems.dao.EmployeeDAOImpl"%>

<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Salary Information</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
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
    <link rel="stylesheet" href="css/report-update.css">
</head>
<body>
    <%
        final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
        final ManagerDAO managerDAO = new ManagerDAOImpl();
        final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
        // Retrieve attributes from the request
        Object yearObj = request.getAttribute("year");
        Object monthObj = request.getAttribute("month");

        // Parse attributes as integers with null checking and default values
        int year = (yearObj != null) ? Integer.parseInt(yearObj.toString()) : 0;
        int month = (monthObj != null) ? Integer.parseInt(monthObj.toString()) : 0;

        System.out.println("Tahun: " + year + ", Bulan: " + month);
        
        RestaurantManager manager = (RestaurantManager)session.getAttribute("managerLog");
        
        Attendance[] attendances = attendanceDAO.selectAllAttendance(year, month, managerDAO.getRestaurantManagerBranchId(manager));
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
    %>
    <div class="main-wrapper"> 
        <nav class="nav-bar"> 
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
                    <h2>Report Information</h2>
                </div>
            </header>
            <main>
                <form action="attendance.view" method="post">
                    <label for="month">Month:-</label>
                    <input type="month" name="month" value="${fullDate}" required>
                    <input type="hidden" name="action" value="getMonthReport">
                    <button type="submit" class="submit-button">Find</button>
                </form>
                <br>
                
                <table class="reportTable" border="1"> 
                    <tr>
                        <th>Employee ID</th>
                        <th>Attendance Date</th>
                        <th>Clock In Time</th>
                        <th>Clock Out Time</th>
                        <th>Overtime Duration</th>
                        <th>Total Hours</th>
                    </tr>
                    
                    <% 
                       
                    if(!(attendances != null)) { %>
                        <td colspan="6" style="text-align:center;">  </td>
                    <% } 
                    else{ 
                    
                    for(Attendance attendance : attendances){
                        Employee employee = employeeDAO.getEmployeeByAttendance(attendance);
                    %>
                    <tr>
                        <td><%= employee.getEmployeeID() %></td>
                        <td><%= attendance.getAttendanceDate() %></td>
                        <td><%= attendance.getClockInTime() %></td>
                        <td><%= attendance.getClockOutTime() %></td>
                        <td><%= (attendance.getOvertimeDuration() != null) ? sdf.format(attendance.getOvertimeDuration()) : "No Overtime" %></td>
                        <td><%= attendance.calculateTotalHours() %></td>
                    </tr>
                    <%} 
                        
                    }   
                    %>
                </table>
                
            </main>
        </div>
        <footer>
            <p>&copy; rezky tomyam employee management system</p>
        </footer>
    </div>
</body>
</html>