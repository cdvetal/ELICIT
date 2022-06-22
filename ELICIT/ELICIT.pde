import java.util.*;
import processing.pdf.*;




//Directory + Folder of runs (without number)
String filen = "data/dataset-Generic/";

//Number of the first run (run1)
int ifile = 1;

//Number of runs (run1, run2, run3, ...)
int sfile = 1;



int fitmap = 2; //Fitness to Color Mapping: 1 - Direct; 2 - Focus Fit Values

ArrayList<ArrayList<Population>> runs = new ArrayList<ArrayList<Population>>();
ArrayList<Population> pops, avg;

float mapx = 0, mapy = 0;  //Coordinate displacement
float mapz = 1;            //Zoom: size multiplier
float dx = 0, dy = 0;      //Dragging displacement

float mapx2 = 0, mapy2 = 0;  //Coordinate dfileselisplacement for trees
float mapz2 = 1;            //Zoom: size multiplier for trees
float dx2 = 0, dy2 = 0;      //Dragging displacement for trees

int[] pos  = {-1, -1};     //position that mouse is hovering
int[] pos2 = {-1, -1, -1}; //last position selected
boolean mode = false;      //If anything is selected

int colswitch = 0;
boolean linet = true;
boolean linec = false;

//Default graphical element sizes
float minim = 0;     //Minimum space between cells and collumns
float inc = 50;      //collumn extension inc

float coltop = 20;   //Collumn button
float nsize = 10;    //Node size
float esize = minim; //Collumn space size

float hudw = 150;    //HUD width

int num_l;
int num_c;

//File Selected
int filesel = -1;
ArrayList<Integer> filesels = new ArrayList<Integer>();
int filesel_ = 0;

boolean bez = false;

int gop = 0; // Genetic Operator Chosen
boolean locktyp = true; //whether there are 2 or 1 chromossomes in the data (must be set manually here)
boolean lockind = true; //whether there exists individual data
boolean fitori = true; //fitness orientation (larger numbers means better fitness (true) or as it approaches 0 (false))
int seltyp = 1; //chromossome chosen

boolean hscr = false;

boolean fitpos = true; //Pos by Fit switch
boolean eva = false;   //Eva mode switch
boolean genow = false; //Genotype window switch 
boolean timel = false; //Timeline view switch
boolean playing = false; //Timeline auto advance
int playBreak = 18; //Break between each transition
int playTime = 0; //Timer

PFont fontsmall, fontxsmall, fontgraph, fontsymb, fontsymb2;

//Gender colors
color c_m, c_f, c_n;
//Type colors
int c_1h, c_1s, c_1b;
int c_2h, c_2s, c_2b;
int c_3h, c_3s, c_3b;
//Navigation colors
color c_sel, c_sel2, c_top;
int c_0h, c_0s, c_0b;
color hudsel;

int n_alp; //Node alpha for "Fitness by Postion" mode

PGraphics buffer;
boolean pdf0 = false;

PImage loading;
int wait = -1;

boolean load_values = true;

float maxfit=-1, minfit=1000000;

float mid; //Screen middle with hud

//Arraylist used to save every fitness value across all the files
//A value is selected from it (from half, or a quarter) to calculate the color map (Indiv.fitColor())
ArrayList<Float> findfit = new ArrayList<Float>(); 
float medfit;

ArrayList<float[]> target = new ArrayList<float[]>();                 //Array of values correspondant to the target fenotype
ArrayList<float[]> targetx = new ArrayList<float[]>();                 //Array of values correspondant to the target fenotype
Indiv indCurr;                  //Currently chosen individual for genotype window
float[] maxes   = {0, 0, 0, 0}; //[max_target, max_chrom_1, max_chrom_2] || Maximum values of the currently displayed graphs
float[] maxes_m = {0, 0, 0, 0}; //Used for the mother (small graph displayed below)
float[] maxes_f = {0, 0, 0, 0}; //Used for the father
float[] mins    = {0, 0, 0, 0}; //[max_target, max_chrom_1, max_chrom_2] || Maximum values of the currently displayed graphs
float[] mins_m  = {0, 0, 0, 0}; //Used for the mother (small graph displayed below)
float[] mins_f  = {0, 0, 0, 0}; //Used for the father

