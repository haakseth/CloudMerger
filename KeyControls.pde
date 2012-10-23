/*
Methods to handle key press actions
*/

void keyTyped(){
  if(key == TAB){
    if((cloud1!=null)&&(cloud2!=null)){
      currentScreen++;
      if (currentScreen > 2) { 
        currentScreen = 0; 
      }
      shouldCameraBeOn();
      println("Current screen is "+currentScreen);
    }
  }
  if(key == 'l'){ //print a list of the selected points
    if(cloud1PointsList!=null){
      println("Selected points in cloud 1:");
      for(int i=0; i<cloud1PointsList.size(); i++){
        println(cloud1PointsList.get(i));   
      }
    }
    if(cloud2PointsList!=null){
      println("Selected points in cloud 2:");
      for(int i=0; i<cloud2PointsList.size(); i++){
        println(cloud2PointsList.get(i));   
      }
    }
  }
  if(key == BACKSPACE){
    currentScreen=0;
    shouldCameraBeOn();
  }

}
