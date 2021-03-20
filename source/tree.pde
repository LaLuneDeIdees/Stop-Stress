
  //Tree t= new Tree(4, 20,40,0.8, 0,PI/2, 0,2,4,false,new Sheet());
  //Tree t= new Tree(3, 80,80,0.5,PI/3,PI/2, 0,6,10,false,new Palm());
  //Tree t= new Tree(2, 80, 81, 0.5, PI/2, PI/5*4, 0, 6, 10, true,new Sosna());

class Tree {
  Sheet l;
  int x, y, yi;
  float lastii=0;
  Branch t;
  Tree(int levels, float start_len, float end_len, float klen, float start_angle, float end_angle, int yi_, int startr, int endr, boolean center,Sheet _l) {
    l=_l;
    x=canva.width/2;
    y=0;
    yi=yi_;
    t=new Branch(levels, start_angle, end_angle, start_len, end_len, klen, startr, endr, center,_l);
    int  r = (int)round(random(-1, 1));
    if (center&&r==0)r=1;
    t.angle=random(start_angle/10, end_angle/10)*r;
  }
  void draw() {
    canva.pushMatrix();
    canva.translate(x, y);
    t.draw();
    canva.popMatrix();
  }
  class Branch {
    boolean end=false;
    Branch bs[];
    float angle, len;
    int start;
    int size;
    Branch(int level, float start_angle, float end_angle, float start_len, float end_len, float klen, int startr, int endr, boolean center,Sheet _l) {
      int  r = (int)round(random(-1, 1));
      if (center&&r==0)r=1;
      angle = random(start_angle, end_angle)*r;
      len=random(start_len, end_len);
      
      start=(int)random(1000, 3000);
      start_len*=klen;
      end_len*=klen;
      end=level!=1;
      size = (int)random(startr, endr);
      if (end) {
        bs = new  Branch[size];
        for (int i=0; i<size; i++) {
          bs[i]=new Branch(level-1, start_angle, end_angle, start_len, end_len, klen, startr, endr, center,_l);
        }
      }
    }
    void draw() {
      angle+=PI/180/10*(((millis()+start)/start%2==0)? 1:-1);
      canva.rotate(angle);
      canva.stroke(0);
      canva.line(0, 0, 0, -len);
      if (!end) {
        canva.translate(0,-len);
        l.draw(len);
        //fill(0, 255, 0);
        //noStroke();
        //rectMode(CENTER);
        //rect(0, -len, len/2, len/2);
      }
      if (end) {
        canva.translate(0, -len);
        for (int i=0; i<size; i++) {
          canva.pushMatrix();
          bs[i].draw();
          canva.popMatrix();
        }
      }
    }
  }
}

class Sheet {
  PImage i;
  int tintt=127;
  Sheet(){
    i = loadImage("Sheet.png");
    tintt = (int)random(127,255);
  }
  void draw(float len) {
    //fill(0, 255, 0);
    //noStroke();
    //rectMode(CENTER);
    //rect(0, 0, len/2, len/2);
    
    canva.imageMode(CENTER);
    canva.tint(tintt);
    canva.image(i,0,len/2,len*2,i.height*len*2/i.width);
  }
}

class Palm extends Sheet{
  PImage i;
  Palm(){
    i = loadImage("Palm.png");
    tintt = (int)random(127,255);
  }
  void draw(float len){
    //fill(0, 255, 0);
    //noStroke();
    ////rectMode(CENTER);
    //circle(0, 0, len);
    canva.imageMode(CENTER);
    canva.tint(tintt);
    canva.image(i,0,len/2,len*3,i.height*len*3/i.width);
  }
}
class Sosna extends Sheet{
  PImage i;
  Sosna(){
    i = loadImage("Sosna.png");
    tintt = (int)random(127,255);
  }
  void draw(float len){
    //fill(0, 255, 0);
    //noStroke();
    //rectMode(CENTER);
    canva.imageMode(CENTER);
    canva.tint(tintt);
    canva.image(i,0,len/2,len/2,i.height*len/2/i.width);
    //circle(0, -len, len/2);
  }
}
