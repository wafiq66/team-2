<%@page import="com.ems.model.Branch" %>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.dao.BranchDAO" %>
<%@page import="com.ems.dao.BranchDAOImpl" %>
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
    <title>Employee List</title>
    
    <!-- Favicon -->
    <link rel="shortcut icon" type="image/x-icon" href="favicon.png">
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="bootstrap.min.css">
    
    <!-- Fontawesome CSS -->
    <link rel="stylesheet" href="font-awesome.min.css">
    
    <!-- Lineawesome CSS-->
    <link rel="stylesheet" href="line-awesome.min.css">
    
    <!-- Select2 CSS -->
    <link rel="stylesheet" href="select2.min.css">
    
    <!-- Datetimepicker CSS -->
    <link rel="stylesheet" href="bootstrap-datetimepicker.min.css">
    
    <!-- Tagsinput CSS -->
    <link rel="stylesheet" href="bootstrap-tagsinput/bootstrap-tagsinput.css">
    
    <!-- Main CSS -->
    <link rel="stylesheet" href="css/officer-emplist.css">
</head>
<body>
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
                    <h2>List Of Employee</h2>
                </div>
            </header>
            <main>
                <a href="verify_passport.jsp" class="add-emp">Add Employee +</a>
                <%
                    final BranchDAO branchDAO = new BranchDAOImpl();
                    final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
                    Employee[] employees = null;
                    Branch[] branches = null;
                    branches = branchDAO.getAllBranch();

                    for(Branch branch:branches){
                %>
                <div class="list-container">
                    <table class="employeeTable" border="1">
                        <h4>Branch: <%=branch.getBranchName() %></h4>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Password</th>
                                <th>Name</th>
                                <th>Phone Number</th>
                                <th>Email</th>
                                <th>Passport Number</th>
                                <th>Status</th>
                                <th>Hourly Pay</th>
                                <th>View</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            employees = employeeDAO.getAllEmployeeByBranch(branch.getBranchID());
                            for(Employee employee:employees){
                        %>
                            <tr>
                                <form action="manage_employee.do" method="post">
                                    <td><%= employee.getEmployeeID() %></td>
                                    <td>*****</td>
                                    <td><%= employee.getEmployeeName() %></td>
                                    <td><%= employee.getEmployeePhoneNumber() %></td>
                                    <td><%= employee.getEmployeeEmail() %></td>
                                    <td><%= employee.getEmployeePassportNumber() %></td>
                                    <td><%= employee.getEmployeeStatus()? "Available" : "Not Available" %></td>
                                    <td><%= employee.getEmployeeHourlyPay() %></td>
                                    
                                    <input type="hidden" name="action" value="viewEmployee">
                                    <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
                                    <td><input type="submit" value="View" class="details"></td>
                                </form>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div><br><br>
                <%
                    }
                %>
            </main>
        </div>
        <footer>
            <p>&copy; rezky tomyam employee management system</p>
        </footer>
    </div>
</body>
</html>