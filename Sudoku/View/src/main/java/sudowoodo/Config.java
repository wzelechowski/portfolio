package sudowoodo;

import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import sudoku.DataException;

import java.io.IOException;

public class Config {
    private static Stage stage = new Stage();

    private static void setStage(Stage stage) {
        Config.stage = stage;
    }

    private static Parent loadFxml(String filePath) throws DataException {
        try {
            return new FXMLLoader(Config.class.getResource(filePath)).load();
        } catch (IOException e) {
            throw new DataException("NotLoad");
        }
    }

    public static void buildStage(String filePath) throws DataException {
        stage.setScene(new Scene(loadFxml(filePath)));
        stage.sizeToScene();
        stage.show();
    }

    public static void buildStage(Stage stage, String filePath) throws DataException {
        setStage(stage);
        stage.setScene(new Scene(loadFxml(filePath)));
        stage.setTitle("Sudoku");
        stage.sizeToScene();
        stage.show();
    }
}
