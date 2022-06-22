
void drawGenotype() {
  
  //Top right : Tree
  pushMatrix();
  translate(0,0,-1);
  if (filesel>-1) {
    if (locktyp) {
      drawTree(indCurr.tree);
    } else {
      if (seltyp==1) {
        drawTree(indCurr.tree);
      } else {
        drawTree(indCurr.tree2);
      }
    }
  }
  popMatrix();
  
  //Top left : Graphs
  if (filesel>-1) {
    noStroke();
    fill(0,0,100);
    rect(hudw, 0, (width-hudw)/3, height-50);
    stroke(0);
    strokeWeight(2f);
    line(hudw+(width-hudw)/3, 0, hudw+(width-hudw)/3, height-50);
    
    if (pdf0) { line(hudw+(width-hudw)/3, 0, hudw+(width-hudw)/3, height); }
    
    int grpx = round( hudw+((width-hudw)/2)*0.06 );
    int grpy = round( (height/2)*0.4 );
    int grpw = round( ((width-hudw)/3)*0.8 );
    int grph = round( (height/2)*0.6 );
    
    //Small graph and text vertical pos
    //int grpy2 = round(grpy+grph*1.3);
    //int grpy3 = round(grpy+grph*1.93);
    int grpy2 = round(grpy+grph*1.4);
    int grpy3 = round(grpy+grph*2.08);
    
    if (pdf0) { grpx = round( hudw*2/3 ); }
    
    textFont(fontxsmall, subt);
    
    
    //Main Graph
    noFill();
    sz = 6;
    drawGraph(grpx, grpy, grpw, grph, getMax(currMaxes(maxes, true)), getMin(currMaxes(mins, false)), indCurr);
    
    //Mother Graph
    if (indCurr.mother!=null) {
      sz = 5;
      drawGraph(grpx-2, grpy2, grpw*0.45, grph*0.45, getMax(currMaxes(maxes_m, true)), getMin(currMaxes(mins_m, false)), indCurr.mother);
      
      fill(0);
      textAlign(CENTER);
      if (indCurr.father!=null) {
        if (!locktyp) { text("Mother",   round(grpx+(grpw*0.45/2)), grpy3); }
        else { text("Crossover",   round(grpx+(grpw*0.45/2)), grpy3); }
      }
      else {
             if (indCurr.type==0) { text("Copy",     round(grpx+(grpw*0.45/2)), grpy3); }
        else if (indCurr.type==1) { text("Mutation", round(grpx+(grpw*0.45/2)), grpy3); }
        else if (indCurr.type==2) { text("Mother",   round(grpx+(grpw*0.45/2)), grpy3); }
      }
      textAlign(LEFT);
    }
    //Father Graph
    if (indCurr.father!=null) {
      noFill();
      sz = 5;
      drawGraph(grpx+grpw*0.55 +7, grpy2, grpw*0.45, grph*0.45, getMax(currMaxes(maxes_f, true)), getMin(currMaxes(mins_f, false)), indCurr.father);
      
      fill(0);
      if (!locktyp) { 
        textAlign(CENTER);
        text("Father", round(grpx+grpw*0.55+(grpw*0.45/2)), grpy3);
        textAlign(LEFT);
      }
      
    }
    
  }
  
  else {
    //Large graph for multiple files
    
    int grpx = round( hudw+((width-hudw)/2)*0.1 );
    int grpy = round( (height/2)*0.3 );
    int grpw = round( ((width-hudw))*0.9 );
    int grph = round( (height)*0.75 );
    
    float max0 = getMax(currMaxes(maxes, true));
    float min0 = getMin(currMaxes(mins, false));
    
    float mina = 100/runs.size()*2;
    if (mina<25) { mina=25; }
    
    noFill();
    strokeWeight(1.5f);
    
    if (linet) {
      drawCurve(grpx, grpy, grpw, grph, target.get(filesel), max0, min0, 0, 100);
    }
    
    for (int i=0; i<runs.size(); i++) {
      Indiv ind = runs.get(i).get(indCurr.idpop).pop.get(indCurr.pos);
      
      if (locktyp) {
        drawCurve(grpx, grpy, grpw, grph, ind.values, max0, min0, 1, mina); 
      } else {
        if (seltyp==1) {
          if (linec) {
            drawCurve(grpx, grpy, grpw, grph, ind.values2, max0, min0, 2, mina); } 
          drawCurve(grpx, grpy, grpw, grph, ind.values, max0, min0, 1, mina); 
        } else {
          if (linec) {
            drawCurve(grpx, grpy, grpw, grph, ind.values, max0, min0, 1, mina); }
          drawCurve(grpx, grpy, grpw, grph, ind.values2, max0, min0, 2, mina);
        }
      }
    }
    
    int axis = round(map(0, min0, max0, grpy, grpy+grph));
    strokeWeight(0.5f);
    stroke(0);
    dashedHLine(round(grpx), round(grpx+grpw), axis, 45);
    dashedVLine(round(grpx+(grpw/2)), round(grpy), round(grpy+grph), 28);
    
    fill(0,0,25);
    textAlign(CENTER);
    text(fitText2(max0), round(grpx+(grpw/2)), round(grpy)-8);
    text(fitText2(min0), round(grpx+(grpw/2)), round(grpy+grph)+15);
    textAlign(RIGHT);
    text("-1", round(grpx-10), axis+3);
    textAlign(LEFT);
    text("1", round(grpx+grpw+10), axis+3);
    noFill();
  }
  
}

