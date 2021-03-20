
final float snow_width = 10;
final float vs = 7*2;
ArrayList snows = new ArrayList();
void snow(){
  canva.noStroke();
      //float kapla[] = {random(-width*2, width*2), random(porogy-kapla_width*32, porogy), random(-width*2, 0)};
  for(int i=0;i<snows.size();i++){
     float kapla[] = (float[])snows.get(i);
     int newx = int(kapla[0]/(1.0-kapla[2]/Z))+canva.width/2;
     int newy = int(kapla[1]/(1.0-kapla[2]/Z))+canva.height/2;
     int newkw = int(snow_width/(1.0-kapla[2]/Z));
     //circle(newx,newy,newkw);
     canva.fill(255,(1.0-newkw/-width/2)*64);
     canva.rect(newx,newy,newkw,newkw);
     kapla[1]+=vs;
     kapla[0]-=vs/5;
     if(newy>canva.height || newx<0){
       snows.remove(i);
       i--;
     }
   }
}
