<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Date"%>
<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>
<%@page import="com.ems.model.Attendance" %>
<%@page import="com.ems.dao.AttendanceDAO" %>
<%@page import="com.ems.dao.AttendanceDAOImpl" %>
<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet" />
    <title>Attendance Page</title>
    <link rel="stylesheet" href="css/emp-attendance.css">
</head>
<body>
    <div class="main-wrapper">
        <nav>
            <div class="page-title-box-1">
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

        <div class="content">
            <header class="header">
                <div class="page-title-box">
                    <h3>Attendance</h3>
                </div>
            </header>

            <main>
                <a href="main_employee.jsp" class="back-link">Back</a>
                <div class="attendance-container">
                    <div class="date-time">
                        <p id="currentDateTime"><%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></p>
                    </div>
                    <%
                        String currentTime = new SimpleDateFormat("HH:mm:ss").format(new java.util.Date());
                        
                        final ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
                        final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
                        boolean allowClockIn = false, allowClockOut = false;
                        Employee employee = (Employee) session.getAttribute("employeeLog");
                        Schedule latestSchedule = scheduleDAO.fetchLatestSchedule(employee);
                        Attendance latestAttendance = attendanceDAO.getLatestAttendance(employee);
                        
                        if(latestAttendance.isBothNone()){
                            allowClockOut = false;
                            if (currentTime.compareTo(latestSchedule.getStartShift()) >= 0 && currentTime.compareTo(latestSchedule.getEndShift()) <= 0) {
                                allowClockIn = true;
                            } else {
                                allowClockIn = false;
                            }
                            
                        }
                        else if(latestAttendance.isBothNotNone()){
                            allowClockOut = false;
                            if (currentTime.compareTo(latestSchedule.getStartShift()) >= 0 && currentTime.compareTo(latestSchedule.getEndShift()) <= 0) {
                                allowClockIn = true;
                            } else {
                                allowClockIn = false;
                            }
                        }
                        else if (latestAttendance.isClockOutOnlyNone()){
                            allowClockOut = true;
                            allowClockIn = false;
                        }
                        System.out.println(allowClockOut);
                        System.out.println(allowClockIn);
                        System.out.println(latestAttendance.getClockInTime());
                        System.out.println(latestAttendance.getClockOutTime());
                        
                    %>
                    <form action="record_attendance.do" method="post">
                        <input type="hidden" name="action" value="in">
                        <input type="submit" id="employeeId" value="Clock In" 
                               <%=allowClockIn? "":"disabled"%>
                               >
                    </form>
                    <form action="record_attendance.do" method="post">
                        <input type="hidden" name="action" value="out">
                        <input type="submit" id="employeeId" value="Clock Out" 
                               <%=allowClockOut? "":"disabled"%>
                               >
                    </form>
                    <p>${message}</p>
                    <a href="attandance_history.jsp">View Attendance History</a>
                    
                </div>
            </main>
        </div>

        <footer>
            <p>&copy; rezky tomyam employee management system</p>
        </footer>
    </div>
</body>
</html>