float[] ms_x   = {0, 0};

//When an individual is selected, this array will contain the best ancestors and descendants which will be used in the genotype window mode
ArrayList<Indiv> timeline = new ArrayList<Indiv>();

void setup() {
  size(1200, 650, P3D);
  smooth(8);
  //hint(DISABLE_DEPTH_TEST);
  //size(1200,650, P2D);
  
  mid = (width-hudw)/2+hudw; //Screen middle with hud
  
  fontxsmall = createFont("assets/RobotoCondensed-Regular.ttf", 13, true);
  fontsmall = createFont("assets/RobotoCondensed-Regular.ttf", 16, true);
  fontgraph = createFont("assets/RobotoCondensed-Regular.ttf", 11, true);
  fontsymb = createFont("assets/EuclidSymbol-Bold.ttf", 75, true);
  fontsymb2 = createFont("assets/Euclid-BoldItalic.ttf", 75, true);
  
  loading = loadImage("assets/wait.png");
  
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, 100);
  
  //Gender colors
  c_m = color(   0, 100, 100); //Mother
  c_f = color( 220, 100, 100); //Father
  c_n = color(   0,   0,   0); //Neither or None
  //Genetic Operator colors
  c_1h =   0; c_1s =   0; c_1b =   0; //Init
  c_2h = 200; c_2s = 100; c_2b =  85; //Others
  c_3h =   0; c_3s =   0; c_3b =   0; //Others Unselected
  //Navigation colors
  c_0h = 200; c_0s =  0; c_0b =  90; //Unselected Indiv
  c_sel = color(  45,  95,  95); //Mouseover
  c_top = color(  45,  95,  95); //Top Bar
  hudsel = color( 200, 100, 100);
  
  ifile+=1;
  
  load_values = true;
  
  println("Loading files...");
  for (int i=ifile; i<ifile+sfile; i++) { //Reads every file and puts it in an array
    pops = new ArrayList<Population>();
    loadFile(filen+"run"+(i-1)+".txt");
    filesels.add(i-1);
    setPositions();
    runs.add(pops);
    print((i-1)+"...");
  } println("Done!");
  fitnessOrientation();
  Collections.sort(findfit);
  medfit = findfit.get(floor(findfit.size()/4)-1);
  
  //Minfit --- NatSel: 0.0016107075 // SexSel: 0.0035579924
  //Calculate fitness color value
  for (ArrayList<Population> run : runs) {
    for (Population pop : run) {
      for (Indiv ind : pop.pop) {
        ind.fitColor();
        ind.childs = ind.children.size();
        Collections.sort(ind.children);
      }
    }
  }
  num_c = pops.size();
  num_l = pops.get(0).pop.size();
  
  if (runs.size()>1) {
    pops = new ArrayList<Population>();
    averageRuns(); //averages every file and saves it into the array pops
    avg = pops;
  }
  
  n_alp = num_l / 25;
  
  mapx = width/2;
  mapy = -(num_l*(nsize+minim)+coltop)/2+height/2;
  zoom(0.5f, width/2, height/2);
  mapx-= width/2-inc;
  
  zoom(0.50f, width/2+1, height/2+1);
  //mapx += hudw;
  //mapy += 10;
  
  mapx = -(nsize+esize+minim)*mapz*(num_c/2-1) + (width/2) + hudw/2 -(nsize/2*mapz);
  mapy -= 15;
  
  if (locktyp) {
    seltyp = 1;
  }
  
  filesel = 0;
  changeRun(runs.get(0));
  
  scrollLimit();
  
  mapx2 = width-(width-hudw)/1.8;
  mapy2 = height/20;
  mapz2 = 0.7;
}

void fitnessOrientation() {
  //finds the fitness orientation (whether it grows or approaches zero over time)
  //compares average fitness of the first population with the last of the first file
  
  Population init = runs.get(0).get(0);
  Population fini = runs.get(0).get(runs.get(0).size()-1);
  
  int fi=0, ff=0;
  
  for (Indiv ind : init.pop) {
    fi+=ind.fit; }
  for (Indiv ind : fini.pop) {
    ff+=ind.fit; }
  
  float temp;
  if (fi>ff) {
    fitori=false;
    
    temp = minfit;
    minfit = maxfit;
    maxfit = temp;
  }
  
}

