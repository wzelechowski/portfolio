package sudowoodo;

import java.util.ListResourceBundle;

public class Authors_pl extends ListResourceBundle {
    private static final Object[][] contents = {
            {"Authors", "Stworzone przez"},
            {"Author1", "Wiktor Żelechowski"},
            {"Author2", "Mikołaj Hryć"}
    };

    @Override
    protected Object[][] getContents() {
        return contents;
    }
}