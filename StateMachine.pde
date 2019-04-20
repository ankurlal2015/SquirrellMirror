//import java.util.Calendar;

enum State { 
    A, B; 
} 

enum Transition { 
    AtoB, BtoA, Hold; 
} 

public class StateMachine {
  
  private State currentState;
  private long time;
  private boolean trying;
  //private Trying currentTransition;
  
  public StateMachine(){
    currentState = State.A;
  }
  
  public Transition determineTransition(State desiredState){
      if (currentState != desiredState){
        if(currentState == State.A){
          return Transition.AtoB;
        }else{
          return Transition.BtoA;
        }
      }else{
        return Transition.Hold;
      }
  }
  
  //public Transition2 determineTransition(State desiredState){
  //  if(trying){
  //    if(){
  //    }
  //  }
  //}
}
