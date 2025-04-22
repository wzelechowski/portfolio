package sudoku;

import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static sudoku.JdbcSudokuBoardDao.filename;

public class JdbcSudokuBoardDaoTest {
    private static final String DB_URL = "jdbc:h2:~/test";
    private static final String username = "sa";
    private static final String password = "1234";
    private Connection connection;
    private Dao<SudokuBoard> sudokuDao;

    @Test
    public void saveAndReadTest() throws DataException {
        try {
            connection = DriverManager.getConnection(DB_URL, username, password);
            connection.setAutoCommit(false);
        } catch (SQLException e) {
            throw new RunException("dataBase");
        }
        sudokuDao = new JdbcSudokuBoardDao(connection);
        SudokuBoard originalSudoku = new SudokuBoard(new BacktrackingSudokuSolver());
        originalSudoku.solveGame();
        sudokuDao.write(originalSudoku);
        SudokuBoard loadedSudoku = sudokuDao.read();
        assertNotSame(originalSudoku, loadedSudoku);
        assertEquals(originalSudoku, loadedSudoku);
        try {
            sudokuDao.close();
        } catch (Exception e) {
            throw new RunException("notClose");
        }
    }

    @Test
    public void boardNamesSavingTest() throws DataException {
        try {
            connection = DriverManager.getConnection(DB_URL, username, password);
            connection.setAutoCommit(false);
        } catch (SQLException e) {
            throw new RunException("dataBase");
        }
        sudokuDao = new JdbcSudokuBoardDao(connection);
        filename = "board1";
        sudokuDao.write(new SudokuBoard(new BacktrackingSudokuSolver()));
        filename = "board2";
        sudokuDao.write(new SudokuBoard(new BacktrackingSudokuSolver()));
        filename = "board3";
        sudokuDao.write(new SudokuBoard(new BacktrackingSudokuSolver()));
        List<String> boardNames = sudokuDao.getBoardNames();
        assertNotNull(boardNames);
        assertTrue(boardNames.contains("board1"));
        assertTrue(boardNames.contains("board2"));
        assertTrue(boardNames.contains("board3"));
        try {
            sudokuDao.close();
        } catch (Exception e) {
            throw new RunException("notClose");
        }
    }
}