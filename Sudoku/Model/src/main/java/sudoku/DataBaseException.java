package sudoku;

import java.sql.SQLException;

public class DataBaseException extends SQLException {
    public DataBaseException(String s) {
        super(ResourceBundleManager.getResourceBundle("sudoku.Exceptions").getString(s));
    }
}
