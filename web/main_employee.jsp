<%@page import="com.ems.model.Employee" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>REZEKY TOMYAM</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="css/main-emp.css">
</head>
<body>
    <%  
        Employee employee = (Employee) session.getAttribute("employeeLog");
        String name = Character.toUpperCase(employee.getEmployeeName().charAt(0)) + employee.getEmployeeName().substring(1);
    %>
    <div class="header"> 
        <div class="header-content">
            <h1>Hi <%=name%>... Welcome to Rezky Tomyam</h1>
        </div>
        <div class="profile-pic"> 
            <img src="images/profile-pic.jpg" alt="Profile Picture">
        </div>
    </div>
    <nav>
        <div class="page-title-box"> 
            <h3>REZEKY TOMYAM</h3>
        </div>
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="employee_profile_main.jsp">Profile</a></li>
            <li><a href="employee_current_schedule.jsp">Schedule</a></li>
            <li><a href="employee_attendance.jsp">Attendance</a></li>
            <li><a href="employee_salary_main.jsp">Salary</a></li>
            <li><a href="welcome.html">Log Out</a></li>
        </ul>
    </nav>
    <main>
        <section id="home">
            <h2>Employee Home Page</h2>
            <p> To listen closely and reply well is the highest perfection we are able to attain in the art of conversation.</p>
            <iframe src="https://www.google.com/maps/embed?pb=!1m23!1m12!1m3!1d127553.27814134693!2d101.75844122917441!3d2.4937222242732484!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!4m8!3e6!4m0!4m5!1s0x31cdf128579bad0f%3A0xcb04e0905d27e30c!2s313%2C%205%2C%20Kampung%20Baru%20Sirusa%2C%2071050%20Port%20Dickson%2C%20Negeri%20Sembilan!3m2!1d2.4937101!2d101.840764!5e0!3m2!1sen!2smy!4v1719996691944!5m2!1sen!2smy" width="400" height="300" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
            <img src="images/rezeky-tomyam.jpg" width="400" height="300" alt="Description of image">
        </section>
    </main>
    <footer>
        <p>&copy; rezky tomyam employee management system</p>
    </footer>
    
</body>
</html>