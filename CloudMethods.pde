//For transformating the cloud itself
public void transformateCloud(){
  //declare and update parameters for this
  gl.glRotatef(11,1,0,0);
  gl.glRotatef(-15,0,1,0);
  gl.glRotatef(28,0,0,1);
  gl.glTranslatef(-37,0,0);
  gl.glTranslatef(0,14,0);
  gl.glTranslatef(0,0,-55);
//  use gl.glrotatef() and trans for actual rotation and transformation of cloud
//  gl.glRotatef(rX,1,0,0);
//  gl.glRotatef(rY,0,1,0);
//  gl.glRotatef(rZ,0,0,1);
//  gl.glTranslatef(tX,0,0);
//  gl.glTranslatef(0,tY,0);
//  gl.glTranslatef(0,0,tZ);
}

//
public FloatBuffer loadFloats(float[] points) {
  FloatBuffer f;
  f = ByteBuffer.allocateDirect(4 * points.length).order(
  ByteOrder.nativeOrder()).asFloatBuffer();
  f.put(points);
  f.rewind();
  return f;
}

//Defines how to read the file with the points
float[] loadPoints(String path) {
  String[] raw = loadStrings(path);
  float[] points = new float[raw.length * 3];
  //colors = new float[raw.length*4];
  for (int i = 0; i < raw.length; i++) {
    String[] thisLine = split(raw[i], ' ');
    points[i * 3] = new Float(thisLine[0]).floatValue();
    points[i * 3 + 1] = new Float(thisLine[1]).floatValue();
    points[i * 3 + 2] = new Float(thisLine[2]).floatValue();
  }
  return points;
}

//Array of PVectors from file
PVector[] loadVectors(String path) {
  String[] raw = loadStrings(path);
  PVector[] vectors = new PVector[raw.length];
  //colors = new float[raw.length*4];
  for (int i = 0; i < raw.length; i++) {
    String[] thisLine = split(raw[i], ' ');
    vectors[i] = new PVector((new Float(thisLine[0]).floatValue()),(new Float(thisLine[1]).floatValue()),(new Float(thisLine[2]).floatValue()));
  }
//  println((points[3])+", "+(points[4])+", "+(points[5]));
//  println(vectors[vectors.length-1]);
  return vectors;
}

public PVector unProject(float winX, float winY)
{
  GL gl=((PGraphicsOpenGL)g).gl;
  GLU glu=((PGraphicsOpenGL)g).glu;
  ((PGraphicsOpenGL)g).beginGL();
  //have to get processing to dump all it's matricies into GL, so the functions work.
  int viewport[] = new int[4];
  //For the viewport matrix... not sure what all the values are, I think the first two are width and height, and all Matricies in GL se
  //m to be 4 or 16...
  double[] proj=new double[16];
  //For the Projection Matrix, 4x4
  double[] model=new double[16];
  //For the Modelview Matrix, 4x4
  gl.glGetIntegerv(GL.GL_VIEWPORT, viewport, 0);
  //fill the viewport matrix
  gl.glGetDoublev(GL.GL_PROJECTION_MATRIX,proj,0);
  //projection matrix
  gl.glGetDoublev(GL.GL_MODELVIEW_MATRIX,model,0);
  //modelview matrix
  FloatBuffer fb = ByteBuffer.allocateDirect(4).order(ByteOrder.nativeOrder()).asFloatBuffer();
  //set up a floatbuffer to get the depth buffer value of the mouse position
  gl.glReadPixels(int(winX), int(height-winY), 1, 1, GL.GL_DEPTH_COMPONENT, GL.GL_FLOAT, fb);
  //Get the depth buffer value at the mouse position. have to do height-mouseY, as GL puts 0,0 in the bottom left, not top left.
  //  println(fb.get(0));
  fb.rewind(); //what the hell does this do
  double[] mousePosArr=new double[4];
  //the result x,y,z will be put in this.. 4th value will be 1, but I think it's "scale" in GL terms, but I think it'll always be 1.
  glu.gluUnProject((double)mouseX,height-(double)mouseY,(double)fb.get(0),model,0,proj,0,viewport,0,mousePosArr,0);
  //glu.gluUnProject((double)mouseX,height-(double)mouseY,(double)0.5, model,0,proj,0,viewport,0,mousePosArr,0); 
  //the magic function. You put all the values in, and magically the x,y,z values come out :)
  ((PGraphicsOpenGL)g).endGL();
  
  return new PVector((float)mousePosArr[0],(float)mousePosArr[1],(float)mousePosArr[2]);
}

public PVector project(PVector obj)
{
  // same as above, but projecting instead of unprojecting
  GL gl=((PGraphicsOpenGL)g).gl;
  GLU glu=((PGraphicsOpenGL)g).glu;
  ((PGraphicsOpenGL)g).beginGL();
  //have to get processing to dump all it's matricies into GL, so the functions work.
  int viewport[] = new int[4];
  double[] proj=new double[16];
  double[] model=new double[16];
  gl.glGetIntegerv(GL.GL_VIEWPORT, viewport, 0);
  gl.glGetDoublev(GL.GL_PROJECTION_MATRIX,proj,0);
  gl.glGetDoublev(GL.GL_MODELVIEW_MATRIX,model,0);
  double[] winPosArr=new double[3];
  //the result x,y,z will be put in this..
  glu.gluProject(obj.x, obj.y, obj.z, model, 0, proj, 0, viewport, 0, winPosArr, 0);
  ((PGraphicsOpenGL)g).endGL();
  
  return new PVector((float)winPosArr[0],(float)winPosArr[1],(float)winPosArr[2]);
}

/**
modified filechooser taken from http://processinghacks.com/hacks:filechooser
@author Tom Carden
@modified by John Wika Haakseth
*/
public void chooseFile(int cloud){
  // create a file chooser 
  final JFileChooser fc = new JFileChooser(); 
  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 
  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    println(file.getAbsolutePath());
    if(cloud==1){
       cloud1 = loadPoints(file.getAbsolutePath());
       vectorCloud1 = loadVectors(file.getAbsolutePath());
       f1 = loadFloats(cloud1);
    }
    if(cloud==2){
      cloud2 = loadPoints(file.getAbsolutePath());
      vectorCloud2 = loadVectors(file.getAbsolutePath());
      f2 = loadFloats(cloud2);
    }
    
    
   }
   else { 
     println("Open command cancelled by user."); 
   }
}


