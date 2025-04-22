package sudoku;

import java.util.ListResourceBundle;

public class Exceptions_en extends ListResourceBundle {
    private static final Object[][] contents = {
            {"notExist", "File doesn't exist "},
            {"notReading", "File can't be read "},
            {"notSave", "File can't be saved "},
            {"notClose","File can't be closed "},
            {"notAssert","Assertion failed "},
            {"notClone","Can't clone this object "},
            {"null","Object is null "},
            {"argument","Illegal argument "},
            {"dataBaseLoad","Downloading from data base error"},
            {"dataBaseSave","Saving from data base error"},
            {"boardID"," Can't download sudoku ID"},
            {"boardAdd","Can't add board"},
            {"dataBase", "Can't access database"}
    };

    @Override
    protected Object[][] getContents() {
        return contents;
    }
}
