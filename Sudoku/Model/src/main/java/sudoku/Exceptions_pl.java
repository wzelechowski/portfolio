package sudoku;

import java.util.ListResourceBundle;

public class Exceptions_pl extends ListResourceBundle {
    private static final Object[][] contents = {
            {"notExist", "Plik nie istnieje "},
            {"notReading", "Blad podczas odczytu pliku "},
            {"notSave", "Blad podczasu zapisu pliku "},
            {"notClose","Blad podczas zamykania pliku "},
            {"notAssert","Asercja nie powiodla sie "},
            {"notClone","Nie mozna sklonowac obiektu "},
            {"null","Obiekt jest nullem "},
            {"argument","Nielegalny argument "},
            {"dataBaseLoad","Blad pobierania z bazy danych"},
            {"dataBaseSave","Blad zapisu planszy do bazy danych"},
            {"boardID","Nie udalo sie pobrac ID dodanej planszy"},
            {"boardAdd","Nie udalo sie dodać planszy do tabeli"}
    };

    @Override
    protected Object[][] getContents() {
        return contents;
    }
}
