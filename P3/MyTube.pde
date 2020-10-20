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
  
  ArrayList<VCT> vectors = new ArrayList<VCT>();
  
   
  VCT[][] quads = new VCT[n][nquads]; 
  for (int i = 1; i < n - 1; i++) {
    // For every 3-tuple (i-1, i, i+1), we find its normal vector
    VCT v1 = V(C[i-1], C[i]);
    VCT v2 = V(C[i], C[i+1]);
    
    // Normalize
    v1 = V(1 / norm(v1), v1);
    v2 = V(1 / norm(v2), v2);
    
    VCT x_axis = N(v1, v2);
    x_axis = V(1 / norm(x_axis), x_axis);
    
    if (vectors.size() == 0) {
      vectors.add(V(-1, x_axis));
    } else {
      // The third axis in the first and second coordinate frames
      VCT y_ax1 = N(v1, x_axis);
      VCT y_ax2 = N(v2, x_axis);
      y_ax1 = V(1 / norm(y_ax1), y_ax1);
      y_ax2 = V(1 / norm(y_ax2), y_ax2);
      
      VCT last_vec = vectors.get(vectors.size() - 1);
      // Coordinates in the first frame
      float x = dot(last_vec, x_axis);
      float y = dot(last_vec, y_ax1);
      
      // Apply the coordinates in the second frame
      vectors.add(V(x, x_axis, y, y_ax2));
    }
    
    
  }
  
  // Duplicate the last vector to be placed at the end of the curve
  VCT last_vec = vectors.get(vectors.size() - 1);
  vectors.add(V(last_vec));
  
  // Smooth the vectors so that the first vector is the same as the last one
  vectors.add(0, V(last_vec));
  
  VCT tangent = V(C[0], C[1]);
  float total_angle = angle(vectors.get(0), vectors.get(1));
  if (cw(tangent, vectors.get(0), vectors.get(1))) {
    total_angle = -total_angle;
  }

  // Propagate the error between the first and last vectors throughout the curve
  for (int i = 1; i < n - 1; i++) {
    float to_rotate = (vectors.size() - i) * 1.0 / vectors.size() * total_angle;
    tangent = V(C[i], C[i+1]);
    vectors.set(i, R(vectors.get(i), to_rotate, tangent));
  }
  
  // Finally, visualize all vectors
  for (int i = 0; i < n; i++) {
    arrow(C[i], 80, vectors.get(i), 3);
    
    // normalize propagated then use radius
    VCT tangent = V(V(C[i-1],C[i+1])); // tangent to rotate the new vectors by
    VCT standardizedCross = U(last_vec).mul(r); // propagated VCT with length of r

    // complete the poly for at each point
    VCT[] poly = new VCT[nquads];
    for (int quad = 1; quad < nquads+1; quad++){
      fill(col);
      // rotate over tangent multiple times
      VCT rotatedSample =  R(standardizedCross, 2*PI*(float)quad/(float)nquads - PI/(float)nquads, tangent); // 2PI*currentQuad/nquads, then offset by PI/nquads
      arrow(C[i], 1, rotatedSample, 5);
      poly[quad-1] = rotatedSample;
      
    }
    quads[i] = poly;
  }
      


   
  
  
  //for (int i = 1; i < n - 1; i++) {
  //  // connect this poly with previous poly
  //  //if (i-1 >= 0 && C[i-1]) {
  //  for (int currQuad = 0; currQuad < nquads; currQuad++){
      
  //    if (currQuad+1 < nquads){
        
  //      System.out.println(i + " " + currQuad);
  //      PNT pA = P(C[i], quads[i][currQuad]);
  //      PNT pB = P(C[i-1], quads[i-1][currQuad]);
  //      //PNT pC = P(C[i-1], quads[i-1][currQuad+1]);
  //      //PNT pD = P(C[i], quads[i][currQuad+1]);
  //      // alternating only if 4 quads and 6 quads
  //      if (nquads == 4 || nquads == 6) {
  //        if (i % 2 == 0) {
  //            fill(white);
  //        }
  //        else {
  //            fill(col);
  //        }
  //      } else {
           
  //      }
  //      //show(pA,pB,pC,pD);
  //    }
  //    //System.out.println(C[i-1] + " " + quads[i-1][0]);
  //  }
  //}
  //System.out.println("Test");
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
