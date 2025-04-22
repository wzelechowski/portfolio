package sudoku;

public class RunException extends RuntimeException {
    public RunException(String s) {
        super(ResourceBundleManager.getResourceBundle("sudoku.Exceptions").getString(s));
    }
}
