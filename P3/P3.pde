//  ******************* Tango dancer 3D 2016 ***********************
pts P1 = new pts(); // polyloop 1 in 3D
pts P2 = new pts(); // polyloop 2 in 3D
pts P; // polyloop reference used for editing
pts O; // the other polyloop (not P)
pts Q = new pts(); // second polyloop in 3D
pts R = new pts(); // inbetweening polyloop L(P,t,Q);


Boolean 
  animating=false,
  targetTracking=false,
  pickedFocus=false, 
  center=true, 
  track=false, 
  showViewer=false, 
  showBodyCurve=true, 
  showBalls=false, 
  showCaplets=false, 
  showVectors=true,
  showTubeAsQuadMesh=true,
  showControl=true, 
  showFootPath=false, 
  showKeys=false, 
  scene1=false,
  solidBalls=false,
  showCorrectedKeys=true,
  showQuads=true,
  showSkater=true
  ;
float 
  t=0, 
  s=0;
int
  f=0, maxf=2*30, level=3, method=4;
String SDA = "angle";

void settings() {
  // Fixes "Profile GL4bc not available" error on my computer
  System.setProperty("jogl.disable.openglcore", "true");
  size(900, 900, P3D);
}
  
void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  P1.declare(); P2.declare(); Q.declare(); R.declare(); // P is a polyloop in 3D: declared in pts
  P1.loadPts("data/pts1");  
  P2.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
//  P.resetOnCircle(5,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
//  P.resetLabels();
  BS.make(); BS2.make();
  noSmooth();
  frameRate(30);
  P=P1; O=P2;
  }

void draw() {
  background(255);
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  P.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)
  
  // Subdivide and display P
  R.copyFrom(P); 
  for(int i=0; i<level; i++) 
    {
    Q.copyFrom(R); 
    Q.subdivideQuinticInto(R); // provide code
    }
 
  //R.showMyProject(); // Provided code (In TAB pts) for project 3
  pts C1 = new pts();
  C1.copyFrom(R);
 
 
  // Subdivide and display O
  R.copyFrom(O); 
  for(int i=0; i<level; i++) 
    {
    Q.copyFrom(R); 
    Q.subdivideQuinticInto(R); // provide code
    }
  pts C2 = new pts();
  C2.copyFrom(R);
  
  //R.showTube();
  
  // new curves for Phase C
  C1.showTube();
  fill(blue);
  C2.showTube();
  
  constructLadder(C1, C2);
  
  

  
  if(targetTracking) F=P(R.G[f]); // sets camera focus on current point G[f] on subdivided curve R

  if(showControl) {fill(grey); P.drawClosedCurve(3);}  // draw polygon between footprints on floor
  fill(yellow,100); P.showPicked(); 

  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
   
  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX,mouseY,26,26); fill(red); text(key,mouseX-5,mouseY+4);}
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  }
  
void constructLadder(pts C1, pts C2) {
  // HashMap<closestPointOnCurve2, point)
  HashMap closestProjection = new HashMap<Integer, Integer>();
  
  for (int i = 0; i < C1.nv; i++) {
    float closestDist = -1;
    Integer closestPoint = null;
    for (int j = 0; j < C2.nv; j++) {
      if (C1.G[i] != null && C2.G[j] != null){
        float dist = V(C1.G[i], C2.G[j]).norm();
        // check if already in the normal map
        //if (closestProjection.get(j) == null) {
          if (closestDist < 0) {
            closestDist = dist;
            closestPoint = j;
          } else if (dist < closestDist) {
            closestDist = dist;
            closestPoint = j;
            //System.out.println(closestDist);
          }
        //}
      }
    }
    fill(cyan);
    //if (closestPoint != null && closestProjection.get(closestPoint) == null) {
      //closestProjection.put(closestPoint, i);
    if (closestPoint != null) {
      arrow(C1.G[i], 1, V(C1.G[i], C2.G[closestPoint]), 3);
      show(C1.G[i], closestDist);
      
      closestProjection.put(i, closestPoint);
    }
    
  }
  
  // caplets example
  //for (int j = 0; j < closestProjection.size()-1; j++) {
  //  VCT vect1 = V(C1.G[j], C2.G[(int)closestProjection.get(j)]);
  //  VCT vect2 = V(C1.G[j+1], C2.G[(int)closestProjection.get(j+1)]);
  //  caplet(C1.G[j], vect1.norm(), C1.G[j+1], vect2.norm());
  //}
  
  System.out.println(C1.nv + " " + C2.nv);
  
  //for (Integer j = 0; j < C2.nv; j++) {
  //  //System.out.println(closestProjection.get(j));
  //  //if (closestProjection.get(j) != null) {
  //    int i = (int)closestProjection.get(j);
  //    arrow(C1.G[i], 1, V(C1.G[i], C2.G[j]), 3);
  //  //}
    
  //}
}
