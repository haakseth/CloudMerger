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

//Same as loadPoints, but reads colors in stead, needed for writing the transformed cloud
int[] loadColors(String path) {
  String[] raw = loadStrings(path);
  int[] col = new int[raw.length * 3];
  //colors = new float[raw.length*4];
  for (int i = 0; i < raw.length; i++) {
    String[] thisLine = split(raw[i], ' ');
    col[i * 3] = Integer.parseInt(thisLine[3]);
    col[i * 3 + 1] = Integer.parseInt(thisLine[4]);
    col[i * 3 + 2] = Integer.parseInt(thisLine[5]);
  }
  return col;
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
  return vectors;
}

/*
unProject() and project() methods adapted from Nathan Nifong's 3d point manipulation project
http://nathannifong.com/3d_point_manipulation/_3D_Point_Manipulation.pde
*/
public PVector unProject(float winX, float winY)
{
  GL gl=((PGraphicsOpenGL)g).gl;
  GLU glu=((PGraphicsOpenGL)g).glu;
  ((PGraphicsOpenGL)g).beginGL();
  int viewport[] = new int[4];
  double[] proj=new double[16];
  double[] model=new double[16];
  gl.glGetIntegerv(GL.GL_VIEWPORT, viewport, 0);
  gl.glGetDoublev(GL.GL_PROJECTION_MATRIX,proj,0);
  gl.glGetDoublev(GL.GL_MODELVIEW_MATRIX,model,0);
  FloatBuffer fb = ByteBuffer.allocateDirect(4).order(ByteOrder.nativeOrder()).asFloatBuffer();
  gl.glReadPixels(int(winX), int(height-winY), 1, 1, GL.GL_DEPTH_COMPONENT, GL.GL_FLOAT, fb);
  fb.rewind(); 
  double[] mousePosArr=new double[4];
  glu.gluUnProject((double)mouseX,height-(double)mouseY,(double)fb.get(0),model,0,proj,0,viewport,0,mousePosArr,0);
  ((PGraphicsOpenGL)g).endGL();
  return new PVector((float)mousePosArr[0],(float)mousePosArr[1],(float)mousePosArr[2]);
}

public PVector project(PVector obj)
{
  // same as above, but projecting instead of unprojecting
  GL gl=((PGraphicsOpenGL)g).gl;
  GLU glu=((PGraphicsOpenGL)g).glu;
  ((PGraphicsOpenGL)g).beginGL();
  int viewport[] = new int[4];
  double[] proj=new double[16];
  double[] model=new double[16];
  gl.glGetIntegerv(GL.GL_VIEWPORT, viewport, 0);
  gl.glGetDoublev(GL.GL_PROJECTION_MATRIX,proj,0);
  gl.glGetDoublev(GL.GL_MODELVIEW_MATRIX,model,0);
  double[] winPosArr=new double[3];
  glu.gluProject(obj.x, obj.y, obj.z, model, 0, proj, 0, viewport, 0, winPosArr, 0);
  ((PGraphicsOpenGL)g).endGL();
  
  return new PVector((float)winPosArr[0],(float)winPosArr[1],(float)winPosArr[2]);
}

/*
Hardcoded choosefile methods. should be merged.
*/
File dir = new File("");
public void chooseFile1(){
  SwingUtilities.invokeLater(new Runnable() {
    public void run() {
      try {
        try { 
          UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
        } 
        catch (Exception e) { 
          e.printStackTrace();  
        }
        JFileChooser fc = new JFileChooser();
        fc.setCurrentDirectory(dir);
        int returnVal = fc.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
          File file = fc.getSelectedFile();
          cloud1filename = file.getName();
          println(cloud1filename);
          dir = new File(file.getAbsolutePath());
          cloud1 = loadPoints(file.getAbsolutePath());
          cloud1col = loadColors(file.getAbsolutePath());
          vectorCloud1 = loadVectors(file.getAbsolutePath());
          f1 = loadFloats(cloud1);
        } 
        else {
          println("Open command cancelled by user.");
        }
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  });
}
public void chooseFile2(){
  SwingUtilities.invokeLater(new Runnable() {
    public void run() {
      try {
        try { 
          UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
        } 
        catch (Exception e) { 
          e.printStackTrace();  
        } 
        JFileChooser fc = new JFileChooser();
        fc.setCurrentDirectory(dir);
        int returnVal = fc.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
          File file = fc.getSelectedFile();
          cloud2filename = file.getName();
          cloud2abspath = file.getAbsolutePath();
          dir = new File(file.getAbsolutePath());
          cloud2 = loadPoints(file.getAbsolutePath());
          vectorCloud2 = loadVectors(file.getAbsolutePath());
          f2 = loadFloats(cloud2);
        } 
        else {
          println("Open command cancelled by user.");
        }
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  });
}
/*
Allow user to reset registration if mistake is made.
*/
public void resetPointLists(){
  cloud1PointsList.clear();
  cloud2PointsList.clear();
}
