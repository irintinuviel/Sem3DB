package com.example.reportsapp;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.stage.Stage;

import java.io.IOException;

public class MenuController {

    private Stage stage;
    private Scene scene;


    public void showsYearMenu(ActionEvent event) throws IOException {
        Parent root= FXMLLoader.load(getClass().getResource("sYearMenu.fxml"));
        stage= (Stage)((Node)event.getSource()).getScene().getWindow();
        scene= new Scene(root);
        stage.setScene(scene);
        stage.show();
    }


    public void shownYearMenu(ActionEvent event) throws IOException {
        Parent root= FXMLLoader.load(getClass().getResource("nYearMenu.fxml"));
        stage= (Stage)((Node)event.getSource()).getScene().getWindow();
        scene= new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    public void showuYearMenu(ActionEvent event) throws IOException {
        Parent root= FXMLLoader.load(getClass().getResource("uYearMenu.fxml"));
        stage= (Stage)((Node)event.getSource()).getScene().getWindow();
        scene= new Scene(root);
        stage.setScene(scene);
        stage.show();
    }
    public void showDateMenu(ActionEvent event) throws IOException {
        Parent root= FXMLLoader.load(getClass().getResource("dateMenu.fxml"));
        stage= (Stage)((Node)event.getSource()).getScene().getWindow();
        scene= new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    public void showIdMenu(ActionEvent event) throws IOException {
        Parent root= FXMLLoader.load(getClass().getResource("idMenu.fxml"));
        stage= (Stage)((Node)event.getSource()).getScene().getWindow();
        scene= new Scene(root);
        stage.setScene(scene);
        stage.show();
    }
}