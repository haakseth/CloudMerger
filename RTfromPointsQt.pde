PVector meanset1;
PVector meanset2;
double[][] pntSet1c;
double[][] pntSet2c;
double[][] CCp1p2;
double[][] A;
double[] delta;
double[][] Q;
Matrix Qmat;
double[][] eigenvalue;
double[][] eigenvector;
double[] qR;
double[][] R; //the rotation matrix
double[] T; // the translation parameters
double[][] diff;
double[] res; //residuals

/* Acquire rotation and translation matrices from selected corresponding points.
Based on MATLAB script by K. Khoshelham, July 2010
Author: John Wika Haakseth, May 2012
*/
void getRotationAndTranslation(ArrayList<PVector> pointset1, ArrayList<PVector> pointset2){
  //Checks to avoid executing method if pointsets are of uneven size or they have less than three points:
  if(pointset1.size() != pointset2.size()){
    println("pointlists need to be of same size: Set 1: " + pointset1.size() + ", Set 2: " + pointset2.size());
    return;
  }
  if(pointset1.size() < 3){
    println("pointlists need to be of size 3 or larger: Set 1: " + pointset1.size() + ", Set 2: " + pointset2.size());
    return;
  }
  //for some operations it's handy to have the pointsets as lists of doubles
  double[][] pointset1db = new double[pointset1.size()][3];
  for(int i=0;i<pointset1.size();i++){
    pointset1db[i][0]=pointset1.get(i).x;pointset1db[i][1]=pointset1.get(i).y;pointset1db[i][2]=pointset1.get(i).z;
  }
  double[][] pointset2db = new double[pointset2.size()][3];
  for(int i=0;i<pointset2.size();i++){
    pointset2db[i][0]=pointset2.get(i).x;pointset2db[i][1]=pointset2.get(i).y;pointset2db[i][2]=pointset2.get(i).z;
  }
  
  int n = pointset1.size();
  int x1=0, y1=0, z1=0, x2=0, y2=0, z2=0;
  for(int i=0; i<pointset1.size();i++){
    x1+=pointset1.get(i).x;
    y1+=pointset1.get(i).y;
    z1+=pointset1.get(i).z;
    x2+=pointset2.get(i).x;
    y2+=pointset2.get(i).y;
    z2+=pointset2.get(i).z;
  }
  meanset1 = new PVector(x1/n,y1/n,z1/n);
  meanset2 = new PVector(x2/n,y2/n,z2/n);
  
  //mean centered points
  pntSet1c = new double[n][3];
  pntSet2c = new double[n][3];
  
  for(int i=0; i<n; i++){
    for(int j=0; j<3; j++){
      switch(j) {
      case 0: 
        pntSet1c[i][j] = pointset1.get(i).x-meanset1.x; 
        pntSet2c[i][j] = pointset2.get(i).x-meanset2.x; 
        break;
      case 1: 
        pntSet1c[i][j] = pointset1.get(i).y-meanset1.y; 
        pntSet2c[i][j] = pointset2.get(i).y-meanset2.y; 
        break;
      case 2: 
        pntSet1c[i][j] = pointset1.get(i).z-meanset1.z; 
        pntSet2c[i][j] = pointset2.get(i).z-meanset2.z; 
        break;
      }
    }
  }
  
  CCp1p2 = new double[3][3];
  for(int i=0; i<3; i++){
    for(int j=0; j<3; j++){
      for(int k=0; k<n; k++){
        CCp1p2[i][j] += pntSet1c[k][i] * pntSet2c[k][j] / n;
      }
    }
  }
  println();
  println("CCp1p2:");
  for(int i=0; i<3; i++){
    println(CCp1p2[i][0] + ", " + CCp1p2[i][1] + ", " + CCp1p2[i][2]);
  }
  
  //A = CCp1p2 - CCp1p2';
  A = new double[3][3];
  for(int i=0; i<3; i++){
    for(int j=0;j<3; j++){
      A[i][j] = CCp1p2[i][j] - CCp1p2[j][i];
    }
  }
  
  println();
  println("A:");
  for(int i=0; i<3; i++){
    println(A[i][0] + ", " + A[i][1] + ", " + A[i][2]);
  }
  
  delta = new double[]{A[1][2], A[2][0], A[0][1]}; 
  println();
  println("delta: " + delta[0] + ", " +delta[1] + ", " +delta[2]);
  
  double CCtrace = 0;
  for(int i=0; i<CCp1p2.length; i++){
    CCtrace += CCp1p2[i][i];
  }
  
  println();
  println("trace: " + CCtrace);
  
  Q = new double[4][4];
  //Make first row and column of Q
  Q[0][0] = CCtrace; //Top left item is trace
  for(int i=1; i<Q.length; i++){
    Q[0][i] = delta[i-1];
  }
  for(int i=1; i<Q.length; i++){
    Q[i][0] = delta[i-1];
  }
  //CCp1p2+CCp1p2'-trace(CCp1p2)*eye(3)
  for(int i=1; i<Q.length; i++){
    for(int j=1;j<Q.length; j++){
      Q[i][j] = CCp1p2[i-1][j-1] + CCp1p2[j-1][i-1];
    }
  }
  for(int i=1; i<Q.length; i++){//-trace(CCp1p2)*eye(3)
    Q[i][i] -= CCtrace;
  }
  
  println();
  println("Q:");
  for(int i=0; i<Q.length; i++){
    println(Q[i][0] + ", " + Q[i][1] + ", " + Q[i][2] + ", " + Q[i][3]);
  }

  Qmat = new Matrix(Q);
//  println(Qmat.)
  EigenvalueDecomposition eigdec = Qmat.eig();
  Matrix Qeigval = eigdec.getD(); // Returns the block diagonal eigenvalue matrix
  Matrix Qeigvec = eigdec.getV(); // Returns the eigenvector matrix
  
  println();
  println("Eigenvalue:");
  for(int i=0; i<Qeigval.getRowDimension(); i++){
    println(Qeigval.get(i,0) + ", " + Qeigval.get(i,1) + ", " + Qeigval.get(i,2) + ", " + Qeigval.get(i,3));
  }
  
  // NEGATIVE VALUES COMPARED TO MATLAB SCRIPT
  println();
  println("Eigenvector:");
  for(int i=0; i<Qeigvec.getRowDimension(); i++){
    println(Qeigvec.get(i,0) + ", " + Qeigvec.get(i,1) + ", " + Qeigvec.get(i,2) + ", " + Qeigvec.get(i,3));
  }
  
  double val = Qeigval.get(0,0);
  int valcolumn = 0;
  for(int i=0; i<Qeigval.getColumnDimension(); i++){
    if(Qeigval.get(i,i)>val){
      val = Qeigval.get(i,i);
      valcolumn =i;
    }
  }
  println();
  println("val = " + val + ", index " + valcolumn);
  println();
  println("qR:");
  
  qR = new double[4];
  for(int i=0; i<qR.length; i++){
    qR[i] = Qeigvec.get(i,valcolumn);
    println(qR[i]);
  }
  
  //qR2R, make the rotation matrix
  double q0 = qR[0], q1 = qR[1], q2 = qR[2], q3 = qR[3];
  R = new double[][]{
    {(q0*q0+q1*q1-q2*q2-q3*q3),(2*(q1*q2-q0*q3)),(2*(q1*q3+q0*q2))},
    {(2*(q1*q2+q0*q3)),(q0*q0+q2*q2-q1*q1-q3*q3),(2*(q2*q3-q0*q1))},
    {(2*(q1*q3-q0*q2)),(2*(q2*q3+q1*q0)),(q0*q0+q3*q3-q1*q1-q2*q2)}
  };
  
  println();
  println("R:");
  for(int i=0; i<R.length; i++){
    println(R[i][0] + ", " + R[i][1] + ", " + R[i][2]);
  }
  

  //translation matrix, meanset2'-R*meanset1'
  T = new double[]{
    (meanset2.x-((R[0][0]*meanset1.x)+(R[0][1]*meanset1.y)+(R[0][2]*meanset1.z))),
    (meanset2.y-((R[1][0]*meanset1.x)+(R[1][1]*meanset1.y)+(R[1][2]*meanset1.z))),
    (meanset2.z-((R[2][0]*meanset1.x)+(R[2][1]*meanset1.y)+(R[2][2]*meanset1.z)))
  };
  
  println();
  println("T:");
  println(T[0] + ", " + T[1] + ", " + T[2]);

  //calculate residuals
  diff = new double[3][3]; //diff = pntSet2' - R*pntSet1' - repmat(T,1,nPnts1);
  //pntSet2'
  for(int i=0; i<3; i++){
    for(int j=0;j<3;j++){
      switch(j) {
      case 0: 
        diff[j][i] = pointset2.get(i).x; 
        break;
      case 1: 
        diff[j][i] = pointset2.get(i).y; 
        break;
      case 2: 
        diff[j][i] = pointset2.get(i).z; 
        break;
      }
    }
  }
  //(-)R*pntSet1
  for(int i=0; i<3; i++){
    for(int j=0; j<3; j++){
      for(int k=0; k<3; k++){
        diff[i][j] -= R[i][k] * pointset1db[j][k];
      }
    }
  }
  //(-) repmat(T,1,nPnts1)
  for(int i=0; i<3;i++){
    diff[0][i] -= T[0];
    diff[1][i] -= T[1];
    diff[2][i] -= T[2];
  }
  
  println();
  println("diff:");
  for(int i=0; i<diff.length; i++){
    println(diff[i][0] + ", " + diff[i][1] + ", " + diff[i][2]);
  }
  
  res = new double[3];
  res[0]=Math.sqrt((diff[0][0]*diff[0][0])+(diff[1][0]*diff[1][0])+(diff[2][0]*diff[2][0]));
  res[1]=Math.sqrt((diff[0][1]*diff[0][1])+(diff[1][1]*diff[1][1])+(diff[2][1]*diff[2][1]));
  res[2]=Math.sqrt((diff[0][2]*diff[0][2])+(diff[1][2]*diff[1][2])+(diff[2][2]*diff[2][2]));
  
  println();
  println("res:");
  for(int i=0; i<3; i++){
    println(res[i]);
  }
}


