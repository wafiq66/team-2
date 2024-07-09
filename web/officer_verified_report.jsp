<%@page import="com.ems.model.Report"%>
<%@page import="com.ems.dao.ReportDAOImpl"%>
<%@page import="com.ems.dao.ReportDAO"%>
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
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
    final ReportDAO reportDAO = new ReportDAOImpl();
    final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
    final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
    final BranchDAO branchDAO = new BranchDAOImpl();
    
    Branch[] branches = branchDAO.getAllBranch();
    
    Integer monthObj = (Integer) request.getAttribute("month");
    Integer yearObj = (Integer) request.getAttribute("year");
    
    int month = (monthObj != null) ? monthObj.intValue() : 0;
    int year = (yearObj != null) ? yearObj.intValue() : 0;
    
    RestaurantManager manager = (RestaurantManager) request.getAttribute("manager");
    String managerName = "";
    Report report = null;
    if (manager != null) {
        report = reportDAO.RetrieveReport(manager, month, year);
        managerName = manager.getManagerName();
    }
    
    Employee employee;
    Attendance[] attendances = null;
    
    if (report != null) {
        attendances = attendanceDAO.getAllAttendancesByReport(report);
    }

    String selectedBranch = request.getParameter("branch");
    String selectedMonth = request.getParameter("month");
    %>
    <div class="main-wrapper">
        <nav class="nav-bar">
            <div class="page-title-box-1">
                <h3>REZEKY TOMYAM</h3>
            </div>
            <ul>
                <li><a href="main_officer.jsp">Home</a></li>
                <li><a href="officer_employee_list.jsp">Employee</a></li>
                <li><a href="officer_salary_main.jsp">Salary</a></li>
                <li><a href="officer_verified_report.jsp">Report</a></li>
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
                        <label for="branch">Branch:</label>
                        <select name="branch" id="branch">
                        <% for (Branch branch : branches) { %>
                            <option value="<%= branch.getBranchID() %>" <%= String.valueOf(branch.getBranchID()).equals(selectedBranch) ? "selected" : "" %>><%= branch.getBranchName() %></option>
                        <% } %>
                        </select>
                        <label for="month">Month:</label>
                        <input type="month" name="month" value="<%= selectedMonth != null ? selectedMonth : "" %>" required>
                        <input type="hidden" name="action" value="getVerifiedReportOfficer">
                        <button type="submit" class="submit-button">Find</button><br>
                    </form>
                   <br>
                    <table class="verifiedTable" border="1">
                        <tr>
                            <th>Employee ID</th>
                            <th>Employee Name</th>
                            <th>Attendance ID</th>
                            <th>Attendance Date</th>
                            <th>Clock In Time</th>
                            <th>Clock Out Time</th>
                        </tr>
                        <% if (attendances == null || attendances.length == 0) { %>
                            <tr>
                                <td colspan="6" style="text-align:center;"><em>No Record Has Been Found</em></td>
                            </tr>
                        <% } else {
                            for (Attendance attendance : attendances) {
                                employee = employeeDAO.getEmployeeByAttendance(attendance);
                                if (employee!= null) {
                        %>
                        <tr>
                            <td><%= employee.getEmployeeID() %></td>
                            <td><%= employee.getEmployeeName() %></td>
                            <td><%= attendance.getAttendanceID() %></td>
                            <td><%= attendance.getAttendanceDate() %></td>
                            <td><%= attendance.getClockInTime() %></td>
                            <td><%= attendance.getClockOutTime() %></td>
                        </tr>
                        <%         }
                            }
                        } %>
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
