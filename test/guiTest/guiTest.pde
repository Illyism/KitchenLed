import controlP5.*;
import processing.serial.*;

// Gui
ControlP5 cp5;
int myColor = color(0,0,0);
ArrayList<Points> temperatureGraph = new ArrayList();
ArrayList<Points> temperatureGraphTarget = new ArrayList();
int targetTemp = 30;
int actualTemp = 50;
int sliderTicks1 = 100;
int sliderTicks2 = 30;

int actualTime = 0;
int targetTime = 60;
boolean overTime = false;

ControlTimer controlTimer;
Textlabel textLabel;
Knob knob;

Slider abc;


// Temperature
float temperature = 0;
int MAX_RANGE = 100;

int speedOfTime = 0;

// Arduino
Serial arduino;  
byte[] prefix = new byte[] {0x41, 0x64, 'N', 'M', 'C', 'T'};


// LED
color[] colarray = new color[60];
int LED_AMOUNT = 60;

color timeColor = color(255, 255, 255);
color target = color(0,0,255);
color white_space = color(0,0,0);
color indicator = color(255,0,0);


void setup() {
  smooth();
  size(700,400);
  noStroke();
  setupCP5();
  setupArduino();
}

void setupCP5() {
  cp5 = new ControlP5(this);
  
  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("targetTemp")
     .setPosition(width/2-60,20)
     .setSize(60, height-20)
     .setRange(0,MAX_RANGE)
     ;

  cp5.addSlider("actualTemp")
     .setPosition(0,20)
     .setSize(60, height-20)
     .setRange(0,MAX_RANGE)
     ;
    
  cp5.addButton("Stop and set")
     .setValue(0)
     .setPosition(width/2+2,2)
     .setSize(width/4-2,16)
     ;
     
  cp5.addButton("Play")
     .setValue(0)
     .setPosition(width/2+2+width/4,2)
     .setSize(width/4-2,16)
     ;

  cp5.addTextlabel("labelActual")
                    .setText("Actual temperature")
                    .setPosition(0,5)
                    ;

  cp5.addTextlabel("labelTarget")
                    .setText("Target temperature")
                    .setPosition(width/2-90,5)
                    .setLock(true)
                    ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("targetTemp").getValueLabel().align(ControlP5.BOTTOM, ControlP5.RIGHT).setPaddingX(0);
  cp5.getController("actualTemp").getValueLabel().align(ControlP5.BOTTOM, ControlP5.RIGHT).setPaddingX(0);
  cp5.getController("Stop and set").getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0);
  cp5.getController("Play").getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0);
  cp5.getController("targetTemp").getCaptionLabel().hide();

  knob = cp5.addKnob("knob1")
                 .setRange(0,targetTime)
                 .setValue(0)
                 .setPosition(width/2+width/5 - 75,height/2 - 75)
                 .setRadius(100)
                 .setNumberOfTickMarks(10)
                 .setTickMarkLength(4)
                 .snapToTickMarks(false)
                 .setColorForeground(color(255))
                 .setDragDirection(Knob.HORIZONTAL);

  controlTimer = new ControlTimer();
  textLabel = new Textlabel(cp5,"--", width/2 + width/5, height/2);
  controlTimer.setSpeedOfTime(0);
}

void setupArduino() {
  println(Serial.list());
  arduino = new Serial(this, Serial.list()[0], 115200);
}

public void Play(int theValue) {
  if(speedOfTime == 0){
    speedOfTime = 1;
    controlTimer.setSpeedOfTime(1);
  } else {
    speedOfTime = 0;
    controlTimer.setSpeedOfTime(0);
  }
}

void draw() {
  background(0);


  getTemperature();

  fill(targetTemp,0,0);
  rect(0,20,width/2,height/2-10);
  fill(actualTemp,0,0);
  rect(0,height/2+10,width/2,height/2-10);
  
  textLabel.setValue(controlTimer.toString());
  textLabel.draw(this);

  actualTime = controlTimer.second() + controlTimer.minute() * 60;
  if (actualTime > targetTime) overTime = true;
  knob.setValue(actualTime);
  knob.setValueLabel(controlTimer.toString());

  fillArray();
  displayLeds();
  
  drawTemperatureGraph(temperatureGraphTarget,2,200);
  drawTemperatureGraph(temperatureGraph, 1,255);
  
  setTemperatureGraph(temperatureGraph, actualTemp);
  setTemperatureGraph(temperatureGraphTarget, targetTemp);  
}

void drawTemperatureGraph(ArrayList<Points> points, int strokeWeight, int strokeColor){
  noFill();
  stroke(strokeColor);
  strokeWeight(strokeWeight);
  beginShape();
  for (int i=0;i<points.size();i++) {
    Points P = (Points)points.get(i);
    vertex(P.x, P.y);
    if (P.x<60)points.remove(i);
    if(frameCount % 10 == 0){
      P.x--;
    }
  }
  endShape();
  noFill();
  stroke(0);
}

void setTemperatureGraph(ArrayList<Points> points, int value) {
  //0,height/2+20,width/2,height/2-20
  //actualTemp
  float t = map(value,0,100,0,height-20);
  Points P = new Points(width/2-60, height-t);
  points.add(P);
}

class Points {
  float x, y;
  Points(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

void getTemperature() {
  while (arduino.available() > 0) {
    String inBuffer = arduino.readString();   
    if (inBuffer != null) {
      try {
        temperature = Float.parseFloat(inBuffer);
      } catch (Exception e) {
        println(inBuffer);
      } finally {
      }
    }
  }
  actualTemp = (int) temperature;
  cp5.getController("actualTemp").setValue(actualTemp);
  //cp5.getController("time").setValue(actualTime);
}


void slider(float theColor) {
  myColor = color(theColor);
  println("a slider event. setting background to "+theColor);
}

void fillArray() {
  for (int i = 0; i < LED_AMOUNT; ++i) {
    colarray[i] = white_space;
  }
  

  float actualTimeLed = map(actualTime, 0, targetTime, 0, LED_AMOUNT);
  float actualTempLed = map(actualTemp, 0, MAX_RANGE, 0, LED_AMOUNT);
  float targetTempLed = map(targetTemp, 0, MAX_RANGE, 0, LED_AMOUNT);

  actualTimeLed = min(actualTimeLed, LED_AMOUNT - 1);
  actualTimeLed = max(actualTimeLed, 0);
    
  actualTempLed = min(actualTempLed, LED_AMOUNT - 1);
  actualTempLed = max(actualTempLed, 0);

  targetTempLed = min(targetTempLed, LED_AMOUNT - 2);
  targetTempLed = max(targetTempLed, 1);

  if (overTime == false) {
    for (int i = 0; i < int(actualTimeLed); ++i){
      colarray[i] = timeColor;
    }
  } else {
    color c = timeColor;
    if (actualTime % 2 == 0) {
      c = white_space;
    }
    for (int i = 0; i < LED_AMOUNT; ++i) {
      colarray[i] = c;
    }
  }

  colarray[int(targetTempLed)] = target;
  colarray[int(targetTempLed) - 1] = target;
  colarray[int(targetTempLed) + 1] = target;

  colarray[int(actualTempLed)] = indicator;
}

void displayLeds() {
  arduino.write(prefix);
  for (int i = 0; i < LED_AMOUNT; ++i) { // 60 Leds
    color col = colarray[i];
    arduino.write(int(red(col)));
    arduino.write(int(green(col)));
    arduino.write(int(blue(col)));
  }
}
