/////////1/////////2/////////3/////////4/////////5/////////6/////////7//
//3456789|123456789|123456789|123456789|123456789|123456789|1234567890//
//<-----------------72 characters across for printing---------------->//
////////////////////////////////////////////////////////////////////////
// Pascale 0.1                                                        //
// This program switches between a number of videos depending on the  //
// movement of the viewer. Produced for the Emily Carr MAA exhibtion  //
// held in March/April 2013.                                          //
//                                                                    //
// Author : Paul Bucci                                                //
// Website : paulbucci.ca                                             //
//                                                                    //
// Motion detection from Daniel Shiffman at:                          //
//   http://www.learningprocessing.com/                               //
////////////////////////////////////////////////////////////////////////

import processing.video.*;

Capture video;
// Previous Frame
PImage prevFrame;
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

PVideo p3;
PVideo p3_a;
PVideo p3_b;

PVideo p4;
PVideo p4_a;
PVideo p4_b;

PVideo p5;
PVideo p5_a;
PVideo p5_b;

PVideo p6;
PVideo p6_a;
PVideo p6_b;

PVideo p7;
PVideo p7_a;
PVideo p7_b;

PVideo p8;
PVideo p8_a;
PVideo p8_b;

PVideo p9;
PVideo p9_a;
PVideo p9_b;

PVideo p10;
PVideo p10_a;
PVideo p10_b;

PVideo p11;
PVideo p11_a;
PVideo p11_b;

PVideo p12;
PVideo p12_a;
PVideo p12_b;

PVideo p13;
PVideo p13_a;
PVideo p13_b;

PVideo p14;
PVideo p14_a;
PVideo p14_b;

PVideo p15;
PVideo p15_a;
PVideo p15_b;

PVideo p16;
PVideo p16_a;
PVideo p16_b;

PVideo p17;
PVideo p17_a;
PVideo p17_b;

PVideo p18;
PVideo p18_a;
PVideo p18_b;

PVideo p19;
PVideo p19_a;
PVideo p19_b;

PVideo p20;
PVideo p20_a;
PVideo p20_b;


// The index of the current A list video being played
int current;
// The size of all playlists
int size = 20;

// The number of frames since last sample
int sample;
// The number of frames before next sample
int sampleRate = 20;

// The refresh rate of the program
int framerate  = 30;

// Counts since last activation
int onCounter = 0;
// Number before since next activation
int onCount = 60; // should hold for _ frames

// How different must a pixel be to be a "motion" pixel
float pixelThreshold = 13;
// How much of the picture should change before we switch
int motionThreshold = 17;

// Size of the webcam image. Smaller is faster.
int videoWidth = 32;
int videoHeight = 24;

// Crop values need to be in the range of the video capture size
int CROP_RIGHT = 26;
int CROP_LEFT = 6;
int CROP_TOP = 0;
int CROP_BOTTOM = videoHeight;

boolean goingForward;
boolean primaryPlaying;

float distance = 100.0;
float xThreshold = 90.0;

