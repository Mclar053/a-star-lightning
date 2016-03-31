class Tile_Block extends Tile
{
  Tile_Block(PVector _pos, PVector _gridPos)
  {
    super(_pos,_gridPos);
    nameType = "block";
//    tileColour = color(random(80,120),170,240);
//tileColour = color(random(40,80),100,120);
//    tileColour = color(200,170,100);
    tileColour = color(70);
    fCost = -2;
  }
}
