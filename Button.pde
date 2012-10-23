class Button{
  int x,y;
  String label;
  
  Button(int x, int y, String label){
    this.x = x;
    this.y = y;
    this.label = label;
  }
  void draw(){
    fill(200);
    if(over()){
	fill(255);
    }
    rect(x, y, textWidth(label)+20, 20);
    fill(0);
    text(label, x+10, y + 15);
  }
  boolean over(){
    if(mouseX >= x && mouseY >= y && mouseX <= x + textWidth(label) && mouseY <= y + 22){
	return true;
    }
    return false;
  }
}
