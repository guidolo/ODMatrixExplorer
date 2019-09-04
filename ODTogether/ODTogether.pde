///**
// * to do list: 
/*pasar el titulo a la derechar
 poner el fondo blanco
 poner una barra a la derecha, con 60% shadow.
 
 seguir esta line:
 titulo : interneighborhood travelsr
 subtitulo
 descripcion de los datos:
 click on a neigborhood to start....
 
 la barra de color roja:
 fijarle la escala al maximo del Neig-hora
 poner en gris todo de lo que no se vea 
 
 grafico de barras:
 usar siempre el mismo escalado de valores
 poner el grafico de barras vertical
 
 animar las trabsiciones
 a reset bottom
 // */
// 

/* COLORS
 rojo     -- 225, 87, 89
 amarillo -- 237, 201, 72
 gris map -- 186, 176, 172
 blue     -- 78, 121, 167
 grey back-- 208, 207, 212
 blue title background -- 16, 72, 112;
 */

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.providers.*;
import java.util.*;

UnfoldingMap map;

//general application
int appWidth = 1000;
int appHeight = 700;

//the location of Buenos Aires
Location BsAsLocation = new Location(-34.608873f, -58.440196f);
String PointSelected;

//tables
Table bublesOD;
Table TableD;

//global variables
int day;
int GlobalHour;
int panelRefx;
int panelRefy;
int panelWidth;
int shadowAnimated=0;
boolean increse=true;
int zoomlevel = 1;


//show information
String showname="";
float showx;
float showy;

//maximuns 
float maxQuantity; 
float minQuantity;
float maxUniversal;
float maxUniversalOD;

//array for the bar chart
float[] quantityPerHour;
float[] maxPerHour;
float maxHour;
float plotX1, plotY1;
float plotX2, plotY2;
float plotX3, plotY3;
float barWidth;
float dataMax=0;
int Xspace = 15;

//color reference
float refDataMax=0;
float refDataMin=0;
int rep=50;

//array for the bar chart Destini
float[] quantityPerHourD;
float[] maxPerHourD;
float dataMaxD=0;


// An Array of objects
Bubble[] bubbles;
Neighborhood[] barrios; 
Bar[] Bars;
List<Marker> countryMarkers;

void setup() {
  size(appWidth, appHeight, P2D);
  day = 4;
  GlobalHour = 9;
  //PointSelected = "PALERMO";
  PointSelected = null;

  Bars = new Bar[24];
  bubbles = new Bubble[100]; 
  barrios = new Neighborhood[100];

  panelWidth = 350;
  panelRefx = width-panelWidth-10;
  panelRefy = 150;
  //set values for barchart
  setValBarChart();

  //map = new UnfoldingMap(this, new OpenStreetMapProvider());
  // map = new UnfoldingMap(this, "map", 0, 100, width-265, height, true, false, new StamenMapProvider.TonerBackground());
  //map = new UnfoldingMap(this, "map", 0, 100, width-265, height, true, false, new MapBox.BlankProvider());
  //map = new UnfoldingMap(this, "map", 0, 100, width-265, height, true, false, new StamenMapProvider.WaterColor());
  //map = new UnfoldingMap(this, "map", 0, 100, width-265, height, true, false, new ThunderforestProvider.OpenCycleMap());
  //map = new UnfoldingMap(this, "map", 0, 0, width-290, height, true, false, new StamenMapProvider.TonerLite());
  //map = new UnfoldingMap(this, "map", 0, 0, width-290, height, true, false, new  OpenStreetMap.OpenStreetMapProvider() );
  //map = new UnfoldingMap(this, "map", 0, 0, width-290, height, true, false, new  StamenMapProvider.WaterColor() );
  //map = new UnfoldingMap(this, "map", 0, 100, width-265, height, true, false, new OpenStreetMap.CloudmadeProvider());
  //map = new UnfoldingMap(this, "map", 0, 100, width-265, height, true, false, new EsriProvider.WorldStreetMap());
  map = new UnfoldingMap(this, "map", 0, 0, panelRefx, height, true, false, new EsriProvider.WorldGrayCanvas());
  //map = new UnfoldingMap(this, "map", 0, 0, width-290, height, true, false, new EsriProvider.DeLorme());

  
  map.zoomToLevel(zoomlevel);
  map.panTo(BsAsLocation);
  MapUtils.createDefaultEventDispatcher(this, map);

  List countries = GeoJSONReader.loadData(this, "BuenosAires.geojson");
  countryMarkers = MapUtils.createSimpleMarkers(countries);
  map.addMarkers(countryMarkers);

  background(208, 207, 212); //grey
  loadData();
  //processData(day, GlobalHour);
  //drawTitles();
  //drawsubtitles();
  //drawDataBars();
  //shadeCountries();
  restart();
}

void draw() {
  map.draw(); 

  if (zoomlevel < 11){
    zoomlevel++;
    map.zoomToLevel(zoomlevel);
    map.panTo(BsAsLocation);
  }
  //drawBubbles();  
  drawTitles();
  drawsubtitles();
  drawDataBars();
  //showInfo("", 0, 0);
  drawReference();
  if (rep > 0) {
    rep--;
    shadeCountries();
  }
  if (PointSelected == null) {
    drawNullReference();
  }
}

void drawNullReference() {
  ScreenPosition screenPos;
  float pixelx, pixely;

  Location River = new Location(-34.544f, -58.354f);


  //GPSLocation = new Location(x, y);
  screenPos = map.getScreenPosition(BsAsLocation); 
  pixelx = screenPos.x;
  pixely = screenPos.y;
  textSize(24);
  textAlign(CENTER);
  text("Buenos Aires", pixelx, pixely);

  screenPos = map.getScreenPosition(River); 
  pixelx = screenPos.x;
  pixely = screenPos.y;
  text("River Plate", pixelx, pixely);
}

void restart() {
  quantityPerHour = new float[24];
  maxPerHour = new float[24];
  quantityPerHourD = new float[24];
  maxPerHourD = new float[24];
  for (int i =0; i<24; i++) {
    quantityPerHour[i]=0;
    maxPerHour[i]=0;
    quantityPerHourD[i]=0; 
    maxPerHourD[i]=0;
  }
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
    rep=500;
    shadeCountries();
  }

  //press over barchart
  for (Bar b : Bars) {
    if (b != null) {
      if (b.over==true) {
        GlobalHour=b.hour;
        processData(day, GlobalHour);
        shadeCountries();
      }
    }
  }
  //  drawDataBars();
  //  drawTitles();
}

