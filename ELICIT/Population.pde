class Population {
  
  ArrayList<Indiv> pop = new ArrayList<Indiv>();
  
  int id; //Population ID (Correspoding to it's index on the population array)
  boolean mouse = false;
  
  float x, y;
  
  int nsel = 0; //Number of individuals in the column selected currently (determines link opacity)
  
  Population(int id) {
    this.id=id;
  }
  
  void selCount() {
    nsel = 0;
    for (Indiv ind : pop) {
      if (ind.sel) { nsel++; }
    }
  }
  
  void show() {
    float x_ = (x*mapz)+mapx;
    float y_ = (y*mapz)+mapy;
    float w_ = nsize*mapz;
    float h_ = (coltop-minim)*mapz;
    
    if (mouse || (eva && pos[0]==id)) {
      noFill();
      strokeWeight(2);
      stroke(c_sel);
      rect(x_, y_+h_, w_, nsize*mapz*num_l);
      
      //fill(45,  25,  95);
      fill(c_sel);
      noStroke();
      rect(x_, y_, w_, h_);
    }
    else {
      fill(c_top);
      //fill(0, 0, 0);
      noStroke();
      rect(x_, y_, w_, h_);
    }
    
  }
  
  
}
