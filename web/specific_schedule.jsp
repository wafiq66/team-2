<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.dao.EmployeeScheduleDAO" %>
<%@page import="com.ems.dao.EmployeeScheduleDAOImpl" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>
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
                    <a href="update_schedule.jsp" class="update">Update Schedule</a><br><br>
                    <a href="manage_schedule_main.jsp" class="back-link">Back</a><br><br>
                    <p id="message">${message}</p>
                    <section class="employee-schedule">
                        <table class="updateTable" border="1">
                            <thead>
                                <tr>
                                    <th>Employee ID</th>
                                    <th>Employee Name</th>
                                    <th>Schedule Date</th>
                                    <th>Start Shift</th>
                                    <th>End Shift</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    Schedule schedule = (Schedule) session.getAttribute("editingSchedule");
                                    EmployeeScheduleDAO employeeScheduleDAO = new EmployeeScheduleDAOImpl();
                                    int[] employeeIDs = employeeScheduleDAO.getAllScheduleEmployee(schedule);
                                    EmployeeDAO employeeDAO = new EmployeeDAOImpl();
                                    for (int employeeID : employeeIDs) {
                                        Employee employee = employeeDAO.getEmployeeById(employeeID);
                                        if (employee.getEmployeeStatus()) { // Check if EmployeeStatus is true
                                %>
                                <tr>
                                    <td><%=employee.getEmployeeID()%></td>
                                    <td><%=employee.getEmployeeName()%></td>
                                    <td><%=schedule.getScheduleDate()%></td>
                                    <td><%=schedule.getStartShift()%></td>
                                    <td><%=schedule.getEndShift()%></td>
                                </tr>
                                <%
                                        }
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
</body>
</html>