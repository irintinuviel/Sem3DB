module com.example.reportsapp {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;
    requires jasperreports;


    opens com.example.reportsapp to javafx.fxml;
    exports com.example.reportsapp;
}