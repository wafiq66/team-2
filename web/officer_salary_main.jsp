<%@page import="com.ems.model.Salary" %>
<%@page import="com.ems.dao.SalaryDAO" %>
<%@page import="com.ems.dao.SalaryDAOImpl" %>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salary Report</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="css/emp-main-salary.css">
</head>
<body>
    <%
        final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
        final SalaryDAO salaryDAO = new SalaryDAOImpl();
        Employee[] employees = employeeDAO.getAllEmployee();
        Employee employee = null;
        
        Integer monthObject = (Integer) request.getAttribute("month");
        monthObject = (monthObject != null) ? monthObject : 0;
        int monthInt = monthObject.intValue();
        
        Integer yearObject = (Integer) request.getAttribute("year");
        yearObject = (yearObject != null) ? yearObject : 0;
        int year = yearObject.intValue();
        
        Salary targetSalary = (Salary) request.getAttribute("targetSalary");

        Salary[] salaries = null;
        if (monthInt > 0 && year > 0) {
            salaries = salaryDAO.getCalculatedEmployeeSalary(monthInt, year);
        }
    %>
    <div class="main-wrapper">
        <nav>
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
                    <h2>Salary Report</h2>
                </div>
            </header>
            <main>
                <br>
                <div class="salary-report-container">
                    <h3>Salary Report</h3>
                    <form action="employee_salary.view" method="post">
                        <label for="employeeID">Employee ID:</label>
                        <select name="employeeID" id="employeeID">
                            <option value="0" selected></option>
                            <% for (Employee e : employees) { %>
                                <option value="<%= e.getEmployeeID() %>"><%= e.getEmployeeID() %></option>
                            <% } %>
                        </select>
                        <label for="month">Month:</label>
                        <input type="month" name="month" id="month" required>
                        <input type="hidden" name="action" value="byMonth">
                        <input type="submit" value="Get Salary Report">
                    </form>
                    <br>
                    <table id="salaryReportTable" border="1">
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Employee Name</th>
                                <th>Month</th>
                                <th>Year</th>
                                <th>Total Hours Worked</th>
                                <th>Salary</th>
                            </tr>
                        </thead>
                        <tbody>  
                            <% if (targetSalary != null) {
                                employee = employeeDAO.getEmployeeById(targetSalary.getEmployeeID());
                            %>
                                <tr>
                                    <td><%= employee != null ? employee.getEmployeeID() : "N/A" %></td>
                                    <td><%= employee != null ? employee.getEmployeeName() : "N/A" %></td>
                                    <td><%= targetSalary.getSalaryMonth() %></td>
                                    <td><%= targetSalary.getSalaryYear() %></td>
                                    <td><%= targetSalary.getTotalHoursWorked() %></td>
                                    <td>RM<%= targetSalary.getSalaryAmount() %></td>
                                </tr>
                            <% } else if (salaries != null) {
                                for (Salary s : salaries) {
                                    employee = employeeDAO.getEmployeeById(s.getEmployeeID());
                            %>
                                <tr>
                                    <td><%= employee != null ? employee.getEmployeeID() : "N/A" %></td>
                                    <td><%= employee != null ? employee.getEmployeeName() : "N/A" %></td>
                                    <td><%= s.getSalaryMonth() %></td>
                                    <td><%= s.getSalaryYear() %></td>
                                    <td><%= s.getTotalHoursWorked() %></td>
                                    <td>RM<%= s.getSalaryAmount() %></td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="6"><em>No Record</em></td>
                                </tr>
                            <% } %>
                        </tbody>
</table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>

