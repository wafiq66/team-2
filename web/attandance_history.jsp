<%@page import="com.ems.model.Employee" %>
<%@page import="com.ems.model.Schedule" %>
<%@page import="com.ems.dao.EmployeeDAO" %>
<%@page import="com.ems.dao.EmployeeDAOImpl" %>
<%@page import="com.ems.dao.ScheduleDAO" %>
<%@page import="com.ems.dao.ScheduleDAOImpl" %>
<%@page import="com.ems.model.Attendance" %>
<%@page import="com.ems.dao.AttendanceDAO" %>
<%@page import="com.ems.dao.AttendanceDAOImpl" %>

<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet" />
    <title>Attendance History</title>
    <link rel="stylesheet" href="css/history.css">
</head>
<body>
    <%
        final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
        Employee employee = (Employee) session.getAttribute("employeeLog");
        
        Attendance[] attendance;
        
        int[] attendanceIDArray = (int[]) request.getAttribute("attendanceID");
        // Assuming attendanceIDArray is already defined and populated somewhere in your code

        if (attendanceIDArray != null) {
            // Check if the first element is -999
            if (attendanceIDArray.length == 1 && attendanceIDArray[0] == -999) {
                // Do nothing if attendanceIDArray contains -999
                attendance = new Attendance[0];
            } else {
                // Proceed to retrieve attendance records using attendanceIDArray
                attendance = attendanceDAO.selectAllAttendance(attendanceIDArray);
            }
        } else {
            // If attendanceIDArray is null, get attendance records for the employee
            attendance = attendanceDAO.selectAllAttendance(employee);
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
    %>
    <div class="main-wrapper">
        <nav class="nav-bar">
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
                    <h3> Employee Attendance History</h3>
                </div>
            </header>

            <main>
                <a href="employee_attendance.jsp" class="back-link">Back</a>
                <div class="attendance-container">
                    <h2> <%= employee.getEmployeeName() %>'s Attendance History</h2>
                    <form action="attendance_record.view" method="post">
                        <label for="month">Month:</label>
                        <input type="month" name="month" id="month" required>
                        <button type="submit" class="submit-button">Find</button>
                    </form>

                    <table id="attendanceHistoryTable" border="1">
                        <thead>
                            <tr>
                                <th>Attendance Date</th>
                                <th>Clock In Time</th>
                                <th>Clock Out Time</th>
                                <th>Overtime Duration</th>
                                <th>Total Hours</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (attendance != null && attendance.length > 0) {
                                    for (Attendance a : attendance) {
                                        System.out.println(a);
                            %>
                            <tr>
                                <td><%= a.getAttendanceDate() %></td>
                                <td><%= sdf.format(a.getClockInTime()) %></td>
                                <td><%= sdf.format(a.getClockOutTime()) %></td>
                                <td>
                                    <%
                                        if (a.getOvertimeDuration() != null) {
                                            // Format the overtime duration if it's not null
                                            out.print(sdf.format(a.getOvertimeDuration()));
                                        } else {
                                            // Handle the case where overtimeDuration is null
                                            out.print("N/A"); // or you can use an empty string: out.print("");
                                        }
                                    %>
                                </td>
                                <td><%= a.calculateTotalHours() %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5"> </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>