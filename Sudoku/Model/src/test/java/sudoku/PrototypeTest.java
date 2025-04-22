package sudoku;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class PrototypeTest {

    @Test
    public void testMakeSudokuBoard_NotNull() {
        SudokuBoardPrototype prototype = new SudokuBoardPrototype();
        SudokuBoard board = prototype.makeSudokuBoard();
        assertNotNull(board);
    }

    @Test
    public void testMakeSudokuBoard_EqualContent() {
        SudokuBoardPrototype prototype = new SudokuBoardPrototype();
        SudokuBoard board1 = prototype.makeSudokuBoard();
        SudokuBoard board2 = prototype.makeSudokuBoard();
        assertEquals(board1, board2);
    }
}

