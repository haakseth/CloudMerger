import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import peasy.*;
import javax.swing.*; 
import Jama.Matrix;
import Jama.EigenvalueDecomposition;

int currentScreen;
PeasyCam camera1;
Button laodcloud1button, laodcloud2button, viewcloud1button, viewcloud2button, transformCloudButton, viewBigCloudButton;
boolean cameraOn = false;


GLU glu;
GL gl;
GL gl2;
int i = 0;

float[] cloud1;
float[] cloud2;
float[] transCloud = null;
float[] bigCloud = null;
PVector[] vectorCloud1;
PVector[] vectorCloud2;
ArrayList cloud1PointsList = new ArrayList();//Lists for holding corresponding points?
ArrayList cloud2PointsList = new ArrayList();
PVector mouseSomething; //whats this?

float rX,rY,rZ,vX,vY,vZ,vYY;
float tX,tY,tZ,tvX,tvY,tvZ;
float pointSize = 5f;
FloatBuffer f1, f2, f3;

void setup(){ 
 size(640, 480, OPENGL);
 laodcloud1button = new Button(200, 50, "Load cloud 1");
 laodcloud2button = new Button(350, 50, "Load cloud 2");
 viewcloud1button = new Button(200, 100, "View cloud 1");
 viewcloud2button = new Button(350, 100, "View cloud 2");
 transformCloudButton = new Button(200, 200, "Merge clouds");
 viewBigCloudButton = new Button(350, 200, "View merged clouds");
 
////////PUT THESE IN A FILECHOOSER METHOD
// cloud1 = loadPoints("pcKinect_reference.txt");
// vectorCloud1 = loadVectors("pcKinect_reference.txt");
// cloud2 = loadPoints("pcKinect_transformed.txt");
// vectorCloud2 = loadVectors("pcKinect_transformed.txt");
// f1 = loadFloats(cloud1);
// f2 = loadFloats(cloud2);

//cloud1PointsList.add(new PVector(172.12, 312.35, 129.05));
//cloud2PointsList.add(new PVector(280.63, 220.26, -34.754));
//cloud1PointsList.add(new PVector(52.372, 162.82, -66.771));
//cloud2PointsList.add(new PVector(54.642, 131.86, -161.87));
//cloud1PointsList.add(new PVector(-154.84, 339.61, -139.42));
//cloud2PointsList.add(new PVector(-71.122, 379.58, -209.71));  
//cloud1PointsList.add(new PVector(179.29, 326.93, -82.203));
//cloud2PointsList.add(new PVector(226.51, 219.59, -239.6));


 
 setupMouseWheel();
// camera1 = new Camera(this);
//  camera1 = new Camera(this,0,200,0, 0,-100,100);
  
}

void draw(){
  //Transformation values, to be updated every time something happens.
  //Rotation:
  rX+=vX;
  rY+=vY;
  rZ+=vZ;
  vX*=.02;
  vY*=.02;
  vYY*=.02;
  vZ*=.02;
  //Translation;
  tX+=tvX;
  tY+=tvY;
  tZ+=tvZ;
  tvX*=.02;
  tvY*=.02;
  tvZ*=.02;
  background(0);
  mouseControl();  
  cameraControl();
  switch(currentScreen) {
    case 0: drawOpenScreen(); break;
    case 1: drawCloudOne(); break;
    case 2: drawCloudTwo(); break;
    case 3: drawBigCloud(); break;
    default: drawOpenScreen(); break;
  }
}

