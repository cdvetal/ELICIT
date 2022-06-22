
class Branch {
  
  Branch prev; //branch that created this one
  //ArrayList<Branch> branches = new ArrayList<Branch>(); //branches spawned by this one
  int degree = 1; //number of branches
  
  int id;
  int level; //position of this branch in the hierarchy
  String op; //operator associated to this branch
  
  boolean bool = true; //used for comparison between other trees
  boolean newn = false;
  //boolean oldn = false;
  
  PVector pos0 = new PVector(0,0);
  PVector pos; //position of one extremity, the other will be retrieved from the prev branch
  
  Branch(int id, int level) {
    this.id = id;
    this.level = level;
    
    //int x = round(width/100*id);
    //int y = round(level*50);
    //pos = new PVector(x,y);
    
  }
  
  void show() {
    float x_ = (pos.x*mapz2)+mapx2;
    float y_ = (pos.y*mapz2)+mapy2;
    
    float siz;
    
    if (prev!=null) {
      float px_ = (prev.pos.x*mapz2)+mapx2;
      float py_ = (prev.pos.y*mapz2)+mapy2;
      
      //stroke(0,0,0,100);
      if (seltyp==1) { stroke(c_sel); }
      else { stroke(200,100,100); }
      //stroke(c_sel);
      noFill();
      
      pushMatrix();
      translate(0,0,-1);
      strokeWeight(1.5*mapz2);
      //strokeWeight(0.5f);
      line(px_, py_, x_, y_);
      popMatrix();
    }
    
  }
  
