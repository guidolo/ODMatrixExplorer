

//void drawBubbles(){
//  for (Bubble b : bubbles) {
//    if (b != null){
//      b.display();
//      b.rollover(mouseX, mouseY);
//    }
//  }
//}

// A Bubble class
class Bubble {
  float x,y, pixelx, pixely;
  float diameterraw;
  float diameter;
  String name;
  Character type;
  boolean over = false;
  boolean skip;
  Location GPSLocation;
  ScreenPosition screenPos;
  
  // Create  the Bubble
  Bubble(float x_, float y_, float diameter_, String s, Character type_) {
    x = x_;
    y = y_;
    diameterraw = diameter_;
    name = s;
  }
  
  // Display the Bubble
  void display() {
    stroke(0);
    strokeWeight(2);
    //noFill();
    
    
    GPSLocation = new Location(x, y);
    screenPos = map.getScreenPosition(GPSLocation); 
    pixelx = screenPos.x;
    pixely = screenPos.y;
    if (type == 'O') {
      fill(200, 200, 0, 500);
      diameter = diameterraw / 10;
    }
    else {
      fill(100, 400, 0, 500);
      diameter = diameterraw / 100;
    }
      
    ellipse(pixelx,pixely,diameter,diameter);
    if (over) {
      fill(0);
      textAlign(CENTER);
      text(name,pixelx,pixely+diameter+20);
    }
  }
  
  void rollover(float px, float py) {
    float d = dist(px,py,pixelx,pixely);
    if (d < diameter) {
      over = true; 
    } else {
      over = false;
    }
  }
  
}
