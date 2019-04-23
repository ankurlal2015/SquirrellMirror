
// This is for testing the 2x2 mirror

public class SmallSignalBuilder implements SignalBuilder {

    private final byte BITS[] = {1, 2, 4, 8, 16, 32, 64, -128};

    public SmallSignalBuilder() {}

    @Override
    public void makeSignal(States states, byte[] signal) {
        if(states.getOutput(0, 0)) {
            signal[0] |= BITS[7];
        }
        if(states.getOutput(0, 1)) {
            signal[0] |= BITS[6];
        }
        if(states.getOutput(1, 0)) {
            signal[0] |= BITS[5];
        }
        if(states.getOutput(1, 1)) {
            signal[0] |= BITS[4];
        }
    }
}