void resetTreePos() {
  mapx2 = width-(width-hudw)/1.8;
  mapy2 = height/20;
  mapz2 = 0.7;
  
  for (Branch b : indCurr.tree) {
    b.pos.x = b.pos0.x;
    b.pos.y = b.pos0.y;
  }
}


void loadFile(String filename) {
  int curpop = -1;
  int iline = 0;
  Population pop = new Population(-1);
  String lines[] = loadStrings(filename);
  
  //Find whether there's individual details or not
  if (locktyp) {
    String list[] = split(lines[lines.length-1], ' ');
    if (list.length>6) { lockind = false; }
  } else {
    String list[] = split(lines[lines.length-1], ' ');
    if (list.length>7) { lockind = false; }
  }
  
  float[] target_;
  float[] targetx_;
  
  if (load_values) {
  //Sets Target Curve
  if (!lockind) {
    iline=2;
    int g = 0;
    String[] list = split(lines[0], ' ');
    if (list[0].equals("0")) { g=1; } 
    if (list[list.length-1].length()>0) { //Checks if the last digit is a null or not
      targetx_ = new float[list.length];
    } else {
      targetx_ = new float[list.length-1];
    }
    for (int k=g; k<targetx_.length; k++) {
      targetx_[k-g] = new Float(list[k]);
    }
    
    targetx.add(targetx_);
    
    String[] list2 = split(lines[1], ' ');
    if (list2[list2.length-1].length()>0) { //Checks if the last digit is a null or not
      target_ = new float[list2.length];
    } else {
      target_ = new float[list2.length-1];
    }
    for (int k=0; k<target_.length; k++) {
      target_[k] = new Float(list2[k]);
    }
    
    target.add(target_);
    
    //Establish max and min of the target
    maxes[0] = getMax(target_);
    maxes_m[0] = maxes[0];
    maxes_f[0] = maxes[0];
    mins[0] = getMin(target_);
    mins_m[0] = mins[0];
    mins_f[0] = mins[0];
    
    ms_x[0] = getMin(targetx_);
    ms_x[1] = getMax(targetx_);
    
    
  }
  }
  
  for (int i = iline ; i < lines.length; i++) { 
    String[] list = split(lines[i], ' ');
    
    if (list.length==1) { break; } //handle --description--
    
    int idpop = Integer.parseInt(list[0]);
    int id    = Integer.parseInt(list[1]);
    int type  = Integer.parseInt(list[2]);
    int type2 = -1;
    int p1, p2;
    double fit;
    
    if (locktyp) { // Valid fitness means: Single Chromossome
      p1    = Integer.parseInt(list[3]);
      p2    = Integer.parseInt(list[4]);
      fit = new Double(list[5]);
    }
    else { // Two Chromossomes
      type2 = Integer.parseInt(list[3]);
      p1    = Integer.parseInt(list[4]);
      p2    = Integer.parseInt(list[5]);
      fit = new Double(list[6]);
    }
    
    if (fit>maxfit) { maxfit = (float) fit; }
    if (fit<minfit) { minfit = (float) fit; }
    findfit.add((float) fit);
    
    if (type==3) { type = 0; }
    if (type2==3) { type2 = 0; }
    
    //fit *= 1 + random(0.4)-0.2; //random
    
    Indiv ind = new Indiv(id, idpop, type, type2, fit);
    
    //Finding parents
    if (p1>-1) {
      Boolean found = false;
      Population p_pop = pops.get(idpop-1);
      for (Indiv p_ind : p_pop.pop) {
        if (p_ind.id==p1) {
          p_ind.children.add(ind);
          ind.mother = p_ind;
          found = true;
          break;
        }
      }
      if (!found) { println("Could not find parent1 "+p1+" for individual "+id+"!"); }
    }
    if (p2>-1) {
      Boolean found = false;
      Population p_pop = pops.get(idpop-1);
      for (Indiv p_ind : p_pop.pop) {
        if (p_ind.id==p2) {
          p_ind.children.add(ind);
          ind.father = p_ind;
          found = true;
          break;
        }
      }
      if (!found) { println("Could not find parent2 "+p2+" for individual "+id+"!"); }
    }
    
    if (idpop!=curpop) { //New Population
      curpop++;
      pop = new Population(idpop);
      pops.add(pop);
    }
    
    //Graph values
    String[] values_;
    
    if (load_values) {
      if (locktyp) {
        values_ = split(list[list.length-1], ',');
        ind.values = new float[values_.length];
        for (int k=0; k<values_.length; k++) {
          ind.values[k] = new Float(values_[k]); }
        }
      else { //Values for 2 Chromossomes
        values_ = split(list[list.length-3], ',');
        ind.values = new float[values_.length];
        for (int k=0; k<values_.length; k++) {
        ind.values[k] = new Float(values_[k]); }
        
        values_ = split(list[list.length-1], ',');
        ind.values2 = new float[values_.length];
        for (int k=0; k<values_.length; k++) {
        ind.values2[k] = new Float(values_[k]); }
      }
    }
    
    /* Tree setup
    String[] lisp;
    if (locktyp) {
      lisp = Arrays.copyOfRange(list, 7, list.length-1);
      ind.tree = createLispTree(lisp);
    }
    else { //Must split two trees ; might be changed later if the weird format is fixed
      lisp = Arrays.copyOfRange(list, 8, list.length-3);
      for (int k=0; k<lisp.length; k++) {
        if (lisp[k].equals(";")) {
          ind.tree = createLispTree(Arrays.copyOfRange(lisp, 0, k));
          ind.tree2 = createLispTree(Arrays.copyOfRange(lisp, k+2, lisp.length));
          break;
        }
      }
    }
    //*/
    
    pop.pop.add(ind);
    
  }
}


