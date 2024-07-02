
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
import com.ems.model.Employee;
import java.time.LocalDate;
/**
 *
 * @author user
 */
public class ViewEmployeeSalaryController extends HttpServlet {
    final SalaryDAO salaryDAO = new SalaryDAOImpl();
    final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
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
        calculateSalaryPastMonth();

        // Get the value of the "month" parameter from the request
        String month = request.getParameter("month");
        String employeeIDParam = request.getParameter("employeeID");

        // Check if month and employeeIDParam are not null
        if (month == null || employeeIDParam == null) {
            // Handle the case where parameters are missing
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters: month and/or employeeID");
            return;
        }

        int employeeID;
        try {
            employeeID = Integer.parseInt(employeeIDParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid employeeID format");
            return;
        }

        // Split the string into year and month
        String[] parts = month.split("-");
        if (parts.length != 2) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid month parameter format");
            return;
        }

        int year, monthInt;
        try {
            year = Integer.parseInt(parts[0]);
            monthInt = Integer.parseInt(parts[1]);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid year or month format");
            return;
        }

        // Print the results to verify
        System.out.println("Year: " + year);
        System.out.println("Month: " + monthInt);

        LocalDate currentDate = LocalDate.now();
        int currentMonth = currentDate.getMonthValue();
        int currentYear = currentDate.getYear();

        System.out.println("Current Month (integer): " + currentMonth);
        System.out.println("Current Year (integer): " + currentYear);

        Salary[] salaries = new Salary[0];

        if (!(currentYear > year || (currentYear == year && currentMonth > monthInt))) {
            salaries = salaryDAO.getUncalculatedEmployeeSalary(monthInt, year);
            for (Salary s : salaries) {
                salaryDAO.updateSalary(s);
                System.out.println("Salary: RM" + s.getSalaryAmount());
            }
            System.out.println("Successfully Updated!");
        } else {
            salaries = salaryDAO.getCalculatedEmployeeSalary(monthInt, year);
            if (salaries.length == 0) {
                salaries = salaryDAO.getUncalculatedEmployeeSalary(monthInt, year);
                for (Salary s : salaries) {
                    salaryDAO.recordSalary(s);
                    System.out.println("Successfully Calculate And Recorded!");
                }
            }
        }

        Salary empSalary = null;
        if (employeeID > 0) {
            Employee targetEmp = employeeDAO.getEmployeeById(employeeID);
            if (targetEmp != null) {
                empSalary = salaryDAO.getCalculatedEmployeeSalary(targetEmp, monthInt, year);
            }
        }

        // Avoid running DAO operations if empSalary is null
        if (empSalary == null) {
            System.out.println("EmpSalary not found for employeeID: " + employeeID);
            request.setAttribute("error", "Employee salary not found for the given month and year.");
        } else {
            
            request.setAttribute("targetSalary", empSalary);
        }

        request.setAttribute("month", monthInt);
        request.setAttribute("year", year);
        request.getRequestDispatcher("officer_salary_main.jsp").forward(request, response);
    }



   
    protected void calculateSalaryPastMonth()
            throws ServletException, IOException {
    
    //to get the local current time
    LocalDate currentDate = LocalDate.now();

    // Extract month and year as integers
    int currentMonth = currentDate.getMonthValue();
    int currentYear = currentDate.getYear();
    if(currentMonth == 1){
        currentMonth = 12;
        currentYear -=1;
    }
    else{
        currentMonth -=1;
    }
    // Print the current month and year
    System.out.println("Past Month (integer): " + currentMonth);
    System.out.println("Past Year (integer): " + currentYear);
    
    Salary[] listSalary = salaryDAO.getCalculatedEmployeeSalary(currentMonth,currentYear);
    if(listSalary.length > 0){
        listSalary = salaryDAO.getUncalculatedEmployeeSalary(currentMonth, currentYear);
        for(Salary s:listSalary){
            salaryDAO.updateSalary(s);
            System.out.println("Done update previous month salary");
        }
    }
    else{
        listSalary = salaryDAO.getUncalculatedEmployeeSalary(currentMonth, currentYear);
        for(Salary s:listSalary){
            salaryDAO.recordSalary(s);
            System.out.println("Done calculate previous month salary");
        }
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
