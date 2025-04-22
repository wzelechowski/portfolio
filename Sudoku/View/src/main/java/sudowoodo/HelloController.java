package sudowoodo;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import sudoku.DataException;
import sudoku.ResourceBundleManager;
import sudoku.RunException;

import java.net.URL;
import java.util.Locale;
import java.util.ResourceBundle;

public class HelloController implements Initializable {
    @FXML
    public Button sudokuButton;
    @FXML
    public ComboBox<String> choiceMenu;
    private static Difficulty selectedDifficulty;
    public ComboBox<Locale> langBox;
    public Button authorsButton;
    public Label authorsLabel;
    public static Locale selectedLocale = Locale.getDefault();

    private static final Logger logger = LoggerFactory.getLogger(HelloController.class);

    public static Difficulty getSelectedDifficulty() {
        return selectedDifficulty;
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        choiceMenu.setPromptText(ResourceBundleManager.getString("promptText"));
        sudokuButton.setText(ResourceBundleManager.getString("confirmText"));
        langBox.setPromptText(ResourceBundleManager.getString("langPromptText"));
        authorsButton.setText(ResourceBundleManager.getString("authorsText"));

        ObservableList<Locale> langList = FXCollections.observableArrayList(
                new Locale("pl"),
                new Locale("en")
        );
        langBox.setItems(langList);

        langBox.valueProperty().addListener((observable, oldValue, newValue) -> {
            selectedLocale = newValue;
            ResourceBundleManager.setLocale(selectedLocale);
            logger.info("Language has been set on: [{}]", newValue.toString());
            try {
                Config.buildStage("hello-view.fxml");
            } catch (DataException e) {
                throw new RunException("null");
            }
        });

        ObservableList<String> difficultyList = FXCollections.observableArrayList(
                ResourceBundleManager.getString(Difficulty.EASY.getKey()),
                ResourceBundleManager.getString(Difficulty.NORMAL.getKey()),
                ResourceBundleManager.getString(Difficulty.HARD.getKey())
        );
        choiceMenu.setItems(difficultyList);

        choiceMenu.valueProperty().addListener((observable, oldValue, newValue) -> {
            logger.info("Difficulty level selected: {}", newValue);
            sudokuButton.setDisable(newValue == null);
        });
    }

    public void onConfirmButtonClicked() throws DataException {
        String selectedDifficultyKey = choiceMenu.getValue();
        if (selectedDifficultyKey != null) {
            if (selectedDifficultyKey.equals("LATWY")) {
                selectedDifficulty = Difficulty.EASY;
            } else if (selectedDifficultyKey.equals("SREDNI")) {
                selectedDifficulty = Difficulty.NORMAL;
            } else {
                selectedDifficulty = Difficulty.HARD;
            }
            logger.info("Difficulty level confirmed: {}", selectedDifficulty);
            Config.buildStage("sudoku-view.fxml");
        }
    }

    public void onClickAuthors() {
        ResourceBundle authorsBundle = ResourceBundle.getBundle("sudowoodo.Authors", selectedLocale);

        String authorsText = authorsBundle.getString("Authors");
        String author1 = authorsBundle.getString("Author1");
        String author2 = authorsBundle.getString("Author2");

        String authorsMessage = authorsText + "\n" + author1 + "\n" + author2;
        authorsLabel.setText(authorsMessage);
        logger.info("Authors have been viewed");
    }
}