////////////////////////////////////////////////////////////////////////
// SETUP
////////////////////////////////////////////////////////////////////////
void setup() {
String[] cameras = Capture.list();
println(cameras[1]);

  size(displayWidth,displayHeight);
  background(0);
  frameRate(framerate);
  
  p1   = new PVideo(0, "A_video1.mov");
  p1_a = new PVideo(0, "B_video1_a.mov");
  p1_b = new PVideo(0, "B_video1_b.mov");
  
  p2   = new PVideo(1, "A_video2.mov");
  p2_a = new PVideo(1, "B_video2_a.mov");
  p2_b = new PVideo(1, "B_video2_b.mov");
  
  p3   = new PVideo(2, "A_video3.mov");
  p3_a = new PVideo(2, "B_video3_a.mov");
  p3_b = new PVideo(2, "B_video3_b.mov");
  
  p4   = new PVideo(3, "A_video4.mov");
  p4_a = new PVideo(3, "B_video4_a.mov");
  p4_b = new PVideo(3, "B_video4_b.mov");
  
  p5   = new PVideo(4, "A_video5.mov");
  p5_a = new PVideo(4, "B_video5_a.mov");
  p5_b = new PVideo(4, "B_video5_b.mov");
  
  p6   = new PVideo(5, "A_video6.mov");
  p6_a = new PVideo(5, "B_video6_a.mov");
  p6_b = new PVideo(5, "B_video6_b.mov");
  
  p7   = new PVideo(6, "A_video7.mov");
  p7_a = new PVideo(6, "B_video7_a.mov");
  p7_b = new PVideo(6, "B_video7_b.mov");
  
  p8   = new PVideo(7, "A_video8.mov");
  p8_a = new PVideo(7, "B_video8_a.mov");
  p8_b = new PVideo(7, "B_video8_b.mov");
  
  p9   = new PVideo(8, "A_video9.mov");
  p9_a = new PVideo(8, "B_video9_a.mov");
  p9_b = new PVideo(8, "B_video9_b.mov");
  
  p10   = new PVideo(9, "A_video10.mov");
  p10_a = new PVideo(9, "B_video10_a.mov");
  p10_b = new PVideo(9, "B_video10_b.mov");
  
  p11   = new PVideo(10, "A_video11.mov");
  p11_a = new PVideo(10, "B_video11_a.mov");
  p11_b = new PVideo(10, "B_video11_b.mov");
  
  p12   = new PVideo(11, "A_video12.mov");
  p12_a = new PVideo(11, "B_video12_a.mov");
  p12_b = new PVideo(11, "B_video12_b.mov");
  
  p13   = new PVideo(12, "A_video13.mov");
  p13_a = new PVideo(12, "B_video13_a.mov");
  p13_b = new PVideo(12, "B_video13_b.mov");
  
  p14   = new PVideo(13, "A_video14.mov");
  p14_a = new PVideo(13, "B_video14_a.mov");
  p14_b = new PVideo(13, "B_video14_b.mov");
  
  p15   = new PVideo(14, "A_video15.mov");
  p15_a = new PVideo(14, "B_video15_a.mov");
  p15_b = new PVideo(14, "B_video15_b.mov");
  
  p16   = new PVideo(15, "A_video16.mov");
  p16_a = new PVideo(15, "B_video16_a.mov");
  p16_b = new PVideo(15, "B_video16_b.mov");
  
  p17   = new PVideo(16, "A_video17.mov");
  p17_a = new PVideo(16, "B_video17_a.mov");
  p17_b = new PVideo(16, "B_video17_b.mov");
  
  p18   = new PVideo(17, "A_video18.mov");
  p18_a = new PVideo(17, "B_video18_a.mov");
  p18_b = new PVideo(17, "B_video18_b.mov");
  
  p19   = new PVideo(18, "A_video19.mov");
  p19_a = new PVideo(18, "B_video19_a.mov");
  p19_b = new PVideo(18, "B_video19_b.mov");
  
  p20   = new PVideo(19, "A_video20.mov");
  p20_a = new PVideo(19, "B_video20_a.mov");
  p20_b = new PVideo(19, "B_video20_b.mov");
  

  playlist = new PVideo[size];
  playlist[0] = p1;
  playlist[1] = p2;
  playlist[2] = p3;
  playlist[3] = p4;
  playlist[4] = p5;
  playlist[5] = p6;
  playlist[6] = p7;
  playlist[7] = p8;
  playlist[8] = p9;
  playlist[9] = p10;
  playlist[10] = p11;
  playlist[11] = p12;
  playlist[12] = p13;
  playlist[13] = p14;
  playlist[14] = p15;
  playlist[15] = p16;
  playlist[16] = p17;
  playlist[17] = p18;
  playlist[18] = p19;
  playlist[19] = p20;

  
  alist = new PVideo[size];
  alist[0] = p1_a;
  alist[1] = p2_a;
  alist[2] = p3_a;
  alist[3] = p4_a;
  alist[4] = p5_a;
  alist[5] = p6_a;
  alist[6] = p7_a;
  alist[7] = p8_a;
  alist[8] = p9_a;
  alist[9] = p10_a;
  alist[10] = p11_a;
  alist[11] = p12_a;
  alist[12] = p13_a;
  alist[13] = p14_a;
  alist[14] = p15_a;
  alist[15] = p16_a;
  alist[16] = p17_a;
  alist[17] = p18_a;
  alist[18] = p19_a;
  alist[19] = p20_a;

  blist = new PVideo[size];
  blist[0] = p1_b;
  blist[1] = p2_b;
  blist[2] = p3_b;
  blist[3] = p4_b;
  blist[4] = p5_b;
  blist[5] = p6_b;
  blist[6] = p7_b;
  blist[7] = p8_b;
  blist[8] = p9_b;
  blist[9] = p10_b;
  blist[10] = p11_b;
  blist[11] = p12_b;
  blist[12] = p13_b;
  blist[13] = p14_b;
  blist[14] = p15_b;
  blist[15] = p16_b;
  blist[16] = p17_b;
  blist[17] = p18_b;
  blist[18] = p19_b;
  blist[19] = p20_b;
  
  current = 0;
  sample = 0;
  
  playlist[0].play();
  
  primaryPlaying = true;
  goingForward = true;
  
  video = new Capture(this, videoWidth, videoHeight, "HP Webcam HD 3310", framerate);
  // Create an empty image the same size as the video
  prevFrame = createImage(video.width,video.height,ALPHA);
  video.start();
}

