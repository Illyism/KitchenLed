import processing.serial.*;

Serial arduino;  
byte[] prefix = new byte[] {0x41, 0x64, 'N', 'M', 'C', 'T'};

int percentage = 0;

int savedTime;
int totalTime = 5000;

color[] colarray = new color[60];
color[] color_step = new color[] {
  color(0,0,0),   // 0%
  color(50,0,0),  // 10%
  color(100,0,0),
  color(150,0,0),
  color(255,0,0),
  color(200,50,0),
  color(100,100,0),
  color(50,150,0),
  color(0,200,0),
  color(0,255,0)  // 100%
};

void setup() {
  println(Serial.list());
  arduino = new Serial(this, Serial.list()[0], 38400);
  fillArray();
  savedTime = millis();
}


int h;
void fillArray() {
  int index = percentage/11; // maximum value
  
  for (int i = 0; i < 60; ++i) {
    colarray[i] = color_step[index];
  }
}

color c;
void draw() {
  int passedTime = millis() - savedTime;
  percentage = int(passedTime * 0.02);
  if (percentage >= 100) {
    exit();
  }
  println(percentage + "%");
  fillArray();

  arduino.write(prefix);
  background(colarray[0]);
  for (int j = 0; j < 60; ++j) { // 60 Leds
    c = colarray[j];
    arduino.write(int(red(c)));
    arduino.write(int(green(c)));
    arduino.write(int(blue(c)));
  }
}