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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet" />
    <title>Salary Report</title>
    <link rel="stylesheet" href="css/emp-main-salary.css">
</head>
<body>
    <%
        final SalaryDAO salaryDAO = new SalaryDAOImpl();
        final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
        Employee employee = (Employee) session.getAttribute("employeeLog");
        Salary[] salaries = salaryDAO.getCalculatedEmployeeSalary(employee);
        
    %>
    <div class="main-wrapper"> <!--add new class for body-->

    <nav>
        <div class="page-title-box-1"> <!--class page title tukar kat sini-->
            <h3>REZEKY TOMYAM</h3>
        </div>
        <ul>
            <li><a href="main_employee.jsp">Home</a></li>
            <li><a href="employee_profile_main.jsp">Profile</a></li>
            <li><a href="employee_current_schedule.jsp">Schedule</a></li>
            <li><a href="employee_attendance.jsp">Attendance</a></li>
            <li><a href="employee_salary_main.jsp">Salary</a></li>
            <li><a href="welcome.html">Log Out</a></li>
        </ul>
    </nav>

     <!-- Content -->
     <div class="content"> <!---new class for content-->
            <header class="header"> <!---new class-->
                <div class="page-title-box"> <!---new class-->
                    <h3>Salary Report</h3>
                </div>
            </header>
    <main>
        <br>
        <div class="salary-report-container">
            <h3><%=employee.getEmployeeName()%></h3> <!--tukar tempat-->
            <table id="salaryReportTable" border="1">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th>Year</th>
                        <th>Total Hours Worked</th>
                        <th>Salary</th>
                    </tr>
                </thead>
                <tbody>  
                    <% 
                        
                        for(Salary s:salaries){%>
                     <tr>
                            <td><%= s.getSalaryMonth() %></td>
                            <td><%= s.getSalaryYear() %></td>
                            <td><%= s.getTotalHoursWorked() %></td>
                            <td>RM <%= s.getSalaryAmount() %></td>
                        </tr>
                    
                    <%} %>
                       
                </tbody>
            </table>
        </div>
    </main>
    </div>
    <footer> <!--- aku buang class footer-->
        <p>&copy; rezky tomyam employee management system</p>
    </footer>
</body>
</html>

