package com.computerrepair.database;

import com.computerrepair.config.DatabaseConfig;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class that provides centralized JDBC connection creation
 * for the Computer Repair Center Management System.
 */
public final class DBConnection {

    // Private constructor prevents instantiation of this utility class
    private DBConnection() {
        throw new UnsupportedOperationException("DBConnection is a utility class and cannot be instantiated.");
    }

    /**
     * Creates and returns a new MySQL JDBC connection using credentials
     * defined in {@link DatabaseConfig}.
     *
     * @return an active {@link Connection} to the database
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
            DatabaseConfig.DB_URL,
            DatabaseConfig.DB_USER,
            DatabaseConfig.DB_PASSWORD
        );
    }
}