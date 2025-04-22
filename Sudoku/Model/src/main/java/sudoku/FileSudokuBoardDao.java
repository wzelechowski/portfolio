package sudoku;

import java.io.*;
import java.util.List;

public class FileSudokuBoardDao implements Dao<SudokuBoard>, AutoCloseable {
    private final String fileName;
    private ObjectOutputStream objectOutputStream;
    private ObjectInputStream objectInputStream;

    public FileSudokuBoardDao(String fileName) {
        this.fileName = fileName;
    }

    @Override
    public SudokuBoard read() throws DataException {
        try {
            objectInputStream = new ObjectInputStream(new FileInputStream(fileName));
            return (SudokuBoard) objectInputStream.readObject();
        } catch (FileNotFoundException e) {
            throw new DataException("notExist");
        } catch (IOException | ClassNotFoundException e) {
            throw new DataException("notReading");
        }
    }

    @Override
    public void write(SudokuBoard obj) throws DataException {
        try {
            objectOutputStream = new ObjectOutputStream(new FileOutputStream(fileName));
            objectOutputStream.writeObject(obj);
        } catch (IOException e) {
            throw new DataException("notSave");
        }
    }

    @Override
    public void close() throws DataException {
        try {
            if (objectInputStream != null) {
                objectInputStream.close();
            }
            if (objectOutputStream != null) {
                objectOutputStream.close();
            }
        } catch (IOException e) {
            throw new DataException("notClose");
        }
    }

    @Override
    public List<String> getBoardNames() throws DataException {
        return null;
    }
}