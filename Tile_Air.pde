class Tile_Air extends Tile
{
  Tile_Air(PVector _pos, PVector _gridPos)
  {
    super(_pos, _gridPos);
    nameType = "air";
//    if(position%5==0 || floor(position/tilesPerLine.x)%5==0)
//    {
//      tileColour = color(200,50);
//    }
//    else
//    {
      tileColour = color(random(0,75),50);
//    }
    fCost = 99999999;
  }
}
