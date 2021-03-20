import g4p_controls.*;
import processing.serial.*;

Serial s=null;

float Z = 0.0f;
float zbuf[][];

float gl_pogoda = 100; //погода: 0 - ясно ... 100 - буря
float ground_type = 7;

int bg_color=0;
PImage mask;
PGraphics canva;

PImage winI;
boolean isplay = false;
boolean iswin = false;



void settings(){
  
  System.setProperty("jogl.disable.openglcore", "false");
  fullScreen(P2D);
}
void setup() {
  //size(700, 500,P2D);

  createGUI();
  dropList3.setItems(Serial.list(), 0);
  window1.setVisible(false);

  load_d();
  noiseDetail(3);
  noiseSeed(0);
  canva = createGraphics(700, 500, P2D);

  Z = canva.width*cos(PI/6);
  //for (int i=0; i<size*size; i++) {
  //  now[i/size][i%size]=0;
  //}
  //for (int x=0; x<size; x++) {
  //  for (int y=0; y<size; y++) {
  //    last[x][y]=now[x][y];
  //  }
  //}
  zbuf = new float[canva.width][canva.height];
  //last[size/5][size/5*4]=size*4;
  //last[size/5*4][size/5*4]=size;


  porogy = -canva.height/2*(1.0 - (-2*canva.width)/Z);

  //for (int i=0; i < ysize; i++) {

  //  place[xsize-1][i]=random(-16, 16);
  //}

  mask=loadImage("background.png");
  winI = loadImage("win1.png");
  winI.resize(width/10, 0);
  mask.resize(width, height);
  
  
  wid = height/20;
   weather_icon = loadImage("weather_icon.png");
   ground_icon = loadImage("ground_icon.png");
   weather_icon.resize(0,wid-4);
   ground_icon.resize(0,wid-4);
   
   //frameRate(60);
}

void draw() {

  ground_type+=(ground_type_copy-ground_type)/20.0;
  gl_pogoda+=(pogoda_copy-gl_pogoda)/30.0;

  canva.beginDraw();
  //if(key=='p')gl_pogoda+=int(gl_pogoda<100)*0.5;
  //if (mousePressed)gl_pogoda+=int(gl_pogoda<100)*0.5;
  //else gl_pogoda-=int(gl_pogoda>0)*0.5;
  for (int x=0; x<canva.width; x++)for (int y=0; y<canva.height; y++)zbuf[x][y]=-canva.width*4;
  //Z+=1;

  bg_color = color(0x09*(100-gl_pogoda*0.5)/120, 0x73*(100-gl_pogoda*0.5)/120, 0xa7*(100-gl_pogoda*0.5)/120);
  canva.background(bg_color);
  canva.loadPixels();
  canva.resetMatrix();
  draw_nebo();
  canva.resetMatrix();
  draw_water();
  canva.resetMatrix();
  draw_ground();
  canva.updatePixels();

  //loadPixels();
  //for (int x=0; x<width; x++)for (int y=0; y<height; y++)pixels[x+y*width]=color(255+zbuf[x][y]/8);
  //updatePixels();
  //for (int i=0; i<xsize; i++)
  //  if (ts[i]!=null && ts[i].y>=height/3 && ts[i].x>5) {
  //    ts[i].draw();
  //    //println(zbuf[ts[i].x][ts[i].y]);
  //  }

  canva.resetMatrix();
  snow();
  canva.resetMatrix();
  rain();

  canva.resetMatrix();
  canva.noStroke();
  canva.fill(0, gl_pogoda*1.5);
  canva.rect(0, 0, canva.width, canva.height);

  //println(frameRate);
  //delay(1000/60);
  canva.endDraw();
  imageMode(CORNER);
  noTint();
  image(canva, 0, 0, width, height);
  image(mask, 0, 0);

  if (isplay) {
    iswin |= gl_pogoda<10 && (int)round(ground_type) == 0;
    if (iswin) {
      delay(100);
      isplay=false;
    }
  }

  if (iswin) {
    gl_pogoda = 0;
    ground_type=0;
    tint(255, sin(millis()/300.0)*127+127);
    image(winI, width*9/10, 0);
  }
  
  
  canva.resetMatrix();
  score_update();
  
  println(frameRate);
}

void keyPressed() {
  if (key==ESC) {
    save_d();
    window1.dispose();
  }

  if (key=='z') {
    isplay=false;
    iswin=false;
    ground_type_copy=7;
    pogoda_copy=100;
    
    selectInput("Select last session:", "select_last_session");
  }
  if (key=='x') {
    ground_type_copy=7;
    pogoda_copy=100;
    iswin=false;
  }

  if (key=='s') {
    window1.setVisible(false);
    window1.close();
    window1.setVisible(true);
  }
}

void save_d() {
  /*
  int xsize = 256;
   int ysize = 512;
   float place[][] = new float[xsize][ysize];
   float noise[][] = new float[xsize][ysize];
   float lasttoy[] = new float[ysize];
   int colors[] = new int[xsize];
   
   
   int size = 512;
   
   float last[][]=new float[size][size];
   float now[][]=new float[size][size];
   */
  String place_s[] = new String[xsize*ysize];
  String noise_s[] = new String[xsize*ysize];
  String lasttoy_s[] = new String[ysize];
  String colors_s[] = new String[xsize];
  String last_s[] = new String[size*size];
  String now_s[] = new String[size*size];
  for (int i=0; i<xsize*ysize; i++) {
    place_s[i]=str(place[i%xsize][i/ysize]);
    noise_s[i]=str(noise[i%xsize][i/ysize]);
  }
  for (int i=0; i<ysize; i++) {
    lasttoy_s[i]=str(lasttoy[i]);
  }
  for (int i=0; i<xsize; i++) {
    colors_s[i]=str(colors[i]);
  }
  for (int i=0; i<size*size; i++) {
    now_s[i]=str(now[i%size][i/size]);
    last_s[i]=str(last[i%size][i/size]);
  }
  saveStrings("data/place.rlx", place_s);
  saveStrings("data/noise.rlx", noise_s);
  saveStrings("data/lasttoy.rlx", lasttoy_s);
  saveStrings("data/colors.rlx", colors_s);
  saveStrings("data/last.rlx", last_s);
  saveStrings("data/now.rlx", now_s);
}


void load_d() {
  /*
  int xsize = 256;
   int ysize = 512;
   float place[][] = new float[xsize][ysize];
   float noise[][] = new float[xsize][ysize];
   float lasttoy[] = new float[ysize];
   int colors[] = new int[xsize];
   
   
   int size = 512;
   
   float last[][]=new float[size][size];
   float now[][]=new float[size][size];
   */
  String place_s[] = loadStrings("data/place.rlx");
  String noise_s[] = loadStrings("data/noise.rlx");
  String lasttoy_s[] = loadStrings("data/lasttoy.rlx");
  String colors_s[] = loadStrings("data/colors.rlx");
  String last_s[] = loadStrings("data/last.rlx");
  String now_s[] = loadStrings("data/now.rlx");
  for (int i=0; i<xsize*ysize; i++) {
    place[i%xsize][i/ysize] = float(place_s[i]);
    noise[i%xsize][i/ysize] = float(noise_s[i]);
  }
  for (int i=0; i<ysize; i++) {
    lasttoy[i] = float(lasttoy_s[i]);
  }
  for (int i=0; i<xsize; i++) {
    colors[i] = int(colors_s[i]);
  }
  for (int i=0; i<size*size; i++) {
    now[i%xsize][i/ysize] = float(now_s[i]);
    last[i%xsize][i/ysize] = float(last_s[i]);
  }
}