void averageRuns() {
  
  //initializes pops using the first run
  for (int p=0; p<num_c; p++) {
    Population pop = new Population(runs.get(0).get(p).id);
    for (int i=0; i<num_l; i++) {
      Indiv indr = runs.get(0).get(p).pop.get(i);
      Indiv ind = new Indiv( indr.id, indr.idpop, -1, -1, 0 );
      
      pop.pop.add(ind);
    }
    pops.add(pop);
  }
  
  for (int r=0; r<runs.size(); r++) {
    ArrayList<Population> plist = runs.get(r);
    
    for (int p=0; p<plist.size(); p++) {
      Population popr = plist.get(p);
      Population pop = pops.get(p);
      
      for (int i=0; i<pop.pop.size(); i++) {
        Indiv indr = popr.pop.get(i);
        Indiv ind = pop.pop.get(i);
        
        //Fitness
        ind.fit += indr.fit;
        
        //Connections
        for (Indiv child : indr.children) {
          ind.childs++;
        }
        
        //Type
             if (indr.type==0) { ind.c_++; }
        else if (indr.type==1) { ind.m_++; }
        else if (indr.type==2) { ind.r_++; }
             if (indr.type2==0) { ind.c2_++; }
        else if (indr.type2==1) { ind.m2_++; }
        else if (indr.type2==2) { ind.r2_++; }
      }
    }
  }
  
  //Calculate Averages
  for (Population pop : pops) {
    for (Indiv ind : pop.pop) {
      ind.fit /= runs.size();
      
      ind.fitColor();
      ind.typeColor();
      ind.runsn=runs.size();
    }
  }
  setPositions();
}


