/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ems.model.Employee;
import com.ems.model.Schedule;
import com.ems.model.Attendance;

import com.ems.dao.ScheduleDAO;
import com.ems.dao.ScheduleDAOImpl;
import com.ems.dao.AttendanceDAO;
import com.ems.dao.AttendanceDAOImpl;
import java.text.SimpleDateFormat;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;


/**
 *
 * @author user
 */
public class RecordAttendanceController extends HttpServlet {
    final ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
    final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
    String message = null;
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if(action.equals("in")){
            clockIn(request,response);
        }else if(action.equals("out")){
            clockOut(request,response);
            System.out.println("aiyo");
        }
    }
    
    protected void clockIn(HttpServletRequest request, HttpServletResponse response) {
        String message; // Declare message variable
        try {
            Attendance attendance = new Attendance(); // attendance object
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            Schedule schedule = scheduleDAO.getScheduleByID(scheduleID); // schedule that employee currently refers to

            // Local date time
            LocalDateTime currentDateTime = LocalDateTime.now();

            if (!schedule.isWithinShift()) {
                // If the current time is not within the shift, set an error message
                message = "You cannot clock in outside of your scheduled shift!";
                request.setAttribute("messageFail", message);
                request.getRequestDispatcher("employee_attendance.jsp").forward(request, response);
                return; // Exit the method to prevent further processing
            }

            // Set the clock in time
            attendance.setClockInTime(Timestamp.valueOf(currentDateTime));
            // Set the late duration
            attendance.setLateClockInDuration(schedule.calculateLateDuration());
            // Set schedule ID
            attendance.setScheduleID(scheduleID);
            
            //record into the database
            attendanceDAO.clockIn(attendance);
            
            System.out.println(attendance.toString());
            message = "You have successfully clocked in!";
            request.setAttribute("messageSuccess", message);
            request.getRequestDispatcher("employee_attendance.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle the exception and forward the request
            message = "An error occurred while processing your clock-in request.";
            request.setAttribute("messageFail", message);

            // Only forward if the response is not committed
            if (!response.isCommitted()) {
                try {
                    request.getRequestDispatcher("employee_attendance.jsp").forward(request, response);
                } catch (ServletException | IOException servletException) {
                    servletException.printStackTrace(); // Handle or log this exception as needed
                }
            } else {
                // Optionally handle the case where the response has been committed (e.g., log the error)
                e.printStackTrace(); // Or use a logging framework
            }
        }
    }
    
    protected void clockOut(HttpServletRequest request, HttpServletResponse response){
        try{
            
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            boolean emergencyOrNot = Boolean.parseBoolean(request.getParameter("emergency"));
            String overtimeNote = request.getParameter("reasonOut");
            
            // Local date time
            LocalDateTime currentDateTime = LocalDateTime.now();
            //retrieve attendance
            Attendance attendance = attendanceDAO.selectAttendanceByScheduleID(scheduleID);
            
            //register Clock Out Time
            attendance.setClockOutTime(Timestamp.valueOf(currentDateTime));
            //register overtime value
            attendance.calculateOvertimeDuration();
            //register Reason Emergency
            if(emergencyOrNot){
                attendance.setEmergencyLeaveNote(overtimeNote);
            }
            
            System.out.println(attendance.toString());
            
            attendanceDAO.updateAttendance(attendance);
            
            message = "You have successfully clocked out!";
            request.setAttribute("messageSuccess", message);
            request.getRequestDispatcher("employee_attendance.jsp").forward(request, response);
        }catch(Exception e){
            System.out.println(e);
        }
    }
    
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
