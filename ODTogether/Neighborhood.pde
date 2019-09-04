
void shadeCountries() {          
  for (Marker marker : countryMarkers) {
    // Find data for country of the current marker
    String departa = marker.getStringProperty("departa");
    for (Neighborhood n : barrios) {
      if (n != null) {
        if (n.name.equals(departa) == true ) {
          if (n.type.equals('O')==true) {
            //transparency color over map
            
             //###############################################################
             //only animation
             if (abs(n.quantityODTransition - n.quantityOD) < 10) {
                n.setTrans(n.quantityOD);
              } else {
                if (n.quantityODTransition > n.quantityOD) {
                  n.setTrans(n.quantityODTransition - (n.quantityODTransition - n.quantityOD)/ 10);
                } else {
                  n.setTrans(n.quantityODTransition + (n.quantityOD-n.quantityODTransition)/ 10);
                }
              }
             //n.setTrans(n.quantityOD);
            //#################################################################
            float transparency = map(log(abs(n.quantityODTransition)), 0, log(maxUniversalOD), 10, 250);
            if (n.quantityODTransition > 0) {
              //red
              marker.setColor(color(225, 87, 89, transparency));
            } else {
              //blue
              marker.setColor(color(78, 121, 167, transparency));
            }
            break;
          } else {
            // for the selected neighborhood
            marker.setColor(color(237, 201, 72));
            break;
          }
        }
      } else {
        // No value available
        int transparency = (PointSelected == null) ? 0:100;
        marker.setColor(color(186, 176, 172, transparency));      
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
      if (n.quantityOD > maxQuantity) {
        maxQuantity = n.quantityOD;
      }
      if (n.quantityOD < minQuantity) {
        minQuantity =  n.quantityOD;
      }
    }
  }
}

class Neighborhood {
  float quantityO;
  float quantityD;
  float quantityOD;
  float quantityODTransition;
  String name;
  Character type;
  boolean over = false;

  // Create  the Bubble
  Neighborhood( String s, float quantityO_, float quantityD_, Character type_) {
    quantityO = quantityO_;
    quantityD = quantityD_;
    quantityOD = quantityO - quantityD;
    name = s;
    type = type_;
    quantityODTransition = 0;
  }

  void sumQuantity(float quantity_) {
    quantityO = quantityO + quantity_ ;
  }

  void setQD(float d) {
    quantityD = d;
    quantityOD = quantityO - quantityD;
  }

  void setQO(float d) {
    quantityO = d;
    quantityOD = quantityO - quantityD;
  }

  void rollover(boolean over_) {
    over = over_;
  }
  
  void setTrans(float n){
    quantityODTransition = n;
  }
}

