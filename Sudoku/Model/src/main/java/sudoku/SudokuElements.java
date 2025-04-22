package sudoku;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;

import java.util.ArrayList;
import java.util.List;

public abstract class SudokuElements implements Cloneable {
    private List<SudokuField> fields;

    public SudokuElements(List<SudokuField> fields) {
        this.fields = fields;
    }

    public boolean verify() {
        for (int i = 0; i < 9; i++) {
            for (int j = i + 1; j < 9; j++) {
                if (fields.get(i).getFieldValue() == fields.get(j).getFieldValue()) {
                    return false;
                }
            }
        }
        return true;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this)
                .append("fields", fields)
                .toString();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        SudokuElements elements = (SudokuElements) o;
        return new EqualsBuilder().append(fields, elements.fields).isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37).append(fields).toHashCode();
    }

    @Override
    public SudokuElements clone() {
        try {
            SudokuElements clone = (SudokuElements) super.clone();
            clone.fields = new ArrayList<>();
            for (SudokuField field : fields) {
                clone.fields.add(field.clone());
            }
            return clone;
        } catch (CloneNotSupportedException e) {
            throw new RunException("notClone");
        }
    }
}
