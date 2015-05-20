// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 10-5: Object-oriented timer

class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  int elapsedTime;
  
  private int elapsedTimeInternal;
  private int totalTimeInternal;
  
  boolean paused = false;
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
    totalTimeInternal = tempTotalTime;
  }
  
  // Starting the timer
  void start() {
    if(paused == true){
      savedTime = millis();
      setTimerValues();
      paused = false;
    }
    else {
      savedTime = millis();
      elapsedTimeInternal = 0;
      totalTimeInternal = totalTime;
    }
  }
  
  void pause(){
    if(!paused){
     paused = true;
     totalTimeInternal = totalTime - elapsedTime;
    }
  }
  
  private void setTimerValues(){
    elapsedTime = totalTime - totalTimeInternal + elapsedTimeInternal;
    elapsedTimeInternal = millis() - savedTime;
  }
  
  boolean isFinished() { 
    // Check how much time has passed
    if(paused == false){
      
      setTimerValues();
      
      if (elapsedTimeInternal > totalTimeInternal) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
