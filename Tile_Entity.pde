class Tile_Entity extends Tile
{
  ArrayList<PVector> moveList;
  PVector startPos,nextPos, currentMove, dir;
  int counter;
  float speed;
  boolean moving, moveMe;;
  
  Tile_Entity(PVector _pos,PVector _gridPos)
  {
    super(_pos, _gridPos);
    moveList = new ArrayList<PVector>();
//    pathfinder = new Pathfinder();
    counter = 0;
    speed = 1.25;
    fCost = -1;
    moving = false;
    moveList.add(new PVector(0,0));
//    for(int i=0; i<10000; i++)
//      moveList.add(new PVector(floor(random(-1,2)),floor(random(-1,2))));
    currentMove = moveList.get(0);
    startPos = pos.get();
    nextPos = startPos.get();
    nextPos.add(currentMove.x*size.x,currentMove.y*size.y,0);
  }
  
  void findPath(PVector mousePos)
  {
    Tile start, end;
    start = grid.get(position);
    end = grid.get(int(floor(mousePos.x*tilesPerLine.x/width)+floor(mousePos.y*tilesPerLine.y/height)*tilesPerLine.x));
    if(end.nameType=="air")
    {
      for(Tile _gridTile : grid)
      {
        _gridTile.checked = false;
        _gridTile.pathed = false;
        if(position == _gridTile.position)
        {
          start = _gridTile;
        }
      }
      moveList = aStarPathfinding(start,end);
      if(moveList.size()==0)
      {
        noPath++;
      }
      else
      {
        pathNumber++;
      }
//      println(moveList.size());
      moveMe =true;
    }
    else
    {
//      println("skip",moveMe);
    }
  }
  
  void move()
  {
    if(moving)
    {
      dir = new PVector(0,0);
      dir.x= checkVectorDir(currentMove.x);
      dir.y = checkVectorDir(currentMove.y);
      pos.x = checkNextMove(dir.x,pos.x,currentMove.x,nextPos.x, width);
      pos.y = checkNextMove(dir.y,pos.y,currentMove.y,nextPos.y, height);
      if(pos.x == nextPos.x && pos.y == nextPos.y)
      {
        moving = false;
        position+=currentMove.x+(currentMove.y*tilesPerLine.x);
        if(counter>=moveList.size())
        {
          moveMe = false;
        }
      }
    }
    else if(!moving && counter < moveList.size())
    {
      changeNextPosition();
      while((nextPos.x<0 || nextPos.y<0 || nextPos.x>width-width/tilesPerLine.x || nextPos.y>height-height/tilesPerLine.y) && counter<moveList.size())
      {
        println("BUMP",counter);
        changeNextPosition();
      }
      moving = true;
//      println(counter, moveList.size());
    }
    
    if(pos.x == nextPos.x && pos.y == nextPos.y && counter>=moveList.size())
      {
          moveMe = false;
      }
  }
  
  void changeNextPosition()
  {
    currentMove = moveList.get(counter);
    startPos = pos.get();
    nextPos = startPos.get();
    nextPos.add(currentMove.x*size.x,currentMove.y*size.y,0);
    counter++;
  }
  
  int checkVectorDir(float _move)
  {
    if(_move>0)
    {
      return 1;
    }
    else if(_move<0)
    {
      return -1;
    }
    return 0;
  }
  
  float checkNextMove(float _dir, float _pos, float _curMove, float _nextPos, int maxGridPos)
  {
//    println(_dir,_pos,_nextPos);
    if(_dir==1)
    {
      if(_pos<_nextPos)
      { 
        _pos+= _curMove*speed;
      }
    }
    else if(_dir==-1)
    {
      if(_pos>_nextPos)
      {
        _pos+= _curMove*speed;
      }
    }
    return _pos;
  }
  
  ArrayList<PVector> aStarPathfinding(Tile _start, Tile _end)
  {
    ArrayList<Tile> pathGrid, openList, closeList;
    pathGrid = new ArrayList<Tile>();
    closeList = new ArrayList<Tile>();
    openList = new ArrayList<Tile>();
    openList.add(_start);
    Tile current;
    for(Tile _tile : grid)
    {
      pathGrid.add(_tile);
    }
    pathGrid = bubbleSortPos(pathGrid);
    
    _start.parent = -1;
    _start.gCost = 0;
    _start.hCost = calcHCost(_start, _end);
    _start.fCost = _start.gCost + _start.hCost;
    
    while(openList.size() != 0)
    {
      openList = bubbleSortFCost(openList);
      current = openList.get(0);
      if(current == _end)
      {
        return createMoveList(_start, current, pathGrid);
      }
      
      closeList.add(current);
      openList.remove(0);
      for(Tile _neighbour : neighbourNodes(current, pathGrid))
      {
        boolean skip = false;
        for(Tile _closeTile : closeList)
        {
          if(_neighbour == _closeTile || _neighbour.nameType!="air")
          {
            skip = true;
          }
        }
        if(!skip)
        {
          int tempGCost = current.gCost + 1;
          
          for(Tile _openTile : openList)
          {
            if(_neighbour == _openTile)
            {
              skip = true;
            }
          }
          if(!skip)
          {
            grid.get(_neighbour.position).checked = true;
            _neighbour.parent = current.position;
            _neighbour.gCost = tempGCost;
            _neighbour.hCost = calcHCost(_neighbour, _end);
            _neighbour.fCost = _neighbour.gCost + _neighbour.hCost;
            openList.add(_neighbour);
          }
        }
      }
    }
    return new ArrayList<PVector>();
  }
  
  int calcHCost(Tile _tileOne, Tile _tileTwo)
  {
    int horizontal, vertical, overall;
    horizontal = abs(_tileOne.position%int(tilesPerLine.x) - _tileTwo.position%int(tilesPerLine.x));
    vertical = abs(floor(_tileOne.position/tilesPerLine.x) - floor(_tileTwo.position%tilesPerLine.x));
    overall =horizontal + vertical;
    return overall;
  }
  
 ArrayList<Tile> neighbourNodes(Tile _current, ArrayList<Tile> _pathGrid)
 {
   ArrayList<Tile> neighbours = new ArrayList<Tile>();
   if(checkEdgeTile(_current)!=0 && checkEdgeTile(_current)!=2 && checkEdgeTile(_current)!=6)
   {
     neighbours.add(_pathGrid.get(int(_current.position-tilesPerLine.y)));
   }
   if(checkEdgeTile(_current)!=1 && checkEdgeTile(_current)!=3 && checkEdgeTile(_current)!=7)
   {
     neighbours.add(_pathGrid.get(int(_current.position+tilesPerLine.y)));
   }
   if(checkEdgeTile(_current)!=0 && checkEdgeTile(_current)!=1 && checkEdgeTile(_current)!=4)
   {
     neighbours.add(_pathGrid.get(int(_current.position-1)));
   }
   if(checkEdgeTile(_current)!=2 && checkEdgeTile(_current)!=3 && checkEdgeTile(_current)!=5)
   {
     neighbours.add(_pathGrid.get(int(_current.position+1)));
   }
   
   return neighbours;
 }
 
 int checkEdgeTile(Tile _current)
 {
   if(_current.position%tilesPerLine.x==0 && floor(_current.position/tilesPerLine.x)==0)
   {
     return 0;
   }
   else if(_current.position%tilesPerLine.x==0 && floor(_current.position/tilesPerLine.x)==tilesPerLine.y-1)
   {
     return 1;
   }
   else if(_current.position%tilesPerLine.x==tilesPerLine.x-1 && floor(_current.position/tilesPerLine.x)==0)
   {
     return 2;
   }
   else if(_current.position%tilesPerLine.x==tilesPerLine.x-1 && floor(_current.position/tilesPerLine.x)==tilesPerLine.y-1)
   {
     return 3;
   }
   else if(_current.position%tilesPerLine.x==0)
   {
     return 4;
   }
   else if(_current.position%tilesPerLine.x==tilesPerLine.x-1)
   {
     return 5;
   }
   else if(floor(_current.position/tilesPerLine.x)==0)
   {
     return 6;
   }
   else if(floor(_current.position/tilesPerLine.x)==tilesPerLine.x-1)
   {
     return 7;
   }
   return -1;
 }
 
 ArrayList<PVector> createMoveList(Tile _start, Tile _end, ArrayList<Tile> _pathGrid)
 {
   ArrayList<Tile> path = new ArrayList<Tile>();
   ArrayList<PVector> _moveList = new ArrayList<PVector>();
   Tile currentTile = _end;
   while(currentTile.parent != -1)
   {
     path.add(currentTile);
     grid.get(currentTile.position).pathed=true;
     currentTile = _pathGrid.get(currentTile.parent);
   }
   path.add(_start);
   for(int i=path.size()-1; i>0; i--)
   {
     Tile _pathTile, _nextTile;
     PVector _pathVec, _nextVec;
     _pathTile = path.get(i-1);
     _nextTile = path.get(i);
     _pathVec = new PVector(_pathTile.position%tilesPerLine.x,floor(_pathTile.position/tilesPerLine.x));
     _nextVec = new PVector(_nextTile.position%tilesPerLine.x,floor(_nextTile.position/tilesPerLine.x));
     PVector moveListVector = PVector.sub(_pathVec,_nextVec);
     _moveList.add(moveListVector);
   }
   return _moveList;
 }
}
