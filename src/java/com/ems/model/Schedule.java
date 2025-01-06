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
import java.time.temporal.ChronoUnit;

public class Schedule {
    private int scheduleID;
    private Timestamp startShift;
    private Timestamp endShift;
    private Date offDay;
    private Date dateBegin;
    private Date dateEnd;
    private int employeeID;

    public Schedule() {
    }

    // Constructor
    public Schedule(int scheduleID, Timestamp startShift, Timestamp endShift, Date offDay, 
                    Date dateBegin, Date dateEnd, int employeeID) {
        this.scheduleID = scheduleID;
        this.startShift = startShift;
        this.endShift = endShift;
        this.offDay = offDay;
        this.dateBegin = dateBegin;
        this.dateEnd = dateEnd;
        this.employeeID = employeeID;
    }

    // Getters
    public int getScheduleID() {
        return scheduleID;
    }

    public Timestamp getStartShift() {
        return startShift;
    }

    public Timestamp getEndShift() {
        return endShift;
    }

    public Date getOffDay() {
        return offDay;
    }

    public Date getDateBegin() {
        return dateBegin;
    }

    public Date getDateEnd() {
        return dateEnd;
    }

    public int getEmployeeID() {
        return employeeID;
    }

    // Setters
    public void setScheduleID(int scheduleID) {
        this.scheduleID = scheduleID;
    }

    public void setStartShift(Timestamp startShift) {
        this.startShift = startShift;
    }

    public void setEndShift(Timestamp endShift) {
        this.endShift = endShift;
    }

    public void setOffDay(Date offDay) {
        this.offDay = offDay;
    }

    public void setDateBegin(Date dateBegin) {
        this.dateBegin = dateBegin;
    }

    public void setDateEnd(Date dateEnd) {
        this.dateEnd = dateEnd;
    }

    public void setEmployeeID(int employeeID) {
        this.employeeID = employeeID;
    }
    
    public String toString() {
        return "Schedule{" +
                "scheduleID=" + scheduleID +
                ", startShift=" + startShift +
                ", endShift=" + endShift +
                ", offDay=" + offDay +
                ", dateBegin=" + dateBegin +
                ", dateEnd=" + dateEnd +
                ", employeeID=" + employeeID +
                '}';
    }
    
    public Timestamp calculateLateDuration(){
        
        LocalTime currentTime = LocalTime.now();
        
        LocalTime startShiftTime = startShift.toLocalDateTime().toLocalTime();
        long lateDurationInMinutes = 0;

        // Check if the current time is greater than the start shift time
        if (currentTime.isAfter(startShiftTime)) {
            // Calculate the difference in minutes
            lateDurationInMinutes = ChronoUnit.MINUTES.between(startShiftTime, currentTime);
        }

        // Convert late duration in minutes to a LocalTime
        LocalTime lateDurationTime = LocalTime.of((int) lateDurationInMinutes / 60, (int) lateDurationInMinutes % 60);

        // Convert LocalTime to LocalDateTime (assuming today’s date)
        Timestamp lateDurationTimestamp = Timestamp.valueOf(LocalDateTime.of(LocalDate.now(), lateDurationTime));

        return lateDurationTimestamp;
    }
    
    public boolean isWithinShift() {
        LocalTime time = LocalTime.now();
        LocalTime startTime = startShift.toLocalDateTime().toLocalTime();
        LocalTime endTime = endShift.toLocalDateTime().toLocalTime();

        return !time.isBefore(startTime) && !time.isAfter(endTime);
    }
        
    
}