int xsize = 256;
int ysize = 512;
float place[][] = new float[xsize][ysize];
float noise[][] = new float[xsize][ysize];
float lasttoy[] = new float[ysize];
int colors[] = new int[xsize];
Tree ts[] = new Tree[xsize];

int nowcolor;
float progyy=0;

void draw_ground() {
  //ground_type=abs((millis()/10000)%13-7);
  switch((int)round(ground_type)) {
  case 0:
    nowcolor=#678E3D;//678E3D; //E9DD00
    break;
  case 1:
    nowcolor=#906902;
    break;
  case 2:
    nowcolor=#F4B756;
    break;
  case 3:
    nowcolor=#90A900;
    break;
  case 4:
    nowcolor=#90A900;
    break;
  case 5:
    nowcolor=#3F704D;
    break;
  case 6:
    nowcolor=#AC9320;
    break;
  case 7:
    nowcolor=#C0C7C2;
    break;
  default:
    break;
  }
  float nowR = red(nowcolor);
  float nowG = green(nowcolor);
  float nowB = blue(nowcolor);
  float lastR = red(colors[xsize-2]);
  float lastG = green(colors[xsize-2]);
  float lastB = blue(colors[xsize-2]);

  float lowwidth_k = canva.width/((float(xsize/2)/(1-(-ysize)/Z))-(float(-xsize/2)/(1-(-ysize)/Z)));


  for (int x=0; x < xsize-1; x++) {
    for (int i=0; i < ysize; i++) {
      place[x][i] = place[x+1][i];
      noise[x][i]=noise[x+1][i];
    }
    colors[x] = colors[x+1];
    ts[x]=ts[x+1];
  }
  colors[xsize-1] = color(lastR+(nowR-lastR)/64.0, 
    lastG+(nowG-lastG)/64.0, 
    lastB+(nowB-lastB)/64.0);
  for (int i=0; i < ysize; i++) {

    float toy = f(millis());
    float tody = toy-lasttoy[i];
    float inter_nowy = place[xsize-2][i];
    float inter_dy = inter_nowy-place[xsize-3][i];
    //dy=(toy-nowy+tody)/100.0;
    PVector vdy=(new PVector(1, toy-inter_nowy).normalize().div(5.0).add(new PVector(1, inter_dy).normalize()));
    inter_dy = vdy.y/vdy.x;
    inter_nowy+=inter_dy+random(-1, 1)/2.0;
    lasttoy[i]= toy;

    place[xsize-1][i]=inter_nowy;
    noise[xsize-1][i]=random(-3, 3);
  }
  /////////////////////
  if (round(random(0, 3))<3) {
    int yy = (int)random(ysize);
    //ts[xsize-1] = new Tree(4, height/30.0*(ysize*2-yy)/ysize, PI/3, yy);

    float len = canva.height/30.0*(ysize*2-yy)/ysize;
    if ((int)round(ground_type)==0)
      ts[xsize-1]=new Tree(2, len*2, len*2, 0.5, PI/2, PI/5*4, yy, 6, 10, true, new Sosna());
    else if ((int)round(ground_type)==4)
      ts[xsize-1]=new Tree(4, len/2, len, 0.8, 0, PI/2, yy, 2, 4, false, new Sheet());
    else if ((int)round(ground_type)==5)
      ts[xsize-1]= new Tree(3, len, len, 0.5, PI/3, PI/2, yy, 6, 10, false, new Palm());
    else ts[xsize-1] = null;
  }
  /////////////////////////
  progyy = canva.height/2/(1.0+width_k*size/Z)+canva.height/2;
  int lastz = 0;
  for (float y=canva.height/2+1; y <=progyy; y+=0.7) {//height/4*3
    for (int x=0; x < canva.width; x+=2) {
      float realz = Z*(1.0-(canva.height/2)/(y-canva.height/2)); //newy = realy/(1.0-realz/Z)
      realz+=width_k*size;
      realz/=lowwidth_k;
      //1.0-realz/Z = realy/newy
      //realz/Z = 1.0-realy/newy
      //realz = Z(1.0-realy/newy)
      float realx = (x-canva.width/2)*(1.0-realz/Z)/lowwidth_k+xsize/2;
      realz*=-1;
      if (realz>=0 && realz<ysize && realx>=0 && realx<xsize) {
        int data = (int)(place[(int)realx][(int)realz]+noise[int(realx)][int(realz)]);
        if (ts[int(realx)]!=null && ts[int(realx)].yi==(int)realz && y-data/2<=progyy) {
          ts[(int)realx].x=x;
          ts[(int)realx].y=(int)y-data/2;
          ts[(int)realx].lastii = -realz-width_k*size;
        }
        if (lastz!=(int)realz) {
          canva.updatePixels();
          for (int i=0; i<xsize; i++)
            if (ts[i]!=null && ts[i].y>=canva.height/3 && ts[i].x>5 && ts[i].yi==lastz) {
              ts[i].draw();
              //println(zbuf[ts[i].x][ts[i].y]);
            }
          canva.loadPixels();
          lastz=(int)realz;
        }

        float k1 = (float)(data-64)/255.0;
        float k2 = 1.0-k1;
        int clr = color(red(colors[(int)realx])*k2+255*k1, 
          green(colors[(int)realx])*k2+255*k1, 
          blue(colors[(int)realx])*k2+255*k1);
        int xw =2;
        realz+=width_k*size;
        data/=2;
        for (int i=0; i<64; i++) {
          if (i/xw+y>canva.height-1 || i/xw+y-data>progyy)break;
          if (zbuf[x+i%xw][int(y+i/xw-data)] < -realz) {
            canva.pixels[x+i%xw+int(y+i/xw-data)*canva.width] =clr;
            zbuf[x+i%xw][int(y+i/xw-data)] = -realz;
          } else break;
        }
      }
    }
  }
}

float f(float x) {
  //x/=10.0;
  x/=10.0;
  //return ( ( cos(pow((0.8588740150433938 + x), 0.778532613221574))) + cos((cos((40.13672346859536 + (x * (-25.53272394855554)))) + pow((32.19561921179342 + x), 0.8617866141222335))))*50;
  return ((((((-3.3372430669918405)) * 0.052588193828190466) + cos((x * (-38.36246315245107)))) * 1.4192218474129366))*height/10;
}
