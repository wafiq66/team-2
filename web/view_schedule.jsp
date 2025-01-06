<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>
<%@page import="com.ems.model.RestaurantManager" %>
<%@page import="com.ems.dao.ManagerDAO" %>
<%@page import="com.ems.dao.ManagerDAOImpl" %>
<%@page import="com.ems.model.Employee" %>
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

    
    <!-- Favicon -->
    <link rel="shortcut icon" type="image/x-icon" href="favicon.png">
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="bootstrap.min.css">
    
    <!-- Fontawesome CSS -->
    <link rel="stylesheet" href="font-awesome.min.css">
    
    <!-- Lineawesome CSS -->
    <link rel="stylesheet" href="line-awesome.min.css">
    
    <!-- Select2 CSS -->
    <link rel="stylesheet" href="select2.min.css">
    
    <!-- Datetimepicker CSS -->
    <link rel="stylesheet" href="bootstrap-datetimepicker.min.css">
    
    <!-- Tagsinput CSS -->
    <link rel="stylesheet" href="bootstrap-tagsinput/bootstrap-tagsinput.css">
    
    
    <!-- Main CSS -->
    <link rel="stylesheet" href="css/specific-schedule.css">
</head>
<body>
    <%      
        RestaurantManager manager = (RestaurantManager) session.getAttribute("managerLog");
        ManagerDAO managerDAO = new ManagerDAOImpl();
        int branchID = managerDAO.getRestaurantManagerBranchId(manager); // Replace with the desired branch ID (commented out for now)
        EmployeeDAO employeeDAO = new EmployeeDAOImpl();
        Employee[] employees = employeeDAO.getAllEmployeeByBranch(branchID);
        
        ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
        Schedule schedule;
    %>
    <div class="main-wrapper"> <!--add new class-->
    <nav>
        <div class="page-title-box-1"> <!--class page title tukar kat sini-->
            <h3>REZEKY TOMYAM</h3>
        </div>
        <ul>
            <li><a href="main_manager.jsp">Home</a></li>
            <li><a href="report_update.jsp">Report</a></li>
            <li><a href="#">Schedule</a></li>
            <li><a href="welcome.html">Log Out</a></li>
        </ul>
    </nav>

    <div class="content"> <!--aku buat class untuk title-->
        <header class="header">
            <div class="page-title-box"> <!---new class-->
                <h2>Schedule</h2>
            </div>
        </header>
    <main>
        <div class="card">
            <div class="card-content">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Employee Name</th>
                                <th>Off Date</th>
                                <th>Shift</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Employee employee: employees) { 
                                
                                if(employee.getEmployeeStatus()){
                            %>
                            <tr>
                                
                            <form action="edit_schedule.jsp" method="post">
                                    <%
                                        schedule = scheduleDAO.fetchLatestSchedule(employee);
                                    %>
                                    <td><%= employee.getEmployeeID() %></td>
                                    <td><%= employee.getEmployeeName() %></td>
                                    <td><%= schedule.getScheduleDate() %></td>
                                    <td><%= schedule.getStartShift() %> - <%= schedule.getEndShift() %></td>
                                    
                                    <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID()%>">
                                    <td><input type="submit" value="Update" class="edit-btn"></td>
                                </form>
                            </tr>
                            <% }} %>
                            
                            
                            
                            <!-- Add more rows as needed -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
</div>

</body>
</html>