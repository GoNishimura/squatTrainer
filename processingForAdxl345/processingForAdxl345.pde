import processing.serial.*;
import processing.sound.*;

Serial myPort;
SoundFile pfpf, waa;
float[] pitch = new float[2];
boolean done = false;

void setup() {
  size(1200, 650);
  background(255);
  pfpf = new SoundFile(this, "pfpf.wav");
  waa = new SoundFile(this, "waa.wav");
  myPort = new Serial(this, "/dev/cu.wchusbserial1410", 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  noStroke();
  if (pitch[0] != 0) {
    background(0);
    fill(255);
    if (pitch[0] < -40 + pitch[1]/2) {
      text("Watch out! You gonna turn over!", 15, 45);
    }
    if (pitch[0] > -30) {
      text("You're bending your back too much!", 15, 85);
    }
    if (pitch[1] > -20) {
      text("You're bending legs too much!", 15, 125);
    }
    if (millis() > 10000 && pitch[0] < -65 && pitch[1] < -65) {
      text("Yeay! It was a successful squat!", 15, 155);
      if (!done) {
        pfpf.play();
        waa.play();
        done = true;
      }
    }
    
    // draw x and y axis
    stroke(255);
    line(-width, height / 2, width, height / 2);
    line(width / 2, -height, width / 2, height);
    
    // draw lines according to the pitch
    pushMatrix();
    stroke(0, 255, 0);
    translate(width/2, height/2);
    arc(0, 0, 50, 50, 0, -radians(pitch[0]));
    arc(0, 0, 50, 50, -radians(pitch[0]), 0);
    rotate(-radians(pitch[0]));
    line(-width, 0, width, 0);
    popMatrix();

    pushMatrix();
    stroke(255, 0, 0);
    translate(width/2, height/2);
    arc(0, 0, 50, 50, PI, PI + radians(pitch[1]));
    arc(0, 0, 50, 50, PI + radians(pitch[1]), PI);
    rotate(radians(pitch[1]));
    line(-width, 0, width, 0);
    popMatrix();

    textSize(32);
    text("Pitch", width/2 - 320, height/2 + 80);
    text("Leg:", width/2 - 180, height/2 + 80);
    text(str(pitch[1]), width/2 - 100, height/2 + 80);
    text("Back:", width/2 + 40, height/2 + 80);
    text(str(pitch[0]), width/2 + 140, height/2 + 80);
    text("Turn over angle:", width/2 - 320, height/2 + 160);
    text(str(-40 + pitch[1]/2), width/2 - 40, height/2 + 160);
  }
}

void serialEvent (Serial fd) 
{
  // get the ASCII string:
  String rpstr = fd.readStringUntil('\n');
  if (rpstr != null) {
    String[] list = split(rpstr, ':');
    pitch[0] = (float(list[0])/100);
    pitch[1] = (float(list[1])/100);
  }
}
