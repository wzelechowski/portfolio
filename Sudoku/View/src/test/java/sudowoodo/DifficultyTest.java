package sudowoodo;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class DifficultyTest {

    @Test
    public void testEasyDifficulty() {
        Difficulty easy = Difficulty.EASY;
        assertEquals(15, easy.getCellsToRemove());
    }

    @Test
    public void testNormalDifficulty() {
        Difficulty normal = Difficulty.NORMAL;
        assertEquals(30, normal.getCellsToRemove());
    }

    @Test
    public void testHardDifficulty() {
        Difficulty hard = Difficulty.HARD;
        assertEquals(60, hard.getCellsToRemove());
    }
}
