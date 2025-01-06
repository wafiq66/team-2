/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ems.model.Schedule;
import com.ems.dao.ScheduleDAO;
import com.ems.dao.ScheduleDAOImpl;

import com.ems.model.RestaurantManager;
import com.ems.dao.ManagerDAO;
import com.ems.dao.ManagerDAOImpl;
import com.ems.model.Employee;
import com.ems.dao.EmployeeDAO;
import com.ems.dao.EmployeeDAOImpl;
import java.util.Arrays;
import javax.servlet.http.HttpSession;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.time.DayOfWeek;
import java.time.format.DateTimeFormatter;

public class ManageScheduleController extends HttpServlet {
    final ScheduleDAO scheduleDAO = new ScheduleDAOImpl();
    final ManagerDAO managerDAO = new ManagerDAOImpl();
    
    final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
    
    //start shift time and end time
    String defaultDate = "2000-01-01 ";
    Timestamp[] timeArray = new Timestamp[]{
        Timestamp.valueOf(defaultDate + "00:00:00"),
        Timestamp.valueOf(defaultDate + "08:00:00"),
        Timestamp.valueOf(defaultDate + "16:00:00"),
        Timestamp.valueOf(defaultDate + "23:59:00")
    };
    
    private Timestamp startShiftTypeChecker(int a){
        return timeArray[a-1];
    }
    
    private Timestamp endShiftTypeChecker(int a){
        return timeArray[a];
    }
    
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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            String action = request.getParameter("action");
            if(action.equals("viewSpecificSchedule")){
                viewSpecificSchedule(request,response);
            }
            else if(action.equals("editingSchedule")){
                editingSchedule(request,response);
                System.out.println("masuk2");
            }
            else if(action.equals("updateSchedule")){
                updateSchedule(request,response);
                System.out.println("masa");
            }
            else if(action.equals("deleteSchedule")){
                deleteSchedule(request,response);
            }
            else if(action.equals("createSchedule")){
                createSchedule(request,response);
            }
        }
    }
    protected void viewSpecificSchedule(HttpServletRequest request, HttpServletResponse response){
        try{
            int employeeID = Integer.parseInt(request.getParameter("employeeID")) ;
            HttpSession session = request.getSession();
            Employee employee = employeeDAO.getEmployeeById(employeeID);
            
            session.setAttribute("employee", employee);
            request.getRequestDispatcher("specific_schedule.jsp").forward(request, response);
        }catch(Exception e){
            // Handle exception
        }
    }
    
    protected void editingSchedule(HttpServletRequest request, HttpServletResponse response){
        try{
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID")) ;
            HttpSession session = request.getSession();
            
            if(scheduleDAO.getLockedScheduleStatus(scheduleID)){
                request.setAttribute("message", "The employee is currently working. The schedule cannot be edited at this time.");
                request.getRequestDispatcher("specific_schedule.jsp").forward(request, response);
            }
            else{
                Schedule schedule = scheduleDAO.getScheduleByID(scheduleID);
            
                System.out.println(schedule.toString());
                session.setAttribute("editingSchedule", schedule);
                request.getRequestDispatcher("edit_schedule.jsp").forward(request, response);
            }
            
        }catch(Exception e){
            System.out.println("Ada masalah ni babi");
        }
    }
    
    protected void updateSchedule(HttpServletRequest request, HttpServletResponse response){
        try{
            HttpSession session = request.getSession();
            Schedule schedule = (Schedule) session.getAttribute("editingSchedule");
            
            int scheduleRange = Integer.parseInt(request.getParameter("shiftType"));
            
            //set range shift
            schedule.setStartShift(startShiftTypeChecker(scheduleRange));
            schedule.setEndShift(endShiftTypeChecker(scheduleRange));
            
            scheduleDAO.updateSchedule(schedule);
            
            String message = "Schedule Successfully Updated!";
            request.setAttribute("message", message);
            request.getRequestDispatcher("edit_schedule.jsp").forward(request, response);
            
        }catch(Exception e){
            // Handle exception
            System.out.println("noh");
            
        }
    }
    
    protected void deleteSchedule(HttpServletRequest request, HttpServletResponse response){
        try{
            HttpSession session = request.getSession();
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID")) ;
            Schedule schedule = scheduleDAO.getScheduleByID(scheduleID);
            
            
            
        }catch(Exception e){
            // Handle exception
            System.out.println("noh");
            
        }
    }
    
    protected void createSchedule(HttpServletRequest request, HttpServletResponse response){
        try{
            //call data
            HttpSession session = request.getSession();
            Schedule schedule = new Schedule();
            
            //employee id
            Employee employee = (Employee)session.getAttribute("employee");
            
            //for future or present
            int forWhich = Integer.parseInt(request.getParameter("forWhich"));
            
            //off date value
            String date = request.getParameter("offDate");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date offDate = sdf.parse(date);
            Date sqlOffDate = new java.sql.Date(offDate.getTime());
            
            LocalDate currentDate = LocalDate.now();
            // Find the start (Sunday) and end (Saturday) of the current week
            LocalDate startOfWeek = currentDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
            LocalDate endOfWeek = currentDate.with(TemporalAdjusters.nextOrSame(DayOfWeek.SATURDAY));
            
            //Find the next week date range
            LocalDate startOfNextWeek = startOfWeek.plusWeeks(1);
            LocalDate endOfNextWeek = endOfWeek.plusWeeks(1);
            
            // Date begin and date end (current)
            Date startOfWeekSql = Date.valueOf(startOfWeek);
            Date endOfWeekSql = Date.valueOf(endOfWeek);
            
            //Date begin and end (next week)
            Date startOfNextWeekSql = Date.valueOf(startOfNextWeek);
            Date endOfNextWeekSql = Date.valueOf(endOfNextWeek);
            
            int scheduleRange = Integer.parseInt(request.getParameter("shiftType")); 
            
            //Set the value into the schedule object
            schedule.setEmployeeID(employee.getEmployeeID()); //employee id
            schedule.setOffDay(sqlOffDate); //off day
            //set the date begin and date end
            if(forWhich == 1){
                schedule.setDateBegin(startOfWeekSql); //date schedule begin
                schedule.setDateEnd(endOfWeekSql); //date schedule end
            }
            else if(forWhich ==2){
                schedule.setDateBegin(startOfNextWeekSql); //date schedule begin
                schedule.setDateEnd(endOfNextWeekSql); //date schedule end
            }
            schedule.setStartShift(startShiftTypeChecker(scheduleRange)); //shift start time
            schedule.setEndShift(endShiftTypeChecker(scheduleRange)); //shift end time
            
            System.out.println(schedule.toString());
            
            scheduleDAO.insertSchedule(schedule);
            request.getRequestDispatcher("specific_schedule.jsp").forward(request, response);
            
        }catch(Exception e){
            // Handle exception
            System.out.println("noh");
            
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