////////////////////////////////////////////////////////////////////////
// DRAW
////////////////////////////////////////////////////////////////////////
void draw() {
   if(!playlist[current].isPlaying() && primaryPlaying) {
     playNext();
   }
   sample();
   int diffCount = detectMotion();
   checkSwitch(diffCount);
}

////////////////////////////////////////////////////////////////////////
// checkSwitch : calls either switchVideo() or switchBack()
////////////////////////////////////////////////////////////////////////
void checkSwitch(int diffCount) {
  if (diffCount > motionThreshold) {
    onCounter = 0;
    if (primaryPlaying) {
      switchVideos();
//      println("This is where we switch");
    }
    else if (!alist[current].isPlaying() && !blist[current].isPlaying()) {
    blist[current].play();
    goingForward = false;
    }
  }
  else if (!primaryPlaying && onCounter >= onCount) {
//    println("This is where we switch BACK");
    switchBack();
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
// Effects : Samples frame count
////////////////////////////////////////////////////////////////////////
void sample() {
 if (sample < sampleRate) {
     sample++;
   }
   else {
     sample = 0;
   } 
   if (onCounter < onCount) {
     onCounter++;
   }
}

////////////////////////////////////////////////////////////////////////
// Effects : checks each pixel for movement, returns count
////////////////////////////////////////////////////////////////////////
int detectMotion() {
  // Capture video
  if (video.available()) {
    // Save previous frame for motion detection!!
    // Before we read the new frame, we always save the previous frame for comparison!
    prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height); 
    prevFrame.updatePixels();
    video.read();
  }
  
  video.loadPixels();
  prevFrame.loadPixels();
  int diffCount = 0;
  // Begin loop to walk through every pixel
  for (int x = CROP_LEFT; x < CROP_RIGHT; x ++ ) {
    for (int y = CROP_TOP; y < CROP_BOTTOM; y ++ ) {
      
      int loc = x + y*video.width;            // Step 1, what is the 1D pixel location
      color current = video.pixels[loc];      // Step 2, what is the current color
      color previous = prevFrame.pixels[loc]; // Step 3, what is the previous color
      
      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); float g1 = green(current); float b1 = blue(current);
      float r2 = red(previous); float g2 = green(previous); float b2 = blue(previous);
      float diff = dist(r1,g1,b1,r2,g2,b2);
      
      // Step 5, How different are the colors?
      // If the color at that pixel has changed, then there is motion at that pixel.
      if (diff > pixelThreshold) { 
        // A pixel changed, add it to the count.
        diffCount++;
      }
    }
  }
//  println(diffCount);
  return diffCount;
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
//    println("Position is: " + position);
    
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
