package sudoku;

public class NullException extends NullPointerException {
    public NullException(String s) {
        super(ResourceBundleManager.getResourceBundle("sudoku.Exceptions").getString(s));
    }
}
