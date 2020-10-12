float defectAngle=0;    
String MaxL="???";

class pts // class for manipulaitng and displaying pointclouds or polyloops in 3D 
  { 
    int maxnv = 16000;                 //  max number of vertices
    PNT[] G = new PNT [maxnv];           // geometry table (vertices)
    char[] L = new char [maxnv];             // labels of points
    VCT [] LL = new VCT[ maxnv];  // displacement vectors
    Boolean loop=true;          // used to indicate closed loop 3D control polygons
    int pv =0,     // picked vertex index,
        iv=0,      //  insertion vertex index
        dv = 0,   // dancer support foot index
        nv = 0,    // number of vertices currently used in P
        pp=0; // index of picked vertex

  pts() {}
  pts declare() 
    {
    for (int i=0; i<maxnv; i++) G[i]=P(); 
    for (int i=0; i<maxnv; i++) LL[i]=V(); 
    return this;
    }     // init all point objects
  pts empty() {nv=0; pv=0; return this;}                                 // resets P so that we can start adding points
  pts addPt(PNT P, char c) { G[nv].setTo(P); pv=nv; L[nv]=c; nv++;  return this;}          // appends a new point at the end
  pts addPt(PNT P) { G[nv].setTo(P); pv=nv; L[nv]='f'; nv++;  return this;}          // appends a new point at the end
  pts addPt(float x,float y) { G[nv].x=x; G[nv].y=y; pv=nv; nv++; return this;} // same byt from coordinates
  pts copyFrom(pts Q) {empty(); nv=Q.nv; for (int v=0; v<nv; v++) G[v]=P(Q.G[v]); return this;} // set THIS as a clone of Q


  pts subdivideQuinticInto(pts Q) 
    {
    float s=1.5;
    Q.empty();
    for(int i=0; i<nv; i++)
      {
      Q.addPt(B(G[p(i)],G[i],G[n(i)],s));
      //Q.addPt(F(G[p(i)],G[i],G[n(i)],G[n(n(i))],s));    
      }
    return this;
    }

    
  pts setToL(pts P, float t, pts Q)                                     // set THIS as the lerp betwen P and Q for time t
    {
    empty(); 
    nv=min(P.nv,Q.nv); 
    for (int v=0; v<nv; v++) G[v]=L(P.G[v],t,Q.G[v]); 
    return this;
    }
  pts resetOnCircle(int k, float r)  // sets THIS to a polyloop with k points on a circle of radius r around origin
    {
    empty(); // resert P
    PNT C = P(); // center of circle
    for (int i=0; i<k; i++) addPt(R(P(C,V(0,-r,0)),2.*PI*i/k,C)); // points on z=0 plane
    pv=0; // picked vertex ID is set to 0
    return this;
    } 
    
  // ********* PICK AND PROJECTIONS *******  
  int SETppToIDofVertexWithClosestScreenProjectionTo(PNT M)  // sets pp to the index of the vertex that projects closest to the mouse 
    {
    pp=0; 
    for (int i=1; i<nv; i++) if (d(M,ToScreen(G[i]))<=d(M,ToScreen(G[pp]))) pp=i; 
    return pp;
    }
  pts showPicked() {show(G[pv],13); return this;}
  PNT closestProjectionOf(PNT M)    // Returns 3D point that is the closest to the projection but also CHANGES iv !!!!
    {
    PNT C = P(G[0]); float d=d(M,C);       
    for (int i=1; i<nv; i++) if (d(M,G[i])<=d) {iv=i; C=P(G[i]); d=d(M,C); }  
    for (int i=nv-1, j=0; j<nv; i=j++) { 
       PNT A = G[i], B = G[j];
       if(projectsBetween(M,A,B) && disToLine(M,A,B)<d) {d=disToLine(M,A,B); iv=i; C=projectionOnLine(M,A,B);}
       } 
    return C;    
    }

  // ********* MOVE, INSERT, DELETE *******  
  pts insertPt(PNT P) { // inserts new vertex after vertex with ID iv
    for(int v=nv-1; v>iv; v--) {G[v+1].setTo(G[v]);  L[v+1]=L[v];}
     iv++; 
     G[iv].setTo(P);
     L[iv]='f';
     nv++; // increments vertex count
     return this;
     }
  pts insertClosestProjection(PNT M) {  
    PNT P = closestProjectionOf(M); // also sets iv
    insertPt(P);
    return this;
    }
  pts deletePicked() 
    {
    for(int i=pv; i<nv; i++) 
      {
      G[i].setTo(G[i+1]); 
      L[i]=L[i+1]; 
      }
    pv=max(0,pv-1); 
    nv--;  
    return this;
    }
  pts setPt(PNT P, int i) { G[i].setTo(P); return this;}
  
  pts drawBalls(float r) {for (int v=0; v<nv; v++) show(G[v],r); return this;}
  pts showPicked(float r) {show(G[pv],r); return this;}
  pts drawClosedCurve(float r) 
    {
    fill(dgreen);
    for (int v=0; v<nv; v++) show(G[v],r*3);    
    fill(magenta);
    for (int v=0; v<nv-1; v++) stub(G[v],V(G[v],G[v+1]),r,r);  
    stub(G[nv-1],V(G[nv-1],G[0]),r,r);
    pushMatrix(); //translate(0,0,1); 
    scale(1,1,0.01);  
    fill(grey);
    for (int v=0; v<nv; v++) show(G[v],r*3);    
    for (int v=0; v<nv-1; v++) stub(G[v],V(G[v],G[v+1]),r,r);  
    stub(G[nv-1],V(G[nv-1],G[0]),r,r);
    popMatrix();
    return this;
    }
  pts set_pv_to_pp() {pv=pp; return this;}
  pts movePicked(VCT V) { G[pv].add(V); return this;}      // moves selected point (index p) by amount mouse moved recently
  pts setPickedTo(PNT Q) { G[pv].setTo(Q); return this;}      // moves selected point (index p) by amount mouse moved recently
  pts moveAll(VCT V) {for (int i=0; i<nv; i++) G[i].add(V); return this;};   
  PNT Picked() {return G[pv];} 
  PNT Pt(int i) {if(0<=i && i<nv) return G[i]; else return G[0];} 


 void savePts(String fn) 
    {
    String [] inppts = new String [nv+1];
    int s=0;
    inppts[s++]=str(nv);
    //for (int i=0; i<nv; i++) {inppts[s++]=str(G[i].x)+","+str(G[i].y)+","+str(G[i].z)+","+L[i];}
    for (int i=0; i<nv; i++) {inppts[s++]=str(G[i].x)+","+str(G[i].y)+","+str(G[i].z);}
    saveStrings(fn,inppts);
    };
  
  void loadPts(String fn) 
    {
    println("Start loading from file: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s=0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    nv = int(ss[s++]); println("nv="+nv);
    for(int k=0; k<nv; k++) 
      {
      int i=k+s; 
      //float [] xy = float(split(ss[i],",")); 
      String [] SS = split(ss[i],","); 
      G[k].setTo(float(SS[0]),float(SS[1]),float(SS[2]));
      //L[k]=SS[3].charAt(0);
      }
    pv=0;
    println("Finished loading from file: "+fn); 
    };
 
   void setPicekdLabel(char c) {L[pp]=c;}
 
  void setFifo() {_LookAtPt.reset(G[dv],60);}   // may be used to remember views and smoothlyh morph to them           


  // helper functions to access next/previous vertex on loop
  void next() {dv=n(dv);}
  int n(int v) {return (v+1) % nv;}
  int p(int v) {if(v==0) return nv-1; else return v-1;}
  int n(int v, int k) {if(k==0) return v; else return n(n(v),k-1);}
  int p(int v, int k) {if(k==0) return v; else return p(p(v),k-1);}
  
  float r=5;
  VCT Accel(int j) {return A(V(G[j],G[p(j)]),V(G[j],G[n(j)]));}
  
  
  int _k=3;
 
  
  
  
  // THESE METHODS RUN THE STUDENTS' CODDE FOR THIS PROJECT
  float tubeRadius=36;
  
  void showMyProject() 
      {
      if(showBodyCurve) 
        {
        if(showCaplets) {fill(yellow); for (int j=0; j<nv; j++) caplet(G[j],tubeRadius/4,G[n(j)],tubeRadius/4); }
        if(showBalls) {fill(brown); for (int j=0; j<nv; j++) show(G[j],tubeRadius/4);}
        if(showTubeAsQuadMesh) showQuadMeshOfTube(G,nv,6,tubeRadius,green); // center points G[], point-count, quad-count in ring, ring-radius, color of checkerboard
        }
      if(animating) 
        {
        f=n(f); // Advance to next sample
        fill(red); if(showSkater) show(G[f],30); 
        fill(dbrown); BS.update(G[f]); BS.showTail(G[f]); //BS.showBalls(H); 
        }      
      }
 
  void showTube()
    {
    showSimpleQuadMeshOfTube(G,nv,6,tubeRadius/2,blue); 
    }

} // end of pts class
