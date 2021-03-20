float geta(float a[][], int size, int x, int y) {
  if (x<0)x=size+x;
  if (x>size-1)x=x%size;
  //if(y<0)y=size+y;
  //if(y>size-1)y=y%size;
  //if (x<0)return 0;
  //if (x>size-1)return 0;
  if (y<0)return 0;
  if (y>size-1)return 0;
  return a[x][y];
}
void seta(float a[][], int size, int x, int y, float data) {
  if (x<0)x=size+x;
  if (x>size-1)x=x%size;
  //if(y<0)y=size+y;
  //if(y>size-1)y=y%size;
  //if (x<0)return 0;
  //if (x>size-1)return 0;
  if (y<0)return;
  if (y>size-1)return;
  a[x][y]=data;
}
int z(float a) {
  if (a>0)return 1;
  if (a<0)return -1;
  return 0;
}


void fileSelected(File selection) {
  session_output = createWriter(selection.getAbsoluteFile());
  session_output.print("TIME EMG TEMP GROUND WEATHER\n");
  sessionstart=millis();
  isplay=true;
}
void select_last_session(File selection){
  if(selection!=null){
    last_session=loadStrings(selection.getAbsoluteFile());
    isscore = true;
  }else{
    last_session=null;
    isscore = false;
  }
  
   selectOutput("Select a file to write to:", "fileSelected");
}
///////////////////

int rnd= 0;
int rand() {
  rnd = ((~((rnd >> 15) ^ (rnd >> 13) ^ (rnd >> 12) ^ (rnd >> 10) ^ rnd ) & 0x00000001 ) << 15 ) | (rnd >> 1);
  return rnd%2;
}
int rand(int l) {
  int i=0;
  for (int k=0; k<l; k++) {
    i|=rand()<<k;
  }
  return i;
}
