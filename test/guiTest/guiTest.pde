import controlP5.*;
import processing.serial.*;

// Gui
ControlP5 cp5;
int myColor = color(0,0,0);

int targetTemp = 30;
int actualTemp = 50;
int sliderTicks1 = 100;
int sliderTicks2 = 30;

int actualTime = 0;
int targetTime = 80;

ControlTimer controlTimer;
Textlabel textLabel;

Slider abc;


// Temperature
float temperature = 0;
int MAX_RANGE = 100;

// Arduino
Serial arduino;  
byte[] prefix = new byte[] {0x41, 0x64, 'N', 'M', 'C', 'T'};


// LED
color[] colarray = new color[60];
int LED_AMOUNT = 60;

color timeColor = color(50, 50, 50);
color target = color(0,0,255);
color white_space = color(0,0,0);
color indicator = color(255,0,0);


void setup() {
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
     .setPosition(0,20)
     .setSize(60, height/2-20)
     .setRange(0,MAX_RANGE)
     ;

  cp5.addSlider("actualTemp")
     .setPosition(0,20+height/2)
     .setSize(60, height/2-20)
     .setRange(0,MAX_RANGE)
     ;
     
  cp5.addSlider("time")
     .setPosition(width/2,20)
     .setSize(width/2, height-20)
     .setRange(0,MAX_RANGE)
     ;
  
  cp5.addTextlabel("labelActual")
                    .setText("Actual temperature")
                    .setPosition(0,height/2+5)
                    ;

  cp5.addTextlabel("labelTarget")
                    .setText("Target temperature")
                    .setPosition(0,5)
                    .setLock(true)
                    ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("targetTemp").getValueLabel().align(ControlP5.BOTTOM, ControlP5.RIGHT).setPaddingX(0);
  cp5.getController("actualTemp").getValueLabel().align(ControlP5.BOTTOM, ControlP5.RIGHT).setPaddingX(0);
  cp5.getController("targetTemp").getCaptionLabel().hide();


  controlTimer = new ControlTimer();
  textLabel = new Textlabel(cp5,"--",100,100);
  controlTimer.setSpeedOfTime(+1);
}

void setupArduino() {
  println(Serial.list());
  arduino = new Serial(this, Serial.list()[0], 115200);
}


void draw() {
  background(0);

  getTemperature();

  fill(targetTemp);
  rect(0,20,width/2,height/2-20);
  fill(actualTemp);
  rect(0,height/2+20,width/2,height/2-20);
  
  textLabel.setValue(controlTimer.toString());
  textLabel.draw(this);
  textLabel.setPosition(width/2, 5);

  if(actualTime <= 1) {
    actualTime = 1;
  } else {
    actualTime = (targetTime - controlTimer.minute() + (controlTimer.hour() * 60) );
  }

  fillArray();
  displayLeds();
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
}


void slider(float theColor) {
  myColor = color(theColor);
  println("a slider event. setting background to "+theColor);
}


void fillArray() {
  for (int i = 0; i < LED_AMOUNT; ++i) {
    colarray[i] = white_space;
  }
  
  float actualTimeLed = targetTime -  map(actualTime, 0, targetTime,0, LED_AMOUNT);
  float actualTempLed = map(actualTemp, 0, MAX_RANGE, 0, LED_AMOUNT);
  float targetTempLed = map(targetTemp, 0, MAX_RANGE, 0, LED_AMOUNT);

  actualTimeLed = min(actualTimeLed, LED_AMOUNT - 1);
  actualTimeLed = max(actualTimeLed, 0);
  
  println(actualTime);
  println(targetTime);
  
  actualTempLed = min(actualTempLed, LED_AMOUNT - 1);
  actualTempLed = max(actualTempLed, 0);

  targetTempLed = min(targetTempLed, LED_AMOUNT - 2);
  targetTempLed = max(targetTempLed, 1);

  for (int i = 0; i < int(actualTimeLed); ++i){
    colarray[i] = timeColor;
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
