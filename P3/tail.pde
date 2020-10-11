// For animating the tail after the red ball
balls BS = new balls(), BS2 = new balls();
class balls // class for manipulaitng and displaying pointclouds or polyloops in 3D 
  { 
    int nv = 64;                 //  max number of vertices
    PNT[] G = new PNT [nv]; 
    PNT[] H = new PNT [nv]; 
    VCT[] V = new VCT [nv]; 
    float r=3;
  balls() {}
  void make() {for (int i=0; i<nv; i++) {G[i]=P(0,0,-r*2.*i); V[i]=V(); H[i]=P();} }
  void showBalls(PNT Q) {for (int i=0; i<nv; i++) show(P(G[i],V(G[0],Q)),r);}
  void showTail(PNT Q) 
    {
    PNT P = P(Q);
    for (int i=0; i<nv; i++) 
      {
      cylinderSection(P,P(G[i],V(G[0],Q)),r);
      show(P(G[i],V(G[0],Q)),r);
      P=P(G[i],V(G[0],Q));
      }
    }
  void update(PNT Q) 
    {
    G[0]=P(Q); 
    for(int i=1; i<nv; i++) H[i]=P(G[i]); 
    for(int i=1; i<nv; i++) G[i]=P(G[i],V[i]); 
    for(int i=1; i<nv; i++) H[i]=P(G[i]); 
    for(int i=1; i<nv; i++) G[i]=P(G[i-1],V(r*2,U(G[i-1],G[i]))); 
    for(int i=1; i<nv; i++) V[i]=V(V[i],.05,V(H[i],G[i])); 
    for(int i=1; i<nv; i++) V[i].z-=.3; 
   }
  }
