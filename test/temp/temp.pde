import processing.serial.*;

// The serial port:
Serial arduino;  

// prefix
byte[] prefix = new byte[] {0x41, 0x64, 'N', 'M', 'C', 'T'};
int LED_AMOUNT = 60;

float percentage = 0;
float temperature = 0;
color[] colarray = new color[60];
color[] color_step = new color[] {
  color(255,255,255),
  color(0,0,255),
  color(0,0,225),
  color(0,0,200),
  color(0,0,150),
  color(0,0,100),
  color(0,0,75),
  color(0,0,50),
  color(0,0,25),
  color(50,50,225),
  color(75,75,225),
  color(100,100,200),
  color(125,125,175),
  color(150,150,150),
  color(175,175,125),
  color(200,200,100),
  color(225,225,75),
  color(255,225,50),
  color(255,200,25),
  color(255,175,0),
  color(255,150,0),
  color(255,125,0),
  color(255,100,0),
  color(255,75,0),
  color(255,50,0),
  color(255,25,0),
  color(255,0,0),
  color(255,0,0),
  color(255,0,0),
  color(255,0,0)
};

void setup() {
  // List all the available serial ports:
  println(Serial.list());

  // Open the port you are using at the rate you want:
  arduino = new Serial(this, Serial.list()[0], 115200);
  fillArray();
}

int h;
void fillArray() {
  float colorPercentage = map(percentage, 0, 100, 0, color_step.length);
  println(colorPercentage);
  int colorIndex = int(colorPercentage);
  println(colorIndex);
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

  percentage = map(temperature, 0, 100, 0, 100);
  println(temperature);
  println(percentage);
  
  fillArray();
  arduino.write(prefix);
  background(colarray[0]);
  for (int j = 0; j < LED_AMOUNT; ++j) { // 60 Leds
    c = colarray[j];
    arduino.write(int(red(c)));
    arduino.write(int(green(c)));
    arduino.write(int(blue(c)));
  }


}