void draw() {
  //beginRecord(PDF, "visuals/"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".pdf");
  //ellipseMode(CENTER);
  //colorMode(HSB, 360, 100, 100, 100);
  
  background(0, 0, 100);
  
  //if (indCurr!=null) { println(indCurr.values); }
  
  if (!genow) {
    
    mouseHover();
    
    for (Population p : pops) { p.selCount(); }
    
    pushMatrix();
    translate(0,0,-1);
    if (esize>minim) { //Draws the connections first, if the graph is open
      if (filesel>-1) {
        for (Population p : pops) {
          for (Indiv ind : p.pop) {
            ind.showLink();
          }
        }
      } else {
        for (ArrayList<Population> pops0 : runs) {
          for (Population p : pops0) {
            for (Indiv ind : p.pop) {
              ind.showLink();
            }
          }
        }
      }
    }
    for (Population p : pops) {
      if (mode && !fitpos) { //In the "fitness by position" mode, draws the selected on top
        for (Indiv ind : p.pop) {
          if (!ind.sel) { //Unselected
            ind.show();
          }
        }
        for (Indiv ind : p.pop) {
          if (ind.sel) { //Selected
            ind.show();
          }
        }
      }
      else { 
        for (Indiv ind : p.pop) {
          ind.show();
        }
      }
    }
    
    for (Population p : pops) {
      p.show();
    }
    popMatrix();
    
    navBar(navx);
    if (alpscr>0) { writeScroll(); }
    drawSubtitles();
  }
  else { //Genotype Windows
    
    if (playing) {
      playTime++;
      if (playTime==playBreak) {
        playTime=0;
        if (!changeTime(indCurr.idpop+1)) {
          playing = false;
        }
      }
    }
    
    drawGenotype();
    drawGenoSubs();
    
    if (filesel>-1) {
      navBar(navx2); }
  }
  drawInterface();
  
  if (wait>-1) {
    loading(); }
  else {
    cursor(0); }
    
  //save("movie/"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".png");
  //endRecord();
}


void setPositions() {
  for (int q=0; q<pops.size(); q++) {
    Population p = pops.get(q);
    Collections.sort(p.pop);
    p.x = q*(nsize+esize);
    p.y = 0;
    
    for (int k=0; k<p.pop.size(); k++) {
      Indiv i = p.pop.get(k);
      i.pos = k;
      i.x = i.idpop*(nsize+esize);
      if (fitpos) { i.y = k*(nsize+minim)+coltop; }
      else { i.y = map( (float)i.fit, 1, 0, coltop, num_l*(nsize+minim) ); }
    }
  }
  
  if (filesel==-1) { setRunsPositions(); }
}

void setRunsPositions() {
  for (ArrayList<Population> pops0 : runs) {
    for (int q=0; q<pops0.size(); q++) {
      Population p = pops0.get(q);
      Collections.sort(p.pop);
      p.x = q*(nsize+esize);
      p.y = 0;
      
      for (int k=0; k<p.pop.size(); k++) {
        Indiv i = p.pop.get(k);
        i.pos = k;
        i.x = i.idpop*(nsize+esize);
        if (fitpos) { i.y = k*(nsize+minim)+coltop; }
        else { i.y = map( i.fit2, 100, 0, coltop, num_l*(nsize+minim) ); }
      }
    }
  }
}


void mouseClicked() {
  if (mouseButton == LEFT) {
    if (mouseY<height-(nav*3) && mouseX>hudw && !genow) {
      
      if (eva) { pos[1]=-1; }
      selectionUpdate(pos[0], pos[1]);
      pos2[0] = pos[0];
      pos2[1] = pos[1];
      
    }
    
  }
  else if (mouseButton!=LEFT && mouseButton!=RIGHT) {
    zoom(0.51f, mouseX, mouseY);
  }
}


void selectionUpdate(int sel0, int sel1) {
  
  if (filesel==-1) { resetAverage(); }
  
  if (sel0>-1) {
    if (sel1>-1) { //Node selected
      resetSel(pops);
      Indiv i = pops.get(sel0).pop.get(sel1);
      i.sel = true;
      i.msel = true;
      
      if (filesel>-1) { //Normal Viz
        i.selectChildren();
        if (!eva) {
          i.selectParents();
        }
      }
      else { //Multiple Files Viz
        i.nsel = runs.size();
        for (ArrayList<Population> pops0 : runs) {
          resetSel(pops0);
          Indiv ind = pops0.get(sel0).pop.get(sel1);
          ind.sel = true;
          ind.msel = true;
          ind.selectChildren();
          if (!eva) {
            ind.selectParents();
          }
        }
      }
      
    }
    else { //Whole population selected
      resetSel(pops);
      
      if (!eva) {
        Population p = pops.get(sel0);
        for (Indiv i : p.pop) {
          i.sel = true;
          if (filesel>-1) { //Normal Viz
            i.selectParents();
          }
          else {
            i.nsel = runs.size();
          }
        }
        if (filesel==-1) { //Multiple Files Viz
          for (ArrayList<Population> pops0 : runs) {
            resetSel(pops0);
            Population pp = pops0.get(sel0);
            for (Indiv i : pp.pop) {
              i.sel = true;
              i.selectParents();
            }
          }
        }
        
      }
      else {
        if (filesel>-1) { //Eva Mode
          evaMode(sel0, pops);
        }
        else { //Mutiple Files Eva Mode
          for (ArrayList<Population> pops0 : runs) {
            evaMode(sel0, pops0);
          }
        }
      }
      
    }
    mode = true;
    
    if (!lockind) { newIndCurr(sel0, sel1); }
  }
  else {
    resetSel(pops);
    if (filesel==-1) {
      for (ArrayList<Population> pops0 : runs) {
        resetSel(pops0); } }
    
    mode=false;
    
    selectTimeline(false);
    indCurr=null;
  }
  
}


