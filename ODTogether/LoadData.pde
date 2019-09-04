void loadData() {
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  bublesOD = loadTable("BubblesOD_sinSame.csv", "header");
  bublesOD.sort("origen_barrio");
  
  TableD = loadTable("BubblesOD_sinSame.csv", "header");
  TableD.sort("destino_barrio");
  
  //function to find the universal max (record with the maxvalue)
  maxUniversal = 0;
  for (int row = 0; row < bublesOD.getRowCount (); row++ ) {
    maxUniversal = max(maxUniversal, bublesOD.getFloat(row, "cantidad"));
  }  
  println("UniversalMax: ",maxUniversal);

  maxUniversalOD = 1494; //calculada con SQL
  
  
}

void processData(int day, int hour) {
  if (PointSelected==null){
    restart();
  } else {
    processDataO(hour);
    processDataD(hour);
    createBars();
    MaxMinNeighborhood();
  }
}

void processDataO(int hour) {
  // The size of the array of Bubble objects is determined by the total number of rows in the CSV

  int bubblerow = 0;
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
  maxPerHour = new float[24];
  
  //vacio barrios
  barrios = new Neighborhood[100];

  //orden del dataset
  if (PointSelected != null) {
    //si esta seteado un destino
    //bublesOD.sort("origen_barrio");
    barrios[0] = new Neighborhood(PointSelected, 0, 0, 'S');
  }

  for (int row = 0; row < bublesOD.getRowCount (); row++ ) {
    if (bublesOD.getInt(row, "day") == day & bublesOD.getInt(row, "hour") == hour ) {  //filtro por dia y hora

      if (PointSelected != null) {  //si hay un destino seleccionado
        if (bublesOD.getString(row, "destino_barrio").equals(PointSelected)==true) { //cargo todos los origenes para ese destino
          //desstiniSum = desstiniSum + bublesOD.getFloat(row, "cantidad");

          //origen  
          float d = bublesOD.getFloat(row, "cantidad");
          String n = bublesOD.getString(row, "origen_barrio");  
          boolean exist = false;
          for (Neighborhood bar : barrios){
            if (bar != null){
              if (bar.name. equals(n)) {
                bar.setQO(d);
                exist = true;
                break;
              }
            }else {break;}
          }
          if (exist == false){
            type = (n.equals(PointSelected)==true) ? 'S':'O'; //selected or Other
            barrios[bubblerow+1] = new Neighborhood(n, d, 0, type);
            bubblerow++;
          }
        }
        
        
      } else { //if PointSelected is null
        nowbarrio =  bublesOD.getString(row, "origen_barrio");
        if (nowbarrio.equals(oldbarrio)== false) {

          oldbarrio = nowbarrio;
          type = (nowbarrio.equals(PointSelected)==true) ? 'D':'O';
          barrios[bubblerow] = new Neighborhood(nowbarrio, bublesOD.getFloat(row, "cantidad"),0, type);
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
          maxPerHour[barHour] = max(maxPerHour[barHour], barQuantity);
        }
      }
    } else {
      barHour = bublesOD.getInt(row, "hour");
      if (barHour >= 0 & barHour <= 23) {
        barQuantity = bublesOD.getFloat(row, "cantidad");
        quantityPerHour[barHour] = quantityPerHour[barHour] + barQuantity;
      }
    } 
    
  } // cierra for


}


//process data in Destini Order
void processDataD(int hour) {
    //calculo del array por hora 
  int barHour;
  float barQuantity;
  quantityPerHourD = new float[24];
  maxPerHourD = new float[24];
  Character type;
            
  for (int row = 0; row < TableD.getRowCount (); row++ ) {
    
    if (TableD.getInt(row, "hour") == hour ) {  //filtro por dia y hora
      if (PointSelected != null) {  //si hay un destino seleccionado
      
        if (TableD.getString(row, "origen_barrio").equals(PointSelected)==true) { //cargo todos los destino de ese origen
          //originSum = originSum + TableD.getFloat(row, "cantidad");
          
          //destiny  
          float d = TableD.getFloat(row, "cantidad");
          String n = TableD.getString(row, "destino_barrio");              
          boolean exist = false;
          int i = 0;        
          for (Neighborhood bar : barrios){
            if (bar != null){
              i++;
              if (bar.name.equals(n)) {
                bar.setQD(d);
                exist = true;
                break;
              }
            }else {
              break;}
          }
          if (exist == false){
            type = (n.equals(PointSelected)==true) ? 'S':'O'; //selected or Other
            barrios[i] = new Neighborhood(n, 0, d, type);
          }
        }
      }
    }
    
    
    
    //calculo del array por hora 
    if (PointSelected != null) {
      if (TableD.getString(row, "origen_barrio").equals(PointSelected)==true) {
        barHour = TableD.getInt(row, "hour");

        if (barHour >= 0 & barHour <= 23) {
          barQuantity = TableD.getFloat(row, "cantidad");
          quantityPerHourD[barHour] = quantityPerHourD[barHour] + barQuantity;
          maxPerHourD[barHour] = max(maxPerHourD[barHour], barQuantity);
        }
      }
    }
    
  } //cierra for
} // end function