  void drawSymb() {
    float x_ = (pos.x*mapz2)+mapx2;
    float y_ = (pos.y*mapz2)+mapy2;
    float siz;
    
    //Ellipse
    if (prev!=null) {
      noStroke();
      fill(0,0,100);
      siz = 23*mapz2;
      
      if (degree==1) {
        strokeWeight(1*mapz2);
        //strokeWeight(0.5f);
        stroke(0,0,25);
      }
    } else {
      if (seltyp==1) { fill(c_sel); }
      else { fill(200,100,100); }
      strokeWeight(2*mapz2);
      noStroke();
      siz = 25*mapz2;
    }
    
    if (newn) {
      if (prev!=null) {
        if (seltyp==1) { fill(45,  95,  95, 34); }
        else { fill(200, 100,  85, 34); }
      } else {
        if (seltyp==1) { fill(45,  95,  70); }
        else { fill(200, 100,  60); }
      }
    }
    
    ellipse(x_, y_, siz, siz);
    
    //Symbol
    fill(0);
    //if (oldn) { fill(0, 0, 0, 34); }
    textAlign(CENTER);
    
    //Missing: sin cos rlog % x1 exp
    
    if (op.equals("+")) {
      textFont(fontsymb, 22*mapz2);
      text("+", x_, y_+(5.5*mapz2));
      
    } else if (op.equals("-")) {
      textFont(fontsymb, 23*mapz2);
      text("_", x_, y_-(6*mapz2));
      text("_", x_, y_-(6*mapz2));
      
    } else if (op.equals("*")) {
      textFont(fontsymb, 22*mapz2);
      text("´", x_, y_+(5.5*mapz2));
      
    } else if (op.equals("1/")) {
      textFont(fontsymb, 19*mapz2);
      text("¸", x_, y_+(5*mapz2));
      
    } else if (op.equals("sqrt")) {
      textFont(fontsymb, 18*mapz2);
      text("Ö", x_, y_+(7.5*mapz2));
    } else if (op.substring(0,min(op.length(), 3)).equals("ERC")) {
      textFont(fontsymb, 19*mapz2);
      text("E", x_-(0.15*mapz2), y_+(6.6*mapz2));
      
      float dst = 8 * mapz2;
      if (mouseX>x_-dst && mouseX<x_+dst && mouseY>y_-dst && mouseY<y_+dst) {
        float ang = atan2((height/2)-y_, (hudw+((width-hudw)*2/3))-x_)+PI;
        float posx = x_+cos(ang)*(40*mapz2);
        float posy = y_+sin(ang)*(25*mapz2);
        textFont(fontxsmall, 13);
        text(op.substring(4,9), posx+(6*mapz2), posy+(7*mapz2));
        noFill();
      }
      
    } else if (op.substring(0,min(op.length(), 8)).equals("VladERCA")) {
      textFont(fontsymb2, 17*mapz2);
      text("EA", x_-(0.15*mapz2), y_+(6.6*mapz2));
      
      float dst = 8 * mapz2;
      if (mouseX>x_-dst && mouseX<x_+dst && mouseY>y_-dst && mouseY<y_+dst) {
        float ang = atan2((height/2)-y_, (hudw+((width-hudw)*2/3))-x_)+PI;
        float posx = x_+cos(ang)*(40*mapz2);
        float posy = y_+sin(ang)*(25*mapz2);
        textFont(fontxsmall, 13);
        text(op.substring(4,9), posx+(6*mapz2), posy+(7*mapz2));
        noFill();
      }
      
    }else if (op.substring(0,min(op.length(), 8)).equals("VladERCB")) {
      textFont(fontsymb2, 17*mapz2);
      text("EB", x_-(0.15*mapz2), y_+(6.6*mapz2));
      
      float dst = 8 * mapz2;
      if (mouseX>x_-dst && mouseX<x_+dst && mouseY>y_-dst && mouseY<y_+dst) {
        float ang = atan2((height/2)-y_, (hudw+((width-hudw)*2/3))-x_)+PI;
        float posx = x_+cos(ang)*(40*mapz2);
        float posy = y_+sin(ang)*(25*mapz2);
        textFont(fontxsmall, 13);
        text(op.substring(4,9), posx+(6*mapz2), posy+(7*mapz2));
        noFill();
      }
      
    }else if (op.substring(0,min(op.length(), 8)).equals("VladERCC")) {
      textFont(fontsymb2, 17*mapz2);
      text("EC", x_-(0.15*mapz2), y_+(6.6*mapz2));
      
      float dst = 8 * mapz2;
      if (mouseX>x_-dst && mouseX<x_+dst && mouseY>y_-dst && mouseY<y_+dst) {
        float ang = atan2((height/2)-y_, (hudw+((width-hudw)*2/3))-x_)+PI;
        float posx = x_+cos(ang)*(40*mapz2);
        float posy = y_+sin(ang)*(25*mapz2);
        textFont(fontxsmall, 13);
        text(op.substring(4,9), posx+(6*mapz2), posy+(7*mapz2));
        noFill();
      }
      
    } else if (op.substring(0,min(op.length(), 2)).equals("n+")) {
      textFont(fontsymb2, 20*mapz2);
      text("n+", x_-(0.15*mapz2), y_+(6.6*mapz2));
      
      float dst = 8 * mapz2;
      if (mouseX>x_-dst && mouseX<x_+dst && mouseY>y_-dst && mouseY<y_+dst) {
        float ang = atan2((height/2)-y_, (hudw+((width-hudw)*2/3))-x_)+PI;
        float posx = x_+cos(ang)*(40*mapz2);
        float posy = y_+sin(ang)*(25*mapz2);
        textFont(fontxsmall, 13);
        text(op.substring(3,op.length()), posx+(6*mapz2), posy+(7*mapz2));
        noFill();
      }
      
    }
     else if (op.substring(0,min(op.length(), 2)).equals("n^")) {
      textFont(fontsymb2, 20*mapz2);
      text("n^", x_-(0.15*mapz2), y_+(6.6*mapz2));
      
      float dst = 8 * mapz2;
      if (mouseX>x_-dst && mouseX<x_+dst && mouseY>y_-dst && mouseY<y_+dst) {
        float ang = atan2((height/2)-y_, (hudw+((width-hudw)*2/3))-x_)+PI;
        float posx = x_+cos(ang)*(40*mapz2);
        float posy = y_+sin(ang)*(25*mapz2);
        textFont(fontxsmall, 13);
        text(op.substring(3,op.length()), posx+(6*mapz2), posy+(7*mapz2));
        noFill();
      }
      
    }
    
    else if (op.equals("x1")) {
      textFont(fontsymb2, 23*mapz2);
      text("x", x_-(1.5*mapz2), y_+(5.4*mapz2));
    } 
    
    else if (op.equals("sin")) {
     textFont(fontsymb2, 18*mapz2);
      text("sin", x_, y_+(5.5*mapz2));
    } else if (op.equals("cos")) {
      textFont(fontsymb2, 18*mapz2);
      text("cos", x_, y_+(5.5*mapz2));
    } else if (op.equals("%")) {
      textFont(fontxsmall, 13);
      text("%", x_, y_+(5.8*mapz2));
    }
    else if (op.equals("rlog")) {
      textFont(fontsymb2, 23*mapz2);
      text("r", x_, y_+(5.8*mapz2));
    }
    else if (op.equals("exp")) {
      textFont(fontsymb2, 23*mapz2);
      text("e", x_, y_+(5.8*mapz2));
    }
     else if (op.equals("negexp")) {
      textFont(fontsymb2, 21*mapz2);
      text("-e", x_, y_+(5.8*mapz2));
    }
    else if (op.equals("square")) {
      textFont(fontsymb2, 21*mapz2);
      text("^2", x_, y_+(5.8*mapz2));
    }
    
    textAlign(LEFT);
    //*/
  
  }
  
}

