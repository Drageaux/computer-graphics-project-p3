void showQuadMeshOfTube(PNT[] C, int n, int nquads, float r, color col) {
  fill(cyan);
  //for (int j = 0; j < n-1; j++) {
  //  caplet(C[j], r/4, C[j+1], r/4);
  //}
  // STUDENTS SHOULD REPLACE THE LINE ABOVE WITH THEIR CODE FOR COMPUTING AND DISPLAYING THE QUADMESH OF THE TUBE OF RADIUS r, 
  // that has n rings of nquads quads with alternating grey and col colors
  // that is twist-free 
  // and is following the polyloop with the n first 3D vertices of C[]
  // Use this function to show the normal vectors (to demonstrate your twist-free propagation
  // Add the option of distributing the end-to-start angle difference evenly at each edge
  
  for (int i = 1; i < n - 1; i++) {
    // For every 3-tuple (i-1, i, i+1), we find its normal vector
    VCT v1 = V(C[i-1], C[i]);
    VCT v2 = V(C[i], C[i+1]);
    VCT cross = N(v1, v2);
    arrow(C[i], 0.3, cross, 5); //<>//
    
    // TODO: need to normalize cross then use radius
    VCT tangent = V(V(C[i-1],C[i+1])); // tangent to rotate the new vectors by
    VCT cross = U(cross).mul(r);
    System.out.println(n(unitCross));
    
    VCT cross1 = R(unitCross,PI*0.5-PI/4, tangent);
    VCT cross2 = R(V(cross),PI-PI/4, tangent);
    VCT cross3 = R(V(cross),PI*1.5-PI/4, tangent);
    VCT cross4 = R(V(cross),PI*2-PI/4, tangent);
    arrow(C[i], 0.3, cross1, 5);
    //arrow(C[i], 0.3, cross2, 5);
    //arrow(C[i], 0.3, cross3, 5);
    //arrow(C[i], 0.3, cross4, 5);
  }
}
  
void showSimpleQuadMeshOfTube(PNT[] C, int n, int nquads, float r, color col) {
  fill(brown); 
  for (int j=0; j<n; j++) show(C[j],r/2);
  fill(yellow); for (int j=0; j<n-1; j++) caplet(C[j],r/4,C[j+1],r/4); 
  // STUDENTS SHOULD REPLACE THE LINE ABOVE WITH THEIR CODE FOR COMPUTING AND DISPLAYING THE QUADMESH OF THE TUBE OF RADIUS r,
  // Put here the final result: water-tight quad-mesh tube along the curve
  // Do not display vectors
  // Option: add normals to the quad vertices for smooth shading
}