void evaMode(int sel0, ArrayList<Population> pops0) {
  //Eva Mode - Goes through each individual in back populations
  //           Selects only those that are the closest descedants to all in this population
  resetSel(pops0);
  boolean found = false;
  int[] evas = new int[0];
  for (int i=sel0-1; i>=0; i--) {
    Population p = pops0.get(i);
    for (int j=0; j<p.pop.size(); j++) {
      Indiv ind = p.pop.get(j);
      if (ind.evaSearch(sel0, pops0, false)) {
        evas = append(evas, j);
        found = true;
        pos2[2] = i;
      }
      resetSel(pops0);
    }
    if (found) {
      for (int k=0; k<evas.length; k++) {
        
        Indiv ind;
        if (filesel>-1) {
          ind = p.pop.get(evas[k]);
        } else {
          ind = pops0.get(i).pop.get(evas[k]);
        }
        
        ind.sel = true;
        ind.msel = true;
        if (filesel==-1) {
          pops.get(i).pop.get(evas[k]).sel=true;
          pops.get(i).pop.get(evas[k]).msel=true;
        }
        
        ind.evaSearch(sel0, pops0, true);
      }
      //println(evas.length);
    break; }
  }
  
  if (!found) { pos2[2] = -1; }
}


void resetSel(ArrayList<Population> pops0) {
  for (Population p : pops0) {
    for (Indiv i : p.pop) {
      i.sel = false;
      i.msel = false;
      i.msel2 = false;
    }
  }
}

void resetAverage() {
  for (Population p : pops) {
    for (Indiv i : p.pop) {
      i.nsel = 0;
    }
  }
}

//Timeline viewing is incompatible with Eva Mode and other Population selections
//To fix this, the best individual of a selected population will be selected for the creation of a timeline
void fixSelection(int p0, int p1) {
  if (p0>-1) {
    if (p1==-1) { //Column Selected (Selects best of population)
      pos2[1] = 0;
      selectionUpdate(p0, 0);
    }
  } else { //Nothing Selected (Selects best of all time)
    pos2[0] = num_c-1;
    pos2[1] = 0;
    selectionUpdate(num_c-1, 0);
  }
  
}

void newIndCurr(int p0, int p1) {
  //Reset previous timeline selection
  if (timel) { selectTimeline(false); }
  
  if (p0>-1) {
    if (p1>-1) { //Indiv Selected
      indCurr = pops.get(p0).pop.get(p1);
    }
    else { //Column Selected (Selects best of population)
      indCurr = pops.get(p0).pop.get(0);
    }
  } else { //Nothing Selected (Selects best of all time)
    indCurr = pops.get(num_c-1).pop.get(0);
  }
  
  if (timel) { fixSelection(p0, p1); }
  
  if (filesel>-1) {
    findBest(indCurr);
    updateGenoSel(true);
  }
  
  //Update with new one
  if (timel) { selectTimeline(true); }
}

