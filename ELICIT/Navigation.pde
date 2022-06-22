
/*
************************************** ZOOM IN/OUT *************************************
*/

void mouseWheel(MouseEvent e){
  float z;
  float z0;
  
  if (!genow) { z = mapz; }
  else { z = mapz2; }
  
  z0 = (e.getCount()/map(z, 0.5f, 4f, 50f, 1f));
  
  if (z<0.3)                { z0 *= 0.25; }
  else if (z>=0.3 && z<0.5) { z0 *= 0.5; }
  else if (z>=0.5 && z<1)   { z0 *= 1; }
  else if (z>=1 && z<2)     { z0 *= 1.5; }
  else                      { z0 *= 2; }
  
  z -= z0;
  z = constrain(z, 0.01f, 4f);
  
  zoom(z, mouseX, mouseY);
}

void zoom(float z, float xx, float yy) { 
  
  if (!genow) {
    mapx += map((mapx-xx), 0, mapz, 0, (z-mapz));
    mapy += map((mapy-yy), 0, mapz, 0, (z-mapz));
    mapz = z;
    scrollLimit();
  }
  else {
    mapx2 += map((mapx2-xx), 0, mapz2, 0, (z-mapz2));
    mapy2 += map((mapy2-yy), 0, mapz2, 0, (z-mapz2));
    mapz2 = z;
  }
  
}



/*
************************************* DRAG-NAVIGATION *****************************************
*/

float mx, my;
boolean mr=true;
void mouseDragged() {
  if (mouseButton == RIGHT) {
    
    if (mr) {
      mx = mouseX;
      my = mouseY;
      mr = false;
    }
    
    if (!genow) {
      mapx -= mx-mouseX;
      mapy -= my-mouseY;
      scrollLimit();
    } else {
      mapx2 -= mx-mouseX;
      mapy2 -= my-mouseY;
    }
    
    mx = mouseX;
    my = mouseY;
  }
  else {
    if ((mouseY>=height-(nav*3) && mouseX>hudw && hscr) || hscr) {
      horScroll();
    }
  }
}

void mouseReleased() {
  mr = true;
  hscr = false;
}

void scrollLimit() {
    float minx;
    float maxx;
    float miny;
    float maxy;
    
    minx =  (width/2) + hudw/2;
    maxx = -(nsize+esize+minim)*mapz*(num_c-1) + (width/2) + hudw/2;
    miny =  height/2;
    maxy = -(nsize+minim)*mapz*(num_l) + (height/2);
    
    if (mapx>minx) { mapx = minx; }
    else if (mapx<maxx) { mapx = maxx; }
    if (mapy>miny) { mapy = miny; }
    else if (mapy<maxy) { mapy = maxy; }
    
    navx = map(mapx, minx, maxx, navmin+hudw, width-navmin);
}

/*
******************************** EXTEND AND COMPRESS EDGE-SPACE ***********************************
*/

void keyPressed() {
  if (key == 'q') {
    //Testing
    
    println("ID: "+indCurr.id+"; Pop: "+indCurr.idpop+"; Pos: "+indCurr.pos+"; Fit: "+indCurr.fit+"; Type: "+indCurr.type);
    println("M/ID: "+indCurr.mother.id+"; Pop: "+indCurr.mother.idpop+"; Pos: "+indCurr.mother.pos+"; Fit: "+indCurr.mother.fit+"; Type: "+indCurr.mother.type);
    for (int i=0; i<indCurr.values.length; i++) {
      println( indCurr.values[i] +" "+ indCurr.mother.values[i] );
    }
  }
  
  if (keyCode == RIGHT) {
    if (!genow) {
      expandGraph(mouseX);
    } else {
      changeTime(indCurr.idpop+1);
    }
  }
  else if (keyCode == LEFT) {
    if (!genow) {
      closeGraph(mouseX, true);
    } else {
      changeTime(indCurr.idpop-1);
    }
  }
  else if (keyCode == DOWN) {
    if (!genow) {
      closeGraph(mouseX, false);
    }
  }
  else if (key == 'z') {
    if (!genow) {
      if (bez) {bez = false;}
      else {bez = true;}
    }
  }
  else if (key == 's') {
    save("visuals/"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".png");
  }
}

