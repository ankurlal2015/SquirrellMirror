import processing.io.*;


public class Transmitter {

    private final int mOe;
    private final int mRclk;
    private final SPI mSpi;
    private final SignalBuilder mSignalBuilder;
    private final byte[] mSignal;

    public Transmitter(int oe, int rclk, int numPanels, SignalBuilder builder) {
        mOe = oe;
        mRclk = rclk;
        mSpi = new SPI(SPI.list()[0]);
        mSignalBuilder = builder;
        int numBytes = ((numPanels - 1) / 8) + 1;
        mSignal = new byte[numBytes];
        init();
    }

    private void init() {
        mSpi.settings(500000, SPI.MSBFIRST, SPI.MODE0);
        GPIO.pinMode(mOe, GPIO.OUTPUT);
        GPIO.pinMode(mRclk, GPIO.OUTPUT);
        GPIO.digitalWrite(mOe, GPIO.LOW); // Always have output
        GPIO.digitalWrite(mRclk, GPIO.LOW); // Start low
    }

    public void sendStates(States states) {
        // Set bits appropritely using a signal builder
        mSignalBuilder.makeSignal(states, mSignal);

        // Send out the bytes
        mSpi.transfer(mSignal);

        // Pulse Rclk to move value from shift register to output register
        GPIO.digitalWrite(mRclk, GPIO.HIGH);
        delay(1);
        GPIO.digitalWrite(mRclk, GPIO.LOW);
    }
}

public interface SignalBuilder {
    void makeSignal(States states, byte[] signal);
}