boolean ffound;
void findBest(Indiv ind) {
  deleteTrees();
  
  //When an individual is selected, creates array with the best ancestors and descendants which will be used in the genotype window mode
  timeline = new ArrayList<Indiv>();
  
  Indiv ind2 = ind;
  int pn;
  
  //There are two ways to go about finding this family line
  //Through one method we can pick the best child of each individual, but individuals with high fitness will not always have good children, and vice-versa
  //The second method ensures that family line selected will end in the best possible individual, by finding him first and then selecting his ancestors
  
  //Method 1: Succesively picking the best child
  if (false) {
    timeline.add(ind);
    
    //Add descendants
    while (ind2.childs>0) { //Since the children list are ordered, adds the last (lowest fit) if there are any
      timeline.add(ind2.children.get(0));
      ind2 = ind2.children.get(0);
    }
    
  } else { //Method 2: Finding the best possible individual and then selecting 
    timeline.add(ind);
    //Find best individual of the current family tree
    boolean brk = false;
    for (int p=num_c-1; p>=0; p--) {
      Population pop0 = pops.get(p);
      for (Indiv ind0 : pop0.pop) {
        if (ind0.sel) {
          ind2 = ind0;
          brk = true;
          break;
        }
      }
      if (brk) { break; }
    }
    
    //Prepares for search
    ffound = false;
    for (int p=num_c-1; p>=ind.idpop; p--) {
      Population pop0 = pops.get(p);
      for (Indiv ind0 : pop0.pop) {
        ind0.fsel = false;
      }
    }
    
    //Find the path that connects the best indiv to the selected indiv
    ind2.bestPath(ind);
    //timeline.add(ind2);
    
  }
  
  //Add ancestors
  pn = ind.idpop;
  ind2 = ind;
  while (pn>0) {
    if (ind2.mother!=null && ind2.father!=null) { //If two parents, finds best and adds it
      if (fitori) {
        
        if (ind2.mother.fit>=ind2.father.fit) { 
          timeline.add(0, ind2.mother);
          ind2 = ind2.mother;
        } else {
          timeline.add(0, ind2.father);
          ind2 = ind2.father;
        }
        
      } else {
        
        if (ind2.mother.fit<=ind2.father.fit) { 
          timeline.add(0, ind2.mother);
          ind2 = ind2.mother;
        } else {
          timeline.add(0, ind2.father);
          ind2 = ind2.father;
        }
        
      }
      
    } else { //If only one parent, adds that parent
      if (ind2.father==null) {
        timeline.add(0, ind2.mother);
        ind2 = ind2.mother;
      } else {
        timeline.add(0, ind2.father);
        ind2 = ind2.father;
      }
    }
    pn--;
  }
  
  if (filesel>-1) { loadTrees(); }
}


void selectTimeline(boolean selct) { 
  //Selects or unselects timeline given the boolean
  if (indCurr!=null) {
    if (selct) {
      
      indCurr.msel2 = true;
      for (Indiv ind : timeline) {
        ind.msel = true;
      }
      
    } else {
      
      if (indCurr.idpop==pos2[0] || indCurr.pos==pos2[1]) {
        indCurr.msel2 = false;
      }
        
      for (Indiv ind : timeline) {
        if (ind.idpop!=pos2[0] || ind.pos!=pos2[1]) {
          ind.msel = false;
        }
      }
      
    }
  }
  
}

