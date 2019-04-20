import processing.io.*;
import org.openkinect.processing.*;
import java.util.Arrays;

//https://processing.org/reference/libraries/io/SPI.html

private static final int OE = 3;
private static final int RCLK = 2;
private static byte TEST_BYTE[] = {85};

private static final int NUM_LEDS = 16;
private static byte[] SIGNAL;


private static final byte BITS[] = {1, 2, 4, 8, 16, 32, 64, -128};

Kinect kinect; 
SPI adc;

// Depth image
PImage depthImg;
 
// Threshold
int minDepth = 700;
int maxDepth = 900;

//Skip is how we adjust resolution. Higher skip is lower res;
int skip = 20;

//number of pixels for the kinect to read in
int width = 32;
int height = 24;

StateMachine[] stateMachineArray = new StateMachine[(width * height)];

// What is the kinect's angle
float angle;

void setup(){

  //have to use raw numbers for "size" for processing.
  //(Don't Change These. Locked by kinect and will make your life way harder if you change).
  size(640,480);
  //background(145, 170, 180);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  angle = kinect.getTilt();
  kinect.initDepth();
  Arrays.fill(stateMachineArray, new StateMachine());
  
  //depthImg = new PImage(1280, 720, ARGB);
  printArray(SPI.list());
  adc = new SPI(SPI.list()[0]);
  adc.settings(500000, SPI.MSBFIRST, SPI.MODE0);
  
  GPIO.pinMode(OE, GPIO.OUTPUT);
  GPIO.pinMode(RCLK, GPIO.OUTPUT);
  GPIO.digitalWrite(OE, GPIO.LOW);
  
  SIGNAL = new byte[(NUM_LEDS - 1) / 8 + 1];
}

void draw(){
  
  
  background(255);
  boolean[] states = new boolean[16];
  depthImg = kinect.getDepthImage();
  int[] depth = kinect.getRawDepth();
  image(depthImg, 0, 0);
  
  for (int x = 0; x<depthImg.width; x+= skip){
    
    for (int y = 0; y<depthImg.height; y+= skip){
      int index = x + y * depthImg.width;
      int depthVal = depth[index];
      
      //Index based on x val
      //i2c.beginTransmission(0x60);
      //index 0 is 0 if empty and 
      //byte[] bytes = new byte[2];
      //bytes[1] = byte(y/skip);
      if (depthVal > minDepth && depthVal < maxDepth) {
        if ((x / 20) < 16) {
          states[(x / 20)] = true;
        }
        fill(0);
        Transition t = stateMachineArray[x/skip*(height) + y/skip].determineTransition(State.A); 
        //bytes[0] = 0;
      } else {
        fill(255);
        Transition t = stateMachineArray[x/skip*(height) + y/skip].determineTransition(State.B); 
        //bytes[0] = 1;
      }
      
      rect(x,y,skip,skip);
      
    }
    }
    
    sendSignal(states, SIGNAL);
  }
 
  // Adjust the angle and the depth threshold min and max
  void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  }
}

void sendSignal(boolean[] states, byte[] signal) {
  int i = 0;
  int sig = -1;
  while (i < states.length) {
   
    if (i % 8 == 0) {
      sig++;
      signal[sig] = 0;
    }
    
    if (states[states.length - 1 - i]) { // The last state is sent first
      signal[sig] |= BITS[7 - (i % 8)]; // And we're MSB first 
    }
    
    i++;
  }
  
  print(signal[0] + " " + signal[1] + "\n");
  
  adc.transfer(signal);
  
  GPIO.digitalWrite(RCLK, GPIO.HIGH);
  delay(1);
  GPIO.digitalWrite(RCLK, GPIO.LOW);
}

void setBit(byte[] b, int bit_num) {
  b[0] |= BITS[bit_num];
}
