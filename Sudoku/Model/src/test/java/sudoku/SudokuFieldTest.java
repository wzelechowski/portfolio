package sudoku;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class SudokuFieldTest {
    @Test
    public void getAndSetFieldValueTest() {
        SudokuField field = new SudokuField();
        assertEquals(field.getFieldValue(), 0);
        field.setFieldValue(1);
        assertEquals(field.getFieldValue(), 1);
    }
    @Test
    public void setTooLowFieldValueTest() {
        SudokuField field = new SudokuField();
        assertThrows(ArgumentException.class, () -> field.setFieldValue(-1));
    }
    @Test
    public void setTooHighFieldValueTest() {
        SudokuField field = new SudokuField();
        assertThrows(ArgumentException.class, () -> field.setFieldValue(10));
    }
    @Test
    public void toStringTest() {
        SudokuField field = new SudokuField();
        assertNotNull(field.toString());
    }
    @Test
    public void equalsDefaultTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        assertTrue(field.equals(field2) && field2.equals(field));
    }
    @Test
    public void equalsSelfTest() {
        SudokuField field = new SudokuField();
        assertTrue(field.equals(field));
    }
    @Test
    public void equalsNullAndDifferentClassTest() {
        SudokuField field = new SudokuField();
        SudokuSolver solver = new BacktrackingSudokuSolver();
        assertFalse(field.equals(null));
        assertFalse(field.equals(solver));
    }
    @Test
    public void hashCodeTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        assertEquals(field.hashCode(), field2.hashCode());
    }
    @Test
    public void differentHashCodeTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        field2.setFieldValue(5);
        assertNotEquals(field.hashCode(), field2.hashCode());
    }
    @Test
    public void equalsAndHashCodeConsistentTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        assertTrue(field.equals(field2) && field2.equals(field));
        assertEquals(field.hashCode(), field2.hashCode());
        field2.setFieldValue(5);
        assertFalse(field.equals(field2) && field2.equals(field));
        assertNotEquals(field.hashCode(), field2.hashCode());
    }
    @Test
    public void compareToTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        field.setFieldValue(3);
        field2.setFieldValue(5);
        assertTrue(field2.compareTo(field) > 0);
        assertTrue(field.compareTo(field2) < 0);
        assertThrows(NullException.class, () -> field.compareTo(null));
        field2.setFieldValue(3);
        assertTrue(field2.compareTo(field) == 0);
    }
}