/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.controller;

import com.ems.model.Branch;
import com.ems.dao.BranchDAO;
import com.ems.dao.BranchDAOImpl;
import com.ems.model.RestaurantManager;
import com.ems.dao.ManagerDAO;
import com.ems.dao.ManagerDAOImpl;
import com.ems.dao.AttendanceDAO;
import com.ems.dao.AttendanceDAOImpl;
import com.ems.model.Attendance;
import com.ems.model.Employee;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author user
 */
public class ViewAttendanceController extends HttpServlet {
    final BranchDAO branchDAO = new BranchDAOImpl();
    final ManagerDAO managerDAO = new ManagerDAOImpl();
    final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
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
            String action = request.getParameter("action");
            
            if(action != null && action.equals("getMonthReport")){
                getMonthReport(request,response);
            }
            else if(action != null && action.equals("getMonthReportOfficer")){
                getMonthReportOfficer(request,response);
            }
            else {
                out.println("Action parameter is missing or incorrect.");
            }
        }
    }

    protected void getMonthReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            
            //String date to month and year int
            
            String date = request.getParameter("month");
            System.out.println(date);
            
            String[] parts = date.split("-");
            int year = Integer.parseInt(parts[0]);
            int month = Integer.parseInt(parts[1]);
            
            System.out.println("Year: " + year + ", Month: " + month);
            
            //Attendance
            Attendance[] attendances = attendanceDAO.selectAllAttendance(year, month);
            for(Attendance attendance:attendances){
                System.out.println("OT: "+ attendance.getOvertimeDuration() +"Total Hours: " + attendance.calculateTotalHours());
            }
            
            request.setAttribute("year", year);
            request.setAttribute("month", month);
            request.setAttribute("fullDate", date);
            request.getRequestDispatcher("report_update.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace(); // Log the exception (or handle it appropriately)
            request.setAttribute("errorMessage", "An error occurred while retrieving attendance records.");
            request.getRequestDispatcher("attandance_history.jsp").forward(request, response);
        }
    }
    
    protected void getMonthReportOfficer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            
            //String date to month and year int
            
            String date = request.getParameter("month");
            System.out.println(date);
            
            String[] parts = date.split("-");
            int year = Integer.parseInt(parts[0]);
            int month = Integer.parseInt(parts[1]);
            int branchID = Integer.parseInt(request.getParameter("branch"));
            System.out.println("Year: " + year + ", Month: " + month);
            
            //Attendance
            Attendance[] attendances = attendanceDAO.selectAllAttendance(year, month);
            for(Attendance attendance:attendances){
                System.out.println("OT: "+ attendance.getOvertimeDuration() +"Total Hours: " + attendance.calculateTotalHours());
            }
            
            request.setAttribute("branchID",branchID);
            request.setAttribute("year", year);
            request.setAttribute("month", month);
            request.setAttribute("fullDate", date);
            request.getRequestDispatcher("officer_verified_report.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace(); // Log the exception (or handle it appropriately)
            request.setAttribute("errorMessage", "An error occurred while retrieving attendance records.");
            request.getRequestDispatcher("attandance_history.jsp").forward(request, response);
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
