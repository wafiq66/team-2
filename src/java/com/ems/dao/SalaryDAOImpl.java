/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.dao;

import com.ems.connection.Connect;
import com.ems.model.Employee;
import com.ems.model.Salary;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SalaryDAOImpl implements SalaryDAO {

    private Connection conn;

    public SalaryDAOImpl() {
        this.conn = Connect.getConnection();
    }

    @Override
    public Salary[] getUncalculatedEmployeeSalary(int month, int year) {
        List<Salary> salaries = new ArrayList<>();
        String sql = "SELECT " +
                     "e.EMPLOYEEID, " +
                     "EXTRACT(MONTH FROM a.ATTENDANCEDATE) AS AttendanceMonth, " +
                     "EXTRACT(YEAR FROM a.ATTENDANCEDATE) AS AttendanceYear, " +
                     "TRUNC(SUM(EXTRACT(HOUR FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) + " +
                     "EXTRACT(MINUTE FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 60 + " +
                     "EXTRACT(SECOND FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 3600)) AS TotalHoursWorked, " +
                     "TRUNC(SUM(EXTRACT(HOUR FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) + " +
                     "EXTRACT(MINUTE FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 60 + " +
                     "EXTRACT(SECOND FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 3600) * e.EMPLOYEEHOURLYPAY) AS TotalSalary " +
                     "FROM ATTENDANCE a " +
                     "JOIN EMPLOYEESCHEDULE es ON a.EMPLOYEESCHEDULEID = es.EMPLOYEESCHEDULEID " +
                     "JOIN EMPLOYEE e ON es.EMPLOYEEID = e.EMPLOYEEID " +
                     "WHERE EXTRACT(MONTH FROM a.ATTENDANCEDATE) = ? AND EXTRACT(YEAR FROM a.ATTENDANCEDATE) = ? " +
                     "GROUP BY e.EMPLOYEEID, EXTRACT(MONTH FROM a.ATTENDANCEDATE), EXTRACT(YEAR FROM a.ATTENDANCEDATE), e.EMPLOYEEHOURLYPAY";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, month);
            statement.setInt(2, year);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Salary salary = new Salary();
                    salary.setEmployeeID(resultSet.getInt("EMPLOYEEID"));
                    salary.setSalaryMonth(resultSet.getInt("AttendanceMonth"));
                    salary.setSalaryYear(resultSet.getInt("AttendanceYear"));
                    salary.setTotalHoursWorked(resultSet.getInt("TotalHoursWorked"));
                    salary.setSalaryAmount(resultSet.getDouble("TotalSalary"));
                    salaries.add(salary);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving salary for month " + month + " and year " + year + ": " + e.getMessage(), e);
        }

        return salaries.toArray(new Salary[0]);
    }



    @Override
    public Salary getUncalculatedEmployeeSalary(Employee employee, int month, int year) {
        Salary salary = new Salary();
        String sql = "SELECT " +
                     "e.EMPLOYEEID, " +
                     "EXTRACT(MONTH FROM a.ATTENDANCEDATE) AS AttendanceMonth, " +
                     "EXTRACT(YEAR FROM a.ATTENDANCEDATE) AS AttendanceYear, " +
                     "TRUNC(SUM(EXTRACT(HOUR FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) + " +
                     "EXTRACT(MINUTE FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 60 + " +
                     "EXTRACT(SECOND FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 3600)) AS TotalHoursWorked, " +
                     "TRUNC(SUM(EXTRACT(HOUR FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) + " +
                     "EXTRACT(MINUTE FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 60 + " +
                     "EXTRACT(SECOND FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 3600) * e.EMPLOYEEHOURLYPAY) AS TotalSalary " +
                     "FROM ATTENDANCE a " +
                     "JOIN EMPLOYEESCHEDULE es ON a.EMPLOYEESCHEDULEID = es.EMPLOYEESCHEDULEID " +
                     "JOIN EMPLOYEE e ON es.EMPLOYEEID = e.EMPLOYEEID " +
                     "WHERE e.EMPLOYEEID = ? AND EXTRACT(MONTH FROM a.ATTENDANCEDATE) = ? AND EXTRACT(YEAR FROM a.ATTENDANCEDATE) = ? " +
                     "GROUP BY e.EMPLOYEEID, EXTRACT(MONTH FROM a.ATTENDANCEDATE), EXTRACT(YEAR FROM a.ATTENDANCEDATE), e.EMPLOYEEHOURLYPAY";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, employee.getEmployeeID());
            statement.setInt(2, month);
            statement.setInt(3, year);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    salary.setEmployeeID(resultSet.getInt("EMPLOYEEID"));
                    salary.setSalaryMonth(resultSet.getInt("AttendanceMonth"));
                    salary.setSalaryYear(resultSet.getInt("AttendanceYear"));
                    salary.setTotalHoursWorked(resultSet.getInt("TotalHoursWorked"));
                    salary.setSalaryAmount(resultSet.getDouble("TotalSalary"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving salary for employee: " + e.getMessage(), e);
        }

        return salary;
    }



    @Override
    public Salary[] getUncalculatedEmployeeSalary(Employee employee) {
        List<Salary> salaryList = new ArrayList<>();
        String sql = "SELECT " +
                     "e.EMPLOYEEID, " +
                     "EXTRACT(MONTH FROM a.ATTENDANCEDATE) AS AttendanceMonth, " +
                     "EXTRACT(YEAR FROM a.ATTENDANCEDATE) AS AttendanceYear, " +
                     "TRUNC(SUM(EXTRACT(HOUR FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) + " +
                     "EXTRACT(MINUTE FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 60 + " +
                     "EXTRACT(SECOND FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 3600)) AS TotalHoursWorked, " +
                     "TRUNC(SUM(EXTRACT(HOUR FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) + " +
                     "EXTRACT(MINUTE FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 60 + " +
                     "EXTRACT(SECOND FROM (a.CLOCKOUTTIME - a.CLOCKINTIME)) / 3600) * e.EMPLOYEEHOURLYPAY) AS TotalSalary " +
                     "FROM ATTENDANCE a " +
                     "JOIN EMPLOYEESCHEDULE es ON a.EMPLOYEESCHEDULEID = es.EMPLOYEESCHEDULEID " +
                     "JOIN EMPLOYEE e ON es.EMPLOYEEID = e.EMPLOYEEID " +
                     "WHERE e.EMPLOYEEID = ? " +
                     "GROUP BY e.EMPLOYEEID, EXTRACT(MONTH FROM a.ATTENDANCEDATE), EXTRACT(YEAR FROM a.ATTENDANCEDATE), e.EMPLOYEEHOURLYPAY " +
                     "ORDER BY EXTRACT(YEAR FROM a.ATTENDANCEDATE), EXTRACT(MONTH FROM a.ATTENDANCEDATE), e.EMPLOYEEID";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, employee.getEmployeeID());

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Salary salary = new Salary();
                    salary.setEmployeeID(resultSet.getInt("EMPLOYEEID"));
                    salary.setSalaryMonth(resultSet.getInt("AttendanceMonth"));
                    salary.setSalaryYear(resultSet.getInt("AttendanceYear"));
                    salary.setTotalHoursWorked(resultSet.getInt("TotalHoursWorked"));
                    salary.setSalaryAmount(resultSet.getDouble("TotalSalary"));
                    salaryList.add(salary);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving salaries for employee: " + e.getMessage(), e);
        }

        return salaryList.toArray(new Salary[0]);
    }



    @Override
    public void recordSalary(Salary salary) {
        String sql = "INSERT INTO Salary (EMPLOYEEID, SALARYMONTH, SALARYYEAR, TOTALHOURSWORKED, SALARYAMOUNT) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, salary.getEmployeeID());
            statement.setInt(2, salary.getSalaryMonth());
            statement.setInt(3, salary.getSalaryYear());
            statement.setInt(4, salary.getTotalHoursWorked());
            statement.setDouble(5, salary.getSalaryAmount());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error recording salary: " + e.getMessage(), e);
        }
    }

    @Override
    public Salary[] getCalculatedEmployeeSalary(int month, int year) {
        List<Salary> salaries = new ArrayList<>();
        String sql = "SELECT " +
                "s.EMPLOYEEID, " +
                "s.SALARYMONTH, " +
                "s.SALARYYEAR, " +
                "s.TOTALHOURSWORKED, " +
                "s.SALARYAMOUNT " +
                "FROM SALARY s " +
                "WHERE s.SALARYMONTH = ? AND s.SALARYYEAR = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, month);
            statement.setInt(2, year);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Salary salary = new Salary();
                    salary.setEmployeeID(resultSet.getInt("EMPLOYEEID"));
                    salary.setSalaryMonth(resultSet.getInt("SALARYMONTH"));
                    salary.setSalaryYear(resultSet.getInt("SALARYYEAR"));
                    salary.setTotalHoursWorked(resultSet.getInt("TOTALHOURSWORKED"));
                    salary.setSalaryAmount(resultSet.getDouble("SALARYAMOUNT"));
                    salaries.add(salary);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving salary for month " + month + " and year " + year + ": " + e.getMessage(), e);
        }

        return salaries.toArray(new Salary[0]);
    }

    @Override
    public Salary getCalculatedEmployeeSalary(Employee employee, int month, int year) {
        Salary salary = new Salary();
        String sql = "SELECT " +
                "s.EMPLOYEEID, " +
                "s.SALARYMONTH, " +
                "s.SALARYYEAR, " +
                "s.TOTALHOURSWORKED, " +
                "s.SALARYAMOUNT " +
                "FROM SALARY s " +
                "WHERE s.EMPLOYEEID = ? AND s.SALARYMONTH = ? AND s.SALARYYEAR = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, employee.getEmployeeID());
            statement.setInt(2, month);
            statement.setInt(3, year);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    salary.setEmployeeID(resultSet.getInt("EMPLOYEEID"));
                    salary.setSalaryMonth(resultSet.getInt("SALARYMONTH"));
                    salary.setSalaryYear(resultSet.getInt("SALARYYEAR"));
                    salary.setTotalHoursWorked(resultSet.getInt("TOTALHOURSWORKED"));
                    salary.setSalaryAmount(resultSet.getDouble("SALARYAMOUNT"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving salary for employee: " + e.getMessage(), e);
        }

        return salary;
    }

    @Override
    public Salary[] getCalculatedEmployeeSalary(Employee employee) {
        List<Salary> salaryList = new ArrayList<>();
        String sql = "SELECT " +
                "s.EMPLOYEEID, " +
                "s.SALARYMONTH, " +
                "s.SALARYYEAR, " +
                "s.TOTALHOURSWORKED, " +
                "s.SALARYAMOUNT " +
                "FROM SALARY s " +
                "WHERE s.EMPLOYEEID = ? " +
                "ORDER BY s.SALARYMONTH, s.SALARYYEAR";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, employee.getEmployeeID());

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Salary salary = new Salary();
                    salary.setEmployeeID(resultSet.getInt("EMPLOYEEID"));
                    salary.setSalaryMonth(resultSet.getInt("SALARYMONTH"));
                    salary.setSalaryYear(resultSet.getInt("SALARYYEAR"));
                    salary.setTotalHoursWorked(resultSet.getInt("TOTALHOURSWORKED"));
                    salary.setSalaryAmount(resultSet.getDouble("SALARYAMOUNT"));
                    salaryList.add(salary);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving salaries for employee: " + e.getMessage(), e);
        }

        return salaryList.toArray(new Salary[0]);
    }

    @Override
    public void updateSalary(Salary salary) {
        String updateSql = "UPDATE Salary " +
                "SET TOTALHOURSWORKED = ?, SALARYAMOUNT = ? " +
                "WHERE EMPLOYEEID = ? AND SALARYMONTH = ? AND SALARYYEAR = ?";

        try (PreparedStatement statement = conn.prepareStatement(updateSql)) {
            statement.setInt(1, salary.getTotalHoursWorked());
            statement.setDouble(2, salary.getSalaryAmount());
            statement.setInt(3, salary.getEmployeeID());
            statement.setInt(4, salary.getSalaryMonth());
            statement.setInt(5, salary.getSalaryYear());

            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated == 0) {
                // No record found for update, insert a new record
                recordSalary(salary);
                System.out.println("Salary record not found, new record inserted.");
            } else {
                System.out.println("Rows updated: " + rowsUpdated);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error updating salary: " + e.getMessage(), e);
        }
    }

}