void updateGenoSel(boolean setnav) {
  if (filesel>-1) {
    
    if (setnav) {
      navx2 = map(indCurr.idpop, 0, timeline.size()-1, navmin+hudw, width-navmin);
    }
    
    //Finds max values and saves them so they don't need to be calculated again
    if (locktyp) {
      maxes[1] = getMax(indCurr.values);
      mins[1]  = getMin(indCurr.values);
      if (indCurr.mother!=null) { 
        maxes_m[1] = getMax(indCurr.mother.values);
        mins_m[1]  = getMin(indCurr.mother.values); }
      if (indCurr.father!=null) { 
        maxes_f[1] = getMax(indCurr.father.values);
        mins_f[1]  = getMin(indCurr.father.values); }
    }
    else {
      maxes[1] = getMax(indCurr.values); 
      maxes[2] = getMax(indCurr.values2);
      mins[1]  = getMin(indCurr.values); 
      mins[2]  = getMin(indCurr.values2);
      if (indCurr.mother!=null) { 
        maxes_m[1] = getMax(indCurr.mother.values);
        maxes_m[2] = getMax(indCurr.mother.values2);
        mins_m[1]  = getMin(indCurr.mother.values);
        mins_m[2]  = getMin(indCurr.mother.values2); }
      if (indCurr.father!=null) { 
        maxes_f[1] = getMax(indCurr.father.values);
        maxes_f[2] = getMax(indCurr.father.values2);
        mins_f[1]  = getMin(indCurr.father.values);
        mins_f[2]  = getMin(indCurr.father.values2); }
    }
    
  }
  else {
    
    float maxx = -10000000;
    float minn = 10000000;
    for (int i=0; i<runs.size(); i++) { //1st Chromosome
      float maxx0 = getMax(runs.get(i).get(indCurr.idpop).pop.get(indCurr.pos).values);
      float minn0 = getMin(runs.get(i).get(indCurr.idpop).pop.get(indCurr.pos).values);
      if (maxx0>maxx) { maxx = maxx0; }
      if (minn0<minn) { minn = minn0; }
    }
    maxes[1] = maxx;
    mins[1] = minn;
    
    if (!locktyp) { //2nd Chromosome
      maxx = -10000000;
      minn = 10000000;
      for (int i=0; i<runs.size(); i++) {
        float maxx0 = getMax(runs.get(i).get(indCurr.idpop).pop.get(indCurr.pos).values2);
        float minn0 = getMin(runs.get(i).get(indCurr.idpop).pop.get(indCurr.pos).values2);
        if (maxx0>maxx) { maxx = maxx0; }
        if (minn0<minn) { minn = minn0; }
      }
      maxes[2] = maxx;
      mins[2] = minn;
    }
    
  }
}




void preLoad(int n) {
  wait = n;
  //imageMode(CENTER);
  //image(loading, (width-hudw)/2 +hudw, height/2);
  cursor(loading);
}

void loading() {
  //Functions that (might) require heavy processing
  // - Saving to file
  // - Opening or closing the graph
  // - Switching between files and the total average
  
  if (wait==0) {      //Save to PDF
    if (!genow) {
      saveImg(true); }
    else {
      saveImg2(true); }
  }
  else if (wait==1) { //Save to PNG
    if (!genow) {
      saveImg(false); }
    else {
      saveImg2(false); }
  }
  else if (wait==2) { //Close Graph
    closeGraph((width-hudw)/2+hudw, true);
  }
  else if (wait==3) { //Expand Graph
    expandGraph((width-hudw)/2+hudw);
  } else if (wait==4) { //Previous File
    
    if (genow) {
      pos2[0] = indCurr.idpop;
      pos2[1] = indCurr.pos;
    }
    
    if (filesel>0) { filesel--; }
    else { filesel=runs.size()-1; }
    changeRun(runs.get(filesel));
    
    if (genow) {
      indCurr = pops.get(pos2[0]).pop.get(pos2[1]);
      findBest(indCurr);
      updateGenoSel(true);
    }
      
  }
  else if (wait==5) { //Average Files
    
    if (genow) {
      pos2[0] = indCurr.idpop;
      pos2[1] = indCurr.pos;
    }
    
    if (filesel==-1) {
      filesel = filesel_;
      changeRun(runs.get(filesel)); }
    else {
      filesel_ = filesel;
      filesel = -1;
      changeRun(avg);
      fixTypeColor(); }
      
    if (genow) {
      indCurr = pops.get(pos2[0]).pop.get(pos2[1]);
      if (filesel>-1) {
        findBest(indCurr); }
      updateGenoSel(true);
    }
      
  }
  else if (wait==6) { //Next File
    
    if (genow) {
      pos2[0] = indCurr.idpop;
      pos2[1] = indCurr.pos;
    }
    
    if (filesel<runs.size()-1) { filesel++; }
    else { filesel=0; }
    resetSel(pops);
    changeRun(runs.get(filesel));
    
    if (genow) {
      indCurr = pops.get(pos2[0]).pop.get(pos2[1]);
      findBest(indCurr);
      updateGenoSel(true);
    }
  }
  
  wait = -1;
  
}
