void drawReference() {
  noStroke();
  float refx;
  float refy;
  float refwidth;
  float refheight;
  float transparency=0;
  float recx;
  float dataMax;
  float dataMin;

  //user configuration --------------------
  refwidth = 300;
  refheight = 30;  
  refx= width - refwidth - 30; 
  refy = height - 150 - refheight;
  //--------------------------------------

  fill(208, 207, 212);
  rect(refx, refy-20, refwidth, refheight+40);   //right framework

  //this code is only for the animation#############################################33
  //if you don't want animation just replace for these two lines
  //  refDataMax = maxQuantity;
  //  refDataMin = minQuantity;

  if (abs(refDataMax - maxQuantity) < 10) {
    refDataMax = maxQuantity;
  } else {
    if (refDataMax > maxQuantity) {
      refDataMax = refDataMax - (refDataMax - maxQuantity)/ 10;
    } else {
      refDataMax = refDataMax + (maxQuantity-refDataMax)/ 10;
    }
  }

  if (abs(refDataMin - minQuantity) < 10) {
    refDataMin = minQuantity;
  } else {
    if (refDataMin > minQuantity) {
      refDataMin = refDataMin - (refDataMin - minQuantity)/ 10;
    } else {
      refDataMin = refDataMin + (minQuantity-refDataMin)/ 10;
    }
  }

  //#################################################################################

  //barra de color
  for (int i=-50; i<=50; i++) {
    recx = map(i, -50, 50, refx, refx+refwidth);
    if (i<0) {
      transparency = map(log(-i), 0, log(50), 10, 250);    
      if (log(maxUniversalOD)/50*i > log(refDataMin*-1)*-1 ) {
        fill(78, 121, 167, transparency); //azul
      } else {
        fill(186, 176, 172, 200);
      }
    } else {
      transparency = map(log(i), 0, log(50), 10, 250);    
      if (log(maxUniversalOD)/50*i < log(refDataMax)) {
        fill(225, 87, 89, transparency); //rojo
      } else {
        fill(186, 176, 172, 200);
      }
    }



    rect(recx, refy, refwidth/100, refheight);
  }
  fill(0);
  rect(refx, refy, 1, refheight+5);
  rect(refx+refwidth/2, refy, 1, refheight+5);
  rect(refx+refwidth-1, refy, 1, refheight+5);
  textSize(12);
  textAlign(LEFT);
  text(round(maxUniversalOD), refx, refy);
  textAlign(CENTER);
  text("0", refx+refwidth/2, refy);
  textAlign(RIGHT);
  text(round(maxUniversalOD), refx+refwidth-1, refy);

  //posicion de barrios seleccioado
  fill(0);
  for (Neighborhood n : barrios) {
    if (n != null) {
      if (n.over == true) {
        //imprime la referencia actual
        //fill(237, 201, 72);
        fill(0);
        if (n.quantityOD >=0) {
          textAlign(RIGHT);
          recx = map(log(n.quantityOD), 0, log(maxUniversalOD), refx+refwidth/2, refx+refwidth);
        } else {
          textAlign(LEFT);          
          recx = map(log(n.quantityOD*-1), 0, log(maxUniversalOD), refx+refwidth/2, refx);
        }
        rect(recx, refy, 2, refheight+15);
        stroke(1);
        fill(208, 207, 212);
        if (n.quantityOD > 0) {
          rect(recx-170, refy+refheight+10, 170, 60);
        } else {
          rect(recx, refy+refheight+10, 170, 60);
        }
        fill(0);

        text(n.name, recx, refy+refheight+20);
        String direction = (round(n.quantityOD) < 0) ? "out" : "in" ;
        text(""+round(n.quantityOD) + " moving " + direction, recx, refy+refheight+35 );
        textSize(11);
        text("("+round(n.quantityO) + " entering and "+round(n.quantityD)+ " exiting)", recx, refy+refheight+55 );
        //text(round(n.quantityD) + " passenger exiting.", recx, refy+refheight+65);
      }
    }
  }
}

