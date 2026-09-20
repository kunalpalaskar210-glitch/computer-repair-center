package com.computerrepair.database;

import java.sql.Connection;

public class ConnectionTest {

    public static void main(String[] args) {
        try (Connection connection = DBConnection.getConnection()) {
            System.out.println("Database connection successful!");
            System.out.println(
                "Connected to: " +
                connection.getMetaData().getDatabaseProductName()
            );
            System.out.println(
                "Database: " +
                connection.getCatalog()
            );
        } catch (Exception e) {
            System.out.println("Database connection failed.");
            e.printStackTrace();
        }
    }
}