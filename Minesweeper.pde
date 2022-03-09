import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 10;
private final static int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r<NUM_ROWS; r++){
      for(int c = 0; c< NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    
    setMines();
}
public void setMines()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])){
      mines.add(buttons[row][col]);
    }
    int row1 = (int)(Math.random()*NUM_ROWS);
    int col1 = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row1][col1])){
      mines.add(buttons[row1][col1]);
    }
    int row2 = (int)(Math.random()*NUM_ROWS);
    int col2 = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row2][col2])){
      mines.add(buttons[row2][col2]);
    }
}
public void draw ()
{
    background( 0 );
    if(isWon() == true){
        displayWinningMessage();
    } 
    
}
public boolean isWon()
{
    //if you flag every mine
    for(int i = 0; i<mines.size(); i++){
      if(mines.get(i).flagged==false){
        return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    print("You Lost");
    fill(255, 0, 0);
    text("You Lost", 200,200);
    String lose[]={"Y", "O", "U", "L", "O", "S", "E"};
    for(int i = 0; i<lose.length; i++){
      buttons[0][i].myLabel = lose[i];
    }
}
public void displayWinningMessage()
{
  print("You Won!");
  fill(0,255,0);
  String win[]={"Y", "O", "U", "W", "I", "N"};
    for(int i = 0; i<win.length; i++){
      buttons[0][i].myLabel = win[i];
    }
}
public boolean isValid(int r, int c)
{
   if(r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0){
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r<=row+1; r++){
      for(int c = col-1; c<=col+1; c++){
        if(isValid(r,c) && mines.contains(buttons[r][c]))
          numMines++;
        }
      }
      
    if(mines.contains(buttons[row][col]))
      numMines++;  
    return numMines;
}

    
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
       width = 400/NUM_COLS;
       height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          if(flagged==true){
            flagged=false;
            clicked=false; //remove light gray
          } else {
            flagged=true;
            
          }
        } else if(mines.contains(this)){
          displayLosingMessage();
        } else if(countMines(myRow, myCol)>0){
          setLabel((countMines(myRow, myCol)));
        } else {
          for(int r = myRow-1; r<=myRow+1; r++){
            for(int c = myCol-1; c<=myCol+1; c++){
              if(isValid(r, c) && buttons[r][c].clicked==false){
                buttons[r][c].mousePressed();
              }
            }
          }
        }
      
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 ); //light gray
        else 
            fill( 100 ); //flagged isfalse -> go back to dark gray

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2); //helps print winning, losing message
    }
    public void setLabel(String newLabel)
    {
        //myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
