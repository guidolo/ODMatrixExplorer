///**
// * to do list: 
// hacer el boton de origen o destino
// al apretar sobre un circulo filtrar con color solo a los que llega ese barrio
// poner un grafico de barras por hora estilo grafico de edades.
// ver como hacer para poner las aristas
// check out marcker selection app to select beigborhoods
// */
// 

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
//import de.fhpotsdam.unfolding.providers.OpenStreetMap.*;
import de.fhpotsdam.unfolding.providers.*;
import java.util.*;

UnfoldingMap map;

//general application
int appWidth = 1000;
int appHeight = 700;

//the location of Buenos Aires
Location BsAsLocation = new Location(-34.608873f, -58.440196f);
String PointSelected;

//table of points
Table table;
Table bublesOrigin;
Table bublesOD;

//global variables
int day;
int GlobalHour;

//botton information
int buttonWidth = 60;
int buttonHeight = 35;
int buttonMargin = 2;
int button1Xpos = appWidth - (buttonWidth*2) - 3;
int button2Xpos = appWidth - (buttonWidth) -2;
int buttonColor = color(255, 255, 255, 100);
int selectedButtonColor = color(100, 200, 100, 200);
float greyTicks = 55; // colors
boolean rectHourOver = false;
boolean rectDayOver = false;

//show information
String showname="";
float showx;
float showy;


float maxQuantity; 
float minQuantity;

//array for the bar chart
float[] quantityPerHour;
float plotX1, plotY1;
float plotX2, plotY2;
float barWidth;

// An Array of objects
Bubble[] bubbles;
Neighborhood[] barrios; 
Bar[] Bars;
List<Marker> countryMarkers;

void setup() {
  size(appWidth, appHeight, P2D);
  day = 4;
  GlobalHour = 9;
  PointSelected = "PALERMO";
  //PointSelected = null;

  Bars = new Bar[24];
  bubbles = new Bubble[100]; 
  barrios = new Neighborhood[100];

  //set values for barchart
  setValBarChart();

  //map = new UnfoldingMap(this, new OpenStreetMapProvider());
  map = new UnfoldingMap(this, "map", 0, 100, width-265, height, true, false, new StamenMapProvider.TonerBackground());
  map.zoomToLevel(11);
  map.panTo(BsAsLocation);
  MapUtils.createDefaultEventDispatcher(this, map);

  List countries = GeoJSONReader.loadData(this, "BuenosAires.geojson");
  countryMarkers = MapUtils.createSimpleMarkers(countries);
  map.addMarkers(countryMarkers);

  background(0);
  loadData();
  processData(day, GlobalHour);
  drawTitles();
  drawsubtitles();
  drawDataBars();
  shadeCountries();

}

void draw() {

  map.draw(); 
  //update(mouseX, mouseY);
  //drawBubbles();  
  //drawButtons();
  //drawTitles();
  drawsubtitles();
  drawDataBars();
  showInfo("", 0, 0);
  drawReference();
}

void mouseMoved() {
  // Deselect all marker
  for (Marker marker : map.getMarkers ()) {
    marker.setSelected(false);
  }

  // Select hit marker
  // Note: Use getHitMarkers(x, y) if you want to allow multiple selection.
  Marker marker = map.getFirstHitMarker(mouseX, mouseY);
  if (marker != null) {
    marker.setSelected(true);
    String name = marker.getStringProperty("departa");
    //showInfo(name, mouseX, mouseY);
    for (Neighborhood n : barrios) {
      if (n != null) {
        if (n.name.equals(name)) {
          n.rollover(true);
        } else {
          n.rollover(false);
        }
      }
    }
  }

  for (Bar b : Bars) {
    if (b != null) {
      b.rollover(mouseX, mouseY);
    }
  }
}

void mousePressed() {

  Marker marker = map.getFirstHitMarker(mouseX, mouseY);
  if (marker != null) {
    PointSelected = marker.getStringProperty("departa");
    processData(day, GlobalHour);
    shadeCountries();
  }

  //press over barchart
  for (Bar b : Bars) {
    if (b != null) {
      if (b.over==true) {
        GlobalHour=b.hour;

        println(GlobalHour);
        processData(day, GlobalHour);
        shadeCountries();
      } 
    }
  }
//  drawDataBars();
//  drawTitles();
}

void drawButtons(){
  //buton day
  fill(200, 200, 0, 500);
  rect(button1Xpos, buttonMargin, buttonWidth, buttonHeight);
  fill(greyTicks);
  text(day, appWidth - (buttonWidth*2) + 12, buttonMargin + 27);
  
  //buton hour
  fill(200, 200, 0, 500);
  rect(button2Xpos, buttonMargin, buttonWidth, buttonHeight);
  fill(greyTicks);
  text(GlobalHour, appWidth - (buttonWidth) + 12, buttonMargin + 27);
}