void expandGraph (float xx) {
  esize+=inc;
  if (esize<=inc*5) {
    setPositions();
    
    float sizex0 = (num_c*nsize+(num_c-1)*(esize-inc))*mapz;
    float sizex =  (num_c*nsize+(num_c-1)*esize)*mapz;
    float m = map((mapx-xx), 0, sizex0, 0, (sizex-sizex0));
    mapx += m;
    
    scrollLimit();
  }
  else { esize-=inc; }
}

void closeGraph (float xx, boolean bool) {
  
  if (bool) {
    esize-=inc;
  } else {
    esize=minim;
  }
  
  if (esize>=minim) { 
    setPositions();
    
    float sizex0 = (num_c*nsize+(num_c-1)*(esize+inc))*mapz;
    float sizex =  (num_c*nsize+(num_c-1)*esize)*mapz;
    float m = map((mapx-xx), 0, sizex0, 0, (sizex-sizex0));
    mapx += m;
    
    scrollLimit();
  }
  else { esize+=inc; }
}



/*
************************************** MOUSE HOVER SELECTION *************************************
*/

void mouseHover() {
  
  //Unselects last selected
  if (pos[0]>-1) {
    if (pos[1]>-1) { //previous selected was a node
      pops.get(pos[0]).pop.get(pos[1]).mouse = false;
    } else { //previous selected was a collumn
      pops.get(pos[0]).mouse = false;
    }
  }
  
  pos[0] = -1;
  pos[1] = -1; 
  
  //MOUSE POSITION # # #
  
  //Verifies if it's not on the interface
  if (!(mouseY>height-(nav*3) || mouseX<=hudw)) {
    
    //Verifies if it's inside the node table
    if (mouseX>=mapx && mouseX<=mapx+((nsize * (num_c)) + (esize * (num_c-1))) * mapz && mouseY>=mapy && mouseY<=mapy+((nsize * (num_l)) + (minim * (num_l-1)) +coltop) * mapz) {
      
      //Verifies if it's hovering on the collumn buttons
      if (mouseY<=mapy+(coltop*mapz)) {
        //Goes through every collumn and breaks when it finds one it's on and selects it
        for (Population p : pops) {
          float xx = (p.x*mapz)+mapx;
          float yy = (p.y*mapz)+mapy;
          if (mouseX>xx && mouseX<xx+nsize*mapz && mouseY>yy && mouseY<yy+coltop*mapz) {
            p.mouse = true;
            pos[0] = p.id;
            break;
          }
        }
      }
      else {
        
        boolean brk = false;
        //Goes through every node and breaks when it finds one it's on and selects it
        for (Population p : pops) {
          for (int i=0; i<p.pop.size(); i++) {
            Indiv ind = p.pop.get(i);
            float xx = (ind.x*mapz)+mapx;
            float yy = (ind.y*mapz)+mapy;
            float ss = nsize*mapz;
            if (mouseX>xx && mouseX<xx+ss && mouseY>yy && mouseY<yy+ss) {
              ind.mouse=true;
              pos[0] = ind.idpop;
              pos[1] = i;
              brk = true;
              break;
            }
          }
          if (brk) { break; }
        }
        
      }
    }
    else {
      pos[0] = -1;
      pos[1] = -1; 
    }
    
  }
}


/// ---------------------------------- Bottom Navigation Bar
int nav = 10;
float navmin = nav*1.5f;
float navx = navmin+hudw;
float navx2 = navmin+hudw;

void navBar(float navx0) {
  //White box
  noStroke();
  fill(0,0,100);
  rect(hudw, height-50, width-hudw, 50);
  
  //Separation line
  stroke(0);
  strokeWeight(2);
  line(hudw, height-49, width, height-49);
  
  //Scroll bar
  stroke(0,0,0,50);
  line(navmin+hudw, height-(nav*1.5), width-navmin, height-(nav*1.5));
  
  noStroke();
  fill(0,0,0);
  rect(navx0-(nav/4), height-(nav*2.25), nav/2, nav*1.5);
  
  if (genow) {
    //Number when bar is scrolling
    textAlign(CENTER);
    fill(0,0,0);
    text("Generation : "+(indCurr.idpop+1), mid, height-nav*3);
    textAlign(LEFT);
  }
}

