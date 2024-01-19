package com.example.reportsapp;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.DatePicker;
import javafx.stage.Stage;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class DateMenuController {
    @FXML
    private DatePicker dateStart;
    @FXML
    private DatePicker dateEnd;
    public void showMainMenu(ActionEvent event) throws IOException {
        Parent root= FXMLLoader.load(getClass().getResource("mainMenu-view.fxml"));
        Stage stage = (Stage) ((Node) event.getSource()).getScene().getWindow();
        Scene scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    public void getData() throws SQLException, JRException {

        LocalDate dataP= dateStart.getValue();
        LocalDate dataK= dateEnd.getValue();
        Date dataPocz= java.sql.Date.valueOf(dataP);
        Date dataKon= java.sql.Date.valueOf(dataK);

        String reportPath = "C:\\Users\\sarar\\IdeaProjects\\reportsApp\\reportsCompiled\\RaportSprzedawcy.jasper";

        Map<String, Object> parameters = new HashMap<>();

        parameters.put("ParametrDataPocz", dataPocz);
        parameters.put("ParametrDataKon", dataKon);
        Connection connection = DatabaseConnector.connect();

        JasperReport jasperReport = (JasperReport) net.sf.jasperreports.engine.util.JRLoader.loadObjectFromFile(reportPath);
        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

        JasperViewer viewer = new JasperViewer(jasperPrint, false);
        viewer.setVisible(true);
        System.out.println("DataPocz "+ dataPocz+ " DataKon"+ dataKon);
    }
}
