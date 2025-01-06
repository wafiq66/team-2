<%@page import="java.util.Arrays"%>
<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.model.RestaurantManager" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>

<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page import="java.text.SimpleDateFormat" %>

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
                <%
                    
                    Schedule schedule = (Schedule) session.getAttribute("editingSchedule");
                    
                    Timestamp startShift = schedule.getStartShift(); // Assuming this returns a String like "08:00:00"
                    Timestamp endShift = schedule.getEndShift();
                    
                    String defaultDate = "2000-01-01 ";
                    Timestamp[] timestampArray = new Timestamp[]{
                        Timestamp.valueOf(defaultDate + "00:00:00"),
                        Timestamp.valueOf(defaultDate + "08:00:00"),
                        Timestamp.valueOf(defaultDate + "16:00:00"),
                        Timestamp.valueOf(defaultDate + "23:59:00")
                    };
                    
                    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
                %>
                <p>${message}</p>
                <form action="manage_schedule.do" method="post" onsubmit="return validateForm()">
                    <label for="">Shift:-</label>
                    
                    <select class="custom-shift" name="shiftType" style="width:100%;">
                        <option value="1" <%= (startShift.equals(timestampArray[0]) && endShift.equals(timestampArray[1])) ? "selected" : "" %>>00:00 - 08:00</option>
                        <option value="2" <%= (startShift.equals(timestampArray[1]) && endShift.equals(timestampArray[2])) ? "selected" : "" %>>08:00 - 16:00</option>
                        <option value="3" <%= (startShift.equals(timestampArray[2]) && endShift.equals(timestampArray[3])) ? "selected" : "" %>>16:00 - 23:59</option>

                        <%
                            // Check if any of the first three options are selected
                            Boolean isSelected = false;
                            if (startShift.equals(timestampArray[0]) && endShift.equals(timestampArray[1])) {
                                isSelected = true;
                            } else if (startShift.equals(timestampArray[1]) && endShift.equals(timestampArray[2])) {
                                isSelected = true;
                            } else if (startShift.equals(timestampArray[2]) && endShift.equals(timestampArray[3])) {
                                isSelected = true;
                            }
                        %>

                        <%-- Render option 4 only if none of the previous options are selected --%>
                        <% if (!isSelected) { %>
                        <option value="4" selected><%= sdf.format(startShift) %> - <%= sdf.format(endShift) %></option>
                        <% } %>
                    </select>

                    <br>
                    
                    <input type="hidden" name="action" value="updateSchedule">
                    <input name="save" type="submit" value="Update">
                </form>
                <a href="specific_schedule.jsp" class="back-link">Back</a><br><br>
            </section>
        </main>
    </div>
</body>
</html>