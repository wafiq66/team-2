/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.dao;

import com.ems.model.Schedule;
/**
 *
 * @author user
 */
public interface ScheduleDAO {
    
    Schedule getScheduleByID(int scheduleID);
    Schedule getActiveScheduleByEmployeeID(int employeeID);
    Schedule getFutureScheduleByEmployeeID(int employeeID);
    boolean getLockedScheduleStatus(int scheduleID);
    void insertSchedule(Schedule schedule);
    void updateSchedule(Schedule schedule);
    Schedule[] getAllScheduleByEmployeeID(int employeeID);
    Schedule[] getAllActiveScheduleByBranchID(int branchID);
    
}
