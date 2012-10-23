import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import peasy.*;
import javax.swing.*; 
import java.text.DecimalFormat;
import Jama.Matrix;
import Jama.EigenvalueDecomposition;

/*
Object declarations:
*/
int currentScreen; //this decides which screen is being drawn
PeasyCam camera1; //Camera object, allows the user to navigate around the cloud using mouse
Button laodcloud1button, laodcloud2button, viewcloud1button, viewcloud2button, 
  transformCloudButton, viewBigCloudButton, resetRegistrationButton, printFileButton; 
boolean cameraOn = false; //camera must be off when displaying menu screen


GLU glu; //OpenGL objects
GL gl, gl2;

float[] cloud1, cloud2;
int[] cloud1col;
String cloud1filename;
String cloud2filename;
String cloud2abspath;

float[] transCloud = null;
float[] bigCloud = null;
PVector[] vectorCloud1;
PVector[] vectorCloud2;
ArrayList cloud1PointsList = new ArrayList();//Lists for holding corresponding points?
ArrayList cloud2PointsList = new ArrayList();

float pointSize = 5f; // set the point size of the point cloud
FloatBuffer f1, f2, f3;

NumberFormat formatter = new DecimalFormat("#0.000"); //Tidying up numbers for file writing

/*
setup() is called when application is launched
*/
void setup(){
  //set up application screen size and renderer
  if(screen.width>1300){
    size(800, 600, OPENGL);
  }
  else{
    size(640, 480, OPENGL);
  }
  /*
  Object instantiators:
  */
  laodcloud1button = new Button(width/2-Math.round(textWidth("Load cloud 1"))-50, 50, "Load cloud 1");
  laodcloud2button = new Button(width/2+30, 50, "Load cloud 2");
  viewcloud1button = new Button(width/2-Math.round(textWidth("View cloud 1"))-50, 100, "View cloud 1");
  viewcloud2button = new Button(width/2+30, 100, "View cloud 2");
  transformCloudButton = new Button(width/2-Math.round(textWidth("Merge clouds")/2), 200, "Merge clouds");
  viewBigCloudButton = new Button(width/2-Math.round(textWidth("View merge clouds")/2), 250, "View merged clouds");
  printFileButton = new Button(width/2-Math.round(textWidth("Print merged cloud to file")/2), 300, "Print merged cloud to file");
  resetRegistrationButton = new Button(width/2-Math.round(textWidth("Reset registration")/2), 400, "Reset registration");
 
////////For very accurate merging of test data,
////////Uncomment the following to start application with :
// cloud1 = loadPoints("pcKinect_reference.txt");
// vectorCloud1 = loadVectors("pcKinect_reference.txt");
// cloud2 = loadPoints("pcKinect_transformed.txt");
// vectorCloud2 = loadVectors("pcKinect_transformed.txt");
// f1 = loadFloats(cloud1);
// f2 = loadFloats(cloud2);
// cloud1PointsList.add(new PVector(172.12, 312.35, 129.05));
// cloud1PointsList.add(new PVector(52.372, 162.82, -66.771));
// cloud1PointsList.add(new PVector(-154.84, 339.61, -139.42));
// cloud2PointsList.add(new PVector(280.63, 220.26, -34.754));
// cloud2PointsList.add(new PVector(54.642, 131.86, -161.87));
// cloud2PointsList.add(new PVector(-71.122, 379.58, -209.71));
  
}

/*
draw() is called every time the screen is updated, 60 times per second
*/
void draw(){
  background(0);
  switch(currentScreen) {
    case 0: drawOpenScreen(); break;
    case 1: drawCloudOne(); break;
    case 2: drawCloudTwo(); break;
    case 3: drawBigCloud(); break;
    default: drawOpenScreen(); break;
  }
  shouldCameraBeOn();
}

