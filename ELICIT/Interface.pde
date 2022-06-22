//Interface Settings

//Font sizes
int title = 16;
int subt = 13;

//Basic Positions
int titlex = 15;  // title x pos
int butx = 16;    // button x pos
int buts = 15;    // button size
int subtx = 38;   // subtitle x pos
int subty = 12;   // subtitle y diff from button

int tbutx = 20; // type button x diff

//Generation-Fitness
int textg  = 28;

//Genotype Switch
int textg2  = 90;
int texth2  = textg2+24;

int top = 148;
//Multiple Files
int text7y = top;
int but7y  = text7y+13;
//Connections
int text1y = but7y+47;
int but11y = text1y+13;
int but12y = but11y+20;
//Color
int text2y = but12y+47;
int but21y = text2y+13;
int but22y = but21y+20;
int but23y = but22y+20;
//Type
int text3y = but23y+47;
int but30y = text3y+13;
int but31y = but30y+20;
int but32y = but31y+20;
//Mode
int text6y = but32y+47;
int but61y = text6y+13;
int but62y = but61y+20;
int but63y = but62y+20;

//Timeline
int text10y = but7y+47;
int but101y = text10y+13;
int but102y = but101y+20;
//Chromosome
int text9y = but102y+47;
int but91y = text9y+13;
//Graph
int text8y = but91y+47;
int but81y = text8y+13;
int but82y = but81y+20;
//Tree
int text11y = but82y+47;
int but111y = text11y+13;

//Save
int text5y = 600;
int but5y  = text5y+10;
int but51x = 15;
int but52x = 77;

void drawInterface() {
  fill(0);
  strokeWeight(2);
  noStroke();
  rect(0, 0, hudw, height);
  
  fill(0, 0, 100);
  textFont(fontxsmall, subt);
  text("Generation : ", titlex, textg);
  text("Position : ",   titlex, textg+20);
  text("Fitness : ",    titlex, textg+40);
  String ffit;
  String ppos;
  String ggen;
  
  if (pos[0]>-1) {
    if (pos[1]>-1) {
      ffit = fitText(pops.get(pos[0]).pop.get(pos[1]).fit);
      ppos = ""+(pos[1]+1); }
    else {
      ffit = fitText(pops.get(pos[0]).pop.get(0).fit);
      ppos = ""+1; }
    ggen = ""+(pos[0]+1);
  }
  else {
    /*
    if (pos2[0]>-1) {
      if (pos2[1]>-1) {
        ffit = fitText(pops.get(pos2[0]).pop.get(pos2[1]).fit);
        ppos = ""+(pos2[1]+1); }
      else {
        ffit = fitText(pops.get(pos2[0]).pop.get(0).fit);
        ppos = i""+1; }
      ggen = ""+(pos2[0]+1);
    }
    */
    if (indCurr!=null) {
      ggen = ""+(indCurr.idpop+1);
      ppos = ""+(indCurr.pos+1);
      ffit = fitText(indCurr.fit);
    }
    else {
      textFont(fontxsmall, subt);
      ggen = ppos = ffit = "— ";
    }
  }
  
  textFont(fontxsmall, subt);
  text("Generation : "+ggen, titlex, textg);
  text("Position : "+ppos,   titlex, textg+20);
  text("Fitness : "+ffit,    titlex, textg+40);
  
  
  //Switch between Normal and Genotype views
  stroke(0,0,100);
  
  text("Full View", 14, textg2+16);
    if (lockind) { fill(0,0,50); }
  text("Individual", 89, textg2+16);
  
  line(0, textg2, hudw, textg2);
  line(hudw/2, texth2+1, hudw/2, textg2);
  
  if (lockind) {
    stroke(0,0,50);
    line(hudw/2+1, textg2, hudw, textg2);
    stroke(0,0,100);
  }
  
  //Bottom line switch
  if (!genow) {
    line(hudw/2, texth2, hudw, texth2);
  } else {
    line(0, texth2, hudw/2, texth2);
  }
  
  noStroke();
  
  //Multiple Files
  if (runs.size()==1) { fill(0,0,50); }
  else { fill(0,0,100); }
  textFont(fontsmall, title);
  text("Multiple Files", titlex, text7y);
  textFont(fontxsmall, subt);
  if (filesel == -1) {
    text("File Average", subtx+tbutx*2, but7y+subty); }
  else {
    text("File: "+(filesel+1), subtx+tbutx*2, but7y+subty); }
    
    if (filesel == -1 || runs.size()==1) { fill(0, 0, 50); }
    else { fill(0, 0, 100); }
  rect(butx, but7y, buts, buts);
    if (filesel == -1) { fill(0, 0, 100); }
    else { fill(0, 0, 100); }
  rect(butx+tbutx, but7y, buts, buts);
    if (filesel == -1 || runs.size()==1) { fill(0, 0, 50); }
    else { fill(0, 0, 100); }
  rect(butx+tbutx*2, but7y, buts, buts);
  
  fill(0);
  triangle(butx+buts-4, but7y+3,   butx+4, but7y+(buts/2),   butx+buts-4, but7y+buts-3);
  rect(butx+4+tbutx, but7y+4,  buts-8, buts-8);
  triangle(butx+4+tbutx*2, but7y+3,   butx+buts-4+tbutx*2, but7y+(buts/2),   butx+4+tbutx*2, but7y+buts-3);
  
  
  if (!genow) {
    //Bezier Curves
    fill(0,0,100);
    textFont(fontsmall, title);
    text("Connections", titlex, text1y);
    textFont(fontxsmall, subt);
    text("Close / Expand", subtx+tbutx, but11y+subty);
    text("Bezier Curves", subtx, but12y+subty);
    if (esize>0) { fill(0, 0, 100); }
    else { fill(0, 0, 50); }
    rect(butx, but11y, buts, buts);
    if (esize<inc*5) { fill(0, 0, 100); }
    else { fill(0, 0, 50); }
    rect(butx+tbutx, but11y, buts, buts);
    if (bez) { fill(0, 0, 100); }
    else { fill(hudsel); }
    rect(butx, but12y, buts, buts);
    //Minus and plus signs
    stroke(0);
    line(butx+3, but11y+buts/2+0.5f, butx+buts-3, but11y+buts/2+0.5f);
    line(butx+tbutx+3, but11y+buts/2+0.5f, butx+tbutx+buts-3, but11y+buts/2+0.5f);
    line(butx+tbutx+buts/2+0.5f, but11y+3, butx+tbutx+buts/2+0.5f, but11y+buts-3);
    noStroke();
    
    //Color
    fill(0,0,100);
    textFont(fontsmall, title);
    text("Color", titlex, text2y);
    textFont(fontxsmall, subt);
    text("Fitness",  subtx, but21y+subty);
    text("Operators",     subtx, but22y+subty);
    text("Children", subtx, but23y+subty);  
      if (colswitch == 0) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx, but21y, buts, buts);
      if (colswitch == 1) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx, but22y, buts, buts);
      if (colswitch == 2) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx, but23y, buts, buts);
    
