/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ems.dao;
import com.ems.connection.Connect;
import com.ems.model.HROfficer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OfficerDAOImpl implements OfficerDAO {

    private Connection conn;

    public OfficerDAOImpl() {
        this.conn = Connect.getConnection();
    }

    @Override
    public HROfficer getHROfficerById(int officerID) {
        HROfficer officer = null;
        String sql = "SELECT * FROM HROFFICER WHERE OFFICERID = ?";
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, officerID);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    officer = new HROfficer();
                    officer.setOfficerID(resultSet.getInt("OFFICERID"));
                    officer.setOfficerPassword(resultSet.getString("OFFICERPASSWORD"));
                    officer.setOfficerName(resultSet.getString("OFFICERNAME"));
                    officer.setOfficerPhoneNumber(resultSet.getString("OFFICERPHONENUMBER"));
                    officer.setOfficerEmail(resultSet.getString("OFFICEREMAIL"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving officer by ID: " + e.getMessage(), e);
        }
        return officer;
    }

    @Override
    public HROfficer[] getAllHROfficer() {
        List<HROfficer> officerList = new ArrayList<>();
        String sql = "SELECT * FROM HROFFICER";

        try (PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                HROfficer officer = new HROfficer();
                officer.setOfficerID(resultSet.getInt("OFFICERID"));
                officer.setOfficerPassword(resultSet.getString("OFFICERPASSWORD"));
                officer.setOfficerName(resultSet.getString("OFFICERNAME"));
                officer.setOfficerPhoneNumber(resultSet.getString("OFFICERPHONENUMBER"));
                officer.setOfficerEmail(resultSet.getString("OFFICEREMAIL"));
                officerList.add(officer);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Replace with logging framework in production
            throw new RuntimeException("Error retrieving all officers: " + e.getMessage(), e);
        }

        return officerList.toArray(new HROfficer[0]);
    }
}