void dashedHLine(int xi, int xf, int y, int spc) {
  //dashed horizontal line for the x axis of the graphs: start pos, height and nubmer of spaces
  float len = (xf-xi)/((spc*2)+1.0);
  for (int i=0; i<(spc*2)+1; i+=2) {
    line(xi+len*i-len*0.1,y, xi+len*(i+1)+len*0.1,y);
  }
}
void dashedVLine(int x, int yi, int yf, int spc) {
  //dashed horizontal line for the x axis of the graphs: start pos, height and nubmer of spaces
  float len = (yf-yi)/((spc*2)+1.0);
  for (int i=0; i<(spc*2)+1; i+=2) {
    line(x,yi+len*i-len*0.1, x,yi+len*(i+1)+len*0.1);
  }
}


void drawGraph(float grpx, float grpy, float grpw, float grph, float max0, float min0, Indiv ind) {
  
  if (max0<0) { max0 = 0; }
  if (min0>0) { min0 = 0; }
  
  float maxx0 = getMax(targetx.get(filesel));
  if (maxx0<0) { maxx0 = 0; }
  float minx0 = getMin(targetx.get(filesel));
  if (minx0>0) { minx0 = 0; }
  
  //strokeWeight(1.5f);
  noStroke();
  if (linet) {
    drawCurve(grpx, grpy, grpw, grph, target.get(filesel), max0, min0, 0, 100);
  }
  
  if (locktyp) {
    drawCurve(grpx, grpy, grpw, grph, ind.values, max0, min0, 1, 100);
  } else {
    if (seltyp==1) {
      if (linec) {
        drawCurve(grpx, grpy, grpw, grph, ind.values2, max0, min0, 2, 100); }
      drawCurve(grpx, grpy, grpw, grph, ind.values, max0, min0, 1, 100);
    } else {
       if (linec) {
        drawCurve(grpx, grpy, grpw, grph, ind.values, max0, min0, 1, 100); }
      drawCurve(grpx, grpy, grpw, grph, ind.values2, max0, min0, 2, 100);
    }
  }
  
  //find the position of the y axis, x=0
  int axis = round(map(0, min0, max0, grpy+grph, grpy));
  int axis_y = round(map(0, minx0, maxx0, grpx, grpx+grpw));
  
  if (axis>grpy+grph) { axis = round(grpy+grph); }
  else if (axis<grpy) { axis = round(grpy); }
  
  if (axis_y>grpx+grpw) { axis_y = round(grpx+grpw); }
  else if (axis_y<grpx) { axis = round(grpx); }
  
  strokeWeight(0.5f);
  stroke(0);
  dashedHLine(round(grpx), round(grpx+grpw), axis, 25);
  dashedVLine(axis_y, round(grpy), round(grpy+grph), 18);
  
  fill(0,0,25);
  textAlign(CENTER);
  text(fitText2(max0), axis_y, round(grpy)-8);
  text(fitText2(min0), axis_y, round(grpy+grph)+15);
  textAlign(RIGHT);
  text(fitText2(minx0), round(grpx-(grpw/50)), axis+3);
  textAlign(LEFT);
  text(fitText2(maxx0), round(grpx+grpw+(grpw/50)), axis+3);
  noFill();
  
}

