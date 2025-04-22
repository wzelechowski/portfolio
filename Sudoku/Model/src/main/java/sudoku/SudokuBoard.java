package sudoku;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;

import java.io.Serializable;
import java.util.Arrays;
import java.util.List;

public class SudokuBoard implements Serializable, Cloneable {
    public static final int SIZE = 9;
    public static final int CELL_NUM = SIZE * SIZE;
    private SudokuField[][] board = new SudokuField[SIZE][SIZE];
    private final SudokuSolver solver;
    private final SudokuCell[][] cells;

    public SudokuBoard(SudokuSolver solver) {
        this.solver = solver;
        this.cells = new SudokuCell[SIZE][SIZE];
        for (int x = 0; x < SIZE; x++) {
            for (int y = 0; y < SIZE; y++) {
                this.board[x][y] = new SudokuField();
                this.cells[x][y] = new SudokuCell(false, 0);
            }
        }
    }

    public int get(int x, int y) {
        return board[x][y].getFieldValue();
    }

    public void set(int x, int y, int value) {
        this.board[x][y].setFieldValue(value);
    }

    public void solveGame() {
        solver.solve(this);
    }

    public SudokuRow getRow(int y) {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SIZE]);
        for (int i = 0; i < SIZE; i++) {
            fields.set(i, board[y][i]);
        }
        return new SudokuRow(fields);
    }

    public SudokuColumn getColumn(int x) {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SIZE]);
        for (int i = 0; i < SIZE; i++) {
            fields.set(i, board[i][x]);
        }
        return new SudokuColumn(fields);
    }

    public SudokuBox getBox(int x, int y) {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SIZE]);
        int num = 0;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                fields.set(num++, board[x * 3 + i][y * 3 + j]);
            }
        }
        return new SudokuBox(fields);
    }

    public boolean checkBoard() {
        for (int i = 0; i < 9; i++) {
            if (!getRow(i).verify() || !getColumn(i).verify()) {
                return false;
            }
        }
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (!getBox(i, j).verify()) {
                    return false;
                }
            }
        }
        return true;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this)
                .append("board", board)
                .toString();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        SudokuBoard board1 = (SudokuBoard) o;
        return new EqualsBuilder().append(board, board1.board).isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37).append(board).toHashCode();
    }

    @Override
    public SudokuBoard clone() {
        try {
            SudokuBoard clonedBoard = (SudokuBoard) super.clone();
            clonedBoard.board = new SudokuField[SIZE][SIZE];

            for (int i = 0; i < SIZE; i++) {
                for (int j = 0; j < SIZE; j++) {
                    clonedBoard.board[i][j] = this.board[i][j].clone();
                }
            }
            return clonedBoard;
        } catch (CloneNotSupportedException e) {
            throw new AssertionException("notAssert");
        }
    }

    public void updateCells() {
        for (int row = 0; row < SIZE; row++) {
            for (int col = 0; col < SIZE; col++) {
                this.cells[row][col].setOriginal(get(row, col));
            }
        }
    }

    public SudokuCell getCell(int x, int y) {
        return cells[x][y];
    }
}