float str0 = 1.2;
void drawTree(ArrayList<Branch> tree) {
  
  for (int i=1; i<tree.size(); i++) {
    Branch b = tree.get(i);
    compressEdges(b.prev, b); // pushes close connected nodes away
    extendEdges(b.prev, b);   // brings separated connected nodes closer
  }
  
  for (Branch b : tree) {
    for (Branch b2 : tree) {
      if (b!=b2) {
        repelNodes(b, b2); //pushes every node away
      }
    }
    centerNodes(b); // pulls nodes torwards the center to prevent them from drifting away
  }
  
  Branch br = tree.get(0);
  br.pos.x = br.pos0.x;
  br.pos.y = br.pos0.y;
  
  for (Branch b : tree) {
    b.show();
  }
  for (Branch b : tree) {
    b.drawSymb();
  }
  
}

void compressEdges(Branch b1, Branch b2) {
  
  PVector dir = PVector.sub(b1.pos, b2.pos);
  float d = dir.mag();
  
  int dgr;
  if (b1.degree>b2.degree) { dgr = b2.degree; }
  else { dgr = b1.degree; }
  
  //float dmin = 20;
  //float str = 100;
  float dmin = 20*str0;
  float str = 100;
  
  if (d>dmin) {
    
    dir.normalize();
    
    float f = map(d, dmin, dmin*10, 0, str);
    f = constrain(f, 0, str);
    
    dir.mult(f);
    b2.pos.add(dir);
    dir.mult(-1);
    b1.pos.add(dir);
    
  }
  
}

void extendEdges(Branch b1, Branch b2) {
  
  PVector dir = PVector.sub(b1.pos, b2.pos);
  float d = dir.mag();
  
  int dgr;
  if (b1.degree>b2.degree) { dgr = b2.degree; }
  else { dgr = b1.degree; }
  
  //float dmax = 80;
  //float str = 5;
  float dmax = 50*str0;
  float str = 5;
  
  if (d<dmax) {
    
    dir.normalize();
    
    float f = map(d, 0, dmax, str, 0);
    f = constrain(f, 0, str);
    
    dir.mult(f);
    b1.pos.add(dir);
    dir.mult(-1);
    b2.pos.add(dir);
    
  }
  
}

void repelNodes(Branch b1, Branch b2) {
  
  PVector dir = PVector.sub(b1.pos, b2.pos);
  float d = dir.mag();
  
  //float dmax = 150;
  //float str = 2;
  float dmax = 100*str0;
  float str = 5;
  
  if (d<dmax) {
    
    dir.normalize();
    
    float f = map(d, 0, dmax, str, 0);
    f = constrain(f, 0, str);
    
    dir.mult(f);
    b1.pos.add(dir);
  }
  
}

void centerNodes(Branch b1) {
  PVector ctr = new PVector(width/2, height/2); 
  PVector dir = PVector.sub(b1.pos, ctr);
  float d = dir.mag();
  dir.mult(-1);
  
  float dmin = 1000;
  
  if (d>dmin) {
    float str = 5;
    
    dir.normalize();
    
    float f = map(d, dmin, dmin+10, 0, str);
    f = constrain(f, 0, str);
    
    dir.mult(f);
    b1.pos.add(dir);
    
  }
}



