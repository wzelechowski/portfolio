package sudoku;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;


public class SudokuBoardTest {
    @Test
    public void getAndSetTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        assertEquals(board.get(0, 0), 0);
        board.set(0, 0, 1);
        assertEquals(board.get(0, 0), 1);
    }
    @Test
    public void solveGameTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        board.solveGame();
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                for (int k = j + 1; k < 9; k++) {
                    if (board.get(i, j) == board.get(i, k)) {
                        fail("Same numbers in row " + i);
                    }
                }
            }
        }
        for (int j = 0; j < 9; j++) {
            for (int i = 0; i < 9; i++) {
                for (int k = i + 1; k < 9; k++) {
                    if (board.get(i, j) == board.get(k, j)) {
                        fail("Same numbers in column " + j);
                    }
                }
            }
        }
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                int[] testBoard = new int[9];
                int num = 0;
                for (int k = i*3; k < i*3+3; k++) {
                    for (int l = j*3; l < j*3+3; l++) {
                        testBoard[num] = board.get(k, l);
                        num++;
                    }
                }
                for (num = 0; num < 8; num++) {
                    if (testBoard[num] == testBoard[num + 1]) {
                        fail("Square 3x3 with rows " + i*3 + " " + (i*3+1) + " " + (i*3+2) +
                                " and columns " + j*3 + " " + (j*3+1) + " " + (j*3+2) + " is incorrect!");
                    }
                }
            }
        }
    }
    @Test
    public void differentBoardTest() {
        SudokuBoard board1 = new SudokuBoard(new BacktrackingSudokuSolver());
        board1.solveGame();
        SudokuBoard board2 = new SudokuBoard(new BacktrackingSudokuSolver());
        board2.solveGame();
        boolean same = true;
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                if (board1.get(i, j) != board2.get(i, j)) {
                    same = false;
                    break;
                }
            }
        }
        assertFalse(same);
    }
    @Test
    public void getRowTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        board.solveGame();
        assertNotNull(board.getRow(1));
    }
    @Test
    public void getColumnTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        board.solveGame();
        assertNotNull(board.getColumn(1));
    }
    @Test
    public void getBoxTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        board.solveGame();
        assertNotNull(board.getBox(1, 1));
    }
    @Test
    public void checkBoardTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        board.solveGame();
        assertTrue(board.checkBoard());
        board.set(0,0, 0);
        board.set(0,1, 0);
        assertFalse(board.checkBoard());
        board.solveGame();
        board.set(0,0,0);
        board.set(1,0,0);
        assertFalse(board.checkBoard());
        board.solveGame();
        board.set(0,0,0);
        board.set(2,2,0);
        assertFalse(board.checkBoard());
    }
    @Test
    public void toStringTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        assertNotNull(board.toString());
    }
    @Test
    public void equalsDefualtTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        SudokuBoard board1 = new SudokuBoard(new BacktrackingSudokuSolver());
        assertTrue(board.equals(board1) && board1.equals(board));
    }
    @Test
    public void equalsSelfTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        assertTrue(board.equals(board));
    }
    @Test
    public void equalsNullAndDifferentClassTest() {
        BacktrackingSudokuSolver solver = new BacktrackingSudokuSolver();
        SudokuBoard board = new SudokuBoard(solver);
        assertFalse(board.equals(null));
        assertFalse(board.equals(solver));
    }
    @Test
    public void hashCodeTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        SudokuBoard board2 = new SudokuBoard(new BacktrackingSudokuSolver());
        assertEquals(board.hashCode(), board2.hashCode());
    }
    @Test
    public void differentHashCodeTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        SudokuBoard board2 = new SudokuBoard(new BacktrackingSudokuSolver());
        board.solveGame();
        board2.solveGame();
        assertNotEquals(board.hashCode(), board2.hashCode());
    }
    @Test
    public void equalsAndHashCodeConsistentTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        SudokuBoard board2 = new SudokuBoard(new BacktrackingSudokuSolver());
        assertTrue(board.equals(board2));
        assertEquals(board.hashCode(), board2.hashCode());
        board.solveGame();
        assertFalse(board.equals(board2));
        assertNotEquals(board.hashCode(), board2.hashCode());
    }
    @Test
    public void cloneTest() {
        SudokuBoard board = new SudokuBoard(new BacktrackingSudokuSolver());
        SudokuBoard clonedBoard = board.clone();
        assertEquals(board, clonedBoard);
        clonedBoard.set(0, 0, 5);
        assertNotEquals(board.get(0, 0), clonedBoard.get(0, 0));
    }
}