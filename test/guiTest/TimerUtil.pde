  static class TimerUtil {
    
    private static int secondsFromMilli(int seconds){
      return seconds * 1000;
    }
    
    public static int minutesFromMilli(int minutes){
      return secondsFromMilli(minutes) * 60;
    }
    
    public static String milliTimeFmt(int time){
      int hours   = ((time / 1000) / 60 / 60 ) % 60;
      int minutes = ((time / 1000) / 60      ) % 60;
      int seconds = ((time / 1000)           ) % 60;
      
      return str(hours) + ":" + str(minutes) + ":" + str(seconds);
    }
    
  }
