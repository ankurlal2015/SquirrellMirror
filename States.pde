
// Wrapper around all of the state machines

public class States {

    private final int mRows;
    private final int mCols;
    private final StateMachine[][] mStateMachines;

    public States(int rows, int cols) {
        mRows = rows;
        mCols = cols;
        mStateMachines = new StateMachine[rows][];
        for (int i = 0; i < rows; i++) {
            mStateMachines[i] = new StateMachine[cols];
            for (int s = 0; s < cols; s++) {
               mStateMachines[i][s] = new StateMachine(); 
            }
        }
    }

    public void updateStateMachine(int x, int y, boolean desiredState) {
        mStateMachines[y][x].updateStateMachine(desiredState);
    }

    public int getNumRows() {
        return mRows;
    }

    public int getNumCols() {
        return mCols;
    }

    public boolean getOutput(int x, int y) {
        return mStateMachines[y][x].getRequiredOutput();
    }
}
