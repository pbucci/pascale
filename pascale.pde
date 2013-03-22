/////////1/////////2/////////3/////////4/////////5/////////6/////////7//
//3456789|123456789|123456789|123456789|123456789|123456789|1234567890//
//<-----------------72 characters across for printing---------------->//
////////////////////////////////////////////////////////////////////////
// Pascale 0.1                                                        //
// This program switches between a number of videos depending on the  //
// speed of the viewer. Produced for the Emily Carr MAA exhibtion     //
// held in March/April 2013.                                          //
//                                                                    //
// Author : Paul Bucci                                                //
// Website : paulbucci.ca                                             //
//                                                                    //
// All blob detection code from:                                      //
// http://www.v3ga.net/processing/BlobDetection/index-page-home.html  //
////////////////////////////////////////////////////////////////////////

import processing.video.*;
import blobDetection.*;

Capture cam;
BlobDetection theBlobDetection;
PImage img;
boolean newFrame=false;

PApplet thisSketch = this;

PVideo[] playlist;
PVideo[] alist;
PVideo[] blist;

PVideo p1;
PVideo p1_a;
PVideo p1_b;

PVideo p2;
PVideo p2_a;
PVideo p2_b;

// The index of the current A list video being played
int current;
// The size of all playlists
int size = 2;
// The number of frames since last sample
int sample;
// The number of frames before next sample
int sampleRate = 30;
// X/Y position of blob last sample
float blobX,blobY;
// Threshold of speed
float speedThreshold = 0.1;
// Counts since last activation
int onCounter;
// Number before since next activation
int onCount = 10; // should hold for _ frames
// Crops the blob tracking area
float cropLeft = 0;
float cropRight = 1000000.0; // might not actually depend on displayWidth, so play with this

boolean goingForward;
boolean primaryPlaying;

float distance = 100.0;
float xThreshold = 90.0;

////////////////////////////////////////////////////////////////////////
// SETUP
////////////////////////////////////////////////////////////////////////
void setup() {
  size(displayWidth,displayHeight);
  background(0);
  frameRate(30);
  
  p1   = new PVideo(0, "A_video1.mov");
  p1_a = new PVideo(0, "B_video1_a.mov");
  p1_b = new PVideo(0, "B_video1_b.mov");
  
  p2   = new PVideo(1, "A_video2.mov");
  p2_a = new PVideo(1, "B_video2_a.mov");
  p2_b = new PVideo(1, "B_video2_b.mov");

  playlist = new PVideo[size];
  playlist[0] = p1;
  playlist[1] = p2;
  
  alist = new PVideo[size];
  alist[0] = p1_a;
  alist[1] = p2_a;
  
  blist = new PVideo[size];
  blist[0] = p1_b;
  blist[1] = p2_b;
  
  current = 0;
  sample = 0;
  blobX = 0;
  blobY = 0;
  playlist[0].play();
  
  primaryPlaying = true;
  goingForward = true;
  
  //Blob setup
    cam = new Capture(this, 40*4, 30*4, 15);
        // Comment the following line if you use Processing 1.5
        cam.start();
        
  // BlobDetection
  // img which will be sent to detection (a smaller copy of the cam frame);
  img = new PImage(80,60);
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f;
  theBlobDetection.setBlobMaxNumber(1); 
}

////////////////////////////////////////////////////////////////////////
// DRAW
////////////////////////////////////////////////////////////////////////

void draw() {
   if(!playlist[current].isPlaying() && primaryPlaying) {
     playNext();
   }
   sample();
   checkBlob();
}


////////////////////////////////////////////////////////////////////////
// SETUP
////////////////////////////////////////////////////////////////////////

void checkBlob() {
  if (newFrame)
  {
    newFrame = false;
    //image(cam,0,0,width,height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    fastblur(img, 2);
    theBlobDetection.computeBlobs(img.pixels);
    drawBlobsAndEdges(true,true);
  }
}

////////////////////////////////////////////////////////////////////////
// Effects : Switches videos from B stream to A stream
////////////////////////////////////////////////////////////////////////
void switchBack() {
   int index = playlist[current].index;

   if (goingForward) {
     float whereAt = alist[index].distanceFromLeft();
     float whereTo = playlist[current].startAt(whereAt);
     
     alist[index].stop();
     playlist[current].play();
     playlist[current].jump(whereTo);   
   }
   else {
     float whereAt = abs(blist[index].distanceFromLeft() - 100);
     float whereTo = playlist[current].startAt(whereAt);
     
     blist[index].stop();
     playlist[current].play();
     playlist[current].jump(whereTo);   
   }
   primaryPlaying = true;
}

////////////////////////////////////////////////////////////////////////
// Effects : Switches videos from A stream to B stream
////////////////////////////////////////////////////////////////////////
void switchVideos() {
  float where = playlist[current].distanceFromLeft();
  int index = playlist[current].index;
  
  primaryPlaying = false;
  
  if (playlist[current].isForward()) {
    goingForward = true;  
    playlist[current].stop();
    alist[index].play();
    alist[index].jump(alist[index].startAt(where));
  }
  else {
    goingForward = false;
    playlist[current].stop();
    blist[index].play();
  }
}

