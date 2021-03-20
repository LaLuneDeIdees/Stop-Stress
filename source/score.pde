boolean isscore = false;
PImage weather_icon, ground_icon;
int wid = 20;
String last_session[] = null;

void score_update() {
  if (isscore && last_session!=null) {
    textSize(32);
    fill(255);
    stroke(255);
    textAlign(LEFT, TOP);
    int i =round((millis()-sessionstart)/50);
    if (i>=last_session.length) {
      i=last_session.length-1;
      last_session[i]="0 0 0 0 0";
      tint(255, cos(millis()/150.0)*127+127);
    } else {
      tint(255);
    }
    String data[] = last_session[i].replace(',', '.').split(" ");
    float tof[] = {1-float(data[3]), 1-float(data[4])};



    rectMode(CORNERS);
    fill(0);
    stroke(255);
    rect(0, 0, width/3, wid);
    fill(#03c6fc);
    noStroke();
    rect(0, 0, width/3*tof[1], wid);
    image(weather_icon, width/3-wid+4-2, 2);

    translate(0, wid+4);
    fill(0);
    stroke(255);
    rect(0, 0, width/3, wid);
    fill(#fce703);
    noStroke();
    rect(0, 0, width/3*tof[0], wid);
    image(ground_icon, width/3-wid+4-2, 2);
  }
}
