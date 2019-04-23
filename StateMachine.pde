import java.lang.System.*;

public class StateMachine {

    private static final long FORWARD_TRANSITION_TIME_MS = 400;
    private static final long BACKWARD_TRANSITION_TIME_MS = 10;

    private boolean mRequiredOutput;
    private boolean mDesiredInput;
    private boolean mInTransition;

    private boolean mCurrentState;

    private long mLastTransitionStartTime;
    private long mRequiredTransitionTime;

    public StateMachine() {
        mCurrentState = false;
        mInTransition = false;
        mDesiredInput = false;
        mRequiredOutput = false;
    }

    public void updateStateMachine(boolean desiredStateInput) {
        mDesiredInput = desiredStateInput; // Set the desired state, but don't perform the update until as late until sending the signal as possible
    }

    private void performUpdate() {
        if (mInTransition) {
            continueTransition();
        } else if (mCurrentState != mDesiredInput) {
            startTransition(mDesiredInput ? FORWARD_TRANSITION_TIME_MS : BACKWARD_TRANSITION_TIME_MS);
        }
    }

    private void startTransition(long requiredTransitionTime) {
        mRequiredTransitionTime = requiredTransitionTime;
        mLastTransitionStartTime = System.currentTimeMillis();
        mRequiredOutput = true;
        mInTransition = true; // Set the flag that we're in transition
    }

    private void continueTransition() {
        long timeSinceStartOfTransition = System.currentTimeMillis() - mLastTransitionStartTime;
        if (timeSinceStartOfTransition >= mRequiredTransitionTime) {
            mInTransition = false; // End the transition
            mRequiredOutput = false; // No longer need to be pulsing high
            mCurrentState = !mCurrentState; // We've finished the transition, so we should be in the opposite state now. Not necessarily desired state.
        }
    }

    public boolean getRequiredOutput() {
        performUpdate();
        return mRequiredOutput;
    }
}
