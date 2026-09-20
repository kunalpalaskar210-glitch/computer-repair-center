package com.computerrepair.config;

/**
 * Configuration class for database connection settings.
 * 
 * Supports environment variables to avoid committing sensitive credentials
 * to version control (Git). If no environment variables are detected, sensible
 * local development defaults are used.
 */
public final class DatabaseConfig {

    // Database connection URL: overridden by COMPUTER_REPAIR_DB_URL if set
    public static final String DB_URL = System.getenv().getOrDefault(
        "COMPUTER_REPAIR_DB_URL",
        "jdbc:mysql://localhost:3306/computer_repair_center?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"
    );

    // Database username: overridden by COMPUTER_REPAIR_DB_USER if set
    public static final String DB_USER = System.getenv().getOrDefault(
        "COMPUTER_REPAIR_DB_USER",
        "root"
    );

    // Database password: overridden by COMPUTER_REPAIR_DB_PASSWORD if set
    // Defaults to an empty string for local setups; never hard-code production passwords in Git
    public static final String DB_PASSWORD = System.getenv().getOrDefault(
        "COMPUTER_REPAIR_DB_PASSWORD",
        ""
    );

    // Private constructor prevents direct instantiation of utility class
    private DatabaseConfig() {
        throw new UnsupportedOperationException("DatabaseConfig is a utility class and cannot be instantiated.");
    }
}