//Genetic Operators
    fill(0,0,100);
    textFont(fontsmall, title);
    text("Genetic Operators", titlex, text3y);
    textFont(fontxsmall, subt);
    if (!locktyp) {
      if (mouseX>butx && mouseX<butx+buts && mouseY>but32y && mouseY<but32y+buts && !locktyp) {
        text("1st Chromosome", subtx+tbutx, but32y+subty); }
      else if (mouseX>butx+tbutx && mouseX<butx+tbutx+buts && mouseY>but32y && mouseY<but32y+buts && !locktyp) {
        text("2nd Chromosome", subtx+tbutx, but32y+subty); }
      else {
        if (seltyp==1) { 
          text("1st Chromosome", subtx+tbutx, but32y+subty); }
        else { 
          text("2nd Chromosome", subtx+tbutx, but32y+subty); }
      }
    }
    fill(0,0,100);
    
    if (mouseX>butx && mouseX<butx+buts && mouseY>but31y && mouseY<but31y+buts) {
      text("Copy",      subtx+tbutx*2, but31y+subty); }
    else if (mouseX>butx+tbutx && mouseX<butx+tbutx+buts && mouseY>but31y && mouseY<but31y+buts) {
      text("Mutation",  subtx+tbutx*2, but31y+subty); }
    else if (mouseX>butx+tbutx*2 && mouseX<butx+tbutx*2+buts && mouseY>but31y && mouseY<but31y+buts) {
      text("Crossover", subtx+tbutx*2, but31y+subty); }
    else if (mouseX>butx+tbutx*2 && mouseX<butx+tbutx*2+buts && mouseY>but30y && mouseY<but30y+buts) {
      text("Mutation +", subtx+tbutx*2, but30y+subty);
      text("Crossover", subtx+tbutx*2, but31y+subty); }
    else {
      if (gop==1) {
        text("Copy",      subtx+tbutx*2, but31y+subty); }
      else if (gop==2) {
        text("Mutation",  subtx+tbutx*2, but31y+subty); }
      else if (gop==3) {
        text("Crossover", subtx+tbutx*2, but31y+subty); }
      else if (gop==4) {
        text("Mutation +", subtx+tbutx*2, but30y+subty);
        text("Crossover", subtx+tbutx*2, but31y+subty); }
      else {
        text("Filter", subtx+tbutx*2, but31y+subty); }
    }
    
    if (!locktyp) {
      if (seltyp==1) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx, but32y, buts, buts);
      if (seltyp==2) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx+tbutx, but32y, buts, buts);
    
    stroke(0);
    noFill();
    rect(butx+2,   but32y+2, buts-4, buts-4);
    rect(butx+tbutx+2, but32y+2, buts-4, buts-4);
    fill(0);
    triangle(butx+buts-2, but32y+2,    butx+2, but32y+buts-2,    butx+buts-2, but32y+buts-2);
    triangle(butx+tbutx+buts-2, but32y+2,  butx+tbutx+2, but32y+buts-2,  butx+tbutx+2, but32y+2);
    noStroke();
    }
    
      if (gop==0) { fill(hudsel); } //All
      else {        fill(0, 0, 100); }
    rect(butx, but30y, buts*2+(tbutx/4), buts);
    fill(0);
    text("All", subtx-11, but30y+subty);
      if (gop==1) { fill(hudsel); } //Copy
      else {        fill(0, 0, 100); }
    rect(butx, but31y, buts, buts);
      if (gop==2) { fill(hudsel); } //Mutation
      else {        fill(0, 0, 100); }
    rect(butx+tbutx, but31y, buts, buts);
      if (gop==3) { fill(hudsel); } //Crossover
      else {        fill(0, 0, 100); }
    rect(butx+tbutx*2, but31y, buts, buts);
      if (gop==4) { fill(hudsel); } //Cross+Mut
      else {        fill(0, 0, 100); }
    rect(butx+tbutx*2, but30y, buts, buts);
    
    fill(0); //Symbols
    rect(butx+3, but31y+3, buts-6, buts-6);
    stroke(0);
    noFill();
    rect(butx+tbutx*2+3, but30y+3, buts-6, buts-6);
    
    line(butx+tbutx*2, but31y, butx+tbutx*2+buts, but31y+buts);
    noStroke();
    
    //Mode
    fill(0,0,100);
    textFont(fontsmall, title);
    text("Mode", titlex, text6y);
    textFont(fontxsmall, subt);
    text("Position by Fitness", subtx, but61y+subty);
    text("Eva Mode",            subtx, but62y+subty);
      if (fitpos) { fill(0, 0, 100); }
      else { fill(hudsel);  }
    rect(butx, but61y, buts, buts);
      if (!eva) { fill(0, 0, 100); }
      else { fill(hudsel); }
    rect(butx, but62y, buts, buts);
    
    if (lockind) { fill(0,0,50); }
    else { fill(0,0,100); }
    text("View Timeline",     subtx, but63y+subty);
      if (!timel) { fill(0, 0, 100); }
      else { fill(hudsel); }
      if (lockind) { fill(0,0,50); }
    rect(butx, but63y, buts, buts);
  }
  else {
    
    //Timeline Control
    fill(0,0,100);
    textFont(fontsmall, title);
    text("Timeline", titlex, text10y);
    textFont(fontxsmall, subt);
    text("Play / Stop", subtx, but101y+subty);
    text("Selection", subtx+tbutx, but102y+subty);
      if (playing) { fill(hudsel); }
      else if (filesel==-1) { fill(0, 0, 50); }
      else {    fill(0, 0, 100); }
    rect(butx, but101y, buts, buts);
      if (indCurr.idpop<=0 || filesel==-1) { fill(0, 0, 50); }
      else {    fill(0, 0, 100); }
    rect(butx, but102y, buts, buts);
      if (indCurr.idpop>=timeline.size()-1 || filesel==-1) { fill(0, 0, 50); }
      else {    fill(0, 0, 100); }
    rect(butx+tbutx, but102y, buts, buts);
    
    fill(0);
    triangle(butx+buts-4, but102y+3,   butx+4, but102y+(buts/2),   butx+buts-4, but102y+buts-3);
    triangle(butx+4+tbutx, but102y+3,   butx+buts-4+tbutx, but102y+(buts/2),   butx+4+tbutx, but102y+buts-3);
    
    
    //Chromosome Switch
    fill(0,0,100);
    textFont(fontsmall, title);
    text("Chromosome", titlex, text9y);
    textFont(fontxsmall, subt);
    if (locktyp) {
      fill(0,0,50);
      text("Chromosomes", subtx+tbutx, but91y+subty); }
    else {
      if (mouseX>butx && mouseX<butx+buts && mouseY>but91y && mouseY<but91y+buts && !locktyp) {
        text("1st Chromosome", subtx+tbutx, but91y+subty); }
      else if (mouseX>butx+tbutx && mouseX<butx+tbutx+buts && mouseY>but91y && mouseY<but91y+buts && !locktyp) {
        text("2nd Chromosome", subtx+tbutx, but91y+subty); }
      else {
        if (seltyp==1) { 
          text("1st Chromosome", subtx+tbutx, but91y+subty); }
        else { 
          text("2nd Chromosome", subtx+tbutx, but91y+subty); }
      }
    }
      if (locktyp) { fill(0, 0, 50); }
      else if (seltyp==1) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx, but91y, buts, buts);
      if (locktyp) { fill(0, 0, 50); }
      else if (seltyp==2) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx+tbutx, but91y, buts, buts);
    stroke(0);
    noFill();
    rect(butx+2,   but91y+2, buts-4, buts-4);
    rect(butx+tbutx+2, but91y+2, buts-4, buts-4);
    fill(0);
    triangle(butx+buts-2, but91y+2,    butx+2, but91y+buts-2,    butx+buts-2, but91y+buts-2);
    triangle(butx+tbutx+buts-2, but91y+2,  butx+tbutx+2, but91y+buts-2,  butx+tbutx+2, but91y+2);
    noStroke();
    
    //Graph Filter 
    fill(0,0,100);
    textFont(fontsmall, title);
    text("Graph", titlex, text8y);
    textFont(fontxsmall, subt);
    text("Target Curve",      subtx, but81y+subty);
    if (locktyp) { fill(0,0,50); }
    text("Both Chromossomes", subtx, but82y+subty);  
      if (linet) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx, but81y, buts, buts);
      if (locktyp) { fill(0,0,50); }
      else if (linec) { fill(hudsel); }
      else {    fill(0, 0, 100); }
    rect(butx, but82y, buts, buts);
    
    //Tree
    fill(0,0,100);
    textFont(fontsmall, title);
    text("Tree", titlex, text11y);
    textFont(fontxsmall, subt);
    text("Reset Position", subtx, but111y+subty);
    fill(0, 0, 100);
    rect(butx, but111y, buts, buts);
    
  }
  
  //Save Buttons
  fill(0,0,100);
  textFont(fontsmall, title);
  text("Save to File", titlex, text5y);
  textFont(fontxsmall, subt);
  text("PDF", but51x+18, but5y+13);
  text("PNG", but52x+18, but5y+13);
  strokeWeight(2);
  stroke(0,0,100);
  noFill();
  rect(but51x, but5y, 58, 18);
  rect(but52x, but5y, 58, 18);
  
}

