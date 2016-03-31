ArrayList<Tile> bubbleSortFCost(ArrayList<Tile> list)
{
   int n = list.size();
   boolean swapped= true;
   while(swapped)
   {
     swapped = false;
     for(int i=1; i<n; i++)
     {
       Tile tileOne, tileTwo;
       tileOne = list.get(i-1);
       tileTwo = list.get(i);
       if(tileOne.fCost > tileTwo.fCost)
       {
         Tile temp = tileOne;
         list.set(i-1,tileTwo);
         list.set(i,temp);
         swapped=true;
       }
     }
  }
  return list;
}

ArrayList<Tile> bubbleSortPos(ArrayList<Tile> list)
{
   int n = list.size();
   boolean swapped= true;
   while(swapped)
   {
     swapped = false;
     for(int i=1; i<n; i++)
     {
       Tile tileOne, tileTwo;
       tileOne = list.get(i-1);
       tileTwo = list.get(i);
       if(tileOne.position > tileTwo.position)
       {
         Tile temp = tileOne;
         list.set(i-1,tileTwo);
         list.set(i,temp);
         swapped=true;
       }
     }
  }
  return list;
}
