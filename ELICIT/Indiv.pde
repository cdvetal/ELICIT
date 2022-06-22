class Indiv implements Comparable {
  
  int id;    //Individual ID
  int idpop; //Indiv's Population ID
  int pos;   //Position in arraylist
  int type, type2;
  color c1, c2;
  double fit;
  
  float c_ = 0,  m_ = 0,  r_ = 0, cr_ = 0;  //Copy, Mutation, Crossover counter for multiple runs
  float c2_ = 0, m2_ = 0, r2_ = 0, cr2_ = 0;
  int runsn = 1;
  
  float fit2;
  int childs = 0; //number of children
  
  boolean sel = false;
  boolean msel = false;
  boolean msel2 = false;
  boolean mouse = false;
  
  boolean fsel = false;
  
  int nsel = 0;
  
  float alp, alp0;
  
  int i_hue = 200; //Main hue used for all color schemes
  
  Indiv mother;
  Indiv father;
  ArrayList<Indiv> children = new ArrayList<Indiv>();
  
  float x, y;
  
  float[] values;
  float[] values2;
  
  ArrayList<Branch> tree;
  ArrayList<Branch> tree2;
  
  Indiv(int id, int idpop, int type, int type2, double fit) {
    this.id = id;
    this.idpop = idpop;
    this.type = type;
    this.type2 = type2;
    this.fit = fit;
  }
  
  void fitColor() {
    //fit2 = map((float)fit, minfit*10, minfit, 0, 110);
    //fit2 = map((float)fit, 0.25, 1, 0, 100);
    //fit2 = (float)(pow(100, (float)fit)*fit*fit);
    
    if (fitmap==2) { //Focus Fit Values
      fit2 = map((float)fit, medfit, maxfit, 75, 105);
      
    } else { //Direct
      fit2 = map((float)fit, minfit, maxfit, 0, 100);
      
    }
    
    fit2 = constrain(fit2, 0, 100);
    
    //if (!fitori) { fit2 = 100-fit2; }
  }
  
  void typeColor() { //Calculates color average (for both chromossomes), only once when the option is selected, then saves it until another option is selected
    if (runs.size()>1) {
      float h_ = 0, s_ = 0, b_ = 0;
      float h2_ = 0, s2_ = 0, b2_ = 0;
      
      float t = 0, t2 = 0;
      
      if (gop==1) { //Copy
        h_ += c_2h*c_; h2_ += c_2h*c2_;
        s_ += c_2s*c_; s2_ += c_2s*c2_;
        b_ += c_2b*c_; b2_ += c_2b*c2_;
        t  += c_;      t2  += c2_;
      }
      if (gop==2) { //Mutation
        h_ += c_2h*m_; h2_ += c_2h*m2_;
        s_ += c_2s*m_; s2_ += c_2s*m2_;
        b_ += c_2b*m_; b2_ += c_2b*m2_;
        t  += m_;      t2  += m2_;
      }
      if (gop==3) { //Crossover
        h_ += c_2h*r_; h2_ += c_2h*r2_;
        s_ += c_2s*r_; s2_ += c_2s*r2_;
        b_ += c_2b*r_; b2_ += c_2b*r2_;
        t  += r_;      t2  += r2_;
      }
      if (gop==4) { //Crossover+Mutation
        h_ += c_2h*cr_; h2_ += c_2h*cr2_;
        s_ += c_2s*cr_; s2_ += c_2s*cr2_;
        b_ += c_2b*cr_; b2_ += c_2b*cr2_;
        t  += cr_;      t2  += cr2_;
      }
      
      if (t>0) { c1 = color( h_/t, s_/t, 100*(t/runs.size()) ); }
      else { c1 = color( c_3h, c_3s, c_3b ); }
      
      if (t2>0) { c2 = color( h2_/t2, s2_/t2, 100*(t2/runs.size()) ); }
      else { c2 = color( c_3h, c_3s, c_3b ); }
    }
  }
  
  
  int compareTo(Object o) {
      int result; 
      Indiv i = (Indiv) o;
      if (this.fit > i.fit) { result = 1; }
      else if (this.fit == i.fit) { result = 0; }
      else { result = -1; }
      
      if (fitori) { result *= -1; } //fitness orientation
      
      return result;
  }
  
  
  void show() {
    float x_ = (x*mapz)+mapx;
    float y_ = (y*mapz)+mapy;
    float s_ = nsize*mapz;
    
    if (filesel>-1 || !mode || !sel) { alp0 = 100; }
    else { alp0 = map(nsel, 1, runs.size(), 50, 100); }
    
    if (fitpos) { alp = alp0; }
    else { alp = alp0 / n_alp; }
    
    noStroke();
    
    if (colswitch==0) {                //Fitness Fill
      if (mode && !sel && !mouse) {    // Not Selected
        fill(c_0h, c_0s, c_0b, alp);
      }
      else {                           // Selected
        fill(i_hue, 100, fit2, alp);
      }
    }
    else if (colswitch==1) {           //Type Fill
      if (mode && !sel && !mouse) {    // Not Selected
        fill(c_0h, c_0s, c_0b, alp);
      }
      else if (filesel>-1) {           // Selected and not File Average
        if (type == -1) {
          fill(c_1h, c_1s, c_1b, alp);
          rect(x_, y_, s_, s_);
        }
        else if (gop==0 || mouse) { //Symbol
          
          fill(c_2h, c_2s, c_2b, alp);
          rect(x_, y_, s_, s_);
          fill(c_3h, c_3s, c_3b, alp);
          if (((type==0 || type==3) && seltyp==1) || ((type2==0 || type2==3) && seltyp==2)) { //Copy Symbol
            rect(x_+(1*mapz), y_+(1*mapz), s_-(2*mapz), s_-(2*mapz));
          } else if ((type==1 && seltyp==1) || (type2==1 && seltyp==2)) { //Mutation Symbol
            
          } else if ((type==2 && seltyp==1) || (type2==2 && seltyp==2)) { //Crossover Symbol
            stroke(c_3h, c_3s, c_3b, alp);
            strokeWeight(2*mapz);
            line(x_, y_, x_+s_, y_+s_);
            noStroke();
          } else if ((type==4 && seltyp==1) || (type2==4 && seltyp==2)) { //Crossover+Mutation Symbol
            //triangle(x_1, y_+s_1, x_+s_1, y_+s_1, x_+s_/2, y_1);
            stroke(c_3h, c_3s, c_3b, alp);
            strokeWeight(2*mapz);
            noFill();
            rect(x_+(1.8*mapz), y_+(1.8*mapz), s_-(3.6*mapz), s_-(3.6*mapz));
            fill(c_3h, c_3s, c_3b, alp);
            noStroke();
          }
        }
        else if ( (gop==1 && (((type==0 || type==3) && seltyp==1) || ((type2==0 || type2==3) && seltyp==2)))
               || (gop==2 && ((type==1 && seltyp==1) || (type2==1 && seltyp==2)))
               || (gop==3 && ((type==2 && seltyp==1) || (type2==2 && seltyp==2)))
               || (gop==4 && ((type==4 && seltyp==1) || (type2==4 && seltyp==2))) ) { //Highlight Color
          fill(c_2h, c_2s, c_2b, alp);
          rect(x_, y_, s_, s_);
        }
        else {   // Genetic Operator Not Selected
          //fill(c_0h, c_0s, c_0b, alp);
          fill(c_3h, c_3s, c_3b, alp);
          rect(x_, y_, s_, s_);
        }
        
        noFill();
      }
       else { //Selected File Average
        
        if (gop>0) { //Color average (calculated in typeColor()) for the genetic operator views with a black square underneath
          if (seltyp==1) { fill(hue(c1), saturation(c1), brightness(c1), alp); }
                    else { fill(hue(c2), saturation(c2), brightness(c2), alp); }
          rect(x_, y_, s_, s_);
        }
        else if ( (seltyp==1 && c_+m_+r_+cr_>0) || (seltyp!=1 && c2_+m2_+r2_+cr2_>0) ){ //Symbol average of all the genetic operators
               //First draws the colored Crossover square, then places the Mutation and Copy circles with the proportionate transparency
          float a_0;
          
       // ## Mutation
          fill(c_2h, c_2s, c_2b, alp);
          rect(x_, y_, s_, s_);
          
      // ## Crossover
          noFill();
          if (seltyp==1) { a_0 = r_/(m_+r_); }
          else { a_0 = r2_/(m2_+r2_); }
          stroke(c_3h, c_3s, c_3b, a_0*alp);
          strokeWeight(2*mapz);
          line(x_, y_, x_+s_, y_+s_);
          
       // ## Crossover + Mutation (cr->r  m->cr  r->m)
          if (seltyp==1) { a_0 = cr_/(m_+cr_); }
          else { a_0 = cr2_/(m2_+cr2_); }
          stroke(c_3h, c_3s, c_3b, a_0*alp);
          strokeWeight(2*mapz);
          noFill();
          rect(x_+(1.8*mapz), y_+(1.8*mapz), s_-(3.6*mapz), s_-(3.6*mapz));
          noStroke();
       // ## Copy
          if (seltyp==1) { a_0 = c_/runs.size(); }
          else { a_0 = c2_/runs.size(); }
          fill(c_3h, c_3s, c_3b, a_0*alp);
          rect(x_+(1*mapz), y_+(1*mapz), s_-(2*mapz), s_-(2*mapz));
        }
        else {
          fill(c_3h, c_3s, c_3b, alp);
          rect(x_, y_, s_, s_);
        }
        
        noFill();
      }
    }
    else if (colswitch==2) {           //Children Fill
      if (mode && !sel && !mouse) {    // Not Selected
        fill(c_0h, c_0s, c_0b, alp); }
      else {                           // Selected
        fill(i_hue, 100, constrain(map((childs/runsn), 0, num_l/(num_l/10), 0, 100), 0, 100), alp);
        //fill(i_hue, 100, constrain(map((childs/runsn), 0, num_l/10, 0, 100), 0, 100), alp);
        //fill(constrain(map((children.size()/runsn), 0, num_l/10, 0, 40), 0, 40), 100, 100);
        //fill(constrain(map((children.size()/runsn), 0, num_l/10, 0, 330), 0, 330), 100, 100);
      }
    }
    
    if ((mouse && !eva) || msel) { //Outline (Mouse-Over or Pressed)
      strokeWeight(2);
      stroke(c_sel);
    }
    if (msel2) {
      fill(c_sel);
    }
    
    rect(x_, y_, s_, s_);
    
  }
  
  void showLink() {
    
    if ( !(msel && eva) ) {
      float x_ = (x*mapz)+mapx;
      float y_ = (y*mapz)+mapy;
      float s_ = nsize*mapz;
      
      noFill();
      strokeWeight(2f);
      
      //Finding alpha for link based on the number of nodes selected in the collumn
      float nsel;
      float mina = 10; //minimum alpha
      if (filesel<0) {
        mina = ceil(mina/runs.size())+1;
      }
      if (!mode) { //Nothing is selected
        nsel = mina;
      } else {
        if (filesel>-1) {
          nsel = pops.get(idpop).nsel;
          nsel = map(nsel, 1, num_l, 50, mina);
        } else {
          nsel = 0;
          for (ArrayList<Population> pops0 : runs) {
            nsel += pops0.get(idpop).nsel;
          }
          nsel = map(nsel, 1, num_l, mina*2, mina/2);
          nsel = constrain(nsel, ceil(mina/2), ceil(mina*2));
        }
      }
      
      if (timel && timeline.size()>0) { nsel*=0.4; }
      
      y_ = y_+s_/2;
      if (father!=null) {
        if (!mode || father.sel) {
          
          boolean bloop = true;
          if (timel && timeline.size()>idpop) {
            if (id==timeline.get(idpop).id && father.id==timeline.get(idpop-1).id) {
              bloop = false;
            }
          }
          if (bloop) {
            connection(father, 2, x_, y_, s_, nsel);
          } else {
            connection(father, 2, x_, y_, s_, 100);
          }
          
        }
      }
      if (mother!=null) {
        if (!mode || mother.sel) {
          
          boolean bloop = true;
          if (timel && timeline.size()>idpop) {
            if (id==timeline.get(idpop).id && mother.id==timeline.get(idpop-1).id) {
              bloop = false;
            }
          }
          if (bloop) {
            connection(mother, 1, x_, y_, s_, nsel);
          } else {
            connection(mother, 1, x_, y_, s_, 100);
          }
          
        }
      }
    }
    
  }
  
  void connection(Indiv ind, int sex, float x_, float y_, float s_, float nsel) {
    float xi_;
    float yi_;
    
    if (filesel==-1 && !fitpos) { //Fixes position for Position by Fitness during File Average
      x_ = (pops.get(idpop).pop.get(pos).x*mapz)+mapx;
      y_ = (pops.get(idpop).pop.get(pos).y*mapz)+mapy;
      xi_ = (pops.get(ind.idpop).pop.get(ind.pos).x*mapz)+mapx;
      yi_ = (pops.get(ind.idpop).pop.get(ind.pos).y*mapz)+mapy;
    } else {
      xi_ = (ind.x*mapz)+mapx;
      yi_ = (ind.y*mapz)+mapy;
    }
    
    color col;
    
    if (locktyp || (mother==null || father==null)) {
    //if (locktyp || (type!=2 && seltyp==1) || (type2!=2 && seltyp==2)) {
      col = c_n;
    } else {
      if (sex==1) { col = c_m; }
      else { col = c_f; }
    }
    
    //if (nsel>0) {
    col = color(hue(col),saturation(col),brightness(col), nsel);
    //}
    
    if (mode) {
      if (sel) { stroke(col); } //If it's selected
      else { noStroke(); }      //If it's not selected
    }
    else { stroke(col); }       //If nothing is selected
    
    xi_ += s_;
    yi_ += s_/2;
    
    if (bez) {
      line(x_, y_, xi_, yi_);
    }
    else {
      float d = (esize*mapz)/3f;
      bezier(x_, y_, x_-d, y_,    xi_+d, yi_, xi_, yi_ );
    }
  }
  
  
  void selectChildren() {
    for (Indiv ind : children) {
      if (!ind.sel) {
        ind.sel = true;
        if (filesel==-1) {
          pops.get(ind.idpop).pop.get(ind.pos).sel = true;
          pops.get(ind.idpop).pop.get(ind.pos).nsel++; }
        
        ind.selectChildren();
      }
    }
  }
  
  
  void selectParents() {
    if (mother!=null) {
      if (!mother.sel) {
        mother.sel=true;
        if (filesel==-1) {
          pops.get(mother.idpop).pop.get(mother.pos).sel = true;
          pops.get(mother.idpop).pop.get(mother.pos).nsel++; }
        
        mother.selectParents();
      }
    }
    if (father!=null) {
      if (!father.sel) {
        father.sel=true;
        if (filesel==-1) {
          pops.get(father.idpop).pop.get(father.pos).sel = true;
          pops.get(father.idpop).pop.get(father.pos).nsel++; }
        
        father.selectParents();
      }
    }
  }
  
  //Works like selectParents() but it's used to save the path that links
  //the currently select individual to the best individual in the family tree
  void bestPath(Indiv best) {
    
    if (mother!=null && father!=null) {
      if (mother.fit>=father.fit) {
        if (!ffound) { checkBest(mother, best); }
        if (!ffound) { checkBest(father, best); }
      } else {
        if (!ffound) { checkBest(father, best); }
        if (!ffound) { checkBest(mother, best); }
      }
    } else {
      if (!ffound) { checkBest(mother, best); }
      if (!ffound) { checkBest(father, best); }
    }
    
    if (ffound) { timeline.add(this); }
  }
  
  void checkBest(Indiv ind, Indiv best) {
    if (ind!=null) {
      if (!ind.fsel) {
        if (ind.id == best.id) {
          ffound = true;
        }
        else {
          ind.fsel = true;
          if (ind.idpop>best.idpop) {
            ind.bestPath(best);
          }
        }
      }
    }
  }
  
  boolean evaSearch(int pid, ArrayList<Population> pops0, boolean selb) {
    //Selects parents and checks whether the entire population pid was selected by the end
    evaChildren(pid, selb);
    
    for (Indiv i : pops0.get(pid).pop) {
      if (!i.sel) {
        return false; }
    }
    return true;
  }
  
  void evaChildren(int pid, boolean selb) {
    if (idpop<pid) {
      for (Indiv i : children) {
        if (!i.sel) {
          i.sel = true;
          if (filesel==-1 && selb) {
            pops.get(i.idpop).pop.get(i.pos).sel = true;
            pops.get(i.idpop).pop.get(i.pos).nsel++;
          }
          
          i.evaChildren(pid, selb);
        }
      }
    }
  }
  
  
  
  //This function is used to check the tree array for a single branch which has either been added or removed
  //The array is compared from beginning to end, and from end to beginning
  //Those that don't match on BOTH comparisons must be new
  //When the nodes are matched, their positions are copied from old to new
  //At the end, those that weren't matched on both comparisons will have their positions reseted
  //This should work because a single altered branch will be found in sequence
  
  //however this doesn't check for removed nodes
  //doing this would require an inverse comparison to see which ones were added when going from new to old
  //the biggest problem is keeping these nodes in the tree, because we would have to find which were the nodes connected to them and reconnect them
  //this is hard because finding nodes no not have many points of distinction, making it easy to mistake one for another and connect the old branch to the wrong node
  //this is made harder when the nodes need to be compared in a tree which might have had it's branches reordered due to the addition or removal of a branch

  // the only points of comparison are the operator, the level, it's position on the level. the degree and children and parents
  // the degree, pos and children are not good points because they might have been subjected to alterations, but the rest must be unchanged for the compared node to remain the same node
  // the problem is that any two nodes can have the same operator, level and parents
  
  // would it be posible to maintain some sort of persistent ids?
  
  void compareTree(Indiv oldi) {
    ArrayList<Branch> newt, oldt;
    if (seltyp == 1) {
      newt = tree;
      oldt = oldi.tree;
    } else {
      newt = tree2;
      oldt = oldi.tree2;
    }
    
    for (Branch b : newt) { b.bool=false; b.newn=false; }
    for (Branch b : oldt) { b.bool=false; b.newn=false; }
    
    
    //Smallest tree
    int min = min(newt.size(), oldt.size());
    
    //Forward search
    for (int i=0; i<min; i++) {
      Branch newb = newt.get(i);
      Branch oldb = oldt.get(i);
      
      boolean test = true;
      //removed (|| newb.degree!=oldb.degree)
      if (newb.level!=oldb.level || !newb.op.equals(oldb.op)) { test = false; }
      if (newb.prev!=null && oldb.prev!=null) {
        if (!newb.prev.op.equals(oldb.prev.op)) { test = false; }
      if (newb.prev.prev!=null && oldb.prev.prev!=null) {
        if (!newb.prev.prev.op.equals(oldb.prev.prev.op)) { test = false; } } }
        
      if (test) {
        newb.bool = true;
        newb.pos.x = oldb.pos.x;
        newb.pos.y = oldb.pos.y;
      }
      
    }
    
    //Backwards search
    int news = newt.size()-1;
    int olds = oldt.size()-1;
    for (int i=min-1; i>=0; i--) {
      Branch newb = newt.get(news);
      Branch oldb = oldt.get(olds);
      
      boolean test = true;
      if (newb.level!=oldb.level || !newb.op.equals(oldb.op) || newb.degree!=oldb.degree) { test = false; }
      if (newb.prev!=null && oldb.prev!=null) {
        if (!newb.prev.op.equals(oldb.prev.op)) { test = false; }
      if (newb.prev.prev!=null && oldb.prev.prev!=null) {
        if (!newb.prev.prev.op.equals(oldb.prev.prev.op)) { test = false; } } }
        
      if (test) {
        newb.bool = true;
        newb.pos.x = oldb.pos.x;
        newb.pos.y = oldb.pos.y;
      }
      
      news--;
      olds--;
    }
    
    
    for (Branch b : newt) { //New nodes
      if (!b.bool) {
        b.pos.x = b.pos0.x;
        b.pos.y = b.pos0.y;
        b.newn = true;
      } 
      for (Branch b2 : newt) { //verifies if any nodes are overlapping
        if (b!=b2) {
          if (b.pos.x==b2.pos.x && b.pos.y==b2.pos.y) { 
            b.pos.x+=1;
            b.pos.y+=1;
          }
        }
      }
    }
    
  }
  
  
  
  
  
  
  // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  //  REPEATED CODE TO DRAW THE OFFSCREEN ELEMENTS INTO A BUFFERED IMAGE SO IT CAN BE EXPORTED
  
  
  void buffer() {
    float x_ = (x+nsize)*mapz;
    float y_ = (y-(coltop-minim)+nsize)*mapz;
    float s_ = nsize*mapz;
    
    if (filesel>-1 || !mode || !sel) { alp0 = 100; }
    else { alp0 = map(nsel, 1, runs.size(), 50, 100); }
    
    if (fitpos) { alp = alp0; }
    else { alp = alp0 / n_alp; }
    
    buffer.noStroke();
    
    if (colswitch==0) {                //Fitness Fill
      if (mode && !sel && !mouse) {    // Not Selected
        buffer.fill(c_0h, c_0s, c_0b, alp);
      }
      else {                           // Selected
        buffer.fill(i_hue, 100, fit2, alp);
      }
    }
    else if (colswitch==1) {           //Type Fill
      if (mode && !sel && !mouse) {    // Not Selected
        buffer.fill(c_0h, c_0s, c_0b, alp);
      }
      else if (filesel>-1) {           // Selected and not File Average
        if (type == -1) {
          buffer.fill(c_1h, c_1s, c_1b, alp);
          buffer.rect(x_, y_, s_, s_);
        }
        else if (gop==0 || mouse) { //Symbol
          
          buffer.fill(c_2h, c_2s, c_2b, alp);
          buffer.rect(x_, y_, s_, s_);
          buffer.fill(c_3h, c_3s, c_3b, alp);
          if ((type==0 && seltyp==1) || (type2==0 && seltyp==2)) { //Copy Symbol
            buffer.rect(x_+(1*mapz), y_+(1*mapz), s_-(2*mapz), s_-(2*mapz));
          } else if ((type==1 && seltyp==1) || (type2==1 && seltyp==2)) { //Mutation Symbol
            //buffer.triangle(x_1, y_+s_1, x_+s_1, y_+s_1, x_+s_/2, y_1);
            buffer.stroke(c_3h, c_3s, c_3b, alp);
            buffer.strokeWeight(2*mapz);
            buffer.noFill();
            buffer.rect(x_+(1.8*mapz), y_+(1.8*mapz), s_-(3.6*mapz), s_-(3.6*mapz));
            buffer.fill(c_3h, c_3s, c_3b, alp);
            buffer.noStroke();
          } else if ((type==2 && seltyp==1) || (type2==2 && seltyp==2)) { //Crossover Symbol
            
          }
        }
        else if ( (gop==1 && ((type==0 && seltyp==1) || (type2==0 && seltyp==2)))
               || (gop==2 && ((type==1 && seltyp==1) || (type2==1 && seltyp==2)))
               || (gop==3 && ((type==2 && seltyp==1) || (type2==2 && seltyp==2))) ) { //Highlight Color
          buffer.fill(c_2h, c_2s, c_2b, alp);
          buffer.rect(x_, y_, s_, s_);
        }
        else {   // Genetic Operator Not Selected
          //buffer.fill(c_0h, c_0s, c_0b, alp);
          buffer.fill(c_3h, c_3s, c_3b, alp);
          buffer.rect(x_, y_, s_, s_);
        }
        
        buffer.noFill();
      }
      else { //Selected File Average
        
        if (gop>0) { //Color average (calculated in typeColor()) for the genetic operator views with a black square underneath
          if (seltyp==1) { buffer.fill(hue(c1), saturation(c1), brightness(c1), alp); }
                    else { buffer.fill(hue(c2), saturation(c2), brightness(c2), alp); }
          buffer.rect(x_, y_, s_, s_);
        }
        else if ( (seltyp==1 && c_+m_+r_+cr_>0) || (seltyp!=1 && c2_+m2_+r2_+cr2_>0) ){ //Symbol average of all the genetic operators
               //First draws the colored Crossover square, then places the Mutation and Copy circles with the proportionate transparency
          float a_0;
          
       // ## Mutation
          buffer.fill(c_2h, c_2s, c_2b, alp);
          buffer.rect(x_, y_, s_, s_);
          
      // ## Crossover
          buffer.noFill();
          if (seltyp==1) { a_0 = r_/(m_+r_); }
          else { a_0 = r2_/(m2_+r2_); }
          buffer.stroke(c_3h, c_3s, c_3b, a_0*alp);
          buffer.strokeWeight(2*mapz);
          buffer.line(x_, y_, x_+s_, y_+s_);
          
       // ## Crossover + Mutation (cr->r  m->cr  r->m)
          if (seltyp==1) { a_0 = cr_/(m_+cr_); }
          else { a_0 = cr2_/(m2_+cr2_); }
          buffer.stroke(c_3h, c_3s, c_3b, a_0*alp);
          buffer.strokeWeight(2*mapz);
          buffer.noFill();
          buffer.rect(x_+(1.8*mapz), y_+(1.8*mapz), s_-(3.6*mapz), s_-(3.6*mapz));
          buffer.noStroke();
       // ## Copy
          if (seltyp==1) { a_0 = c_/runs.size(); }
          else { a_0 = c2_/runs.size(); }
          buffer.fill(c_3h, c_3s, c_3b, a_0*alp);
          buffer.rect(x_+(1*mapz), y_+(1*mapz), s_-(2*mapz), s_-(2*mapz));
        }
        else {
          buffer.fill(c_3h, c_3s, c_3b, alp);
          buffer.rect(x_, y_, s_, s_);
        }
        
        buffer.noFill();
      }
    }
    else if (colswitch==2) {           //Children Fill
      if (mode && !sel && !mouse) {    // Not Selected
        buffer.fill(c_0h, c_0s, c_0b, alp); }
      else {                           // Selected
        buffer.fill(i_hue, 100, constrain(map((childs/runsn), 0, num_l/10, 0, 100), 0, 100), alp);
        //buffer.fill(constrain(map((children.size()/runsn), 0, num_l/10, 0, 40), 0, 40), 100, 100);
        //buffer.fill(constrain(map((children.size()/runsn), 0, num_l/10, 0, 330), 0, 330), 100, 100);
      }
    }
    
    if ((mouse && !eva) || msel) { //Outline (Mouse-Over or Pressed)
      buffer.strokeWeight(2);
      buffer.stroke(c_sel);
    }
    if (msel2) {
      buffer.fill(c_sel);
    }
    
    buffer.rect(x_, y_, s_, s_);
    
  }
  
  
  void bufferLink() {
    
    if ( !(msel && eva) ) {
      float x_ = (x+nsize)*mapz;
      float y_ = (y-(coltop-minim)+nsize)*mapz;
      float s_ = nsize*mapz;
      
      buffer.noFill();
      buffer.strokeWeight(2f);
      
      //Finding alpha for link based on the number of nodes selected in the collumn
      float nsel;
      float mina = 10; //minimum alpha
      if (filesel<0) {
        mina = ceil(mina/runs.size())+1;
      }
      if (!mode) { //Nothing is selected
        nsel = mina;
      } else {
        if (filesel>-1) {
          nsel = pops.get(idpop).nsel;
          nsel = map(nsel, 1, num_l, 50, mina);
        } else {
          nsel = 0;
          for (ArrayList<Population> pops0 : runs) {
            nsel += pops0.get(idpop).nsel;
          }
          nsel = map(nsel, 1, num_l, mina*2, mina/2);
          nsel = constrain(nsel, ceil(mina/2), ceil(mina*2));
        }
      }
      
      if (timel && timeline.size()>0) { nsel*=0.4; }
      
      y_ = y_+s_/2;
      if (father!=null) {
        if (!mode || father.sel) {
          
          boolean bloop = true;
          if (timel && timeline.size()>idpop) {
            if (id==timeline.get(idpop).id && father.id==timeline.get(idpop-1).id) {
              bloop = false;
            }
          }
          if (bloop) {
            connectionB(father, 2, x_, y_, s_, nsel);
          } else {
            connectionB(father, 2, x_, y_, s_, 100);
          }
          
        }
      }
      if (mother!=null) {
        if (!mode || mother.sel) {
          
          boolean bloop = true;
          if (timel && timeline.size()>idpop) {
            if (id==timeline.get(idpop).id && mother.id==timeline.get(idpop-1).id) {
              bloop = false;
            }
          }
          if (bloop) {
            connectionB(mother, 1, x_, y_, s_, nsel);
          } else {
            connectionB(mother, 1, x_, y_, s_, 100);
          }
          
        }
      }
    }
    
  }
  
  void connectionB(Indiv ind, int sex, float x_, float y_, float s_, float nsel) {
    float xi_;
    float yi_;
    
    if (filesel==-1 && !fitpos) { //Fixes position for Position by Fitness during File Average
      x_ = (pops.get(idpop).pop.get(pos).x+nsize)*mapz;
      y_ = (pops.get(idpop).pop.get(pos).y-(coltop-minim)+nsize)*mapz;
      xi_ = (pops.get(ind.idpop).pop.get(ind.pos).x+nsize)*mapz;
      yi_ = (pops.get(ind.idpop).pop.get(ind.pos).y-(coltop-minim)+nsize)*mapz;
    } else {
      xi_ = (ind.x+nsize)*mapz;
      yi_ = (ind.y-(coltop-minim)+nsize)*mapz;
    }
    
    color col;
    
    if (locktyp || (mother==null || father==null)) {
    //if (locktyp || (type!=2 && seltyp==1) || (type2!=2 && seltyp==2)) {
      col = c_n;
    } else {
      if (sex==1) { col = c_m; }
      else { col = c_f; }
    }
    
    //if (nsel>0) {
    col = color(hue(col),saturation(col),brightness(col), nsel);
    //}
    
    if (mode) {
      if (sel) { buffer.stroke(col); } //If it's selected
      else { buffer.noStroke(); }      //If it's not selected
    }
    else { buffer.stroke(col); }       //If nothing is selected
    
    xi_ += s_;
    yi_ += s_/2;
    
    if (bez) {
      buffer.line(x_, y_, xi_, yi_);
    }
    else {
      float d = (esize*mapz)/3f;
      buffer.bezier(x_, y_, x_-d, y_,    xi_+d, yi_, xi_, yi_ );
    }
  }
}
