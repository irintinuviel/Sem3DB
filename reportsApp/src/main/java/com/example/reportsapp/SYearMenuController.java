package com.example.reportsapp;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.view.JasperViewer;


public class SYearMenuController {
    @FXML
    private TextField fieldStart;
    @FXML
    private TextField fieldEnd;
    public void showMainMenu(ActionEvent event) throws IOException {
        Parent root= FXMLLoader.load(getClass().getResource("mainMenu-view.fxml"));
        Stage stage = (Stage) ((Node) event.getSource()).getScene().getWindow();
        Scene scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    public void getData(){
        String rokPocz;
        String rokKon;
        rokPocz= fieldStart.getText();
        rokKon= fieldEnd.getText();
        if (rokPocz.isEmpty() || rokKon.isEmpty()){
            System.out.println("Podaj poprawne dane!");
        } else {
            try{
                int paramRokPocz= Integer.parseInt(rokPocz);
                int paramRokKon= Integer.parseInt(rokKon);
                String reportPath = "C:\\Users\\sarar\\IdeaProjects\\reportsApp\\reportsCompiled\\RaportSprzedazy.jasper";
                Map<String, Object> parameters = new HashMap<>();

                parameters.put("ParametrRokPocz", paramRokPocz);
                parameters.put("ParametrRokKon", paramRokKon);
                Connection connection = DatabaseConnector.connect();

                JasperReport jasperReport = (JasperReport) net.sf.jasperreports.engine.util.JRLoader.loadObjectFromFile(reportPath);
                JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

                JasperViewer viewer = new JasperViewer(jasperPrint, false);
                viewer.setVisible(true);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            } catch (JRException e) {
                throw new RuntimeException(e);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

        }
    }

}

