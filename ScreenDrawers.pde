//Screen that shows when application is launched, user clicks a button to open filechoosers to find clouds.
void drawOpenScreen(){
  
  laodcloud1button.draw();
  laodcloud2button.draw();
  viewcloud1button.draw();
  viewcloud2button.draw();
  if(cloud1PointsList.size()>2 && cloud2PointsList.size()>2){
    transformCloudButton.draw();
  }
  if(transCloud!=null){
    viewBigCloudButton.draw();
  }
  
  
}

void drawCloudOne(){
  //Get GL object to make direct OpenGL calls
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  gl = pgl.beginGL();
  gl.glPointSize(pointSize); //default is 1
  gl.glColor4f(0.6f,0.5f,0.6f,0.6f);   
  gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
  gl.glVertexPointer(3, GL.GL_FLOAT, 0, f1); //define an array of vertex data, gets points from FloatBuffer f
  gl.glDrawArrays(GL.GL_POINTS, 0, f1.capacity()/3);
  gl.glDisableClientState(GL.GL_VERTEX_ARRAY); 
  pgl.endGL();
  
  frame.setTitle("Cloud "+ currentScreen+ ", registered " + cloud1PointsList.size() + " points.");
}

void drawCloudTwo(){
  
  //Get GL object to make direct OpenGL calls
  PGraphicsOpenGL pgl2 = (PGraphicsOpenGL) g;
  gl2 = pgl2.beginGL();
  gl2.glPointSize(pointSize);
  gl2.glColor4f(0.6f,0.6f,0.5f,0.6f);   
  gl2.glEnableClientState(GL.GL_VERTEX_ARRAY);
  gl2.glVertexPointer(3, GL.GL_FLOAT, 0, f2); //define an array of vertex data, gets points from FloatBuffer f
  gl2.glDrawArrays(GL.GL_POINTS, 0, f2.capacity()/3);
  gl2.glDisableClientState(GL.GL_VERTEX_ARRAY);
  pgl2.endGL();
  
  frame.setTitle("Cloud "+ currentScreen+ ", registered " + cloud2PointsList.size() + " points.");
}



void drawBigCloud(){
  
  //Get GL object to make direct OpenGL calls
  PGraphicsOpenGL pgl2 = (PGraphicsOpenGL) g;
  gl2 = pgl2.beginGL();
  gl2.glPointSize(pointSize);
  gl2.glColor4f(0.6f,0.6f,0.5f,0.6f);   
  gl2.glEnableClientState(GL.GL_VERTEX_ARRAY);
  gl2.glVertexPointer(3, GL.GL_FLOAT, 0, f2); //define an array of vertex data, gets points from FloatBuffer f
  gl2.glDrawArrays(GL.GL_POINTS, 0, f2.capacity()/3);
  gl2.glDisableClientState(GL.GL_VERTEX_ARRAY);
  
  gl2.glColor4f(0.5f,0.6f,0.6f,0.6f);   
  gl2.glEnableClientState(GL.GL_VERTEX_ARRAY);
  gl2.glVertexPointer(3, GL.GL_FLOAT, 0, f3); //define an array of vertex data, gets points from FloatBuffer f
  gl2.glDrawArrays(GL.GL_POINTS, 0, f3.capacity()/3);
  gl2.glDisableClientState(GL.GL_VERTEX_ARRAY);
  pgl2.endGL();
}

void shouldCameraBeOn(){
  if(currentScreen == 0){
    camera();
    cameraOn = false;
  }
  else{
    if(cameraOn == false){
    //    camera1 = new PeasyCam(this,100);
      camera1 = new PeasyCam(this,00,00,00, 500);
//      camera1.setRotations(30,180,0);
      camera1.setWheelScale(0.1);
      camera1.setMinimumDistance(0);
      cameraOn = true;
    }

  }
}
