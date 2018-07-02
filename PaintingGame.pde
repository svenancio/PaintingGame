/*
  PAINTING GAME - 2014
  Sergio Venancio
  GNU General Public License v3.0
*/

int initGrid = 3;//size of the starting game grid

int grid = initGrid;
int[][] board;
boolean playing, over, countdown, onward = false;
int[] last = new int[2];
float tempo;

void setup() {
  board = new int[grid][grid];
  size(600,600);
  frameRate(24);
  background(255);
  strokeWeight(1);
  stroke(0);
  tempo = 24*60;//1 minute
  onward = false;
  last[0] = -1;
  last[1] = -1;
  createBoard();
}

void draw() {
  testBoard();
  int i, j = 0;
  createTimer();
  if(countdown) {
    tempo--;
  }
  if(playing) {
    if(mouseX >= width || mouseX < 0 || mouseY >= height || mouseY < 0) {
      gameOver();
    }
    
    i = floor(max(0,min(mouseX,width-1)) / (width/grid));
    j = floor(max(0,min(mouseY,height-1)) / (height/grid));
    
    if(last[0] != i || last[1] != j) {
      //(un)paint
      if(board[i][j] == 1) {
        drawSquare(i,j,1);
      } else {
        drawSquare(i,j,0);
      }
      last[0] = i;
      last[1] = j;
    }
  }
  
  if(tempo <= 0) {
    playing = false;
    countdown = false;
    gameOver();
  }
}

void createTimer() {
  pushMatrix();
  translate(0,0);
  fill(0);
  noStroke();
  rect(0,height-20,50,20);
  fill(255);
  textSize(18);
  text(""+floor(tempo / 24),10,height-2);
  popMatrix();
}

void createBoard() {
  for(int i=0;i<grid;i++) {
    for(int j=0;j<grid;j++) {
      drawSquare(i,j,round(random(0,1)));
    }
  }
}

void drawSquare(int i,int j,int colour) {
  pushMatrix();
    translate(i*width/grid,j*height/grid);
    if (colour == 1) {
      fill(0);
      board[i][j] = 0;
    } else {
      fill(255);
      board[i][j] = 1;
    }
    rect(0,0,width/grid,height/grid);
  popMatrix();
}

void testBoard(){
  for(int i=0;i<grid;i++) {
    for(int j=0;j<grid;j++) {
      if(board[i][j] == 1) return;
    }
  }
  
  gameWin();
}

void gameWin() {
  //draw happy face
  pushMatrix();
    translate(width/2,height/2);
    fill(200,0,0);
    textSize(18);
    text("NEXT",200,250);
    ellipse(-75,-100,50,50);
    ellipse(75,-100,50,50);
    noFill();
    strokeWeight(10);
    stroke(200,0,0);
    arc(0,0,300,300,0,PI);
  popMatrix();
  
  //set game on conditions
  countdown = false;
  playing = false;
  onward = true;
}

void mousePressed() {
  if(!over) {
    playing = true;
    countdown = true;
  }
}

void mouseReleased() {
  if(playing) {
    playing = false;
    countdown = false;
    gameOver();
  }
  
  //clickable area to restart game
  if(over && mouseX > width-100 && mouseY > height-100) {
    playing = over = false;
    last[0] = last[1] = -1;
    grid = initGrid;
    setup();
  }
  
  //clickable area to continue game
  if(onward && mouseX > width-100 && mouseY > height-100) {
    playing = over = false;
    last[0] = last[1] = -1;
    grid++;
    setup();
  }
}

void gameOver() {
  //draw unhappy face
  pushMatrix();
    translate(width/2,height/2);
    fill(200,0,0);
    textSize(18);
    text("RESTART",200,250);
    ellipse(-75,-100,50,50);
    ellipse(75,-100,50,50);
    noFill();
    strokeWeight(10);
    stroke(200,0,0);
    arc(0,150,300,300,PI,TWO_PI);
  popMatrix();
  
  //set game over conditions
  playing = false;
  over = true;
}