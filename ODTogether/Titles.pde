void drawTitles() {
  String name;

  //framework
  //noStroke();
  fill(16, 72, 112); //blue title background
  rect(400, 10, 430, 40 );
  rect(400, 50, 584, 40 );

  noStroke();
  fill(208, 207, 212); //blue title background
  rect(400, 89, 529, 53 );

  textAlign(LEFT);
  fill(250);
  textSize(32);

  //textFont()
  text("Interneighborhood travels", 420, 40);
  textSize(24);
  text("Bus trips in the City of Buenos Aires, Argentina", 420, 80);

  textSize(16);
  fill(16, 72, 112);
  text("This tool explores the flow of passanger entering and exiting", 435, 113);
  text("a Neigborhood.", 435, 133);
}

void drawsubtitles() {
  String name; 
  String time;

  fill(208, 207, 212);
  stroke(2);
  rect(panelRefx, panelRefy, panelWidth, height );

  //  String name;
  //  //origin
  //  fill(225, 87, 89);
  //  name = "From: All Neighbohoods";
  textAlign(LEFT);
  textSize(16);
  //  text(name, refx, refy + 10);


  //destini

  if (PointSelected == null) {

    shadowAnimated = (increse == true) ? shadowAnimated + 25: shadowAnimated - 25;
    increse = (shadowAnimated==0) ? true:increse;
    increse = (shadowAnimated==250) ? false:increse;
    fill(255, 255, 0, shadowAnimated);
    name = "Choose a Neighborhood to Start";
    time = "";
  } else {
    fill(16, 72, 112); //blue title background
    name = "Neighborhood selected :"+PointSelected;
    time = "Monday 4th of May at " + GlobalHour + ":00";
  }
  textSize(16);
  text(name, panelRefx + 10, panelRefy + 29);
  text(time, panelRefx + 10, panelRefy + 50);

  //color references   
  fill(225, 87, 89);
  rect(panelRefx + 10, panelRefy + 70, 15, 15 );
  fill(78, 121, 167);
  rect(panelRefx + 10, panelRefy + 90, 15, 15 );

  fill(0);
  textSize(12);
  text("Pasengers entering to " + PointSelected, panelRefx + 27, panelRefy + 85);
  text("Pasengers exiting from " + PointSelected, panelRefx + 27, panelRefy + 105);
}  

