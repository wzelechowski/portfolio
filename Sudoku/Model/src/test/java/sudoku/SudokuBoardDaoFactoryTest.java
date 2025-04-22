package sudoku;

import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

public class SudokuBoardDaoFactoryTest {
    @Test
    public void getFileDaoTest() {
        String fileName = "exampleFile";
        Dao<SudokuBoard> dao = SudokuBoardDaoFactory.getFileDao(fileName);
        assertNotNull(dao);
    }

    @Test
    public void getJdbcDaoTest() {
        Connection connection = null;
        try {
            String jdbcURL = "jdbc:h2:mem:sudokuDatabase";
            connection = DriverManager.getConnection(jdbcURL);
            Dao<SudokuBoard> dao = SudokuBoardDaoFactory.getJdbcDao(connection);
            assertNotNull(dao);
            assertTrue(dao instanceof JdbcSudokuBoardDao);

        } catch (SQLException e) {
            e.printStackTrace();
            fail("Błąd tworzenia połączenia z bazą danych");
        } finally {
            try {
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}