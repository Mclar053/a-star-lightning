class Tile_Player extends Tile_Entity
{
  String name;
  //Item[] inventory = new Item[28];
  
  Tile_Player(PVector _pos,PVector _gridPos, String _name)
  {
    super(_pos, _gridPos);
    name = _name;
    nameType = "player";
//    tileColour = color(0,255,255);
//    tileColour = color(counter%255,120,0);
//    tileColour = color(180,240,170);
tileColour = color(random(70));
//    tileColour = color(150,random(10,70),random(50,200));
//    tileColour = color(0,0,255,50);
//    tileColour = color(0,0,170);
  }
  
  void movementControl()
  {
    if(moveMe)
    {
      move();
//      tileColour = color(counter*2,(170-counter)*0.5,50);
    }
    else
    {
//      println(position);
      findPath(new PVector(random(width),random(height)));
      this.counter=0;
    }
  }
  
}