void update(int x, int y) {
  rectHourOver = false;
  rectDayOver = false;

  if ( overRect(button1Xpos, buttonMargin, buttonWidth, buttonHeight) ) {
    rectDayOver = true;
  } 
  if ( overRect(button2Xpos, buttonMargin, buttonWidth, buttonHeight) ) {
    rectHourOver = true;
  } 
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void createBars() {
  for (int row = 0; row < quantityPerHour.length; row++) {
    Bars[row] = new Bar(row, quantityPerHour[row]);
  }
}

void drawDataBars() {
  noStroke();

  //framework
  fill(0);
  rect(plotX1 - 5, plotY1 - 5, plotX2-plotX1+10, plotY2 - plotY1+30 );

  //draw bar
  for (Bar b : Bars) {
    if (b != null) {
      b.display();
    }
  }
  //    fill(250);
  textSize(8);
  textAlign(LEFT);
  text("0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23", plotX1 - 5, plotY2+10);
}


void setValBarChart() {
  // Corners of the plotted time series
  //  plotX1 = 120; 
  //  plotX2 = 480;
  //  plotY1 = height - 60;
  //  plotY2 = height - 10;
  //  barWidth = 10; 

  plotX1 = width - 260; 
  plotX2 = width - 10;
  plotY1 = height - 590;
  plotY2 = height - 500;
  barWidth = 9;
}

class Bar {
  float value;
  int hour;
  boolean over = false;
  boolean choosen = false;
  float barx, bary, barHeight;

  // Create  the Bubble
  Bar(int h_, float q_) {
    hour = h_;
    value = q_;
    float x = map(hour, 0, 23, plotX1, plotX2);
    float y = map(value, 0, max(quantityPerHour), 0, plotY2-plotY1 );
    barx=x-barWidth/2;
    bary=plotY1 + (plotY2- plotY1)-y;
    //float barWidth = barWidth;
    barHeight = y;
  }

  // Display the Bar
  void display() {
    noStroke();
    //noStroke();

    if (hour==GlobalHour) {
      //selectec
      fill(52, 121, 158);
    } else {
      //muted
      fill(207, 218, 226);
    }

    rect(barx, bary, barWidth, barHeight); 
//    fill(250);
//    textSize(8);
//    textAlign(LEFT);
//    text(hour, barx, bary+barHeight+10);
  }

  void rollover(float px, float py) {
    if (mouseX >= barx && mouseX <= barx+barWidth &&  mouseY >= bary && mouseY <= bary+barHeight) {
      over = true;
    } else {
      over = false;
    }
  }
} // clase




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
void loadData() {
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  bublesOD = loadTable("BubblesOD.csv", "header");
  bublesOD.sort("origen_barrio");
}

void processData(int day, int hour) {
  // The size of the array of Bubble objects is determined by the total number of rows in the CSV

  int bubblerow = 0;
  boolean firsttime = true;
  float desstiniSum = 0; 
  float destinilongitude=0;
  float destinilatitude=0;
  String destinin="";
  String nowbarrio;
  String oldbarrio="";
  Character type;

  //calculo del array por hora 
  int barHour;
  float barQuantity;
  quantityPerHour = new float[24];

  //orden del dataset
  if (PointSelected != null) {
    //si esta seteado un destino
    //bublesOD.sort("origen_barrio");
    barrios[0] = new Neighborhood(PointSelected, 0, 'D');
  }

  println("Record count:", bublesOD.getRowCount());
  for (int row = 0; row < bublesOD.getRowCount (); row++ ) {
    if (bublesOD.getInt(row, "same") == 0){
      if (bublesOD.getInt(row, "day") == day & bublesOD.getInt(row, "hour") == hour ) {
  
        if (PointSelected != null) {
          //filtro para el destino seleccionado
          if (bublesOD.getString(row, "destino_barrio").equals(PointSelected)==true) {
            desstiniSum = desstiniSum + bublesOD.getFloat(row, "cantidad");
  
            //there is only one destiny 
            if (firsttime==true) {
              firsttime = false;
            }
  
            //origen  
            float d = bublesOD.getFloat(row, "cantidad");
            String n = bublesOD.getString(row, "origen_barrio");  
            //bubbles[bubblerow] = new Bubble(latitude, longitude, d, n, 'O');
            barrios[bubblerow+1] = new Neighborhood(n, d, 'O');
            bubblerow++;
          }
        } else { //if PointSelected is null
  
          nowbarrio =  bublesOD.getString(row, "origen_barrio");
          if (nowbarrio.equals(oldbarrio)== false) {
  
            oldbarrio = nowbarrio;
            type = (nowbarrio.equals(PointSelected)==true) ? 'D':'O';
            barrios[bubblerow] = new Neighborhood(nowbarrio, bublesOD.getFloat(row, "cantidad"), type);
            bubblerow++;
          } else {
            barrios[bubblerow].sumQuantity(bublesOD.getFloat(row, "cantidad"));
          }
        }
      }
  
  
      //calculo del array por hora 
      if (PointSelected != null) {
        if (bublesOD.getString(row, "destino_barrio").equals(PointSelected)==true) {
          barHour = bublesOD.getInt(row, "hour");
          if (barHour >= 0 & barHour <= 23) {
            barQuantity = bublesOD.getFloat(row, "cantidad");
            quantityPerHour[barHour] = quantityPerHour[barHour] + barQuantity;
          }
        }
      } else {
        barHour = bublesOD.getInt(row, "hour");
        if (barHour >= 0 & barHour <= 23) {
          barQuantity = bublesOD.getFloat(row, "cantidad");
          quantityPerHour[barHour] = quantityPerHour[barHour] + barQuantity;
        }
      }
    }
  } // cierra for

  createBars();
  MaxMinNeighborhood();
}


void shadeCountries() {
  for (Marker marker : countryMarkers) {
    // Find data for country of the current marker
    String departa = marker.getStringProperty("departa");
    for (Neighborhood n : barrios) {
      if (n != null) {
        if (n.name.equals(departa) == true ) {
          //println(n.type);
          if (n.type.equals('O')==true) {
            float transparency = map(n.totalQuantity, minQuantity, maxQuantity, 10, 255);
            marker.setColor(color(225, 87, 89, transparency));
            break;
          } else {
            marker.setColor(color(237, 201, 72));
            break;
          }
        }
      } else {
        // No value available
        marker.setColor(color(186, 176, 172));      
        break;
      }
    }
  }
}

void showInfo(String name, float x, float y) {
  if (showname.equals(name)==true | name=="") {
    fill(0);
    textAlign(CENTER);
    text(showname, showx, showy);
  } else {
    showname = name;
    showx=x;
    showy=y;
  }
}


void MaxMinNeighborhood() {
  //calculo los maximos y minimos
  maxQuantity = 0; 
  minQuantity = 99999;
  for (Neighborhood n : barrios) {
    if (n != null) {
      if (n.totalQuantity > maxQuantity) {
        maxQuantity = n.totalQuantity;
      }
      if (n.totalQuantity < minQuantity) {
        minQuantity =  n.totalQuantity;
      }
    }
  }
}

class Neighborhood {
  float quantity;
  float totalQuantity;
  String name;
  Character type;
  boolean over = false;

  // Create  the Bubble
  Neighborhood( String s, float quantity_, Character type_) {
    totalQuantity = quantity_;
    name = s;
    type = type_;
  }

  void sumQuantity(float quantity_) {
    totalQuantity = totalQuantity + quantity_ ;
  }
  
  void rollover(boolean over_){
   over = over_; 
  }  
}

void drawReference() {
  float refx;
  float refy;
  float refwidth;
  float refheight;

  refwidth = 250;
  refheight = 50;  

  refx= width - refwidth - 10;
  refy = height - 400 - refheight;
  //framework
  fill(255);
  rect(refx, refy, refwidth, refheight+20);
  for (int i=0; i<100; i++) {
    float recx = map(i, 0, 100, refx, refx+refwidth);
    float transparency = map(i, 0, 100, 10, 255);
    fill(225, 87, 89, transparency);
    rect(recx, refy, refwidth/100, 50);
  }
  fill(0);
  rect(refx, refy, 1, 50+5);
  rect(refx+refwidth/2, refy, 1, 50+5);
  rect(refx+refwidth-1, refy, 1, 50+5);
  textSize(12);
  textAlign(LEFT);
  text(round(minQuantity), refx, refy+ 60+5);
  textAlign(CENTER);
  text(round(maxQuantity/2), refx+refwidth/2, refy+ 60+5);
  textAlign(RIGHT);
  text(round(maxQuantity), refx+refwidth-1, refy+ 60+5);

  fill(0);
  for (Neighborhood n : barrios) {
    if (n != null) {
      if (n.over == true) {
        fill(237, 201, 72);
        float recx = map(n.totalQuantity, minQuantity, maxQuantity, refx, refx+refwidth);
        rect(recx, refy, 2, 50+5);
      }
    }
  }
}

void drawTitles() {
  String name;
  //framework
  fill(0);
  rect(10, 10, 480, 40 );

  textAlign(LEFT);
  fill(250);
  textSize(32);

  //textFont()
  text("Origin and Destini explorator", 20, 40);
}

void drawsubtitles() {

  fill(0);
  rect(width-250, 10, 250, 60 );

  String name;
  //origin
  fill(225, 87, 89);
  name = "From: All Neighbohoods";
  textAlign(LEFT);
  textSize(16);
  text(name, width-250, 40);


  //destini
  fill(237, 201, 72);
  if (PointSelected == null) {
    name = "No selection";
  } else {
    name = "To:"+PointSelected;
  }
  textSize(16);
  text(name, width-250, 60);
}  


