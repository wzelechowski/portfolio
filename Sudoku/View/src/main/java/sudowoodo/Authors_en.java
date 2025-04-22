package sudowoodo;

import java.util.ListResourceBundle;

public class Authors_en extends ListResourceBundle {
    private static final Object[][] contents = {
            {"Authors", "Created by"},
            {"Author1", "Wiktor Żelechowski"},
            {"Author2", "Mikołaj Hryć"}
    };

    @Override
    protected Object[][] getContents() {
        return contents;
    }
}