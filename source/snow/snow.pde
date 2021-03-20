float porogy=0;
void setup() { //newy = realy / (1.0 - realz/Z)
  //find realy
  //realy = newy(1.0 - realz/Z)
  //size(700,500);
  fullScreen();
  rectMode(CENTER);
  noStroke();


  porogy = -height/2*(1.0 - (-2*width)/Z);
}
final int count = 4096;
final int count_int = 6;
final float kapla_width = 10*4;
final float v = 7*10;
final float Z = 600.0f;
ArrayList kapli = new ArrayList();
void draw() {
  background(60, 20, 70);
  if (kapli.size()<count+1 && mousePressed) {
    for (int i=0; i<count_int; i++) {
      float kapla[] = {random(-width*2, width*2), random(porogy-kapla_width*32, porogy), random(-width*2, 0)};
      kapli.add(kapla);
    }
  }
  for (int i=0; i<kapli.size(); i++) {
    float kapla[] = (float[])kapli.get(i);
    int newx = int(kapla[0]/(1.0-kapla[2]/Z))+width/2;
    int newy = int(kapla[1]/(1.0-kapla[2]/Z))+height/2;
    int newkw = int(kapla_width/(1.0-kapla[2]/Z));
    //circle(newx,newy,newkw);
    stroke(255, (1.0-newkw/-width/2)*16);
    line(newx, newy, newx-newkw, newy+newkw*5);
    kapla[1]+=v;
    kapla[0]-=v/5;
    if (newy>height || newx<0) {
      kapli.remove(i);
      i--;
    }
  }
}
