/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.model;

/**
 *
 * @author user
 */
import java.sql.Date;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalTime;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Calendar;

public class Attendance {
    private int attendanceID;
    private Timestamp clockInTime;
    private Timestamp clockOutTime;
    private Timestamp overtimeDuration; // You might want to change this to a different type based on your needs
    private String emergencyLeaveNote;
    private int scheduleID;
    private Timestamp lateClockInDuration;
    
   public Attendance() {
        
    }

    public Attendance(int attendanceID, Date attendanceDate, Timestamp clockInTime, Timestamp clockOutTime, String overtimeNote, Timestamp overtimeDuration, String emergencyLeaveNote, int scheduleID, Timestamp lateClockInDuration) {
        this.attendanceID = attendanceID;
        this.clockInTime = clockInTime;
        this.clockOutTime = clockOutTime;
        this.overtimeDuration = overtimeDuration;
        this.emergencyLeaveNote = emergencyLeaveNote;
        this.scheduleID = scheduleID;
        this.lateClockInDuration = lateClockInDuration;
    }

    public int getAttendanceID() {
        return attendanceID;
    }

    public void setAttendanceID(int attendanceID) {
        this.attendanceID = attendanceID;
    }

    public Timestamp getClockInTime() {
        return clockInTime;
    }

    public void setClockInTime(Timestamp clockInTime) {
        this.clockInTime = clockInTime;
    }

    public Timestamp getClockOutTime() {
        return clockOutTime;
    }

    public void setClockOutTime(Timestamp clockOutTime) {
        this.clockOutTime = clockOutTime;
    }

    public Timestamp getOvertimeDuration() {
        return overtimeDuration;
    }

    public void setOvertimeDuration(Timestamp overtimeDuration) {
        this.overtimeDuration = overtimeDuration;
    }

    public String getEmergencyLeaveNote() {
        return emergencyLeaveNote;
    }

    public void setEmergencyLeaveNote(String emergencyLeaveNote) {
        this.emergencyLeaveNote = emergencyLeaveNote;
    }

    public int getScheduleID() {
        return scheduleID;
    }

    public void setScheduleID(int scheduleID) {
        this.scheduleID = scheduleID;
    }

    public Timestamp getLateClockInDuration() {
        return lateClockInDuration;
    }

    public void setLateClockInDuration(Timestamp lateClockInDuration) {
        this.lateClockInDuration = lateClockInDuration;
    }
   
    @Override
    public String toString() {
        return "Attendance{" +
                "attendanceID=" + attendanceID +
                ", clockInTime=" + clockInTime +
                ", clockOutTime=" + clockOutTime +
                ", overtimeDuration=" + overtimeDuration +
                ", emergencyLeaveNote='" + emergencyLeaveNote + '\'' +
                ", scheduleID=" + scheduleID +
                ", lateClockInDuration=" + lateClockInDuration +
                ", totalHours=" + calculateTotalHours() + // Include total hours in the string representation
                '}';
    }
    
    public void calculateOvertimeDuration() {
        if (clockInTime == null || clockOutTime == null) {
            // Handle case where clock in or clock out time is not set
            this.overtimeDuration = null;
            return;
        }

        // Calculate the duration between clock in and clock out
        long durationInMinutes = Duration.between(clockInTime.toLocalDateTime(), clockOutTime.toLocalDateTime()).toMinutes();

        // Check if the duration exceeds 8 hours (480 minutes)
        if (durationInMinutes > 480) {
            // Calculate overtime minutes
            long overtimeMinutes = durationInMinutes - 480;
            // Cap the overtime at 3 hours (180 minutes)
            if (overtimeMinutes > 180) {
                overtimeMinutes = 180;
            }

            // Convert overtime minutes to hours and minutes
            int hours = (int) (overtimeMinutes / 60);
            int minutes = (int) (overtimeMinutes % 60);

            // Create LocalDateTime with the correct hours and minutes
            LocalDateTime overtimeDateTime = LocalDateTime.now()
                .withHour(hours)
                .withMinute(minutes)
                .withSecond(0)
                .withNano(0);

            this.overtimeDuration = Timestamp.valueOf(overtimeDateTime);
        } else {
            // No overtime
            this.overtimeDuration = null;
        }
    }
    
    public int calculateTotalHours() {
        // Check if clockInTime and clockOutTime are not null
        if (clockInTime != null && clockOutTime != null) {
            // Calculate total hours from clockInTime to clockOutTime
            long totalHours = (clockOutTime.getTime() - clockInTime.getTime()) / (1000 * 60 * 60);

            // If overtimeDuration is not null, add the overtime hours
            if (overtimeDuration != null) {
                // Calculate the time difference properly
                // Convert Timestamp to LocalDateTime
                LocalDateTime localDateTime = overtimeDuration.toLocalDateTime();

                // Retrieve the hour as an int
                int hours = localDateTime.getHour();
                System.out.println("Total Overtime Hours: " + hours);
                return (int) (8 + hours);
            }

            // Return total hours calculated from clockInTime and clockOutTime
            return (int) totalHours;
        }

        // Return 0 if clockInTime or clockOutTime is null
        return 0;
    }
    
    public LocalDate getAttendanceDate() {
        if (clockInTime != null) {
            return clockInTime.toLocalDateTime().toLocalDate();
        }
        return null; // or throw an exception based on your design choice
    }
}
