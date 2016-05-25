import de.voidplus.leapmotion.*;


public class Avatar {
  PVector pos;//
  PVector dir;//used for directionality of the vector from thumb to forefinger
  PVector pinchVector; 
  PVector pinchHalf;//measured as midway between the thumb and for finger.  Used for the position of the grasping object
  PVector thumbPos;
  PVector indexPos;
  Tile activeTile;
  boolean pinching;
  boolean turnLeft;
  boolean turnRight;
  boolean resetTurn;
  
    LeapMotion leap;  
  Hand hand;  

  final static double LEFT_ANGLE = -40.*PI/180.;
  final static double RIGHT_ANGLE = 20.*PI/180.;
  
  public Avatar(PVector _pos, LeapMotion _leap) {
    this.pos  = _pos;
    this.leap = _leap;
    
    pinching = false;
    turnLeft = false;
    turnRight = false;
    resetTurn = true;
    pos = new PVector(100,100);
    dir = new PVector(100,100);
    thumbPos = new PVector(100,100);
    indexPos = new PVector(100,100);
    activeTile = new Tile();
  }

  public Avatar(Hand _hand) {
    this.hand = _hand;
    pinching = false;
  }

  public void update(Tile t) {
    if (t != null){
      activeTile = t;
    }
    //get position of the thumb and forefinger positions
    if (leap.getHands().size()>0) {
      hand = leap.getHands().get(0);
      Finger thumb = hand.getThumb();
      Finger index = hand.getIndexFinger();
      thumbPos = thumb.getPosition();
      indexPos = index.getPosition(); 
      //get a vector for the direction
      dir.set(indexPos.x, indexPos.y);
      dir.sub(thumbPos);
      //find the midpoint vector
      pinchHalf = new PVector(dir.x, dir.y);
      pinchHalf.div(2.);
      //the position that will be tracked is the position of the vector from the origin to the midpoint between thumb and index
      pos.set(thumbPos.x, thumbPos.y);
      pos.add(pinchHalf);
//      println(dir.mag()+" ", pinchHalf.mag());
      if (pinching = pinchHalf.mag() < 60) {
//        print("Pinching");
      }
      if (dir.heading()< LEFT_ANGLE && resetTurn){
         turnLeft = true;
         activeTile.rot.rotate(-PI/2.);
         resetTurn = false;
         print("rotateLeft "+dir.heading());
      } 
      else if (dir.heading() > RIGHT_ANGLE&& resetTurn){
        turnRight = true;
        activeTile.rot.rotate(PI/2.);
        resetTurn = false;
        
        print("rotateRight "+dir.heading());
      }
      else if ( (dir.heading()>LEFT_ANGLE)&&(dir.heading() < RIGHT_ANGLE)){
        resetTurn = true;
        turnRight = false;;
        turnLeft = false;
   //     print("resetTurn = "+ resetTurn + turnLeft+turnRight);
      }   
    }
  }

  public void setDir() {
  }

  public void drawA() {
    //fill(0);
    //if (over){
    //   fill(255,255,255,150); 
    //}
    if (pinching){
       tint(255,150,20,150); 
    }
    if (turnLeft){
       //fill(200, 0 , 0, 200); 
    }
    else if (turnRight){
       // fill(0, 200 , 0, 200);
    }
    fill(30,200,200,150);
    ellipse(pos.x, pos.y, 100, 100);
    //line(pos.x, pos.y, pos.x+dir.x, pos.y + dir.y);
    line(pos.x, pos.y, thumbPos.x, thumbPos.y);
    line(pos.x, pos.y, indexPos.x, indexPos.y);

  }
}

