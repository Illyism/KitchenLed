import processing.serial.*;

Serial arduino;  
byte[] prefix = new byte[] {0x41, 0x64, 'N', 'M', 'C', 'T'};

float percentage = 0;

int savedTime;
int totalTime = 30000;

int LED_AMOUNT = 60;

color[] colarray = new color[60];
color[] color_step = new color[] {
  color(0,0,0),
  color(25,0,0),
  color(50,0,0),
  color(75,0,0),
  color(100,0,0),
  color(125,0,0),
  color(150,0,0),
  color(175,0,0),
  color(200,0,0),
  color(225,0,0),
  color(255,0,0),
  color(255,25,0),
  color(255,50,0),
  color(255,75,0),
  color(255,100,0),
  color(255,125,0),
  color(255,150,0),
  color(255,175,0),
  color(255,200,0),
  color(255,225,0),
  color(255,255,0),
  color(255,255,0),
  color(225,255,0),
  color(200,255,0),
  color(175,255,0),
  color(150,255,0),
  color(125,255,0),
  color(100,255,0),
  color(75,255,0),
  color(50,255,0),
  color(25,255,0),
  color(0,255,0),
  color(255,255,255)
};

void setup() {
  println(Serial.list());
  arduino = new Serial(this, Serial.list()[0], 38400);
  fillArray();
  savedTime = millis();
}


int h;
void fillArray() {
  float colorPercentage = map(percentage, 0, 100, 0, color_step.length);
  int colorIndex = int(colorPercentage);
  int ledsCount = int(map(colorPercentage - colorIndex, 0, 1, 0, 60));
  for (int i = 0; i < ledsCount; ++i) {
    if (colorIndex < (color_step.length - 1)) {
      colarray[i] = color_step[colorIndex+1];
    } else {
      colarray[i] = color_step[colorIndex];
    }
  }
  for (int i = ledsCount; i < LED_AMOUNT; ++i) {
    colarray[i] = color_step[colorIndex]; 
  }
}

color c;
void draw() {
  int passedTime = millis() - savedTime;
  percentage = (float)passedTime / (float)totalTime * 100;
  if (percentage >= 100) {
    exit();
    return;
  }
  fillArray();

  arduino.write(prefix);
  background(colarray[0]);
  for (int j = 0; j < LED_AMOUNT; ++j) {
    c = colarray[j];
    arduino.write(int(red(c)));
    arduino.write(int(green(c)));
    arduino.write(int(blue(c)));
  }
}