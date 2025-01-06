<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.time.LocalTime;" %>
<%@ page import="com.ems.model.Employee" %>
<%@ page import="com.ems.dao.EmployeeDAO" %>
<%@ page import="com.ems.dao.EmployeeDAOImpl" %>
<%@ page import="com.ems.model.Attendance" %>
<%@ page import="com.ems.dao.AttendanceDAO" %>
<%@ page import="com.ems.dao.AttendanceDAOImpl" %>
<%@ page import="com.ems.model.Schedule" %>
<%@ page import="com.ems.dao.ScheduleDAO" %>
<%@ page import="com.ems.dao.ScheduleDAOImpl" %>
<%@ page import="java.time.LocalDate, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
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
    <div class="main-wrapper"> <!--add new class for body-->
        <% 
            Employee employee = (Employee)session.getAttribute("employeeLog");
            ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
            Schedule schedule = scheduleDAO.getActiveScheduleByEmployeeID(employee.getEmployeeID());
            AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
            // Initialize variables
            boolean hasSchedule = (schedule != null);
            boolean isWithinRange = false;
            boolean clockInOrOut = false;
            boolean neverClockedIn = false;
            String formattedDateTime = ""; // Declare here
            
            if (hasSchedule) {
                Timestamp startShift = schedule.getStartShift();
                Timestamp endShift = schedule.getEndShift();
                
                // Get the current local time
                LocalTime currentTime = LocalTime.now();
                
                // Extract time from the Timestamp
                LocalTime startTime = startShift.toLocalDateTime().toLocalTime();
                LocalTime endTime = endShift.toLocalDateTime().toLocalTime();
                
                // Get the current local date and time
                LocalDateTime now = LocalDateTime.now();
                LocalDate today = LocalDate.now();
                
                // Format the date and time
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                formattedDateTime = now.format(formatter); // Assign the formatted date here
                
                // Check if current time is within the schedule range
                isWithinRange = (currentTime.isAfter(startTime) || currentTime.equals(startTime)) && 
                                (currentTime.isBefore(endTime) || currentTime.equals(endTime));
                
                
                clockInOrOut = scheduleDAO.getLockedScheduleStatus(schedule.getScheduleID());
                
                neverClockedIn = !attendanceDAO.clockInChecker(schedule.getScheduleID(), today);
                
                System.out.println(neverClockedIn);
            }
        %>
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
                <h3>Attendance</h3>
            </div>
        </header>
    

        <main> <!--new tag-->
        <a href="main_employee.jsp" class="back-link">Back</a> <!--new class added-->
            <div class="attendance-container">
                <div class="date-time">
                    <p id="currentDateTime"><%= hasSchedule ? formattedDateTime : "No active schedule available." %></p>
                </div>
                <p style="color: red">${messageFail}</p>
                <p style="color: green">${messageSuccess}</p>
                
                <% if (hasSchedule) { %>
                    <form action="record_attendance.do" method="post">
                        <input type="hidden" name="scheduleID" value="<%= schedule.getScheduleID() %>">
                        <input type="hidden" name="action" value="in">
                        <input type="submit" id="employeeId" value="Clock In" 
                               <%= isWithinRange && !clockInOrOut && neverClockedIn ? "" : "disabled" %>
                               >
                    </form>
                               
                    <form action="record_attendance.do" method="post">
                        <input type="hidden" name="scheduleID" value="<%= schedule.getScheduleID() %>">
                        <input type="hidden" name="action" value="out">
                        <input type="submit" id="employeeId" value="Clock Out" 
                               <%= clockInOrOut && !isWithinRange ? "" : "disabled" %>
                               >
                    </form>
                               
                    <form id="emergencyClockOutFormTrigger">
                        <input 
                            type="button" 
                            id="employeeId" 
                            class="emergency-btn"
                            value="Emergency Clock Out" 
                            onclick="showConfirmation()" 
                            <%= clockInOrOut ? "" : "disabled" %>
                        >
                    </form>
                <% } else { %>
                    <p style="color: red;">You do not have an active schedule. You cannot clock in or clock out.</p>
                <% } %>
                
                <!-- Emergency Clock Out Form Popup -->
                <div id="emergencyFormPopup" class="popup-overlay">
                    <div class="popup-content">
                        <h3>Emergency Clock Out Form</h3>
                        <form id="emergencyClockOutForm" action="record_attendance.do" method="post">
                            <input type="hidden" name="scheduleID" value="<%= hasSchedule ? schedule.getScheduleID() : "" %>">
                            <input type="hidden" name="emergency" value="true">
                            <input type="hidden" name="action" value="out">
                            <div class="form-group">
                                <label for="reason">Reason for Emergency Clock Out:</label>
                                <textarea id="reason" name="reasonOut" required></textarea>
                            </div>
                            <div class="button-group">
                                <button type="button" class="btn btn-cancel" onclick="closeEmergencyForm()">Cancel</button>
                                <button type="submit" class="btn btn-submit">Submit</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Confirmation Popup -->
                <div id="confirmationPopup" class="popup-overlay">
                    <div class="popup-content confirmation-popup">
                        <h3>Emergency Clock Out</h3>
                        <p>Confirm clock out? Emergency clock out is final and will be recorded.</p>
                        <div class="button-group">
                            <button class="btn btn-cancel" onclick="closeConfirmation()">Cancel</button>
                            <button class="btn btn-continue" onclick="showEmergencyForm()">Continue</button>
                        </div>
                    </div>
                </div>

                <a href="attandance_history.jsp">View Attendance History</a>
                
            </div>
        </main>
    </div>
    <footer> <!-- aku delete class footer-->
        <p>&copy; rezky tomyam employee management system</p>
    </footer>
</div>
</div>
</body>
<script>
    function showConfirmation() {
        document.getElementById('confirmationPopup').style.display = 'block';
    }
    
    function closeConfirmation() {
        document.getElementById('confirmationPopup').style.display = 'none';
    }
    
    function showEmergencyForm() {
        closeConfirmation();
        document.getElementById('emergencyFormPopup').style.display = 'block';
    }
    
    function closeEmergencyForm() {
        document.getElementById('emergencyFormPopup').style.display = 'none';
    }
    
    // Add this to your emergency clock out button
    document.querySelector('input[value="Emergency Clock Out"]').onclick = function(e) {
        e.preventDefault();
        showConfirmation();
    };
</script>
</html>