
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
    <title>Verified Attendance Report Information</title>
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
    <link rel="stylesheet" href="css/verify-report.css">
</head>
<body>
    <%
        final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
        final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
        Employee employee = new Employee();
        
        Attendance[] attendance;
        
        int[] attendanceIDArray = (int[]) request.getAttribute("attendanceID");
        // Assuming attendanceIDArray is already defined and populated somewhere in your code

        if (attendanceIDArray != null) {
            // Check if the first element is -999
            if (attendanceIDArray.length == 1 && attendanceIDArray[0] == -999) {
                // Do nothing if attendanceIDArray contains -999
                attendance = new Attendance[0];
            } else {
                // Proceed to retrieve attendance records using attendanceIDArray
                attendance = attendanceDAO.selectAllAttendance(attendanceIDArray);
            }
        } else {
            // If attendanceIDArray is null, get attendance records for the employee
            attendance = attendanceDAO.selectAllAttendance(employee);
        }
        
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
                    <h2>Verified Report Information</h2>
                </div>
            </header>
            <main>
                <a href="report_update.jsp" class="back-link">Back</a><br>
                <div class="verified-container">
                    <form action="verified_report.view" method="post">
                        <label for="month">Month:</label>
                        <input type="month" name="month" value="${fulldate}" required>
                        <input type="hidden" name="action" value="getVerifiedReport">
                        <button type="submit" class="submit-button">Find</button><br>
                    </form>
                    <br>
                    <table id="verifiedTable" border="1">
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Employee Name</th>
                                <th>Attendance Date</th>
                                <th>Clock In Time</th>
                                <th>Clock Out Time</th>
                                <th>Overtime Duration</th>
                                <th>Emergency Leave Note</th>
                                <th>Late Clock In Duration</th>
                                <th>Total Hours</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (attendance != null && attendance.length > 0) {
                                    for (Attendance a : attendance) {
                                        System.out.println(a);
                                        employee = employeeDAO.getEmployeeByAttendance(a);
                            %>
                            <tr>
                                <td><%= employee.getEmployeeID() %></td>
                                <td><%= employee.getEmployeeName() %></td>
                                <td><%= a.getAttendanceDate() %></td>
                                <td><%= sdf.format(a.getClockInTime()) %></td>
                                <td><%= sdf.format(a.getClockOutTime()) %></td>
                                <td>
                                    <%
                                        if (a.getOvertimeDuration() != null) {
                                            // Format the overtime duration if it's not null
                                            out.print(sdf.format(a.getOvertimeDuration()));
                                        } else {
                                            // Handle the case where overtimeDuration is null
                                            out.print("N/A"); // or you can use an empty string: out.print("");
                                        }
                                    %>
                                </td>
                                <td><%= a.getEmergencyLeaveNote() %></td>
                                <td>
                                    <%
                                        if (a.getLateClockInDuration() != null) {
                                            // Format the overtime duration if it's not null
                                            out.print(sdf.format(a.getLateClockInDuration()));
                                        } else {
                                            // Handle the case where overtimeDuration is null
                                            out.print("N/A"); // or you can use an empty string: out.print("");
                                        }
                                    %>
                                </td>
                                <td><%= a.calculateTotalHours() %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9"> </td>
                            </tr>
                            <%
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
