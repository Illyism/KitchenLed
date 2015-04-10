import processing.serial.*;

// The serial port:
Serial arduino;  

// prefix
byte[] prefix = new byte[] {0x41, 0x64, 'N', 'M', 'C', 'T'};
color[] colarray = new color[255];

void setup() {
  // List all the available serial ports:
  println(Serial.list());

  // Open the port you are using at the rate you want:
  arduino = new Serial(this, Serial.list()[0], 38400);
  
  colorMode(HSB);
  fillArray();
}


int h;
void fillArray() {
  color current;
  for (int i = 0; i < 255; ++i) {
    if (h >= 255)  h=0;  else  h++;
    current = color(h, 255, 255);
    colarray[i] = current;
  }
}

void shiftArray() {
  for (int i = 0; i < 255; ++i) {
    if (i + 1 >= 255) {
      colarray[i] = colarray[0];
    } else {
      colarray[i] = colarray[i+1];
    }
  }
}

color c;
void draw() {
  arduino.write(prefix);
  background(colarray[0]);
  for (int j = 0; j < 60; ++j) { // 60 Leds
    c = colarray[j];
    arduino.write(int(red(c)));
    arduino.write(int(green(c)));
    arduino.write(int(blue(c)));
  }

  shiftArray();
  while (arduino.available() > 0) {
    String inBuffer = arduino.readString();   
    if (inBuffer != null) {
      println(inBuffer);
    }
  }
}