ArrayList<Branch> createLispTree(String[] lisp) {
  ArrayList<Branch> branches = new ArrayList<Branch>();
  ArrayList<ArrayList<Branch>> levels = new ArrayList<ArrayList<Branch>>();
  
  int level = 0;
  Branch b;                    //Current Branch
  Branch b0 = new Branch(0,0); //Parent Branch
  
  for (int i=0; i<lisp.length; i++) {
    String str = lisp[i];
    
    b = new Branch(i, level);
    
    if (levels.size()<=level) {
      levels.add(new ArrayList<Branch>());
    } levels.get(level).add(b);
    
    if (i==0) { //First Branch init
      if (str.charAt(0)=='(') { str = str.substring(1); }
      level++;
      b0 = b;
    }
    else {
      //b0.branches.add(b); //Parent branch adds current branch to list 
      b0.degree++;
      b.prev = b0;        //Current branch adds parent branch as his parent
      
      if (str.charAt(0)=='(') { // ------------------------------------ Every first node that follows this will be a branch of this node (level+1)
        str = str.substring(1);
        level++;
        b0 = b;
      }
    }
    
    while ( str.charAt(str.length()-1)==')' ) { // ------------------ Next node will be a branch of the parent of this node (level-1)
      // --- If it's ERC(), cycle needs to end before the last ')'
      if (str.length()>4) {
        if (str.substring(0,3).equals("ERC") && str.charAt(str.length()-2)!=')') {
          break;
        }
      }
      
      str = str.substring(0, str.length()-1);
      level--;
      b0 = b0.prev;
    }
    
    b.op = str;
    branches.add(b);
    
  }
  
  //Using the ArrayList levels we can position each node on the horizontal axis based on the number of nodes on that level -
  //The vertical position will be decided by the level itself
  
  for (ArrayList<Branch> bs : levels) {
    for (int k=0; k<bs.size(); k++) {
      Branch br = bs.get(k);
      int x = round((width/2/(bs.size()+1))*(k+1));
      int y = round(br.level*40);
      PVector pos = new PVector(x,y);
      
      br.pos = pos;
      br.pos0.x = pos.x;
      br.pos0.y = pos.y;
    }
  }
  
  return branches;
}


// In order to conserve memory, only the trees of the current timeline will be retrieved dynamically from the data
// These will be deleted when the timeline changes

void loadTrees() {
  //Uses the current file number and indiv id to find file and line (filesel, ind.id)
  String lines[] = loadStrings(filen+"run"+filesels.get(filesel)+".txt");
  
  for (int i=0 ; i < timeline.size(); i++) {
    Indiv ind = timeline.get(i);
    String[] list = split(lines[ind.id+4], ' '); //Individuals start at 1; old list started at 1; new lists starts at 6
    
    String[] lisp;
    if (locktyp) {
      if (list[7].length()>0) {
        lisp = Arrays.copyOfRange(list, 7, list.length-1);
      } else {
        lisp = Arrays.copyOfRange(list, 8, list.length-1);
      }
      ind.tree = createLispTree(lisp);
    }
    else { //Must split two trees ; might be changed later if the weird format is fixed
    
      if (list[7].length()>0) {
        lisp = Arrays.copyOfRange(list, 7, list.length-3);
      } else {
        lisp = Arrays.copyOfRange(list, 8, list.length-3);
      }
      
      for (int k=0; k<lisp.length; k++) {
        if (lisp[k].equals(";")) {
          ind.tree = createLispTree(Arrays.copyOfRange(lisp, 0, k));
          ind.tree2 = createLispTree(Arrays.copyOfRange(lisp, k+1, lisp.length));
          break;
        }
      }
    }
    
  }
}

void deleteTrees() {
  for (int i=0 ; i < timeline.size(); i++) {
    Indiv ind = timeline.get(i);
    ind.tree = new ArrayList<Branch>();
    if (locktyp) { ind.tree2 = new ArrayList<Branch>(); }
  }
}
