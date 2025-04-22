package sudoku;

public class SudokuBoardPrototype {
    private final SudokuBoard sudokuBoard = new SudokuBoard(new BacktrackingSudokuSolver());

    public SudokuBoard makeSudokuBoard() {
        return sudokuBoard.clone();
    }
}