void drawSubtitles() {
  
  //Text "Ancestors | Descendants"
  if (mode) {
    fill(0, 75);
    textFont(fontxsmall, subt);
    
    float mapx_;
    if (eva && pos2[1]==-1 && pos2[2]!=-1) {
      mapx_ = mapx+((pos2[2]*(nsize+esize)+nsize/2)*mapz);
    }
    else {
      mapx_ = mapx+((pos2[0]*(nsize+esize)+nsize/2)*mapz);
    }
    
    if (pos2[0]>0 && !eva) {
      textAlign(RIGHT);
      text("Ancestors  ", mapx_, mapy-5);
    }
    if ( (pos2[0]<num_c-1 && pos2[1]!=-1) || (pos2[0]>0 && pos2[2]>-1 && pos2[2]<num_c-1 && eva)) {
      textAlign(LEFT);
      text("  Descendants", mapx_, mapy-5);
    }
    textAlign(CENTER);
    text("|", mapx_, mapy-5);
    textAlign(LEFT);
  } 
  
  //Extra text
  noStroke();
  
  /*
  //White transparent box
  fill(0, 0, 100, 85);
  int whw, whh; //width and height
  boolean msel = false;
  if ((runs.size()>1 && filesel==-1) || !fitpos || eva) {
    msel = true;
  }
  //Width
  if (colswitch==1 && !locktyp && gop==0) {
    whw = 286;
  }
  else if (colswitch==1 && !locktyp && gop>0) {
    whw = 356;
  } else {
    whw = 262;
  }
  //Height
  if (msel && (colswitch==1)) {
    whh = 80;
  } else if (msel || (colswitch==1)) {
    whh = 60;
  } else {
    whh = 45;
  }
  rect(hudw, 0, whw, whh);
  //*/
  
  fill(0);
  textFont(fontsmall, title);
  
  String s = "";
  //fitpos, eva, seltype
       if (colswitch==0) { s+="Fitness View"; }
  else if (colswitch==1) {
    
          if (seltyp==1 && locktyp)  { s+="Genetic Operator View"; }
     else if (seltyp==1 && !locktyp) { s+="Genetic Operator View - 1st Chromosome"; }
     else if (seltyp==2) { s+="Genetic Operator View - 2nd Chromosome"; }
     
     if (gop==1) { s+=" - Copy"; }
     else if (gop==2) { s+=" - Mutation"; }
     else if (gop==3) { s+=" - Crossover"; } 
     else if (gop==4) { s+=" - Mutation + Crossover"; } 
  }
  else if (colswitch==2) { s+="Number of Children View"; }
  
  text(s, hudw+titlex, 30);
  
  textFont(fontxsmall, subt);
  s = "";
  if (runs.size()>1 && filesel==-1) {
    s+="Total Average";
    
    if (eva || !fitpos) {
      s+=" + ";
    }
  }
       if ( eva && fitpos)             { s+="Eva Mode"; }
  else if (!eva && !fitpos && !timel)  { s+="Position by Fitness"; }
  else if ( eva && !fitpos)            { s+="Position by Fitness + Eva Mode"; }
  else if (timel && fitpos)            { s+="Timeline View"; }
  else if (timel && !fitpos)           { s+="Position by Fitness + Timeline View"; }
  
  text(s, hudw+titlex, 48);
  
  if (colswitch==1) {
    float xsym = hudw+titlex;
    float ysym = 36;
    if ((runs.size()>1 && filesel==-1) || eva || !fitpos || timel) { ysym += 17; }
    
    fill(0);
    stroke(0);
    rect(xsym+3, ysym+3, buts-6, buts-6);
    
    noStroke();
    fill(c_2h, c_2s, c_2b);
    rect(xsym+53, ysym+2, buts-4, buts-4);
    
    stroke(c_2h, c_2s, c_2b);
    rect(xsym+122, ysym+3, buts-6, buts-6);
    stroke(0);
    line(xsym+122, ysym+3, xsym+122+buts-6, ysym+3+buts-6);
    
    fill(c_2h, c_2s, c_2b);
    rect(xsym+199, ysym+3, buts-6, buts-6);
    
    fill(0);
    textFont(fontxsmall, subt);
    text("Copy",      xsym+17,  ysym+12);
    text("Mutation",  xsym+67,  ysym+12);
    text("Crossover", xsym+138, ysym+12);
    text("Mutation + Crossover", xsym+213, ysym+12);
  }
  
}

String fitText(double fit) {
  String s;
  
  if (fit<100) {
    s = String.format("%.7f", fit);
  } else if (fit>=100 && fit<10000) {
    s = String.format("%.4f", fit);
  } else {
    s = String.format("%6.4e", fit);
  }
  
  return s;
}

String fitText2(double fit) {
  String s;
  Boolean bool = false;
  if (fit<0) {
    bool=true;
    fit*=-1;
  }
  
  if (fit<10) {
    s = String.format("%.2f", fit);
  } else if (fit>=10 && fit<100) {
    s = String.format("%.1f", fit);
  } else {
    s = String.format("%3.0e", fit);
  }
  
  if (bool) { 
    s = "-"+s; }
   
   //s = s.replace(',', '.');
   //float f = Float.parseFloat(s);
   //s = f+"";
   
   if (s.equals("0,00")) { s = "0"; }
  
  return s;
}