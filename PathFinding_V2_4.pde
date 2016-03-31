ArrayList<Tile> grid = new ArrayList<Tile>();
Tile_Player Player;
ArrayList<Tile_Player> players = new ArrayList<Tile_Player>();

PVector tilesPerLine;
boolean textDisplay, move;
int pathNumber, noPath, blockProb;

void setup()
{
  tilesPerLine = new PVector(70,70);
  blockProb = 4;
  textDisplay = false;
  size(700,700);
  for(int i=0; i<100; i++)
  {
    int randomX, randomY;
//    randomX = 5;
//    randomY = 5;
    randomX = floor(random(tilesPerLine.x));
    randomY = floor(random(tilesPerLine.y));
    Player = new Tile_Player(new PVector(randomX*width/tilesPerLine.x,randomY*height/tilesPerLine.y),new PVector(randomX,randomY),"thing");
    Player.currentMove = Player.moveList.get(0);
    players.add(Player);
  }
  setupGrid(20000);
  println(width/tilesPerLine.x,height/tilesPerLine.y);
  grid = bubbleSortPos(grid);
  
  noStroke();
}

void draw()
{
//  background(0);
  for(Tile _tile : grid)
  {
    _tile.display();
//    println(_tile.opacityP,_tile.opacityC);
  }
  for(Tile_Player player : players)
  {
    player.movementControl();
    player.display();
  }
}

void setupGrid(int _blockN)
{
  grid = new ArrayList<Tile>();
  for(int i=0; i<tilesPerLine.x; i++)
  {
    for(int j=0; j<tilesPerLine.y; j++)
    {
      PVector newVector = new PVector(i*width/tilesPerLine.x,j*height/tilesPerLine.y);
      if(int(random(10))%blockProb==0 && _blockN>0)
      {
        grid.add(new Tile_Block(newVector, new PVector(i,j)));
        _blockN--;
      }
      else
      {
        grid.add(new Tile_Air(newVector,new PVector(i,j)));
      }
    }
  }
  println(_blockN);
}

void mousePressed()
{
//  if(mouseButton == LEFT)
//  {
//    Player.findPath(new PVector(mouseX,mouseY));
//    move = true;
//    Player.counter = 0;
//  }
}

void keyPressed()
{
  if(key=='r')
  {
    for(Tile _tile : grid)
    {
      _tile.checked = false;
      _tile.pathed = false;
    }
  }
  else if(key=='t')
  {
    setupGrid(20000);
  }
}
