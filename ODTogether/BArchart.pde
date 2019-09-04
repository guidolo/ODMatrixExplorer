


void setValBarChart() {
  // Corners of the plotted time series
  //plotX1 = width - 260; 
  int barHeight;
  int barMIDLEX;

  barWidth = 9;
  barHeight = 90;
  barMIDLEX = height - 320; //moves the center X of the graph

  plotX1 = width-310-10;
  plotX2 = width - 30;
  plotY1 = barMIDLEX - barHeight; 
  plotY2 = barMIDLEX;
  plotY3 = barMIDLEX + barHeight;
}

void createBars() {
  for (int row = 0; row < quantityPerHour.length; row++) {
    Bars[row] = new Bar(row, quantityPerHour[row], maxPerHour[row], quantityPerHourD[row], maxPerHourD[row]);
  }
}

void drawDataBars() {
  noStroke();

  //framework
  fill(208, 207, 212);
  rect(plotX1 - 30, plotY1 - 5, plotX2-plotX1+10, plotY3 - plotY1+30 );

  //draw bar
  for (Bar b : Bars) {
    if (b != null) {
      b.display();
    }
  }
  if (PointSelected != null){
    drawAxeYLabels();
    drawAxeYLabelsD();
  }
}

void drawAxeYLabels() {

  //vertical label
  pushMatrix();
  textSize(12);
  textAlign(CENTER);
  float auxx = plotX1-20;
  float auxy = plotY2;
  translate(auxx, auxy);
  rotate(-HALF_PI);
  text("Number of trips (in hundreds)", 0, 0);
  popMatrix();



  fill(0);
  textSize(8);
  textAlign(RIGHT);

  stroke(128);
  strokeWeight(1);
  int volumeInterval = 1000;
  float dataMin = 0;

  ///animation code
  if (abs(dataMax - max(quantityPerHour)) < 10) {
    dataMax = max(quantityPerHour);
  } else {
    if (dataMax > max(quantityPerHour)) {
      dataMax = dataMax - (dataMax - max(quantityPerHour))/ 10;
    } else {
      dataMax = dataMax + (max(quantityPerHour)-dataMax)/ 10;
    }
  }
  for (float v = dataMin; v <= dataMax; v += volumeInterval) {
    if (v % volumeInterval == 0) {     // If a major tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1 );  
      float textOffset = textAscent()/2;  // Center vertically
      if (v == dataMin) {
        textOffset = 0;                   // Align by the bottom
      } else if (v == dataMax) {
        textOffset = textAscent();        // Align by the top
      }
      text(floor(v)/1000, plotX1 - 10, y + textOffset);
      line(plotX1 - 4, y, plotX1, y);     // Draw major tick
    }
  }
}

void drawAxeYLabelsD() {
  fill(0);
  textSize(8);
  textAlign(RIGHT);

  stroke(128);
  strokeWeight(1);
  int volumeInterval = 1000;
  float dataMin = 0;
  if (abs(dataMaxD - max(quantityPerHourD)) < 10) {
    dataMax = max(quantityPerHourD);
  } else {
    if (dataMaxD > max(quantityPerHourD)) {
      dataMaxD = dataMaxD - (dataMaxD - max(quantityPerHourD))/ 10;
    } else {
      dataMaxD = dataMaxD + (max(quantityPerHourD)-dataMaxD)/ 10;
    }
  }
  for (float v = dataMin; v <= dataMaxD; v += volumeInterval) {
    if (v % volumeInterval == 0) {     // If a major tick mark
      float y = map(v, dataMin, dataMaxD, plotY2, plotY3 );  
      float textOffset = textAscent()/2;  // Center vertically
      if (v == dataMin) {
        textOffset = 0;                   // Align by the bottom
      } else if (v == dataMaxD) {
        textOffset = textAscent();        // Align by the top
      }
      text(floor(v)/1000, plotX1 - 10, y + textOffset+Xspace);
      line(plotX1 - 4, y+Xspace, plotX1, y+Xspace);     // Draw major tick
    }
  }
}





class Bar {
  float valueO;
  float valueD;
  int hour;
  boolean over = false;
  boolean choosen = false;
  float barx, bary, barHeightO, barHeightD;
  float transparencyO;
  float transparencyD;

  // Create  the BAR
  Bar(int h_, float qo_, float maxHourO_, float qd_, float maxHourD_) {
    hour = h_;
    valueO = qo_;
    valueD = qd_;
    float x = map(hour, 0, 23, plotX1, plotX2);
    float y = map(valueO, 0, max(quantityPerHour), 0, plotY2-plotY1 );
    barx=x-barWidth/2;
    bary=plotY1 + (plotY2- plotY1)-y;
    barHeightO = y;
    barHeightD = map(valueD, 0, max(quantityPerHourD), 0, plotY2-plotY1 );
    transparencyO = maxHourO_;
    transparencyD = maxHourD_;
  }

  // Display the Bar
  void display() {
    //barras
    if (hour==GlobalHour | over == true) {
      stroke(1);
    } else {
      noStroke();
    }
    //display origin
    float transp = map(log(transparencyO), 0, log(maxUniversal), 0, 255);
    fill(225, 87, 89, transp);
    rect(barx, bary, barWidth, barHeightO); 

    //display destiny
    transp = map(log(transparencyD), 0, log(maxUniversal), 0, 255);
    //transp = 250;
    fill(78, 121, 167, transp);
    rect(barx, plotY2+Xspace, barWidth, barHeightD); 

    fill(0);
    textSize(8);
    textAlign(LEFT);
    text(hour, barx, bary+barHeightO+10);
  }

  void rollover(float px, float py) {
    if (mouseX >= barx && mouseX <= barx+barWidth &&  mouseY >= bary && mouseY <= bary+barHeightO) {
      over = true;
    } else {
      over = false;
    }
  }
} // clase