int alpscr = 0;
int cgen0 = 0;
void writeScroll() {
  textAlign(CENTER);
  fill(0,0,0,alpscr);
  text("Generation : "+cgen0, mid, height-nav*3);
  textAlign(LEFT);
  
  alpscr-=2;
}

int prevPos = -1;
void horScroll() {
  if (!genow) { //Population horizontal scroll
    navx = mouseX;
    if (navx<navmin+hudw) { navx = navmin+hudw; }
    else if (navx>width-navmin) { navx = width-navmin; }
    
    int cgen = round(map(navx, navmin+hudw, width-navmin, 0, num_c-1));
    mapx = -(nsize+esize+minim)*mapz*cgen + (width/2) + hudw/2 -(nsize/2*mapz);
    
    cgen0 = cgen+1;
    alpscr = 100;
    
    strokeWeight(0.5f);
    stroke(0);
    //line(mid, 0, mid, mapy-5);
    //if ( mapy+(nsize*num_l+coltop)*mapz+5<height-60 ) { line(mid, mapy+(nsize*num_l+coltop)*mapz+5, mid, height-60); }
    dashedVLine(round(mid), 0, round(mapy)-2, round(dist(mid, 0, mid, mapy-2))/6);
    float h0 = round(mapy+(nsize*num_l+coltop)*mapz)+2;
    if ( h0<height-57 ) { dashedVLine(round(mid), round(h0), height-60, round(dist(mid, h0, mid, height-57))/6); }
    
    //Triangle arrow
    strokeWeight(1.4f);
    stroke(0,0,100);
    fill(0);
    triangle( mid-6,height-49,  mid+6,height-49,  mid,height-55 );
    
    stroke(0);
    strokeWeight(2);
    line(hudw, height-49, width, height-49);
    noStroke();
    
  }
  else if (genow && filesel>-1) { //Timeline traveler
    navx2 = mouseX;
    if (navx2<navmin+hudw) { navx2 = navmin+hudw; }
    else if (navx2>width-navmin) { navx2 = width-navmin; }
    
    int cgen = round(map(navx2, navmin+hudw, width-navmin, 0, timeline.size()-1));
    
    if (cgen!=prevPos) {
      prevPos = cgen;
      
      indCurr.msel2 = false;
      if ((indCurr.idpop!=pos2[0] || indCurr.pos!=pos2[1]) && !timel) {
        indCurr.msel = false; }
        
      Indiv indOld = indCurr;
      indCurr = timeline.get(cgen);
      indCurr.compareTree(indOld);
      
      indCurr.msel2 = true;
      indCurr.msel = true;
      
      updateGenoSel(false);
    }
  }
}


boolean changeTime(int cgen) {
  if (cgen>timeline.size()-1 || cgen<0) { return false; }
  
  indCurr.msel2 = false;
  if ((indCurr.idpop!=pos2[0] || indCurr.pos!=pos2[1]) && !timel) {
    indCurr.msel = false; }
    
  Indiv indOld = indCurr;
  indCurr = timeline.get(cgen);
  indCurr.compareTree(indOld);
  
  indCurr.msel2 = true;
  indCurr.msel = true;
  
  updateGenoSel(true);
  
  return true;
}




