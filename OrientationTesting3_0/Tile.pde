import java.util.ArrayList;

public class Tile {

  //tiles have
  //static ArrayList <Tile> set1;
  //shared randomized image array which is used to determine proper pos and rot it should have
  //have an image which is selected based on 
  PImage img;     
  //position & rotation
  PVector pos;
  PVector rot;
  //selected boolean state where it moves until not selected
  boolean held;
  //over boolean state where we highlight the tile
  boolean over;
  // set boolean state when the tile is in the proper location
  boolean set;
  int siz = 5;
  int id = -99;
  int overOffset = 8;  

  public Tile () {
    img = loadImage("tile_null.png");
    pos = new PVector();
    rot = new PVector(1, 0);
    siz = img.width;
    id = -99;
  }


  public Tile (int i) {
    img = loadImage("tile"+i+".png");
    pos = new PVector(i%3*img.width, i/3*img.width);
    rot = new PVector(1, 0);
    siz = img.width ;
    id = i;
  }

  public Tile (Tile t) {
    img = t.img;     
    //current position & rotation
    pos = new PVector (t.pos.x, t.pos.y);
    rot = new PVector (t.rot.x, t.rot.y);
    //selected boolean state where it moves until not selected
    held = t.held;
    //over boolean state where we highlight the tile
    over = t.over;
    // set boolean state when the tile is in the proper location
    set = t.set;
    siz = img.width;
    id = t.id; 
  }

  // tiles do 
  //not used
  boolean mouseOver (PVector m ) {
    if (abs(m.x - pos.x) < siz/2 && abs(m.y - pos.y) < siz/2) {
      return true;
    }
    return false;
  }

  void update(PVector m) {
    //over = (abs(m.x - pos.x) < siz/2 && abs(m.y - pos.y) < siz/2);
    //become transparent when being held and moved
    //get a clear outline when hovered over
    if (over) {
      //     if (mousePressed&&mouseButton == left){
      //      held=;
      //    }
      //fill(255,255,0,65);
      strokeWeight(overOffset);
      stroke(255, 255, 20, 200);
      rect(pos.x, pos.y, siz+2*overOffset, siz+2*overOffset);
      //  img.resize(siz+overOffset,0);
    } else {
      //  img.resize(siz,0);
    }
    //can be selected by the left mouse button

    //OR can be rotated using the right mouse button 
    //OR can be rotated by the mouse scroll wheel
  }

  //draw themselves
  void _draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rot.heading());
    //fill(255);
    if (set) {
      tint(50, 50, 50, 250);
      //fill(0,255,0);
    }
    else if (held){
      tint(250, 250, 250, 70);
      noFill();    
    } else {
      tint(255, 255, 225, 255);
     // fill(255,0,0);
      rect(0,0, img.width,img.height);
    }
    image(img, 0, 0, img.width-5, img.height - 5);
    popMatrix();
  }
}

