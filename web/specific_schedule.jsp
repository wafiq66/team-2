<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>

<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
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
    <link rel="stylesheet" href="css/specific-schedule.css">
</head>
<body>
    <%
        Employee employee = (Employee) session.getAttribute("employee");
        
        ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
        Schedule[] schedulesAll = scheduleDAO.getAllScheduleByEmployeeID(employee.getEmployeeID());
        Schedule scheduleActive = scheduleDAO.getActiveScheduleByEmployeeID(employee.getEmployeeID());
        Schedule scheduleFuture = scheduleDAO.getFutureScheduleByEmployeeID(employee.getEmployeeID());
        
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
                    <h2>Employee Schedule</h2>
                </div>
            </header>
            <main>
                <div class="update-container">
                    <a href="manage_schedule_main.jsp" class="back-link">Back</a><br><br>
                    <section class="employee-schedule">
                        
                        <!--future schedule table-->
                            <table class="schedule-table">
                                <thead>
                                    <tr>
                                        <th colspan="7" style="text-align: center;">Next Week Schedule</th>
                                    </tr>
                                    <tr>
                                        <th>Employee Name</th>
                                        <th>Off Date</th>
                                        <th>Begin Date</th>
                                        <th>End Date</th>
                                        <th>Start Shift</th>
                                        <th>End Shift</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        if (scheduleFuture != null) { // Check if scheduleActive exists
                                    %>
                                        <tr>
                                            <td><%= employee.getEmployeeName() %></td>
                                            <td><%= scheduleFuture.getOffDay() %></td>
                                            <td><%= scheduleFuture.getDateBegin() %></td>
                                            <td><%= scheduleFuture.getDateEnd() %></td>
                                            <td><%= sdf.format(scheduleFuture.getStartShift())  %></td>
                                            <td><%= sdf.format(scheduleFuture.getEndShift())  %></td>
                                            <td>
                                                <form method="post" action="manage_schedule.do">
                                                    <input type="hidden" value="<%= scheduleFuture.getScheduleID() %>" name="scheduleID">
                                                    <input type="hidden" value="editingSchedule" name="action">
                                                    <button type="submit" class="view-btn">Edit</button>
                                                </form>
                                            </td>
                                        </tr>
                                    <%
                                        } else { // Schedule does not exist
                                    %>
                                        <tr>
                                            <td colspan="6" style="text-align: center;">No schedule found for this employee.</td>
                                            <td>
                                                <a href="future_schedule.jsp" class="view-btn">Create</a>
                                            </td>
                                        </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>

                            <br><br>
                        <p style="color: red">${message}</p>
                        <!--current schedule table-->
                        <table class="schedule-table">
                            <thead>
                                <tr>
                                    <th colspan="7" style="text-align: center;">Current Schedule</th>
                                </tr>
                                <tr>
                                    <th>Employee Name</th>
                                    <th>Off Date</th>
                                    <th>Begin Date</th>
                                    <th>End Date</th>
                                    <th>Start Shift</th>
                                    <th>End Shift</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (scheduleActive != null) { // Check if scheduleActive exists
                                %>
                                    <tr>
                                        <td><%= employee.getEmployeeName() %></td>
                                        <td><%= scheduleActive.getOffDay() %></td>
                                        <td><%= scheduleActive.getDateBegin() %></td>
                                        <td><%= scheduleActive.getDateEnd() %></td>
                                        <td><%= sdf.format(scheduleActive.getStartShift())  %></td>
                                        <td><%= sdf.format(scheduleActive.getEndShift())  %></td>
                                        <td>
                                            <form method="post" action="manage_schedule.do">
                                                <input type="hidden" value="<%= scheduleActive.getScheduleID() %>" name="scheduleID">
                                                <input type="hidden" value="editingSchedule" name="action">
                                                <button type="submit" class="view-btn">Edit</button>
                                            </form>
                                        </td>
                                    </tr>
                                <%
                                    } else { // Schedule does not exist
                                %>
                                    <tr>
                                        <td colspan="6" style="text-align: center;">No active schedule found for this employee.</td>
                                        <td>
                                            <a href="create_schedule.jsp" class="view-btn">Create</a>
                                        </td>
                                    </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                            
                        <br><br>
                        
                        <!--previous schedule table-->
                        <table class="schedule-table">
                            <thead>
                                <tr>
                                    <th colspan="7" style="text-align: center;">History Schedule</th>
                                </tr>
                                <tr>
                                    <th>Employee Name</th>
                                    <th>Off Date</th>
                                    <th>Begin Date</th>
                                    <th>End Date</th>
                                    <th>Start Shift</th>
                                    <th>End Shift</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (schedulesAll != null && schedulesAll.length > 0) {
                                        // The array is not empty
                                        for(Schedule schedule:schedulesAll){
                                %>
                                    <tr>
                                        <td><%= employee.getEmployeeName() %></td>
                                        <td><%= schedule.getOffDay() %></td>
                                        <td><%= schedule.getDateBegin() %></td>
                                        <td><%= schedule.getDateEnd() %></td>
                                        <td><%= sdf.format(schedule.getStartShift())  %></td>
                                        <td><%= sdf.format(schedule.getEndShift())  %></td>
                                    </tr>
                                <%            
                                        }
                                    } else {
                                        // The array is empty or null
                                %>        
                                    <tr>
                                        <td colspan="6" style="text-align: center;">No schedule found for this employee.</td>
                                    </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </section>
                </div>
            </main>
        </div>
        <footer>
            <p>&copy; rezky tomyam employee management system</p>
        </footer>
    </div>
                    <script>
                        function confirmDelete() {
                            return confirm("Are you sure you want to delete this schedule?");
                        }
                    </script>               
</body>
</html>