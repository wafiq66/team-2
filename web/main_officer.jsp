<%@page import="com.ems.model.HROfficer" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>REZEKY TOMYAM</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="css/main-officer.css">
</head>
<body>
    <%
        HROfficer officer = (HROfficer) session.getAttribute("officerLog");
        String name = Character.toUpperCase(officer.getOfficerName().charAt(0)) + officer.getOfficerName().substring(1);
    %>
    <div class="header"> 
        <div class="header-content">
            <h1>Hi <%=name%>... Welcome to Rezky Tomyam</h1>
        </div>
        <div class="profile-pic"> 
            <img src="images/profile-pic-officer.jpg" alt="Profile Picture">
        </div>
    </div>
    <nav>
        <div class="page-title-box"> 
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
    <main>
        <section id="home">
            <h2>Home</h2>
            <p>  Lorem ipsum dolor sit amet consectetur adipisicing elit. Modi, provident voluptate aliquam tempora reprehenderit aperiam a id, officiis eligendi ullam excepturi, animi consectetur quam repudiandae placeat reiciendis cum recusandae? Eaque?   </p>
        </section>
    </main>
    <footer>
        <p>&copy; rezky tomyam employee management system</p>
    </footer>
    
</body>
</html>