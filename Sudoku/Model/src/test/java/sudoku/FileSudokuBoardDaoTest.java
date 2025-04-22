package sudoku;

import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;

public class FileSudokuBoardDaoTest {


    @Test
    public void readAndWriteTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        board.solveGame();
        String testFileName = "test_board";
        try (Dao<SudokuBoard> dao = SudokuBoardDaoFactory.getFileDao(testFileName)) {
            dao.write(board);
        } catch (Exception e) {
            throw new RunException("notSave");
        }
        SudokuBoard board2;
        try ( Dao<SudokuBoard> dao = SudokuBoardDaoFactory.getFileDao(testFileName)) {
            board2 = dao.read();
        } catch (Exception e) {
            throw new RunException("notLoad");
        }
        assertNotNull(board2);
        assertEquals(board, board2);
        File file = new File(testFileName);
        file.delete();
        assertFalse(file.exists());
    }
    @Test
    public void readNonExistentFileTest() {
        String nonExistentFileName = "non_existent_file";
        assertThrows(IOException.class, () -> {
            try (Dao<SudokuBoard> dao = SudokuBoardDaoFactory.getFileDao(nonExistentFileName)) {
                dao.read();
            }
        });
    }
    @Test
    public void writeIOExceptionTest() {
        String protectedFileName = "protectedDirectory/test_exc";
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        assertThrows(IOException.class, () -> {
            try (Dao<SudokuBoard> dao = SudokuBoardDaoFactory.getFileDao(protectedFileName)) {
                dao.write(board);
            }
        });
        File file = new File(protectedFileName);
        file.delete();
        assertFalse(file.exists());
    }

    @Test
    public void closeTest() {
        String testFileName = "test_close_board";
        Dao<SudokuBoard> dao;
        try {
            dao = SudokuBoardDaoFactory.getFileDao(testFileName);
        } catch (Exception e) {
            throw new RunException("notClose");
        }

        assertNotNull(dao);

        try {
            dao.close();
        } catch (Exception e) {
            throw new RunException("notClose");
        }

        File file = new File(testFileName);
        file.delete();
        assertFalse(file.exists());
    }
}