package com.ems.dao;

import com.ems.model.Employee;
import com.ems.model.Schedule;
import com.ems.model.Attendance;
import com.ems.connection.Connect;
import com.ems.dao.EmployeeDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.time.LocalDate;

public class AttendanceDAOImpl implements AttendanceDAO {

    private Connection conn;

    public AttendanceDAOImpl() {
        this.conn = Connect.getConnection();
    }

    @Override
    public void clockIn(Attendance attendance) {
        String sql = "INSERT INTO attendance (ClockInTime, LateClockInDuration, ScheduleID) VALUES (?, ?, ?)"; // Updated SQL query

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            // Set the parameters for the insert
            statement.setTimestamp(1, attendance.getClockInTime()); // Assuming clockInTime is a Timestamp
            statement.setTimestamp(2, attendance.getLateClockInDuration()); // Assuming lateClockInDuration is a Timestamp
            statement.setInt(3, attendance.getScheduleID()); // Assuming scheduleID is an int

            statement.executeUpdate(); // Execute the insert statement
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error inserting attendance: " + e.getMessage(), e);
        }
    }
    
    @Override
    public boolean clockInChecker(int scheduleID, LocalDate date) {
        String sql = "SELECT COUNT(*) FROM CLOCKIN_HISTORY WHERE SCHEDULEID = ? AND ATTENDANCEDATE = ?";
        try (PreparedStatement preparedStatement = conn.prepareStatement(sql)) {
            preparedStatement.setInt(1, scheduleID);
            // Convert LocalDate to java.sql.Date
            preparedStatement.setDate(2, java.sql.Date.valueOf(date)); // Convert LocalDate to SQL Date

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    // If count is greater than 0, then clock-in exists
                    return resultSet.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Handle exceptions properly in production code
        }
        return false; // No record found
    }
    
    @Override
    public Attendance selectAttendanceByScheduleID(int scheduleID) {
        String sql = "SELECT AttendanceID, ClockInTime, LateClockInDuration, ScheduleID FROM working WHERE ScheduleID = ?";
        Attendance attendance = null; // Initialize attendance to null

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            // Set the parameters for the select
            statement.setInt(1, scheduleID);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) { // Check if there is a result
                    attendance = new Attendance();
                    attendance.setAttendanceID(resultSet.getInt("AttendanceID")); // Assuming AttendanceID is an int
                    attendance.setClockInTime(resultSet.getTimestamp("ClockInTime")); // Assuming ClockInTime is a Timestamp
                    attendance.setLateClockInDuration(resultSet.getTimestamp("LateClockInDuration")); // Assuming LateClockInDuration is a Timestamp
                    attendance.setScheduleID(resultSet.getInt("ScheduleID")); // Assuming ScheduleID is an int
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving attendance: " + e.getMessage(), e);
        }

        return attendance; // Return the attendance record (could be null if not found)
    }
    
    public Attendance updateAttendance(Attendance attendance) {
        String sql = "UPDATE Attendance SET " +
                     "ClockInTime = ?, " +
                     "ClockOutTime = ?, " +
                     "OvertimeDuration = ?, " +
                     "EmergencyLeaveNote = ?, " +
                     "ScheduleID = ?, " +
                     "LateClockInDuration = ? " +
                     "WHERE AttendanceID = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            // Set the parameters for the update
            statement.setTimestamp(1, attendance.getClockInTime()); // Assuming ClockInTime is a Timestamp
            statement.setTimestamp(2, attendance.getClockOutTime()); // Assuming ClockOutTime is a Timestamp
            statement.setTimestamp(3, attendance.getOvertimeDuration()); // Assuming OvertimeDuration is a Timestamp
            statement.setString(4, attendance.getEmergencyLeaveNote()); // Assuming EmergencyLeaveNote is a String
            statement.setInt(5, attendance.getScheduleID()); // Assuming ScheduleID is an int
            statement.setTimestamp(6, attendance.getLateClockInDuration()); // Assuming LateClockInDuration is a Timestamp
            statement.setInt(7, attendance.getAttendanceID()); // Assuming AttendanceID is an int

            // Execute the update
            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                return attendance; // Return the updated attendance object
            } else {
                // Handle the case where no rows were updated (e.g., invalid AttendanceID)
                throw new RuntimeException("No attendance record found with ID: " + attendance.getAttendanceID());
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error updating attendance: " + e.getMessage(), e);
        }
    }
    
    @Override
    public Attendance[] selectAllAttendance(int[] attendanceIDs) {
        // Create a placeholder for the SQL query
        StringBuilder sql = new StringBuilder("SELECT ATTENDANCEID, CLOCKINTIME, CLOCKOUTTIME, OVERTIMEDURATION, EMERGENCYLEAVENOTE, SCHEDULEID, LATECLOCKINDURATION, EMPLOYEEID, BRANCHID " +
                                              "FROM ATTENDANCE_RECORD " +
                                              "WHERE ATTENDANCEID IN (");

        // Append placeholders for the prepared statement
        for (int i = 0; i < attendanceIDs.length; i++) {
            sql.append("?");
            if (i < attendanceIDs.length - 1) {
                sql.append(", ");
            }
        }
        sql.append(")");

        // Convert int[] to Integer[]
        Integer[] params = new Integer[attendanceIDs.length];
        for (int i = 0; i < attendanceIDs.length; i++) {
            params[i] = attendanceIDs[i]; // Autoboxing from int to Integer
        }

        // Execute the query with the attendanceIDs
        return executeAttendanceQuery(sql.toString(), params);
    }
    
    @Override
    public Attendance[] selectAllAttendance(int year, int month, Employee employee) {
        String sql = "SELECT ATTENDANCEID, CLOCKINTIME, CLOCKOUTTIME, OVERTIMEDURATION, EMERGENCYLEAVENOTE, SCHEDULEID, LATECLOCKINDURATION, EMPLOYEEID, BRANCHID " +
                     "FROM ATTENDANCE_RECORD " +
                     "WHERE YEAR = ? AND MONTH = ? AND EMPLOYEEID = ?";
        return executeAttendanceQuery(sql, year, month, employee.getEmployeeID());
    }

    @Override
    public Attendance[] selectAllAttendance(Employee employee) {
        String sql = "SELECT ATTENDANCEID, CLOCKINTIME, CLOCKOUTTIME, OVERTIMEDURATION, EMERGENCYLEAVENOTE, SCHEDULEID, LATECLOCKINDURATION, EMPLOYEEID, BRANCHID " +
                     "FROM ATTENDANCE_RECORD " +
                     "WHERE EMPLOYEEID = ?";
        return executeAttendanceQuery(sql, employee.getEmployeeID());
    }

    @Override
    public Attendance[] selectAllAttendance(int year, int month) {
        String sql = "SELECT ATTENDANCEID, CLOCKINTIME, CLOCKOUTTIME, OVERTIMEDURATION, EMERGENCYLEAVENOTE, SCHEDULEID, LATECLOCKINDURATION, EMPLOYEEID, BRANCHID " +
                     "FROM ATTENDANCE_RECORD " +
                     "WHERE YEAR = ? AND MONTH = ?";
        return executeAttendanceQuery(sql, year, month);
    }

    @Override
    public Attendance[] selectAllAttendance(int year, int month, int branch) {
        String sql = "SELECT ATTENDANCEID, CLOCKINTIME, CLOCKOUTTIME, OVERTIMEDURATION, EMERGENCYLEAVENOTE, SCHEDULEID, LATECLOCKINDURATION, EMPLOYEEID, BRANCHID " +
                     "FROM ATTENDANCE_RECORD " +
                     "WHERE YEAR = ? AND MONTH = ? AND BRANCHID = ?";
        return executeAttendanceQuery(sql, year, month, branch);
    }

    private Attendance[] executeAttendanceQuery(String sql, Integer... params) {
        List<Attendance> attendanceList = new ArrayList<>();

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            // Set parameters based on the number of params provided
            for (int i = 0; i < params.length; i++) {
                statement.setInt(i + 1, params[i]);
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Attendance attendance = new Attendance();
                    attendance.setAttendanceID(resultSet.getInt("ATTENDANCEID"));
                    attendance.setClockInTime(resultSet.getTimestamp("CLOCKINTIME"));
                    attendance.setClockOutTime(resultSet.getTimestamp("CLOCKOUTTIME"));
                    attendance.setOvertimeDuration(resultSet.getTimestamp("OVERTIMEDURATION"));
                    attendance.setEmergencyLeaveNote(resultSet.getString("EMERGENCYLEAVENOTE"));
                    attendance.setScheduleID(resultSet.getInt("SCHEDULEID"));
                    attendance.setLateClockInDuration(resultSet.getTimestamp("LATECLOCKINDURATION"));

                    attendanceList.add(attendance);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving attendance: " + e.getMessage(), e);
        }

        return attendanceList.toArray(new Attendance[0]); // Convert list to array and return
    }
}
