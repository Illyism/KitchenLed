import controlP5.*;

ControlP5 cp5;
int myColor = color(0,0,0);

int targetTemp = 100;
int actualTemp = 100;
int sliderTicks1 = 100;
int sliderTicks2 = 30;

ControlTimer c;
Textlabel t;

Slider abc;

void setup() {
  size(700,400);
  noStroke();
  cp5 = new ControlP5(this);
  
  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("targetTemp")
     .setPosition(0,20)
     .setSize(60, height/2-20)
     .setRange(0,150)
     ;

  cp5.addSlider("actualTemp")
     .setPosition(0,20+height/2)
     .setSize(60, height/2-20)
     .setRange(0,150)
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
  cp5.getController("targetTemp").getCaptionLabel().hide();


  c = new ControlTimer();
  t = new Textlabel(cp5,"--",100,100);
  c.setSpeedOfTime(-1);
}

void draw() {
  background(0);

  fill(targetTemp);
  rect(0,20,width/2,height/2-20);
  fill(50);
  rect(0,height/2+20,width/2,height/2-20);
  
  t.setValue(c.toString());
  t.draw(this);
  t.setPosition(mouseX, mouseY);
}

void slider(float theColor) {
  myColor = color(theColor);
  println("a slider event. setting background to "+theColor);
}

void mousePressed() {
  c.reset();
}
