
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.controller;

import com.ems.dao.EmployeeDAO;
import com.ems.dao.EmployeeDAOImpl;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ems.model.Salary;
import com.ems.dao.SalaryDAO;
import com.ems.dao.SalaryDAOImpl;
import com.ems.model.Attendance;
import com.ems.dao.AttendanceDAO;
import com.ems.dao.AttendanceDAOImpl;
import com.ems.model.Employee;
import java.time.LocalDate;
/**
 *
 * @author user
 */
public class ViewEmployeeSalaryController extends HttpServlet {
    final SalaryDAO salaryDAO = new SalaryDAOImpl();
    final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
    final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
    
    Salary calculateSalary(int month, int year, Employee employee){
        Salary salary = new Salary();
        
        salary.setEmployeeID(employee.getEmployeeID());
        salary.setSalaryMonth(month);
        salary.setSalaryYear(year);
        
        int monthTotalHours = 0;
        
        Attendance[] attendances = attendanceDAO.selectAllAttendance(year, month, employee);
        
        if (attendances == null || attendances.length == 0) {
            // Handle the case when attendances is null or empty
            System.out.println("No attendance records found for the specified criteria.");
            
            return null;
        } else {
            // Process the attendances array
            System.out.println("Attendance records found:");
            for (Attendance attendance : attendances) {
                if (attendance != null) { // Additional null check for individual elements
                    monthTotalHours += attendance.calculateTotalHours();
                }
            }
        }
        
        salary.setTotalHoursWorked(monthTotalHours);
        salary.setSalaryAmount(monthTotalHours * employee.getEmployeeHourlyPay());
        System.out.println("Sucessfully Calculated"+salary);
        return salary;
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
            
            String action = request.getParameter("action");
            if(action.equals("byMonth")){
                viewByMonth(request,response);
            }
            
        }
    }
    
    protected void viewByMonth(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String date = request.getParameter("month");
        String[] parts = date.split("-");
        int year = Integer.parseInt(parts[0]);
        int month = Integer.parseInt(parts[1]);
        int employeeId = Integer.parseInt(request.getParameter("employeeID"));
        
        System.out.println("Month: " + month);
        System.out.println("Year: " + year);
        Employee[] employees = employeeDAO.getAllEmployee();
        for(Employee employee: employees){
            Salary salary = salaryDAO.getCalculatedEmployeeSalary(employee, month, year);
            System.out.println(employee.getEmployeeID());
            System.out.println(salary.getEmployeeID());
            if(salary.getEmployeeID() == 0){
                Salary tempSalary = calculateSalary(month, year, employee);
                if (tempSalary != null) salaryDAO.recordSalary(tempSalary);
            }
        }
        
        request.setAttribute("employeeId",employeeId);
        request.setAttribute("month", month);
        request.setAttribute("year", year);
        request.getRequestDispatcher("officer_salary_main.jsp").forward(request, response);
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
