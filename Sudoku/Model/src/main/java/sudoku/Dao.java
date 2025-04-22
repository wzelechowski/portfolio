package sudoku;

import java.util.List;

public interface Dao<T> extends AutoCloseable {
    T read() throws DataException;

    void write(T obj) throws DataException;

    void close() throws DataException;

    List<String> getBoardNames() throws DataException;
}

