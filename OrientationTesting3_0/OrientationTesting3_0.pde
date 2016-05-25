import java.util.ArrayList;
import de.voidplus.leapmotion.*;

final static int NUMBER_OF_TILES = 9;
LeapMotion leap;
ArrayList <Tile> MASTER = new ArrayList<Tile>();
ArrayList <PVector> MASTER_POS = new ArrayList<PVector>();

public ArrayList <Tile> answerList = new ArrayList <Tile>();
public ArrayList <Tile> problemList = new ArrayList <Tile>();

public StopWatch timer = new StopWatch();
public Avatar avatar;
public PVector mouse;
public PVector mouseDir;

public boolean selected;
public boolean wrong;
public Tile activeTile;

public int numberSet;

void setup() {
  size(1000, 600);
  leap = new LeapMotion(this);
  mouse = new PVector();
  mouseDir =new PVector();
  avatar = new Avatar(mouse, leap);
  imageMode(CENTER);
  rectMode(CENTER);
  reset();  
  noFill();
  noCursor();
  textSize(30);
}

void reset() {
  //loading an tile image just to get the dimensions of it directly
  PImage img = loadImage("tile8.png");
  int img_w = img.width;//tile image width 
  MASTER.clear();
  problemList.clear();
  answerList.clear();
  activeTile = null;
  for (int i = 0; i < NUMBER_OF_TILES; i++) {
    MASTER.add(new Tile(i));    
    MASTER_POS.add(new PVector(i%3*img_w+img_w/2+5, i/3*img_w+img_w/2+5));
    problemList.add(new Tile());
    problemList.get(i).pos = new PVector(MASTER_POS.get(i).x, MASTER_POS.get(i).y);
    answerList.add(new Tile());
    answerList.get(i).pos = new PVector(MASTER_POS.get(i).x+500, MASTER_POS.get(i).y);
  }
}

void drawCursor() {
  fill(0, 200);
  ellipse(mouse.x, mouse.y, 30, 30);
  line (mouse.x, mouse.y, mouse.x + mouseDir.x, mouse.y + mouseDir.y);
  noFill();
}

void shuffleList(ArrayList <Tile> l) {
  //get the size of the list we need
  int len = l.size();
  //make copies of our master copies
  ArrayList <Tile> master_copy = new ArrayList<Tile> ();
  ArrayList <PVector> pos_copy = new ArrayList<PVector> ();

  for (int i = 0; i < len; i ++) {
    master_copy.add(new Tile (MASTER.get(i)));
    pos_copy.add(new PVector(l.get(i).pos.x, l.get(i).pos.y));
  }
  l.clear();
  //copy all the elements in the copy into new positions
  for (int i = 0; i < len; i ++) {
    int rTile = (int)random(0, master_copy.size());//random tile
    int rPos = (int)random(0, master_copy.size());//random position
    //create another reference to the tile in the copy of the master list
    Tile tile = master_copy.get(rTile);   
    //add it to the list
    l.add(tile);
    //take its new position from the pos list
    tile.pos = new PVector(pos_copy.get(rPos).x, pos_copy.get(rPos).y);
    //     tile.pPos.x+=(i*10);
    //     tile.pPos.y+=(i*10);

    //get a new random rotation
    randRot(tile.rot);
    //remove the tile from the copy of the master list
    master_copy.remove(rTile);
    //remove the position from the pos list
    pos_copy.remove(rPos); 
    //  print(i+" ,"+len+" ,"+rTile+" ,"+rPos+" ,"+master_copy.size()); 
    //  println();
    //  print(tile.pos.x+" ,"+tile.pos.y);    
    //  println();
  }
}

void keyPressed() {
  if (key == ' ') {
    activeTile = null;
    shuffleList(problemList);
    shuffleList(answerList);
    timer.start();
  } else if (key == 'r') {
    setup();
    numberSet = 0;
  }
}

void randRot(PVector r) {
  r.rotate((int)random(0, 4)*PI/2.);
}
/*
void mousePressed() {
 if (activeTile != null) {
 if (mouseButton == LEFT) {
 activeTile.held = true;
 } else if (mouseButton == RIGHT && !activeTile.set) {
 activeTile.rot.rotate(PI/2.);
 }
 }
 }*/