/**The transformation: 
- Takes in cloud array n*3x1, rotation matrix and translation matrix.
- Converts cloud array to nx3 matrix (n points, 3 dimensions)
- Applies rotation matrix. Matrix multiplication between R and cloud
- Adds on the translation parameters.

- Print to file?
- Merge with 2nd cloud?
- Display resulting, larger cloud?
Author: John Wika Haakseth, May 2012
**/
void transformateCloud(float[] cloud, double[][] R, double[] T){
  double[][] cloud_trans = new double[cloud.length/3][3];
  for(int i=0; i<cloud_trans.length;i++){
    cloud_trans[i][0] = cloud[3*i+0];
    cloud_trans[i][1] = cloud[3*i+1];
    cloud_trans[i][2] = cloud[3*i+2];
  }
  //Rotation, R*cloud_trans:
  double[][] rotated = new double[cloud_trans.length][3];
  for(int i=0; i<rotated.length; i++){
    for(int j=0; j<3; j++){
      for(int k=0; k<3; k++){
        rotated[i][j] += R[j][k] * cloud_trans[i][k];
      }
    }
  }
  
  //Translation, rotated + T;
  for(int i=0;i<rotated.length;i++){
    rotated[i][0] = rotated[i][0] + T[0];
    rotated[i][1] = rotated[i][1] + T[1];
    rotated[i][2] = rotated[i][2] + T[2];
  }
  println();
  println(rotated.length);
  println("The last point: " + rotated[rotated.length-1][0] +", "+ rotated[rotated.length-1][1] +", "+rotated[rotated.length-1][2]);
  
  transCloud = new float[cloud1.length];
  //put transformed cloud into float array
  for(int i=0; i<rotated.length-1;i++){
    for(int j=0; j<3; j++){
      transCloud[i*3+j] = (float)rotated[i][j];
    }
  }
  f3 = loadFloats(transCloud);
}

