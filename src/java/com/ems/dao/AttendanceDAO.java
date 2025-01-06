/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.dao;

import com.ems.model.Employee;
import com.ems.model.Attendance;
import java.time.LocalDate;
/**
 *
 * @author user
 */
public interface AttendanceDAO {
    
    void clockIn(Attendance attendance);
    boolean clockInChecker(int scheduleID,LocalDate Date);
    Attendance selectAttendanceByScheduleID(int scheduleID);
    Attendance[] selectAllAttendance(int[] attendanceIDs);
    Attendance[] selectAllAttendance(Employee employee);
    Attendance[] selectAllAttendance(int year, int month, Employee employee);
    Attendance[] selectAllAttendance(int year,int month);
    Attendance[] selectAllAttendance(int year,int month, int branch);
    Attendance updateAttendance(Attendance attendance);
}
