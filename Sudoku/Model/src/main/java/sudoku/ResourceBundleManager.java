package sudoku;

import java.util.Locale;
import java.util.ResourceBundle;

public class ResourceBundleManager {
    private static Locale locale = Locale.getDefault();
    private static final String BASE_NAME = "lang";
    private static ResourceBundle resourceBundle;

    public static void setLocale(Locale newLocale) {
        if (newLocale != null) {
            locale = newLocale;
        } else {
            locale = Locale.getDefault();
        }
        resourceBundle = ResourceBundle.getBundle(BASE_NAME, locale);
    }

    public static String getString(String key) {
        resourceBundle = ResourceBundle.getBundle(BASE_NAME, locale);
        return resourceBundle.getString(key);
    }

    public static ResourceBundle getResourceBundle(String baseName) {
        return ResourceBundle.getBundle(baseName, locale);
    }
}