void mousePressed() {
  
  //This will stop the animation if the mouse is pressed at any point during it
  if ((mouseX>butx && mouseX<butx+buts && mouseY>but101y && mouseY<but101y+buts && genow) && filesel>-1 || playing) {
    if (playing) { playing=false; } 
    else {
      if (indCurr.idpop>=timeline.size()-1) {
        changeTime(0);
      }
      playing=true;
      playTime=0;
    }
  }
  
  if (mouseY>=height-(nav*3) && mouseX>hudw) {
    horScroll();
    hscr = true;
  }
  
  //Genotype View
  else if (mouseX>0 && mouseX<hudw/2 && mouseY>textg2 && mouseY<texth2) {
    if (genow) {
      genow = false;
    }
  }
  else if (mouseX>=hudw/2 && mouseX<hudw && mouseY>textg2 && mouseY<texth2 && !lockind) {
    if (!genow) {
      genow = true;
      
      if (eva) { eva = false; }
      
      if (indCurr==null) {
        newIndCurr(pos2[0], pos2[1]);
      }
      if (!timel) { fixSelection(pos2[0], pos2[1]); }
      
      if (filesel==-1) { updateGenoSel(false); }
      
    }
  }
  
  //Multiple Files Buttons
  else if (mouseX>butx && mouseX<butx+buts && mouseY>but7y && mouseY<but7y+buts && filesel>-1 && runs.size()>1) {
    
    preLoad(4);
  }
  else if (mouseX>butx+tbutx && mouseX<butx+buts+tbutx && mouseY>but7y && mouseY<but7y+buts && runs.size()>1) {
    
    preLoad(5);
  }
  else if (mouseX>butx+tbutx*2 && mouseX<butx+buts+tbutx*2 && mouseY>but7y && mouseY<but7y+buts && filesel>-1 && runs.size()>1) {
    
    preLoad(6);
  }
  
  
  if (!genow) {
    //Bezier Button
    if (mouseX>butx && mouseX<butx+buts && mouseY>but11y && mouseY<but11y+buts && esize>0) {
      //closeGraph((width-hudw)/2+hudw);
      preLoad(2);
    }
    else if (mouseX>butx+tbutx && mouseX<butx+tbutx+buts && mouseY>but11y && mouseY<but11y+buts && esize<inc*5) {
      //expandGraph((width-hudw)/2+hudw);
      preLoad(3);
    }
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but12y && mouseY<but12y+buts) {
      if (bez) {bez = false;}
      else {bez = true;} }
    
    //Color Buttons
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but21y && mouseY<but21y+buts) {
      colswitch = 0; }
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but22y && mouseY<but22y+buts) {
      colswitch = 1; }
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but23y && mouseY<but23y+buts) {
      colswitch = 2; }
    
    //Genetic Operator Buttons
    else if (mouseX>butx && mouseX<butx+buts*2+(tbutx/4) && mouseY>but30y && mouseY<but30y+buts) {
      colswitch = 1;
      gop = 0;
      fixTypeColor();
    }
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but31y && mouseY<but31y+buts) {
      colswitch = 1;
      gop = 1;
      fixTypeColor();
    }
    else if (mouseX>butx+tbutx && mouseX<butx+tbutx+buts && mouseY>but31y && mouseY<but31y+buts) {
      colswitch = 1;
      gop = 2;
      fixTypeColor();
    }
    else if (mouseX>butx+tbutx*2 && mouseX<butx+tbutx*2+buts && mouseY>but31y && mouseY<but31y+buts) {
      colswitch = 1;
      gop = 3;
      fixTypeColor();
    }
    else if (mouseX>butx+tbutx*2 && mouseX<butx+tbutx*2+buts && mouseY>but30y && mouseY<but30y+buts) {
      colswitch = 1;
      gop = 4;
      fixTypeColor();
    }
      
    //Chromosome Buttons
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but32y && mouseY<but32y+buts && !locktyp) {
      colswitch = 1;
      seltyp=1;
    }
    else if (mouseX>butx+tbutx && mouseX<butx+tbutx+buts && mouseY>but32y && mouseY<but32y+buts && !locktyp) {
      colswitch = 1;
      seltyp=2;
    }
    
    //Mode Buttons
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but61y && mouseY<but61y+buts) {
      if (fitpos) {
        fitpos=false; } 
      else {
        fitpos=true; }
      setPositions();
    }
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but62y && mouseY<but62y+buts) {
      if (eva) {
        eva = false;
        selectionUpdate(pos2[0], pos2[1]);
      }
      else {
        if (timel) {
          timel=false;
          selectTimeline(false); }
        
        eva = true;
        selectionUpdate(pos2[0], -1);
        pos2[1] = -1;
      }
    }
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but63y && mouseY<but63y+buts  && !lockind) {
      if (timel) {
        timel=false;
        selectTimeline(false);
      } 
      else {
        if (pos2[1]>-1 || eva) {
          if (eva) { eva = false; }
          fixSelection(pos2[0], pos2[1]);
          selectTimeline(true);
        }
        timel=true;
      }
    }
  
  }
  else {
    
    //Chromosome Switch
    if (mouseX>butx && mouseX<butx+buts && mouseY>but91y && mouseY<but91y+buts && !locktyp) {
      seltyp=1;
    }
    else if (mouseX>butx+tbutx && mouseX<butx+tbutx+buts && mouseY>but91y && mouseY<but91y+buts && !locktyp) {
      seltyp=2;
    }
    
    //Timeline Controls
    //Playing button at the top of this function
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but102y && mouseY<but102y+buts && filesel>-1) {
      changeTime(indCurr.idpop-1); }
    else if (mouseX>butx+tbutx && mouseX<butx+buts+tbutx && mouseY>but102y && mouseY<but102y+buts && filesel>-1) {
      changeTime(indCurr.idpop+1); }
    
    //Graph Filter
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but81y && mouseY<but81y+buts) {
      if (linet) { linet=false; } 
      else { linet=true; } }
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but82y && mouseY<but82y+buts && !locktyp) {
      if (linec) { linec=false; } 
      else { linec=true; } }
    
    //Tree
    else if (mouseX>butx && mouseX<butx+buts && mouseY>but111y && mouseY<but111y+buts) {
      resetTreePos(); }
      
  }
  
  //Java2D Save Button
  if (mouseX>but51x && mouseX<but51x+58 && mouseY>but5y && mouseY<but5y+18) {
    preLoad(0);
  }
  //P3D Save Button
  else if (mouseX>but52x && mouseX<but52x+58 && mouseY>but5y && mouseY<but5y+18) {
    preLoad(1);
  }
  
}

