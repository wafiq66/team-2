<%@page import="java.util.Arrays"%>
<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>

<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.TemporalAdjusters" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Smarthr - Bootstrap Admin Template">
	<meta name="keywords" content="admin, estimates, bootstrap, business, corporate, creative, management, minimal, modern, accounts, invoice, html5, responsive, CRM, Projects">
    <meta name="author" content="Dreamguys - Bootstrap Admin Template">
    <meta name="robots" content="noindex, nofollow">
    <title>Schedule</title>
    <link rel="shortcut icon" type="image/x-icon" href="favicon.png">
    <link rel="stylesheet" href="bootstrap.min.css">
    <link rel="stylesheet" href="font-awesome.min.css">
    <link rel="stylesheet" href="line-awesome.min.css">
    <link rel="stylesheet" href="select2.min.css">
    <link rel="stylesheet" href="bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" href="bootstrap-tagsinput/bootstrap-tagsinput.css">
    <link rel="stylesheet" href="css/create-schedule.css">
    
</head>
<body>
    <%
        LocalDate currentDate = LocalDate.now();
       
        Employee employee = (Employee) session.getAttribute("employee");
        
        // Find the start (Sunday) and end (Saturday) of the current week
        LocalDate startOfWeek = currentDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
        LocalDate endOfWeek = currentDate.with(TemporalAdjusters.nextOrSame(DayOfWeek.SATURDAY));
        
        LocalDate startOfNextWeek = startOfWeek.plusWeeks(1);
        LocalDate endOfNextWeek = endOfWeek.plusWeeks(1);
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
        <main>
            <section class="employee-schedule">
                <p>${message}</p>
                <form  action="manage_schedule.do" method="post" onsubmit="return validateForm()">
                    
                    <label for="">Shift:-</label>
                    
                    <select name="shiftType" class="custom-shift" style="width:100%;">
                        <option value="1">00:00 - 08:00</option>
                        <option value="2">08:00 - 16:00</option>
                        <option value="3">16:00 - 23:59</option>
                    </select>
                    
                    <label for="scheduleDate">Select Off Day:</label>
                    <select name="offDate" class="custom-shift" style="width:100%;" required>
                        <%
                            // Loop through the week from startOfWeek to endOfWeek
                            LocalDate dateIterator = startOfNextWeek;
                            while (!dateIterator.isAfter(endOfNextWeek)) {
                                // Format the date to a string for the value attribute
                                String dateValue = dateIterator.toString();
                        %>
                                <option value="<%= dateValue %>"><%= dateValue %></option>
                        <%
                                // Move to the next day
                                dateIterator = dateIterator.plusDays(1);
                            }
                        %>
                    </select>
                    
                    <br>
                    <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
                    <input type="hidden" name="forWhich" value="2">
                    <input type="hidden" name="action" value="createSchedule">
                    <input name="save" type="submit" value="Create">
                </form>
                <a href="specific_schedule.jsp" class="back-link">Back</a><br><br>
            </section>
        </main>
    </div>
</body>
</html>