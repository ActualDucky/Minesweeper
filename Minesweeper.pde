import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_COLS = 20;
public final static int NUM_ROWS = 20;
public final static int MINE_COUNT = 60;
public boolean firstClick;
public int minedCount;
private MSButton[][] buttons; //2D ARRAY
private ArrayList <MSButton> mines; 

void setup (){
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make(click);
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];

    for(int i = 0; i < NUM_ROWS; i++){
        for(int j = 0; j < NUM_COLS; j++){
            buttons[i][j] = new MSButton(i, j);
        }
    }

    firstClick = true;
    minedCount = 0;

    mines = new ArrayList <MSButton>();
    
    setMines();
}
public void setMines()
{
    for(int i = 0; i < MINE_COUNT; i++){
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if(!mines.contains(buttons[row][col])){
            mines.add(buttons[row][col]);
        }
    }
}
public void setMines(int r, int c){
    for(int i = 0; i < MINE_COUNT; i++){
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if(!mines.contains(buttons[row][col])){
            mines.add(buttons[row][col]);
        }
    }
}

public void draw (){
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}

public boolean isWon(){
    return !(minedCount < ((NUM_ROWS * NUM_COLS) - MINE_COUNT));
}
public void displayLosingMessage(){
    gameOver();
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][9].setLabel(" ");
    buttons[9][10].setLabel("L");
    buttons[9][11].setLabel("O");
    buttons[9][12].setLabel("S");
    buttons[9][13].setLabel("E");
}
public void displayWinningMessage(){
    gameOver();
    buttons[9][5].setLabel("Y");
    buttons[9][6].setLabel("O");
    buttons[9][7].setLabel("U");
    buttons[9][8].setLabel(" ");
    buttons[9][9].setLabel("W");
    buttons[9][10].setLabel("I");
    buttons[9][11].setLabel("N");
}
public void gameOver() {
    for(int i = 0; i < NUM_ROWS; i++){
        for(int j = 0; j < NUM_COLS; j++){
            buttons[i][j].gameOver();
        }
    }
}
public boolean isValid(int r, int c){
    return r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0;
}
public int countMines(int row, int col){
    int numMines = 0;

    for(int i = row - 1; i <= row + 1; i++){
        for(int j = col - 1; j <= col + 1; j++){
            if(isValid(i, j) && mines.contains(buttons[i][j])){
                numMines++;
            }
        }
    }

    return numMines;
}
public class MSButton{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, game, clickable;
    private String myLabel;
    
    public MSButton (int row, int col){
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        game = clickable = true;
        Interactive.add(click); //Manager
    }

    // called by Manager
    public void mousePressed() {
        if(firstClick && mines.contains(click)){
            for(int i = mines.size() - 1; i >= 0; i--){
                mines.remove(i);
            }
            setMines(myRow, myCol);
        }
        if(firstClick && countMines(myRow, myCol) > 0){
            while (countMines(myRow, myCol) > 0){
                for(int i = mines.size() - 1; i >= 0; i--){
                    mines.remove(i);
                }
                setMines(myRow, myCol);
            }
        }
        if(game && clickable){
            firstClick = false;
            clicked = true;
            if(keyPressed || mouseButton == RIGHT){
                if(flagged){
                    flagged = false;
                    clicked = false;
                }
                    else {
                    flagged = true;
                }
            }
               else if(mines.contains(click)){
                displayLosingMessage();
            }
              else if(countMines(myRow, myCol) > 0){
                clickable = false;
                minedCount++;
                setLabel(countMines(myRow, myCol));
            }
                else{
                clickable = false;
                minedCount++;
                for(int i = -1; i <= 1; i++){
                    for(int j = -1; j <= 1; j++){
                        if(isValid(myRow + i, myCol + j) && buttons[myRow + i][myCol + j].checkClicked()){
                            buttons[myRow + i][myCol + j].mousePressed();
                        }
                    }
                }
            }
        }
    }
    public void draw () {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(click) ) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){
        myLabel = newLabel;
    }
    public void setLabel(int newLabel){
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged() {
        return flagged;
    }
    public boolean checkClicked() {
        return !clicked;
    }
    public void gameOver() {
        game = false;
    }
}
