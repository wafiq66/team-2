<%@page import="com.ems.model.RestaurantManager"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>REZEKY TOMYAM</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="css/main-man.css">
</head>
<body>
    <%
        RestaurantManager manager = (RestaurantManager) session.getAttribute("managerLog");
        String name = Character.toUpperCase(manager.getManagerName().charAt(0)) + manager.getManagerName().substring(1);
    %>
    <div class="header"> 
        <div class="header-content">
            <h1>Hi <%=name%>... Welcome to Rezky Tomyam</h1>
        </div>
        <div class="profile-pic"> 
            <img src="images/profile-pic-manager.jpg" alt="Profile Picture">
        </div>
    </div>
    <nav>
        <div class="page-title-box"> 
            <h3>REZEKY TOMYAM</h3>
        </div>
        <ul>
            <li><a href="main_manager.jsp">Home</a></li>
            <li><a href="report_update.jsp">Report</a></li>
            <li><a href="manage_schedule_main.jsp">Schedule</a></li>
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