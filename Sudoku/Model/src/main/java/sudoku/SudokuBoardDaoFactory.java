package sudoku;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SudokuBoardDaoFactory {

    private Connection connection;

    private SudokuBoardDaoFactory() {
    }

    public static Dao<SudokuBoard> getFileDao(String fileName) {
        return new FileSudokuBoardDao(fileName);
    }

    public static Dao<SudokuBoard> getJdbcDao(Connection connection) {
        return new JdbcSudokuBoardDao(connection);
    }

    public List<String> getBoardNames() throws DataException {
        List<String> boardNames = new ArrayList<>();
        try {
            String selectQuery = "SELECT BOARD_NAME FROM SudokuBoard";
            PreparedStatement statement = connection.prepareStatement(selectQuery);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                String boardName = resultSet.getString("BOARD_NAME");
                boardNames.add(boardName);
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            throw new DataException("dataBaseLoad");
        }
        return boardNames;
    }
}
