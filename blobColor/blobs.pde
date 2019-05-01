// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/ce-2l2wRqO8

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;
color myColor;
  Blob(float x, float y, color myColor) {
    this.myColor = myColor;
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
  }

  void show() {
    stroke(0);
    fill(myColor);
    stroke(myColor);
    strokeWeight(2);
    ellipseMode(CORNERS);
    ellipse(minx*2, miny*2, maxx*2, maxy*2);
    //filter(BLUR, 6);
  }

  void add(float x, float y) {
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }
  
  float size() {
    return (maxx-minx)*(maxy-miny); 
  }

  boolean isNear(float x, float y) {
    float cx = (minx + maxx) / 2;
    float cy = (miny + maxy) / 2;

    float d = distSq(cx, cy, x, y);
    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
  
  float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}
}
