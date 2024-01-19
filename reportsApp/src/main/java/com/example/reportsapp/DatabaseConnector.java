package com.example.reportsapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnector {

    private static final String DB_URL = "jdbc:mariadb://127.0.0.1:3306/galeria";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";

    public static Connection connect() throws SQLException {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);
            System.out.println("Połączono z bazą danych!");
        } catch (SQLException e) {
            System.out.println("Błąd podczas połączenia z bazą danych: " + e.getMessage());
        }
        return connection;
    }
}