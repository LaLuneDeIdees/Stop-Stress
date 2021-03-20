final int count = 4096;
final int count_int = 16*4;
final float kapla_width = 10;
final float v = 7*10*2;
float porogy=0;
ArrayList kapli = new ArrayList();
void rain(){
  
      //float kapla[] = {random(-width*2, width*2), random(porogy-kapla_width*32, porogy), random(-width*2, 0)};
  
  for (int i=0; i<kapli.size(); i++) {
    float kapla[] = (float[])kapli.get(i);
    int newx = int(kapla[0]/(1.0-kapla[2]/Z))+canva.width/2;
    int newy = int(kapla[1]/(1.0-kapla[2]/Z))+canva.height/2;
    int newkw = int(kapla_width/(1.0-kapla[2]/Z));
    //circle(newx,newy,newkw);
    canva.stroke(255, (1.0-newkw/-width/2)*64);
    canva.line(newx, newy, newx-newkw, newy+newkw*5);
    kapla[1]+=v;
    kapla[0]-=v/5;
    if (newy>canva.height || newx<0) {
      kapli.remove(i);
      i--;
    }
  }
}
