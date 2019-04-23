import processing.io.*;
import org.openkinect.processing.*;
import java.util.Arrays;

//https://processing.org/reference/libraries/io/SPI.html

Kinect kinect; 

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


// What is the kinect's angle
float angle;


States states;
Transmitter output;
Transmitter.SignalBuilder signalBuilder;

void setup(){

  //have to use raw numbers for "size" for processing.
  //(Don't Change These. Locked by kinect and will make your life way harder if you change).
  size(640,480);
  //background(145, 170, 180);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  angle = kinect.getTilt();
  kinect.initDepth();

  signalBuilder = new SmallSignalBuilder();
  states = new States(2, 2);
  output = new Transmitter(3, 2, 4, signalBuilder);
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
        states.updateStateMachine(true);
        //bytes[0] = 0;
      } else {
        fill(255);
        states.updateStateMachine(false);
        //bytes[0] = 1;
      }
      
      rect(x,y,skip,skip);
      
    }
    }
    
    transmitter.sendStates(states);
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
