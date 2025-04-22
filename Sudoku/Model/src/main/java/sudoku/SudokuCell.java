package sudoku;

import java.io.Serializable;

public class SudokuCell implements Serializable {
    private boolean deleted;
    private int original;

    public SudokuCell(boolean deleted, int original) {
        this.deleted = deleted;
        this.original = original;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public int getOriginal() {
        return original;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

    public void setOriginal(int original) {
        this.original = original;
    }
}
