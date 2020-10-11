/*
Demo Skater on Rope 3D with Scarf DEMO
1  P=P1 edit loop P1 and show its subdivisino and quad meshing
2  P=P2 edit loop P2 and show its subdivisino and quad meshing
[  control loop P 
i  insert point at closest projection from mouse onto P
click on floor to select closest control vertex of P 
mouse-drag to move selected control vertex to floor location under mouse
hold x and mouse-drag to move selected control vertex of P horizontally
hold z and mouse-drag to change height of selected control vertex of P
Z  lower/raise all control vertices of P
. ,  subdivision level
{   show/hide subdivided version R of P
  =  show caplet for each edge of R
  @  show ball for each vertex of R
  ]  show R as a tube 
    q  show the quads of the tube 
    v  show the normal vector for each vertex of R 
a  animate
s  red sphere moving along R with a brown tail
^  the camera tracks the red sphere
hold t and mouse-drag to transalte the camera horizontally (focus remains center of screen)
hold T and mouse-drag to transalte the camera vertically (focus remains center of screen)
*/

void keyPressed() 
  {
//  if(key=='`') picking=true; 
  if(key=='?') scribeText=!scribeText;
  if(key=='!') snapPicture();
  if(key=='~') filming=!filming;
  if(key=='f') {P.setPicekdLabel(key);}
  if(key=='s') showSkater=!showSkater; {P.setPicekdLabel(key);}
  if(key=='b') {P.setPicekdLabel(key);}
  if(key=='c') {P.setPicekdLabel(key);}
  if(key=='F') {P.addPt(Of,'f');}
  if(key=='S') {P.addPt(Of,'s');}
  if(key=='B') {P.addPt(Of,'b');}
  if(key=='C') {P.addPt(Of,'c');}
  if(key=='M') {method=(method+1)%5;}
  if(key=='[') {showControl=!showControl;}
  if(key=='{') {showBodyCurve=!showBodyCurve;}
  if(key=='\\') {showKeys=!showKeys;}
  if(key=='_') {showFootPath=!showFootPath;}
  if(key=='|') {showCorrectedKeys=!showCorrectedKeys;}
  if(key=='=') {showCaplets=!showCaplets;}
  if(key=='@') showBalls=!showBalls;
  if(key==']') showTubeAsQuadMesh=!showTubeAsQuadMesh;
  if(key=='v') showVectors=!showVectors;
  if(key=='q') showQuads=!showQuads;
  //if(key=='.') track=!track;
  if(key=='P') P1.copyFrom(P2);
  if(key=='Q') P2.copyFrom(P1);
  if(key=='1') {P=P1; O=P2;}
  if(key=='2') {P=P2; O=P1;}
  if(key==',') {level=max(level-1,0); f=0;}
  if(key=='.') {level++;f=0;}
//  if(key=='t') PickedFocus=true; // snaps focus F to the selected vertex of P (easier to rotate and zoom while keeping it in center)
  //if(key=='x' || key=='z' || key=='d') P.setPicked(); // picks the vertex of P that has closest projeciton to mouse
  if(key=='d') {P.set_pv_to_pp(); P.deletePicked();}
  if(key=='i') P.insertClosestProjection(Of); // Inserts new vertex in P that is the closeset projection of O
  if(key=='W') {P1.savePts("data/pts1"); P2.savePts("data/pts2");}  // save vertices to pts2
  if(key=='L') {P1.loadPts("data/pts"); P2.loadPts("data/pts2");}   // loads saved model
  if(key=='w') P.savePts("data/pts");   // save vertices to pts
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='a') {animating=!animating; P.setFifo(); println("animating="+animating);}// toggle animation
  if(key=='#') exit();
  if(key=='^') targetTracking=!targetTracking;
  //if(key=='1') scene1=!scene1;
  if(key=='-') f=R.p(f);
  if(key=='+') f=R.n(f);


  change=true;   // to save a frame for the movie when user pressed a key 
  }

void mouseWheel(MouseEvent event) 
  {
  dz -= 10.*event.getAmount(); 
  change=true;
  }

void mousePressed() 
  {
  //if (!keyPressed) picking=true;
  if (!keyPressed) {P.set_pv_to_pp(); println("picked vertex "+P.pp);}
  if(keyPressed && key=='e') {P.addPt(Of);}
//  if(keyPressed && (key=='f' || key=='s' || key=='b' || key=='c')) {P.addPt(Of,key);}

 // if (!keyPressed) P.setPicked();
  change=true;
  }
  
void mouseMoved() 
  {
  //if (!keyPressed) 
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;};
  if (keyPressed && key=='`') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)


  change=true;
  }
  
void mouseDragged() 
  {
  if (!keyPressed) P.setPickedTo(Of); 
//  if (!keyPressed) {Of.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); }
  if (keyPressed && key==CODED && keyCode==SHIFT) {Of.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));};
  if (keyPressed && key=='x') P.movePicked(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='z') P.movePicked(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='X') P.moveAll(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='Z') P.moveAll(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='t')  // move focus point on plane
    {
    if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  if (keyPressed && key=='T')  // move focus point vertically
    {
    if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  if (keyPressed && key=='%')  defectAngle+=(float)(mouseX-pmouseX)*PI/width;
  //if (keyPressed && key=='-')  _ab+=(float)(mouseX-pmouseX)*PI/width;
  change=true;
  }  

// **** Header, footer, help text on canvas
void displayHeader()  // Displays title and authors face on screen
    {
    scribeHeader(title,0); scribeHeaderRight(name); 
    fill(white); image(myFace, width-myFace.width/2,25,myFace.width/2,myFace.height/2); 
    }
void displayFooter()  // Displays help text at the bottom
    {
    scribeFooter(guide,1); 
    scribeFooter(menu,0); 
    }

String title ="6491 P4 2020: Space Curves subdivision, twist-free display, correspondence", name ="Jarek Rossignac",
       menu="?:help, !:picture, ~:(start/stop)capture, space:rotate, `/wheel:closer, t/T:target, .:track, a:anim, #:quit",
       guide="xz/XZ:move/ALL, e:exchange, q/p:copy, l/L:load, w/W:write, C/K:show caplet/cone"; // user's guide
