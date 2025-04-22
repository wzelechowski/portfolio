package sudoku;

import java.util.ArrayList;
import java.util.Collections;

public class BacktrackingSudokuSolver implements SudokuSolver {
    public void solve(SudokuBoard board) {
        ArrayList<Integer> numbers = new ArrayList<>();
        for (int j = 1; j <= 9; j++) {
            numbers.add(j);
        }
        Collections.shuffle(numbers);
        int[] startBoard = new int[SudokuBoard.CELL_NUM];
        for (int i = 0; i < SudokuBoard.CELL_NUM; i++) {
            int rowNum = i / SudokuBoard.SIZE;
            int colNum = i % SudokuBoard.SIZE;
            boolean fitNum = false;
            if (startBoard[i] == 0) {
                for (int j = 0; j < 9; j++) {
                    startBoard[i] = numbers.get(j);
                    board.set(rowNum, colNum, startBoard[i]);
                    if (isValid(i, board)) {
                        fitNum = true;
                        break;
                    }
                }
            } else {
                board.set(rowNum, colNum, board.get(rowNum, colNum) % 9 + 1);
                while (board.get(rowNum, colNum) != startBoard[i]) {
                    if (isValid(i, board)) {
                        fitNum = true;
                        break;
                    }
                    board.set(rowNum, colNum, board.get(rowNum, colNum) % 9 + 1);
                }
            }
            if (!fitNum) {
                startBoard[i] = 0;
                board.set(rowNum, colNum, 0);
                i = i - 2;
            }
        }
    }

    private boolean isValid(int index, SudokuBoard board) {
        int rowNum = index / SudokuBoard.SIZE;
        int colNum = index % SudokuBoard.SIZE;
        int number = board.get(rowNum, colNum);
        for (int i = 0; i < colNum; i++) {
            if (number == board.get(rowNum, i)) {
                return false;
            }
        }
        for (int i = 0; i < rowNum; i++) {
            if (number == board.get(i, colNum)) {
                return false;
            }
        }
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                int squareRow = i + (rowNum / (SudokuBoard.SIZE / 3)) * 3;
                int squareCol = j + (colNum / (SudokuBoard.SIZE / 3)) * 3;
                if (board.get(squareRow, squareCol) == number && (squareRow * 9 + squareCol) < index) {
                    return false;
                }
            }
        }
        return true;
    }
}