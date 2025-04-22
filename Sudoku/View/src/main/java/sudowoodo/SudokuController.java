package sudowoodo;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import javafx.util.converter.IntegerStringConverter;
import javafx.util.converter.NumberStringConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import sudoku.*;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.*;
import java.util.function.UnaryOperator;
import java.util.regex.Pattern;

import static sudoku.JdbcSudokuBoardDao.filename;
import static sudowoodo.HelloController.getSelectedDifficulty;
import static sudowoodo.HelloController.selectedLocale;

public class SudokuController implements Initializable {
    @FXML
    private GridPane sudokuGrid;
    @FXML
    public Button saveButton;
    @FXML
    public Button loadButton;
    private SudokuBoard sudoku;
    private Dao<SudokuBoard> sudokuDao;
    private static final Logger logger = LoggerFactory.getLogger(HelloController.class);
    private static final String DB_URL = "jdbc:h2:~/SudokuDatabase";
    private static final String username = "user";
    private static final String password = "1234";

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        selectedLocale = Locale.getDefault();
        saveButton.setText(ResourceBundleManager.getString("saveText"));
        loadButton.setText(ResourceBundleManager.getString("loadText"));
        initializeSudokuBoard();
    }

    private void initializeSudokuBoard() {
        Difficulty difficulty = getSelectedDifficulty();
        sudoku = generateSudoku();
        logger.info("Sudoku have been generated");
        int cellsToRemove = difficulty.getCellsToRemove();
        sudoku.solveGame();
        sudoku.updateCells();
        removeCells(cellsToRemove, sudoku);
        loadSudoku();
    }

    public void loadSudoku() {
        sudokuGrid.getChildren().clear();
        for (int row = 0; row < 9; row++) {
            for (int col = 0; col < 9; col++) {
                int val = sudoku.get(row, col);
                TextField cell = new TextField();
                cell.setPrefSize(50, 50);
                cell.getStyleClass().add("sudoku-cell");
                if (!sudoku.getCell(row, col).isDeleted()) {
                    cell.setText(String.valueOf(val));
                    cell.setDisable(true);
                } else if (sudoku.getCell(row, col).isDeleted() && val != 0) {
                    bindTextFieldToSudokuCell(cell, row, col);
                    cell.setText(String.valueOf(val));
                } else {
                    bindTextFieldToSudokuCell(cell, row, col);
                    cell.clear();
                }
                sudokuGrid.add(cell, col, row);
            }
        }
        logger.info("Sudoku has been loaded");
    }

    private void removeCells(int cellsToRemove, SudokuBoard board) {
        Random random = new Random();
        int removedCount = 0;
        while (removedCount < cellsToRemove) {
            int row = random.nextInt(9);
            int col = random.nextInt(9);
            if (board.get(row, col) != 0) {
                board.set(row, col, 0);
                board.getCell(row, col).setDeleted(true);
                removedCount++;
                logger.info("Sudoku field value has been removed: [row={}, col={}]", row, col);
            }
        }
    }

    private SudokuBoard generateSudoku() {
        return new SudokuBoard(new BacktrackingSudokuSolver());
    }

    private TextFormatter<Integer> textValidator() {
        Pattern pattern = Pattern.compile("[1-9]?");
        UnaryOperator<TextFormatter.Change> filter = change -> {
            String newText = change.getControlNewText();
            if (pattern.matcher(newText).matches()) {
                return change;
            }
            return null;
        };

        return new TextFormatter<>(new IntegerStringConverter(), 0, filter);
    }


    private void bindTextFieldToSudokuCell(TextField cell, int row, int col) {
        IntegerProperty cellValueProperty = new SimpleIntegerProperty();
        cellValueProperty.set(sudoku.get(row, col));
        cell.textProperty().bindBidirectional(cellValueProperty, new NumberStringConverter());
        cell.setTextFormatter(textValidator());

        cellValueProperty.addListener((observable, oldValue, newValue) -> {
            if (newValue.intValue() != 0) {
                cell.setText(String.valueOf(newValue));
            } else {
                cell.clear();
            }
            cellValueProperty.set(newValue.intValue());
            sudoku.set(row, col, newValue.intValue());
            logger.info("Sudoku field has been changed: [row={}, col={}, value={}]", row, col, newValue.intValue());
        });
    }

    public void save() {
        TextInputDialog dialog = new TextInputDialog();
        dialog.setTitle(ResourceBundleManager.getString("saveDialog"));
        dialog.setHeaderText(null);
        dialog.setContentText(ResourceBundleManager.getString("enterBoardName"));
        Optional<String> result = dialog.showAndWait();
        result.ifPresent(boardName -> {
            try {
                filename = boardName;
                Connection connection = DriverManager.getConnection(DB_URL, username, password);
                sudokuDao = SudokuBoardDaoFactory.getJdbcDao(connection);
                sudokuDao.write(sudoku);
                logger.info("Sudoku has been saved to the database with name: {}", boardName);
            } catch (DataException e) {
                logger.error("Error saving Sudoku to the database: {}", e.getMessage());
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        });
    }

    public void load() {
        ChoiceDialog<String> dialog = new ChoiceDialog<>();
        dialog.setTitle(ResourceBundleManager.getString("loadDialog"));
        dialog.setHeaderText(null);
        dialog.setContentText(ResourceBundleManager.getString("selectBoardToLoad"));
        try {
            Connection connection = DriverManager.getConnection(DB_URL, username, password);
            sudokuDao = SudokuBoardDaoFactory.getJdbcDao(connection);
            List<String> boardNames = sudokuDao.getBoardNames();
            dialog.getItems().addAll(boardNames);
        } catch (DataException e) {
            logger.error("Error loading board names from the database: {}", e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        Optional<String> result = dialog.showAndWait();
        result.ifPresent(boardName -> {
            try {
                filename = boardName;
                sudoku = sudokuDao.read();
                loadSudoku();
            } catch (DataException e) {
                logger.error("Error loading Sudoku from the database: {}", e.getMessage());
            }
        });
    }
}
