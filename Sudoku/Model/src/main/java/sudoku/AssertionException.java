package sudoku;

public class AssertionException extends AssertionError {
    public AssertionException(String s) {
        super(ResourceBundleManager.getResourceBundle("sudoku.Exceptions").getString(s));
    }
}
