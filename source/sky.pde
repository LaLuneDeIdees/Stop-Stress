
float SKY_H = 100.0f;

void draw_nebo() {
  SKY_H = -canva.height/2;
  float k = 150.0;
  float angle = -5;
  float Az = SKY_H/angle;
  for (int x=0; x<canva.width; x+=3) {
    for (float y=0; y<canva.height/9*6; y+=3.001) {
      //double realz = Z*(1.0 - (SKY_H+y)/(y-height/2));
      float kz = Z/(y-canva.height/2);
      double realz = kz/(kz+angle)*(abs(Az)+abs(Z))+Z;
      realz*=-1;
      //println(realz);

      double realx = (x-canva.width/2)*(1.0-realz/Z);
      double data = noise((float)realx/k+millis()/4000.0, (float)realz/k-millis()/8000.0, millis()/10000.0)*255;
      //if(data<millis()/200)data=0;
      data-=200*(100-gl_pogoda)/100;
      //data = realz/-100;
      if (data<0)data=0;
      float k1 = (float)data/255.0;
      float k2 = 1.0-k1;
      int clr = color(red(bg_color)*k2+255*k1, 
        green(bg_color)*k2+255*k1, 
        blue(bg_color)*k2+255*k1);

      //pixels[x+y*width]=clr;
      int newx =x;
      int newy=(int)y;
      int sizes=3;
      for (int xx=0; xx<sizes; xx++) {
        for (int yy=0; yy<sizes; yy++) {
          canva.pixels[newx+newy*canva.width]=clr;
          newy++;
        }
        newy-=sizes;
        newx++;
      }
    }
  }
}
