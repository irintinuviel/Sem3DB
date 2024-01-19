package com.example.reportsapp;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.util.JRLoader;
import net.sf.jasperreports.view.JasperViewer;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class IdMenuController {

    @FXML
    private TextField fieldId;
    public void showMainMenu(ActionEvent event) throws IOException {
        Parent root= FXMLLoader.load(getClass().getResource("mainMenu-view.fxml"));
        Stage stage = (Stage) ((Node) event.getSource()).getScene().getWindow();
        Scene scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    public void getData(){
        String id;
        id= fieldId.getText();
        if (id.isEmpty()){
            System.out.println("Podaj poprawne dane!");
        } else {
            try {
                int nrInw = Integer.parseInt(id);
                System.out.println("NrInw " + nrInw);
                String reportPath = "C:\\Users\\sarar\\IdeaProjects\\reportsApp\\reportsCompiled\\RaportDziela2.jasper";
                String subrepPath = "C:\\Users\\sarar\\IdeaProjects\\reportsApp\\reportsCompiled\\RaportWystaw.jasper";
                JasperReport jaspersubReport = (JasperReport) net.sf.jasperreports.engine.util.JRLoader.loadObjectFromFile(subrepPath);
                Map<String, Object> parameters = new HashMap<>();

                parameters.put("ParametrNrInw",nrInw);
                parameters.put("Subraport",jaspersubReport);
                parameters.put(JRParameter.IS_IGNORE_PAGINATION, true);
                Connection connection = DatabaseConnector.connect();

                JasperReport jasperReport = (JasperReport) net.sf.jasperreports.engine.util.JRLoader.loadObjectFromFile(reportPath);
                JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

                JasperViewer viewer = new JasperViewer(jasperPrint, false);
                viewer.setVisible(true);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            } catch (JRException | SQLException e) {
                throw new RuntimeException(e);
            }

        }

    }

}