void checkHeld() {
  if (activeTile != null) {
    //turn the tile
//    if (avatar.turnLeft && avatar.resetTurn && !activeTile.set) {
//      activeTile.rot.rotate(-PI/2.);
//    } else if (avatar.turnRight && avatar.resetTurn && !activeTile.set) {
//      activeTile.rot.rotate(PI/2.);
//    }
    //check for pinching to 
    activeTile.held = avatar.pinching;
    if (activeTile.held && avatar.pinching && !activeTile.set) {
      activeTile.pos.x = mouse.x;
      activeTile.pos.y = mouse.y;
    } 
    else if (!avatar.pinching) {
      activeTile.held = false;
      snapTile(activeTile, problemList);
      selected = false;
      activeTile = null;
    }

  }
}
/*
void mouseReleased() {
 if (activeTile != null) {
 if (mouseButton == LEFT) {
 activeTile.held = false; 
 }
 //check to see if we can snap the tile into position on the grid
 snapTile(activeTile, problemList);
 // }
 }
 selected = false;
 activeTile = null;
 }
 
 void mouseDragged() {
 if (activeTile != null) {
 if (activeTile.held&&!activeTile.set ) {
 activeTile.pos.x = mouseX;
 activeTile.pos.y = mouseY;
 }
 }
 }
 */
void detectTile(ArrayList <Tile> l, PVector m) {  
  //activeTile = null;
  //find the tile we are over currently
  for (Tile tile : l) {
    tile.over = (abs(m.x - tile.pos.x) < tile.siz/2. && abs(m.y - tile.pos.y) < tile.siz/2.);
    if (tile.over && !selected && !tile.set) {
      activeTile = tile;
      selected = true;
    }
  }
}
/*
void detectTile(ArrayList <Tile> l, PVector m) {  
 //activeTile = null;
 //find the tile we are over currently
 for (Tile tile : l) {
 tile.over = (abs(m.x - tile.pos.x) < tile.siz/2. && abs(m.y - tile.pos.y) < tile.siz/2.);
 if (tile.over && !selected) {
 activeTile = tile;
 selected = true;
 }
 }
 }*/

void snapTile(Tile t, ArrayList <Tile> l) {
  for (int i = 0; i < l.size (); i ++) {
    //if a tile is close to another tile then snap it into position
    if (abs(l.get(i).pos.x - t.pos.x) < t.siz/2. && abs(l.get(i).pos.y - t.pos.y) < t.siz/2.) {
      t.pos.x = l.get(i).pos.x;
      t.pos.y = l.get(i).pos.y;
      if (!t.set&&(t.id == l.get(i).id)&&((int)(100*cos(t.rot.heading()))== (int)(100*cos(l.get(i).rot.heading())))) {
        t.set = true;
        numberSet++;
        println(numberSet);
      }
      println (t.id, t.rot.heading(), l.get(i).id, l.get(i).rot.heading());
    }
  }
}


void draw() {
  //mouse = new PVector(mouseX, mouseY);

  avatar.update(activeTile);

  mouse = avatar.pos;
  mouseDir = avatar.dir;//new PVector (mouseX - pmouseX,mouseY - pmouseY);
  //mouseDir.rotate(PI);
  //mouseDir.normalize();
  //mouseDir.mult(30);  

  background(200);
  if (numberSet < problemList.size()) {
    //  if (problemList.size() > 0){
    for (int i = 0; i < problemList.size (); i++) {
      //MASTER.get(i)._draw();
      problemList.get(i)._draw();
    }  
    for (int i = 0; i < problemList.size (); i++) {
      //MASTER.get(i)._draw();
      answerList.get(i)._draw();
    } 
    detectTile(answerList, mouse);
    checkHeld();
    for (int i = 0; i < problemList.size (); i++) {
      answerList.get(i).update(mouse);
    }
    text((int)timer.getElapsedTime()/1000, 500, width/2);
  } else {
    textSize(30);
    text("Your time " + (int)timer.getElapsedTime()/1000, 500, 300);
    text("YOU WIN!", 500, 500);
    timer.stop();
  }
  if (activeTile != null) {
    activeTile._draw();
  }
  //drawCursor();
  avatar.drawA();
}
//  }

