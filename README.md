# KitchenLed

## Hardware

### LEDs

We are using a [WS2812 LED RGB Strip](https://www.sparkfun.com/products/12025) as our LED array. It's 1 meter long and has 60 leds. The [WS2812](http://i.il.ly/kitchenled/WS2812.pdf) is really simple to use, it has no clock pin like the WS2801 so it means it's more time-dependant but simpler.

Wire Color | Function | Notes
---------- | -------- | -----
Red        | Vcc      | WS2812 power supply. Should be a regulated supply between 5V and 7V.
Yellow     | GND      | Ground. 0V.
Green      | Data     | Serial data in or out. Look at arrows and labels on strip to check which it is.

You send 24 bits (8 red, 8 green, 8 blue) for one LED, then wait more than 50us and it will set the first LED to your color. You can control the whole strip at once as well by sending 24 bits for your amount of leds. So in our case with 60 LEDs it would count up to 1440 bits.

### Arduino

![](http://i.il.ly/kitchenled/arduino.jpg)

We're using an Arduino to control the LEDs. We've stripped out the JST and placed them in a breadboard and wired a VCC, GND and one datapin on pin **13**.

Next step is to setup the LED controller. Adafruit has a [Neopixel](https://github.com/adafruit/Adafruit_NeoPixel) library that makes this very simple. Just save the zip and import it in your Arduino library. We've built the controller with [modified code](https://github.com/Illyism/KitchenLed/blob/master/led/led.ino) from Tweaking4All to be able to control the LEDs from a COM port.

The arduino listens to a prefix `0x41, 0x64, 'N', 'M', 'C', 'T'` to go in LED writing mode. After that, it expects you to send bytes for each color for each LED. After all the bytes are received it goes back to waiting mode until it receives a prefix again.

PREFIX ➜ 1st LED Red ➜ 1st LED Green ➜ 1st LED Blue ➜ ... ➜ 60th LED Red ➜ 60th LED Green ➜ 60th LED Blue


### Processing

With the first hardware part completed, we can look over at sending data from a computer, raspberry pi or any other device to Arduino using the COM port.

The [proof of concept](https://github.com/Illyism/KitchenLed/blob/master/test/rainbow/rainbow.pde) starts with cycling the LEDs in rainbow mode.

1. Open the COM port
2. Write prefix
3. Go to the next hue in HSB
4. Set the GUI background
5. Convert to RGB and for each LED send the red byte
6. Send the green byte
7. Send the blue byte