float getMax(float[] values) {
  float max = -10000;
  for (float i : values) {
    if (i>max && !Float.isNaN(i) && !Float.isInfinite(i)) { max = i; }
  }
  return max;
}
float getMin(float[] values) {
  float min = 100000;
  for (float i : values) {
    if (i<min && !Float.isNaN(i) && !Float.isInfinite(i)) { min = i; }
  }
  return min;
}

int sz;
void drawCurve(float x, float y, float w, float h, float[] values, float max, float min, int col, float alp) {
  float inc = w/(values.length-1);
  float x1, y1, x2, y2;

  //beginShape();
  //vertex(x, map(values[0], min, max, y, y+h));
  //for (int i=1; i<values.length; i++) {
    //vertex((i*inc)+x, map(values[i], min, max, y+h, y));
  //}
  //for (int i=0; i<values.length; i++) {
  //  vertex(map(targetx[i], ms_x[0], ms_x[1], x, x+w), map(values[i], min, max, y+h, y));
  //}
  //endShape();
  
  boolean circle = true;
  if (col==0) {
    circle = false;
    stroke(0,  0,  0, 75);
  } else if (col==1) {
    fill(45,  95,  85, alp);
  } else if (col==2) {
    fill(200, 100, 85, alp);
  }
  
  for (int i=0; i<values.length; i++) {
    float tx = targetx.get(filesel)[i];
    float ty = values[i];
    
    if (!Float.isNaN(tx) && !Float.isNaN(ty) && !Float.isInfinite(tx) && !Float.isInfinite(ty)) {
      float cx = map(tx, ms_x[0], ms_x[1], x, x+w);
      float cy = map(ty, min, max, y+h, y);
      if (circle) {
        noStroke();
        ellipse(cx, cy, sz, sz);
      } else {
        strokeWeight(1);
        int ll = 2;
        line(cx-ll, cy-ll, cx+ll, cy+ll);
        line(cx+ll, cy-ll, cx-ll, cy+ll);
      }
    }
  }
  
}

float[] currMaxes(float[] cmaxes, boolean mxmn) {
  //Receives one of the arrays of max or min values and outputs one with only the currently selected values
  //[target, chrm1, chrm2]
  
  float[] newmaxes = new float[0];
  
  if (linet) { //Target is on
    if (mxmn) {
      newmaxes = append(newmaxes, getMax(target.get(filesel)));
    } else {
      newmaxes = append(newmaxes, getMin(target.get(filesel)));
    }
  }
  if (locktyp) { //Only one chromossome
    newmaxes = append(newmaxes, cmaxes[1]);
  }
  else {
    if (seltyp==1) { //1st Chromosome Selected
      if (linec) { //Showing both
        newmaxes = append(newmaxes, cmaxes[2]);
      }
      newmaxes = append(newmaxes, cmaxes[1]);
    }
    else { //2nd Chromosome Selected
      if (linec) { //Showing both
        newmaxes = append(newmaxes, cmaxes[1]);
      }
      newmaxes = append(newmaxes, cmaxes[2]);
    }
  }
  
  return newmaxes;
}

void drawGenoSubs() {
  strokeWeight(2);
  //Text and subtitles
  fill(0);
  textFont(fontsmall, title);
  text("Individual View", hudw+titlex, 30);
  
  float xsym = hudw+titlex;
  float ysym = 36;
  
  stroke(0);
  fill(0);
  rect(xsym+3, ysym+3, buts-6, buts-6);
  if (locktyp) {
    fill(c_sel);
    rect(xsym+57+3, ysym+3, buts-6, buts-6);
  } else {
    fill(c_sel);
    rect(xsym+57+3, ysym+3, buts-6, buts-6);
    fill(200, 100, 100);
    rect(xsym+167+3, ysym+3, buts-6, buts-6);
  }
  
  fill(0);
  textFont(fontxsmall, subt);
  text("Target", xsym+17,  ysym+12);
  if (locktyp) {
    text("Individual", xsym+75, ysym+12);
  } else {
    text("1st Chromosome", xsym+74,  ysym+12);
    text("2nd Chromosome", xsym+185, ysym+12);
  }
}