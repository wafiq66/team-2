/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.dao;

import com.ems.connection.Connect;
import com.ems.model.Employee;
import com.ems.model.Schedule;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAOImpl implements ScheduleDAO {
    private Connection conn;

    public ScheduleDAOImpl() {
        this.conn = Connect.getConnection();
    }

    @Override
    public Schedule getScheduleByID(int scheduleID) {
        Schedule schedule = null;
        String sql = "SELECT * FROM SCHEDULE WHERE SCHEDULEID = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, scheduleID);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    schedule = new Schedule();
                    schedule.setScheduleID(resultSet.getInt("SCHEDULEID"));
                    schedule.setScheduleDate(resultSet.getDate("SCHEDULEDATE") != null ? resultSet.getDate("SCHEDULEDATE").toString() : null);
                    schedule.setStartShift(resultSet.getTime("STARTSHIFT") != null ? new SimpleDateFormat("HH:mm:ss").format(resultSet.getTime("STARTSHIFT")) : null);
                    schedule.setEndShift(resultSet.getTime("ENDSHIFT") != null ? new SimpleDateFormat("HH:mm:ss").format(resultSet.getTime("ENDSHIFT")) : null);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving schedule by ID: " + e.getMessage(), e);
        }

        return schedule;
    }

    @Override
    public int createSchedule(Schedule schedule) {
        String sqlInsert = "INSERT INTO SCHEDULE (SCHEDULEDATE, STARTSHIFT, ENDSHIFT) VALUES (?, ?, ?)";
        String sqlSelect = "SELECT SCHEDULEID FROM SCHEDULE WHERE SCHEDULEDATE = ? AND STARTSHIFT = ? AND ENDSHIFT = ?";

        try {
            // Insert the new schedule
            try (PreparedStatement insertStatement = conn.prepareStatement(sqlInsert)) {
                insertStatement.setDate(1, java.sql.Date.valueOf(schedule.getScheduleDate()));
                insertStatement.setTime(2, java.sql.Time.valueOf(schedule.getStartShift()));
                insertStatement.setTime(3, java.sql.Time.valueOf(schedule.getEndShift()));
                insertStatement.executeUpdate();
            }

            // Select the generated ID
            try (PreparedStatement selectStatement = conn.prepareStatement(sqlSelect)) {
                selectStatement.setDate(1, java.sql.Date.valueOf(schedule.getScheduleDate()));
                selectStatement.setTime(2, java.sql.Time.valueOf(schedule.getStartShift()));
                selectStatement.setTime(3, java.sql.Time.valueOf(schedule.getEndShift()));

                try (ResultSet resultSet = selectStatement.executeQuery()) {
                    if (resultSet.next()) {
                        return resultSet.getInt("SCHEDULEID");
                    } else {
                        throw new RuntimeException("Error creating schedule: no ID found");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error creating schedule: " + e.getMessage(), e);
        }
    }



    @Override
    public void updateSchedule(Schedule schedule) {
        String sql = "UPDATE SCHEDULE SET SCHEDULEDATE = ?, STARTSHIFT = ?, ENDSHIFT = ? WHERE SCHEDULEID = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setDate(1, java.sql.Date.valueOf(schedule.getScheduleDate()));
            statement.setTime(2, java.sql.Time.valueOf(schedule.getStartShift()));
            statement.setTime(3, java.sql.Time.valueOf(schedule.getEndShift()));
            statement.setInt(4, schedule.getScheduleID());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error updating schedule: " + e.getMessage(), e);
        }
    }

    @Override
    public void deleteSchedule(Schedule schedule) {
        String sql = "DELETE FROM SCHEDULE WHERE SCHEDULEID = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, schedule.getScheduleID());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error deleting schedule: " + e.getMessage(), e);
        }
    }

    @Override
    public Schedule fetchLatestSchedule(Employee employee) {
        Schedule schedule = null;
        String sql = "SELECT S.* " +
                     "FROM EMPLOYEESCHEDULE ES " +
                     "JOIN SCHEDULE S ON (ES.SCHEDULEID = S.SCHEDULEID) " +
                     "WHERE ES.SCHEDULEACTIVATIONSTATUS = 1 " +
                     "AND ES.EMPLOYEEID = ? " +
                     "AND TRUNC(S.SCHEDULEDATE) <= TRUNC(SYSDATE) " + // Ensures schedule date is today or in the future
                     "ORDER BY S.SCHEDULEDATE DESC";

        sql = "SELECT * FROM (" + sql + ") WHERE ROWNUM <= 1";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, employee.getEmployeeID());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    schedule = new Schedule();
                    schedule.setScheduleID(resultSet.getInt("SCHEDULEID"));
                    schedule.setScheduleDate(resultSet.getDate("SCHEDULEDATE") != null ? resultSet.getDate("SCHEDULEDATE").toString() : "none");
                    schedule.setStartShift(resultSet.getTime("STARTSHIFT") != null ? new SimpleDateFormat("HH:mm:ss").format(resultSet.getTime("STARTSHIFT")) : "none");
                    schedule.setEndShift(resultSet.getTime("ENDSHIFT") != null ? new SimpleDateFormat("HH:mm:ss").format(resultSet.getTime("ENDSHIFT")) : "none");
                } else {
                    schedule = new Schedule();
                    schedule.setScheduleID(0);
                    schedule.setScheduleDate("none");
                    schedule.setStartShift("none");
                    schedule.setEndShift("none");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error fetching latest schedule for employee: " + e.getMessage(), e);
        }

        return schedule;
}



    @Override
    public Schedule[] getAllScheduleByBranch(int branchID) {
        List<Schedule> scheduleList = new ArrayList<>();
        String sql = "SELECT DISTINCT S.* " +
                     "FROM SCHEDULE S " +
                     "JOIN EMPLOYEESCHEDULE ES ON S.SCHEDULEID = ES.SCHEDULEID " +
                     "JOIN EMPLOYEE E ON ES.EMPLOYEEID = E.EMPLOYEEID " +
                     "WHERE E.BRANCHID = ? AND E.EMPLOYEESTATUS = 1";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, branchID);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Schedule schedule = new Schedule();
                    schedule.setScheduleID(resultSet.getInt("SCHEDULEID"));
                    schedule.setScheduleDate(resultSet.getDate("SCHEDULEDATE") != null ? resultSet.getDate("SCHEDULEDATE").toString() : null);
                    schedule.setStartShift(resultSet.getTime("STARTSHIFT") != null ? new SimpleDateFormat("HH:mm:ss").format(resultSet.getTime("STARTSHIFT")) : null);
                    schedule.setEndShift(resultSet.getTime("ENDSHIFT") != null ? new SimpleDateFormat("HH:mm:ss").format(resultSet.getTime("ENDSHIFT")) : null);
                    scheduleList.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving schedules by branch ID: " + e.getMessage(), e);
        }

        return scheduleList.toArray(new Schedule[0]);
    }
}
