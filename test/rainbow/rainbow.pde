import processing.serial.*;

// The serial port:
Serial arduino;  

// prefix
byte[] prefix = new byte[] {0x41, 0x64, 'N', 'M', 'C', 'T'};

void setup() {
  // List all the available serial ports:
  println(Serial.list());

  // Open the port you are using at the rate you want:
  arduino = new Serial(this, Serial.list()[0], 38400);
  
  colorMode(HSB);
}


color c;
int h;
void draw() {
  arduino.write(prefix);
  if (h >= 255)  h=0;  else  h++;

  c = color(h, 255, 255);
  background(c);

  for (int j = 0; j < 60; ++j) { // 60 Leds
    arduino.write(int(red(c)));
    arduino.write(int(green(c)));
    arduino.write(int(blue(c)));
  }
}