void fixTypeColor() {
  if (filesel==-1) {
    for (Population p : pops) {
      for (Indiv i : p.pop) {
        i.typeColor(); }}}
}

void changeRun(ArrayList<Population> run) {
  
  resetSel(pops);
  pops = run;
  selectionUpdate(pos2[0], pos2[1]);
  setPositions();
}


void saveImg(boolean pdf) {
  int ww = ceil( ((nsize * (num_c+2)) + (esize * (num_c-1))) * mapz );
  int hh = ceil( ((nsize * (num_l+2)) + (minim * (num_l-1))) * mapz );
  
  if (pdf) {
    buffer = createGraphics(ww, hh, PDF, "visuals/"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".pdf");
  }
  else {
    if (esize>minim) {
      buffer = createGraphics(ww, hh, JAVA2D);
    } else {
      buffer = createGraphics(ww, hh, P3D);
    }
  } 
  
  buffer.beginDraw();
  buffer.ellipseMode(CORNER);
  buffer.colorMode(HSB, 360, 100, 100, 100);
  buffer.background(0,0,100);
  
  
  if (esize>minim) { //Draws the connections first, if the graph is open
    if (filesel>-1) {
      for (Population p : pops) {
        for (Indiv ind : p.pop) {
          ind.bufferLink();
        }
      }
    } else {
      for (ArrayList<Population> pops0 : runs) {
        for (Population p : pops0) {
          for (Indiv ind : p.pop) {
            ind.bufferLink();
          }
        }
      }
    }
  }
  for (Population p : pops) {
    if (mode && !fitpos) { //In the "fitness by position" mode, draws the selected on top
      for (Indiv ind : p.pop) {
        if (!ind.sel) { //Unselected
          ind.buffer();
        }
      }
      for (Indiv ind : p.pop) {
        if (ind.sel) { //Selected
          ind.buffer();
        }
      }
    }
    else { 
      for (Indiv ind : p.pop) {
        ind.buffer();
      }
    }
  }
  
  //Redraw selected nodes on top to fix drawing order
  for (Population p : pops) {
    for (Indiv i : p.pop) {
      if (i.msel) {
        i.buffer();
      }
    }
  }
  
  if (pdf) {
    buffer.dispose();
    buffer.endDraw();
  }
  else {
    buffer.endDraw();
    buffer.save("visuals/"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".png");
  }
}

//Try making a bufferedimg the size of the screen, drawing everything on there and then pasting it on the screen and just switch the render when saving an image.

void saveImg2(boolean pdf) {
  if (!pdf) {
    
    PImage img = get(round(hudw), 0, round(width-hudw), height-50);
    img.save("visuals/"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".png");
    
  } else {
    
    beginRecord(PDF, "visuals/"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".pdf");
    ellipseMode(CENTER);
    colorMode(HSB, 360, 100, 100, 100);
    background(0,0,100);
    
    pdf0 = true;
    drawGenotype();
    pdf0 = false;
    
    endRecord();
    
  }
}
