<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>
<%@page import="com.ems.model.RestaurantManager" %>
<%@page import="com.ems.dao.ManagerDAO" %>
<%@page import="com.ems.dao.ManagerDAOImpl" %>
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
        Schedule[] schedules = scheduleDAO.getAllScheduleByBranch(branchID);
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
                    <form action="view_schedule.do" method="post">
                        <input type="submit" value="View Current Schedule"><br><br>
                    </form>
                    <a href="create_schedule.jsp" class="create-sch">Create Schedule</a> <br> <br>
                    <p>${message}</p>
                    <table class="scheduleTable" border="1">
                        <tr>
                            <thead>
                                <th>Schedule Date</th>
                                <th>Start Shift</th>
                                <th>End Shift</th>
                                <th>View Schedule</th>
                            </thead>
                        </tr>
                        <tbody>
                            <% for (Schedule schedule : schedules) { %>
                            <tr>
                                <form action="manage_schedule.do">
                                    <td><%= schedule.getScheduleDate() %></td>
                                    <td><%= schedule.getStartShift() %></td>
                                    <td><%= schedule.getEndShift() %></td>
                                    <input type="hidden" name="scheduleID" value="<%= schedule.getScheduleID() %>">
                                    <input type="hidden" name="action" value="viewSpecificSchedule">
                                    <td><input type="submit" value="View" class="details"></td>
                                </form>
                            </tr>
                            <% } %>
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