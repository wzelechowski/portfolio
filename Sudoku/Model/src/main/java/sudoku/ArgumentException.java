package sudoku;

public class ArgumentException extends IllegalArgumentException {
    public ArgumentException(String s) {
        super(ResourceBundleManager.getResourceBundle("sudoku.Exceptions").getString(s));
    }
}
