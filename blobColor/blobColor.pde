
import processing.video.*;

Capture video;

color trackColor; 
float thresholdHUE = 0.8; // important
float thresholdSAT = 40; // important
float distThreshold = 60; // important

int scaleFactor = 3; // downsampling of video for performance 

ArrayList<Blob> blobs = new ArrayList<Blob>();
PImage img;

PImage imgA;
PImage imgB;

boolean newFrame=false;
color trackColor1[];
ArrayList<PVector> colorPositions;
PImage sampleImg;

int counter = 150;
boolean starting = true;

void setup() {
  
  frameRate(30);
 // fullScreen();
  size(640, 360);
  colorMode(HSB, 255);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[3]);
  video.start();
  
  trackColor1 = new color[5];
  trackColor1[0] = color(200, 100, 255); // HSB color
  trackColor1[1] = color(150, 100, 255); // HSB color
  trackColor1[2]= color(100, 100, 255); //HSB color
  trackColor1[3] = color(50, 100, 255); //HSB color
  trackColor1[4]= color(10, 100, 255); //HSB color
  sampleImg = new PImage(150, 150);
  
  imageGenerator(2);
}



void keyPressed() {
  if (key == 'a') {
    distThreshold++;
  } else if (key == 'z') {
    distThreshold--;
  }
  
   if (key == ';') {
    //saveFrame();
    saveFrame("imgCapture.jpg");
  }
  
/*     if (key == 'c') {
    saveFrame("Photos/imgCapture-####.jpg");
  } */
  
}


void draw() {
  
  if (counter==150 && starting==true) {
    imgA = loadImage("img-A.png");
  }
  
  if (counter==151 && starting==true) {
    imgB = loadImage("img-B.png");
    starting = false;
  }
  
  if (counter==150 && starting==false) {
    imageGenerator(1);
  }
  
  if (counter==300 && starting==false) {
    counter = 0;
    imageGenerator(2);
  }
  
  
  if (counter>=0 && counter<100 && starting==false) {
    image(imgA, 0, 0);
    pushStyle();
      tint(255, map(counter,0, 150, 0, 255));
      image(imgB, 0, 0);
      tint(255, map(counter,0, 150, 0, 255));
    popStyle();
  }
  
  if (counter>=150 && counter<300 && starting==false) {
    image(imgB, 0, 0);
    pushStyle();
      tint(255, map(counter,150 , 300, 0, 255));
      image(imgA, 0, 0);
      tint(255, map(counter,150 , 300, 0, 255));
    popStyle();
  }
  
  println(counter);
  
  counter ++;
  
}

void imageGenerator(int p) {
  
  if (video.available() == true) {
    video.read();
    sampleImg = video.copy();
    sampleImg.resize(width/scaleFactor, 0);
  }
  image(video, 0, 0, width, height);
  blobs.clear(); // remove all the last blobs
  
  //background(255);
  
  checkforBlob(sampleImg);
  // display blobs
  for (Blob b : blobs) {
    if (b.size() > 600) {
      b.show();
    }
    
  filter(BLUR,20);
  
    if(p==1){
    saveFrame("img-A.png");
    imgA = loadImage("img-A.png");
  }
  
  if(p==2){
    saveFrame("img-B.png");
    imgB = loadImage("img-B.png");
  }
  }
  
}


void checkforBlob(PImage img) {
  img.loadPixels();
  for (int y = 1; y < img.height-1; y++) { // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) { // Skip left and right edges
      int loc = x + y * img.width; 
      float refHue = hue(img.pixels[loc]);
      float refSAT = saturation(img.pixels[loc]);
      // check each color
      for (int i=0; i<trackColor1.length; i++) {
        float testHue = hue(trackColor1[i]);
        float testSat = saturation(trackColor1[i]);
        float d = Math.abs(refHue-testHue);
        float d2 = Math.abs(refSAT-testSat);

        if (d < thresholdHUE && d2 < thresholdSAT) {

          boolean found = false;

          int x2 = scaleFactor*x;
          int y2 = scaleFactor*y;

          for (Blob b : blobs) {
            if (b.isNear(x2, y2)) {
              b.add(x2, y2);
              found = true;
              break;
            }
          }
          if (!found) {
            Blob b = new Blob(x2, y2, trackColor1[i]);
            blobs.add(b);
          }
        }
      }
    }
  }
}


void mousePressed() {

  /* int locX = floor((float(mouseX)/float(width))*sampleImg.width);
  int locY = floor((float(mouseY)/float(height))*sampleImg.height);
  int loc = locX +locY * sampleImg.width;
  color trackColor = color(sampleImg.pixels[loc]);
  if (key == '0') {
    trackColor1[0] = trackColor;
  }
  if (key == '1') {
    trackColor1[1] = trackColor;
  }
  if (key == '2') {
    trackColor1[2] = trackColor;
  }
  if (key == '3') {
    trackColor1[3] = trackColor;
  }
  if (key == '4') {
    trackColor1[4] = trackColor;
  }
  */
  

 }
