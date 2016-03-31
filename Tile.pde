class Tile
{
  PVector pos, size;
  String nameType;
  boolean checked, pathed;
  color tileColour;
  int position, parent, fCost, hCost, gCost;
  float opacityP,opacityC;
  
  Tile(PVector _pos, PVector _gridPos)
  {
    pos = _pos;
    position = int(_gridPos.x+(_gridPos.y*tilesPerLine.x));
    size = new PVector(width/tilesPerLine.x,height/tilesPerLine.y);
    checked = false;
    pathed = false;
  }
  
  void display()
  {
    pushMatrix();
      translate(pos.x,pos.y);
      fill(tileColour);
      if(checked)
      {
        fill(130,140);
//        fill(255,0,0,170);
      }
      if(pathed)
      {
        fill(200,200,0,170);
//        fill(0,170,0,170);
      }
      rect(0,0,size.x,size.y);
      if(textDisplay)
      {
        fill(0);
        textSize(10);
        text(position+"\n"+int(pos.x)+" "+int(pos.y)+"\n"+parent,0,10);
      }
    popMatrix();
  }
}
