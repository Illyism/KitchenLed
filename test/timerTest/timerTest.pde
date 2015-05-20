// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 10-5: Object-oriented timer

Timer timer;

void setup() {
  size(200,200);
  background(0);
  fill(255);
  
  timer = new Timer(TimerUtil.secondsFromMilli(10));
  timer.start();
}

void draw() {
  //println(timer.elapsedTime);
  //println(TimerUtil.milliTimeFmt(timer.elapsedTime) + "/" + TimerUtil.milliTimeFmt(timer.totalTime));
  
  clear();
  
  float curTime = map(timer.elapsedTime,0,timer.totalTime,0,height);
  rect(0,0,curTime,width);
  if (timer.isFinished()) {
    
    background(random(255));
    
  }
}

void mousePressed() {
  if(mouseButton == LEFT){
    println("Starting timer");
    timer.start();
  } else {
    println("Pausing timer");
    timer.pause();
  }
}
