package sudoku;

import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class SudokuElementsTest {

    @Test
    public void verifyValidTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuBox box = new SudokuBox(fields);
        assertTrue(row.verify() && column.verify() && box.verify());
    }
    @Test
    public void verifyInvalidTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 8; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        fields.set(8, new SudokuField());
        fields.get(8).setFieldValue(1);
        SudokuRow row = new SudokuRow(fields);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuBox box = new SudokuBox(fields);
        assertFalse(row.verify() && column.verify() && box.verify());
    }
    @Test
    public void fieldsUnmodifiableListTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        assertThrows(UnsupportedOperationException.class, () -> fields.add(new SudokuField()));
    }
    @Test
    public void toStringTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuBox box = new SudokuBox(fields);
        assertNotNull(row.toString());
        assertNotNull(column.toString());
        assertNotNull(box.toString());
    }
    @Test
    public void equalsDefaultTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuRow row2 = new SudokuRow(fields);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuColumn column2 = new SudokuColumn(fields);
        SudokuBox box = new SudokuBox(fields);
        SudokuBox box2 = new SudokuBox(fields);
        assertTrue(row.equals(row2) && row2.equals(row) && column.equals(column2)
                && column2.equals(column) && box.equals(box2) && box2.equals(box));
    }
    @Test
    public void equalsSelfTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuBox box = new SudokuBox(fields);
        assertTrue(row.equals(row) && column.equals(column) && box.equals(box));
    }
    @Test
    public void equalsNullAndDifferentClassTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuBox box = new SudokuBox(fields);
        assertFalse(row.equals(null) && column.equals(null) && box.equals(null));
        assertFalse(row.equals(fields) && column.equals(fields) && box.equals(fields));
    }
    @Test
    public void hashCodeTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuRow row2 = new SudokuRow(fields);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuColumn column2 = new SudokuColumn(fields);
        SudokuBox box = new SudokuBox(fields);
        SudokuBox box2 = new SudokuBox(fields);
        assertEquals(row.hashCode(), row2.hashCode());
        assertEquals(column.hashCode(), column2.hashCode());
        assertEquals(box.hashCode(), box2.hashCode());
    }
    @Test
    public void differentHashCodeTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        List<SudokuField> fields2 = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 8; i > 0; i--) {
            for (int j = 1; j < 10; j++) {
                fields2.set(i, new SudokuField());
                fields2.get(i).setFieldValue(j);
            }
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuRow row2 = new SudokuRow(fields2);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuColumn column2 = new SudokuColumn(fields2);
        SudokuBox box = new SudokuBox(fields);
        SudokuBox box2 = new SudokuBox(fields2);
        assertNotEquals(row.hashCode(), row2.hashCode());
        assertNotEquals(column.hashCode(), column2.hashCode());
        assertNotEquals(box.hashCode(), box2.hashCode());
    }
    @Test
    public void equalsAndHashCodeConsistentTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        List<SudokuField> fields2 = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields2.set(i, new SudokuField());
            fields2.get(i).setFieldValue(i + 1);
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuRow row2 = new SudokuRow(fields2);
        SudokuColumn column = new SudokuColumn(fields);
        SudokuColumn column2 = new SudokuColumn(fields2);
        SudokuBox box = new SudokuBox(fields);
        SudokuBox box2 = new SudokuBox(fields2);
        assertTrue(row.equals(row2) && row2.equals(row) && column.equals(column2)
                && column2.equals(column) && box.equals(box2) && box2.equals(box));
        assertEquals(row.hashCode(), row2.hashCode());
        assertEquals(column.hashCode(), column2.hashCode());
        assertEquals(box.hashCode(), box2.hashCode());
        fields2.get(0).setFieldValue(0);
        assertFalse(row.equals(row2) && row2.equals(row) && column.equals(column2)
                && column2.equals(column) && box.equals(box2) && box2.equals(box));
        assertNotEquals(row.hashCode(), row2.hashCode());
        assertNotEquals(column.hashCode(), column2.hashCode());
        assertNotEquals(box.hashCode(), box2.hashCode());
    }
    @Test
    public void cloneElementsTest() {
        List<SudokuField> fields = Arrays.asList(new SudokuField[SudokuBoard.SIZE]);
        for (int i = 0; i < 9; i++) {
            fields.set(i, new SudokuField());
            fields.get(i).setFieldValue(i + 1);
        }
        SudokuRow row = new SudokuRow(fields);
        SudokuRow clonedRow = (SudokuRow) row.clone();
        assertEquals(row, clonedRow);
        fields.get(0).setFieldValue(2);
        assertNotEquals(row, clonedRow);
    }
}
