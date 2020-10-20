void showQuadMeshOfTube(PNT[] C, int n, int nquads, float r, color col) {
  fill(cyan);
  for (int j = 0; j < n-1; j++) {
    caplet(C[j], r/4, C[j+1], r/4);
  }
  // STUDENTS SHOULD REPLACE THE LINE ABOVE WITH THEIR CODE FOR COMPUTING AND DISPLAYING THE QUADMESH OF THE TUBE OF RADIUS r, 
  // that has n rings of nquads quads with alternating grey and col colors
  // that is twist-free 
  // and is following the polyloop with the n first 3D vertices of C[]
  // Use this function to show the normal vectors (to demonstrate your twist-free propagation
  // Add the option of distributing the end-to-start angle difference evenly at each edge
  
  ArrayList<VCT> vectors = new ArrayList<VCT>();
  
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
    } //<>//
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
