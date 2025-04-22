package sudoku;

import java.io.IOException;

public class DataException extends IOException {
    public DataException(String s) {
        super(ResourceBundleManager.getResourceBundle("sudoku.Exceptions").getString(s));
    }
}