////////////////////////////////////////////////////////////////////////
// Effects : Updates the movie frame when a new frame is available
////////////////////////////////////////////////////////////////////////
void movieEvent(Movie m) {
  m.read();
  // (displayWidth - videoWidth)/2
  // For Pascale:
  // Example:
  // Your video is 1920px across. Write:
  // int offsetX = (displayWidth - 1920)/2;
  // image(m,offsetX,0);
  image(m,0,0);
}

////////////////////////////////////////////////////////////////////////
// Effects : Stops the current video and plays the next on the playlist.
////////////////////////////////////////////////////////////////////////
void playNext() {
  playlist[current].stop();
  // if we're at the end of the playlist, start
  // from the beginning
  if ((current+1) >= size) {
    current = 0;
  } 
  else {
    current++;
  }
  playlist[current].play();
}

////////////////////////////////////////////////////////////////////////
// Samples frame count
////////////////////////////////////////////////////////////////////////
void sample() {
 if (sample < sampleRate) {
     sample++;
   }
   else {
     sampleSpeed();
     sample = 0;
   } 
   if (onCounter < onCount) {
     onCounter++;
   }
}

////////////////////////////////////////////////////////////////////////
// Samples speed of blob
////////////////////////////////////////////////////////////////////////
void sampleSpeed() {
  float newX = getBlobX();
  //float newY = getBlobY();
  // float dist = newX - blobX; // user can only activate walking left to right
  // float dist = blobX - newX; // user can only activate walking right to left
  float dist = abs(blobX - newX);
  
  println(dist);
  
  if (dist > speedThreshold && newX > cropLeft && newX < cropRight) {
    onCounter = 0;
    if (primaryPlaying) {
      switchVideos();
      println("This is where we switch");
    }
    else if (!alist[current].isPlaying() && !blist[current].isPlaying()) {
    blist[current].play();
    goingForward = false;
    }
  }
  else if (!primaryPlaying && onCounter >= onCount) {
    println("This is where we switch BACK");
    switchBack();
  }
  blobX = newX;
}

////////////////////////////////////////////////////////////////////////
// Unpacks blob object to get x-value of centre 
////////////////////////////////////////////////////////////////////////
float getBlobX() {
  float x = 0;
  Blob b;
  b = theBlobDetection.getBlob(0);
  if (b != null) {
    x = b.x;
  }
  return x;
}

////////////////////////////////////////////////////////////////////////
// captureEvent()
////////////////////////////////////////////////////////////////////////
void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}

////////////////////////////////////////////////////////////////////////
// drawBlobsAndEdges()
////////////////////////////////////////////////////////////////////////
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA,eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(3);
        stroke(0,255,0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
              eA.x*width, eA.y*height, 
              eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255,0,0);
        rect(
          b.xMin*width,b.yMin*height,
          b.w*width,b.h*height
          );
      }

    }

      }
}

////////////////////////////////////////////////////////////////////////
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
////////////////////////////////////////////////////////////////////////
void fastblur(PImage img,int radius)
{
 if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }
}

////////////////////////////////////////////////////////////////////////
// PVideo extends the built-in Movie object
////////////////////////////////////////////////////////////////////////
class PVideo extends Movie {
  // Member fields  
  int index;
  float time;
  float speed;
  float speedInv;
  
  // Constuctor
  PVideo(int i, String f) {
    super(thisSketch,f);
    
    // For some reason, this.duration() returns 0
    // if the movie is not playing, despite the 
    // processing.org documentation, so on
    // instatiation, briefly start and stop to get
    // duration.
    this.play();
    time = this.duration();
    this.stop();
    
    // Index is for a/blist arrays
    index = i;
    
    // To switch between videos, we need a simple
    // way of tracking position
    speed = distance/time;
    speedInv = time/distance;
    
  }
  
  ////////////////////////////////////////////////////////////////////////
  // Effects : Looks into the superclass protected field
  // Returns : True if the movie is playing
  ////////////////////////////////////////////////////////////////////////
  boolean isPlaying() {
    return super.playing;
  }
  
  ////////////////////////////////////////////////////////////////////////
  // Effects : Determines whether an a or b video should be played.
  // Returns : True if position is < xThreshold, which is 3/4 distance.
  ////////////////////////////////////////////////////////////////////////
  boolean isForward() {
    float position = this.distanceFromLeft();
    println("Position is: " + position);
    
    if (position < xThreshold) {
      return true;
    }
    else {
      return false;
    }
  }
  ////////////////////////////////////////////////////////////////////////
  // Effects : checks current distance from left side of frame
  //         : by (speed*currentTimeCode), by the simple formula
  //         : borrowed from physics (speed = distance/time)
  // Returns : Distance from left side of frame in meters
  ////////////////////////////////////////////////////////////////////////
  float distanceFromLeft() {    
    return (this.speed*this.time());
  }
  
  // Returns : The distance in meters from the left side of
  //         : the frame that we should the new video at 
  float startAt(float d) {
    return (d*this.speedInv);
  }
}

////////////////////////////////////////////////////////////////////////
// TEST FUNCTIONS IF NO WEBCAM ATTACHED
////////////////////////////////////////////////////////////////////////

void mousePressed() {
 if (primaryPlaying) { 
  switchVideos();
 }
}

void mouseReleased() {
  switchBack();
}
