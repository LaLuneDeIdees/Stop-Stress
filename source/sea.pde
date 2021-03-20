
int size = 512;

float last[][]=new float[size][size];
float now[][]=new float[size][size];
float width_k = 1;
void draw_water() {
  int maxdata =0;
  float lowWidth = int(float(size/2)/(1-(-size)/Z))-int(float(-size/2)/(1-(-size)/Z));
  width_k = canva.width/lowWidth;
  for (int x=0; x<canva.width; x+=2) {
    for (int y=canva.height-1; y>canva.height/2; y-=2) {
      int newy=y;
      int newx = x;
      double realz = Z*(1.0 - float(canva.height/2)/(newy-canva.height/2))/width_k;
      double realx = (newx-canva.width/2)*(1.0-realz/Z)/(width/lowWidth);

      if (!(realz>-size && realx<size/2 && realz<0 && realx>-size/2))continue;
      int data = (int)now[(int)(realx+size/2)][(int)((realz+size))-1]; 
      if (data>maxdata)maxdata=data;
      data = (int)(data/(1.0-realz/Z));
      newy-=data/4;
      data*=2;
      data+=16;
      if (data<-127)data=-127;
      float k2 = (255-data)/255.0;
      int clr = color(red(bg_color)*k2+data, 
        green(bg_color)*k2+data, 
        blue(bg_color)*k2+data);
      int sizes=2;
      //for (int yy=0; yy<sizes; yy++) {
      //  if (newx>=0 && newy>=0 && newx<width && newy<height) {
      //    if (realz<=zbuf[newx][newy])break;
      //    zbuf[newx][newy]=(float)realz;
      //    pixels[newx+newy*width]=clr;
      //  }
      //  newy++;
      //}

      for (int xx=0; xx<sizes; xx++) {
        for (int yy=0; yy<sizes; yy++) {
          if (newx>=0 && newy>=0 && newx<canva.width && newy<canva.height) {
            if (realz<=zbuf[newx][newy])break;
            zbuf[newx][newy]=(float)realz;
            canva.pixels[newx+newy*canva.width]=clr;
          }
          newy++;
        }
        newy-=sizes;
        newx++;
      }
    }
  }

  if ( true) {
    int i = (int)random(size-8)+4;
    int j = (int)random(size-8)+4;
    int ampl = (int)(127/16+(127-127/16)*gl_pogoda/100);
    last[i][j]=random(-ampl, ampl);
    for (int n=0; n<4; n++) {
      last[i-n][j+n]=last[i][j];
      last[i+n][j+n]=last[i][j];
      last[i-n][j-n]=last[i][j];
      last[i+n][j-n]=last[i][j];
    }
    if (key=='a') {
      //last[4][04]=size*16;
      for (int b=0; b<size/3; b++)
        last[size/3-b][b]=size;
      //last[size/3][size/32]=size*1024;
    }
    if (gl_pogoda>50) {
      ampl = 127/16;
      for (int n=0; n<size*4; n++) {
        i = (int)random(size-8)+4;
        j = (int)random(size-8)+4;
        last[i][j]+=random(-ampl, ampl);
      }

      ////////////////////////////////////
      if (ground_type>4) {
        if (snows.size()<count+1) {
          for (int m=0; m<count_int/8; m++) {
            float kapla[] = {random(-canva.width*2, canva.width*2), random(porogy-kapla_width*32, porogy), random(-canva.width*2, 0)};
            snows.add(kapla);
          }
        }
      } else {
        if (kapli.size()<count+1) {
          for (int m=0; m<count_int; m++) {
            float kapla[] = {random(-canva.width*2, canva.width*2), random(porogy-kapla_width*32, porogy), random(-canva.width*2, 0)};
            kapli.add(kapla);
          }
        }
      }
      ////////////////////////////////////
    }
  }
  for (int i=0; i < 10; i++)  
    last[size/3*2+i][size-1]=-abs(sin(millis()/100.0)*40);

  for (int n=0; n<1; n++) {
    for (int x=0; x<size; x++) {
      for (int y=0; y<size; y++) {
        float laplas=0;
        for (int i=1; i<2; i++) {
          laplas+=geta(last, size, x-i, y);
          laplas+=geta(last, size, x+i, y);

          laplas+=geta(last, size, x, y+i);
          laplas+=geta(last, size, x, y-i);

          //laplas+=geta(last, size, x-i, y-i);
          //laplas+=geta(last, size, x+i, y+i);
          //laplas+=geta(last, size, x-i, y+i);
          //laplas+=geta(last, size, x+i, y-i);
        }
        // laplas = last_this - sumXlast
        // new = last_this * (2-1/rho) - now * (1-1/rho) + laplas;
        laplas/=4;
        laplas-=last[x][y];
        float vis = 0.001;
        if (gl_pogoda<30 && maxdata>48)vis*=10;
        now[x][y] = last[x][y]*(2-vis)-now[x][y]*(1-vis)+laplas;
      }
    }
    //for (int x=0; x<size; x++) {
    //  for (int y=0; y<size; y++) {
    //    float tmp=last[x][y];
    //    last[x][y]=now[x][y];
    //    now[x][y]=tmp;
    //  }
    //}
    for (int x=0; x < size-1; x++) {
      for (int i=0; i < size; i++) {
        float tmp = last[x][i];
        last[x][i] = geta(now, size, x+1, i);
        float tmp2 = geta(last, size, x+1, i);
        //float tmp2 = geta(last, size, x+1, i);
        seta(last, size, x+1, i, tmp);

        tmp = now[x][i];
        now[x][i] = tmp2;
        seta(now, size, x+1, i, tmp);
      }
    }

    for (int i=0; i < size; i++) {
      float tmp = last[size-1][i];
      last[size-1][i] = geta(now, size, size-1, i);
      now[size-1][i] = tmp;
    }
  }
  //for(int n=0; n < 2; n++)
  //for(int x=0; x < size-1; x++){
  //   for(int i=0; i < size; i++){
  //     float tmp = last[x][i];
  //      last[x][i] = geta(now,size,x+1,i);
  //      float tmp2 = geta(last,size,x+1,i);
  //      seta(last,size,x+1,i,tmp);

  //      float tmp1 = now[x][i];
  //      now[x][i] = tmp2;
  //      seta(now,size,x+1,i,tmp1);
  //   }
  //}
}
