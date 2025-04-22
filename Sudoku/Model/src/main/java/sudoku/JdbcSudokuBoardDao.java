package sudoku;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JdbcSudokuBoardDao implements Dao<SudokuBoard>, AutoCloseable {
    private final Connection connection;

    public static String filename;

    public JdbcSudokuBoardDao(Connection connection) {
        this.connection = connection;
        initializeDatabase();
    }

    private void initializeDatabase() {
        try (Statement statement = connection.createStatement()) {
            statement.executeUpdate("CREATE TABLE IF NOT EXISTS SudokuBoard ("
                    + "BOARD_ID INT AUTO_INCREMENT PRIMARY KEY, "
                    + "BOARD_NAME VARCHAR(255) NOT NULL)");
            statement.executeUpdate("CREATE TABLE IF NOT EXISTS SudokuCell ("
                    + "CELL_ID INT AUTO_INCREMENT PRIMARY KEY, "
                    + "BOARD_ID INT NOT NULL, "
                    + "ROW_INDEX INT NOT NULL, "
                    + "COL_INDEX INT NOT NULL, "
                    + "CELL_VALUE INT NOT NULL, "
                    + "CELL_DELETED BOOLEAN NOT NULL, "
                    + "FOREIGN KEY (BOARD_ID) REFERENCES SudokuBoard(BOARD_ID))");
        } catch (SQLException e) {
            e.printStackTrace(); //dodac logger
        }
    }

    @Override
    public SudokuBoard read() {
        SudokuBoard sudokuBoard = new SudokuBoard(new BacktrackingSudokuSolver());
        try {
            String selectQuery = "SELECT * FROM SUDOKUBOARD "
                    + "JOIN SUDOKUCELL ON SUDOKUBOARD.BOARD_ID = SUDOKUCELL.BOARD_ID "
                    + "WHERE SUDOKUBOARD.BOARD_NAME = ?";
            PreparedStatement statement = connection.prepareStatement(selectQuery);
            statement.setString(1, filename);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int rowIndex = resultSet.getInt("ROW_INDEX");
                int colIndex = resultSet.getInt("COL_INDEX");
                int cellValue = resultSet.getInt("CELL_VALUE");
                boolean isDeleted = resultSet.getBoolean("CELL_DELETED");
                sudokuBoard.set(rowIndex, colIndex, cellValue);
                sudokuBoard.getCell(rowIndex, colIndex).setDeleted(isDeleted);
            }
            resultSet.close();
            statement.close();  //try-with-resources
        } catch (SQLException e) {
            try {
                throw new DataException("dataBaseLoad");
            } catch (DataException ex) {
                throw new RuntimeException("dataBaseLoad");
            }
        }
        return sudokuBoard;
    }

    @Override
    public void write(SudokuBoard obj) {
        try {
            connection.setAutoCommit(false);

            String insertBoardSql = "INSERT INTO SudokuBoard (BOARD_NAME) VALUES (?)";
            PreparedStatement boardStatement = connection.prepareStatement(insertBoardSql,
                    Statement.RETURN_GENERATED_KEYS);

            boardStatement.setString(1, filename);

            int affectedRows = boardStatement.executeUpdate();
            if (affectedRows == 0) {
                throw new DataBaseException("boardAdd");
            }

            ResultSet generatedKeys = boardStatement.getGeneratedKeys();
            int boardId;
            if (generatedKeys.next()) {
                boardId = generatedKeys.getInt(1);
                generatedKeys.close();
                boardStatement.close();

                String insertCellSql = "INSERT INTO SudokuCell (BOARD_ID, ROW_INDEX, COL_INDEX,"
                        + " CELL_VALUE, CELL_DELETED)"
                        + " VALUES (?, ?, ?, ?, ?)";
                PreparedStatement cellStatement = connection.prepareStatement(insertCellSql);
                for (int row = 0; row < SudokuBoard.SIZE; row++) {
                    for (int col = 0; col < SudokuBoard.SIZE; col++) {
                        int cellValue = obj.get(row, col);
                        boolean isDeleted = obj.getCell(row, col).isDeleted();
                        cellStatement.setInt(1, boardId);
                        cellStatement.setInt(2, row);
                        cellStatement.setInt(3, col);
                        cellStatement.setInt(4, cellValue);
                        cellStatement.setBoolean(5, isDeleted);
                        cellStatement.addBatch();
                    }
                }
                cellStatement.executeBatch();
                cellStatement.close();
            } else {
                generatedKeys.close();
                throw new DataBaseException("boardID");
            }

            connection.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException rollbackException) {
                rollbackException.printStackTrace();
            }
            throw new RunException("dataBaseSave");
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException autoCommitException) {
                autoCommitException.printStackTrace();
            }
        }
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

    @Override
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
