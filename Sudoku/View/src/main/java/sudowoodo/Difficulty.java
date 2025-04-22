package sudowoodo;

public enum Difficulty {
    EASY(15, "EASY"),
    NORMAL(30, "NORMAL"),
    HARD(60, "HARD");

    private final int cellsToRemove;
    private final String key;

    Difficulty(int cellsToRemove, String key) {
        this.cellsToRemove = cellsToRemove;
        this.key = key;
    }

    public int getCellsToRemove() {
        return cellsToRemove;
    }

    public String getKey() {
        return key;
    }
}
