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

public class ScheduleDAOImpl implements ScheduleDAO {

    private Connection conn;

    public ScheduleDAOImpl() {
        this.conn = Connect.getConnection();
    }
    @Override
    public Schedule getActiveScheduleByEmployeeID(int employeeID) {
        Schedule schedule = null; // Initialize to null to indicate no schedule found
        String sql = "SELECT * FROM active_schedule WHERE employeeid = ?"; // Query modified to filter by employeeID

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, employeeID);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) { // Check if there is at least one result
                    schedule = new Schedule();
                    schedule.setScheduleID(resultSet.getInt("scheduleid"));
                    schedule.setStartShift(resultSet.getTimestamp("startshift"));
                    schedule.setEndShift(resultSet.getTimestamp("endshift"));
                    schedule.setOffDay(resultSet.getDate("offday")); // Assuming offday is a Date
                    schedule.setDateBegin(resultSet.getDate("datebegin")); // Assuming datebegin is a Date
                    schedule.setDateEnd(resultSet.getDate("dateend")); // Corrected to use dateend
                    schedule.setEmployeeID(resultSet.getInt("employeeid")); // Assuming employeeid is relevant
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving active schedule by employee ID: " + e.getMessage(), e);
        }

        return schedule; // Return the found schedule or null if not found
    }
    @Override
    public Schedule getFutureScheduleByEmployeeID(int employeeID) {
        Schedule schedule = null; // Initialize to null to indicate no schedule found
        String sql = "SELECT * FROM future_schedule WHERE employeeid = ?"; // Query modified to filter by employeeID

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, employeeID);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) { // Check if there is at least one result
                    schedule = new Schedule();
                    schedule.setScheduleID(resultSet.getInt("scheduleid"));
                    schedule.setStartShift(resultSet.getTimestamp("startshift"));
                    schedule.setEndShift(resultSet.getTimestamp("endshift"));
                    schedule.setOffDay(resultSet.getDate("offday")); // Assuming offday is a Date
                    schedule.setDateBegin(resultSet.getDate("datebegin")); // Assuming datebegin is a Date
                    schedule.setDateEnd(resultSet.getDate("dateend")); // Corrected to use dateend
                    schedule.setEmployeeID(resultSet.getInt("employeeid")); // Assuming employeeid is relevant
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving active schedule by employee ID: " + e.getMessage(), e);
        }

        return schedule; // Return the found schedule or null if not found
    }
    @Override
    public boolean getLockedScheduleStatus(int scheduleID) {
        boolean isLocked = false; // Initialize to false
        String sql = "SELECT * FROM working WHERE scheduleid = ?"; // SQL query to find rows in the working view

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, scheduleID); // Set the scheduleID in the query
            try (ResultSet resultSet = statement.executeQuery()) {
                // Check if any rows are returned
                if (resultSet.next()) { // If there is at least one row
                    isLocked = true; // Set isLocked to true
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving locked schedule status: " + e.getMessage(), e);
        }

        return isLocked; // Return the locked status
    }
    
    @Override
    public void insertSchedule(Schedule schedule) {
        String sql = "INSERT INTO schedule (startshift, endshift, offday, datebegin, dateend, employeeid) VALUES (?, ?, ?, ?, ?, ?)"; // SQL query to insert the schedule

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            // Set the parameters for the insert
            statement.setTimestamp(1, schedule.getStartShift());
            statement.setTimestamp(2, schedule.getEndShift());
            statement.setDate(3, schedule.getOffDay()); // Assuming offday is a Date
            statement.setDate(4, schedule.getDateBegin()); // Assuming datebegin is the schedule date
            statement.setDate(5, schedule.getDateEnd()); // Assuming dateend is the schedule date
            statement.setInt(6, schedule.getEmployeeID()); // Set the employee ID

            statement.executeUpdate(); // Execute the insert statement
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error inserting schedule: " + e.getMessage(), e);
        }
    }
    @Override
    public void updateSchedule(Schedule schedule) {
        String sql = "UPDATE schedule SET startshift = ?, endshift = ?, offday = ?, datebegin = ?, dateend = ? WHERE scheduleid = ?"; // SQL query to update the schedule

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            // Set the parameters for the update
            statement.setTimestamp(1, schedule.getStartShift());
            statement.setTimestamp(2, schedule.getEndShift());
            statement.setDate(3, schedule.getOffDay()); // Assuming offday is a Date
            statement.setDate(4, schedule.getDateBegin()); // Assuming datebegin is the schedule date
            statement.setDate(5, schedule.getDateEnd()); // Assuming employeeid is relevant
            statement.setInt(6, schedule.getScheduleID()); // Set the scheduleID for the WHERE clause

            statement.executeUpdate(); // Execute the update statement
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error updating schedule: " + e.getMessage(), e);
        }
    }
    
    @Override
    public Schedule[] getAllScheduleByEmployeeID(int employeeID) {
        ArrayList<Schedule> scheduleList = new ArrayList<>();
        String sql = "SELECT * FROM schedule WHERE employeeid = ?"; // Adjust the SQL query

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, employeeID); // Set the employeeID parameter
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Schedule schedule = new Schedule();
                    schedule.setScheduleID(resultSet.getInt("scheduleid"));
                    schedule.setStartShift(resultSet.getTimestamp("startshift"));
                    schedule.setEndShift(resultSet.getTimestamp("endshift"));
                    schedule.setOffDay(resultSet.getDate("offday")); // Assuming offday is a Date
                    schedule.setDateBegin(resultSet.getDate("datebegin")); // Assuming datebegin is the schedule date
                    schedule.setDateEnd(resultSet.getDate("dateend")); // Corrected to dateend
                    schedule.setEmployeeID(resultSet.getInt("employeeid")); // Assuming employeeid is relevant
                    scheduleList.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving schedules by employee ID: " + e.getMessage(), e);
        }

        return scheduleList.toArray(new Schedule[0]);
    }
    
    @Override
    public Schedule getScheduleByID(int scheduleID) {
        Schedule schedule = null; // Initialize schedule to null
        String sql = "SELECT * FROM schedule WHERE scheduleid = ?"; // SQL query to find the schedule by ID

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, scheduleID); // Set the scheduleID in the query
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) { // Check if a result is returned
                    schedule = new Schedule(); // Create a new Schedule object
                    schedule.setScheduleID(resultSet.getInt("scheduleid"));
                    schedule.setStartShift(resultSet.getTimestamp("startshift"));
                    schedule.setEndShift(resultSet.getTimestamp("endshift"));
                    schedule.setOffDay(resultSet.getDate("offday")); // Assuming offday is a Date
                    schedule.setDateBegin(resultSet.getDate("datebegin")); // Assuming datebegin is the schedule date
                    schedule.setDateEnd(resultSet.getDate("dateend")); // Assuming dateend is the end date
                    schedule.setEmployeeID(resultSet.getInt("employeeid")); // Assuming employeeid is relevant
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving schedule by ID: " + e.getMessage(), e);
        }

        return schedule; // Return the retrieved Schedule object or null if not found
    }
    
    @Override
    public Schedule[] getAllActiveScheduleByBranchID(int branchID) {
        ArrayList<Schedule> scheduleList = new ArrayList<>();
        String sql = "SELECT * FROM active_schedule WHERE branchid = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, branchID);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Schedule schedule = new Schedule();
                    schedule.setScheduleID(resultSet.getInt("scheduleid"));
                    schedule.setStartShift(resultSet.getTimestamp("startshift"));
                    schedule.setEndShift(resultSet.getTimestamp("endshift"));
                    schedule.setOffDay(resultSet.getDate("offday")); // Assuming offday is a String
                    schedule.setDateBegin(resultSet.getDate("datebegin")); // Assuming datebegin is the schedule date
                    schedule.setDateEnd(resultSet.getDate("datebegin")); // Assuming datebegin is the schedule date
                    schedule.setEmployeeID(resultSet.getInt("employeeid")); // Assuming employeeid is relevant
                    scheduleList.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving active schedules by branch ID: " + e.getMessage(), e);
        }

        return scheduleList.toArray(new Schedule[0]);
    }
    
    
}
