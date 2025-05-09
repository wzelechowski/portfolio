package sudowoodo;

import javafx.application.Application;
import javafx.stage.Stage;
import sudoku.DataException;

public class HelloApplication extends Application {
    @Override
    public void start(Stage stage) throws DataException {
        Config.buildStage(stage, "hello-view.fxml");
    }

    public static void main(String[] args) {
        launch();
    }
}