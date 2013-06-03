int [][] world;
color black = color(0);
color white = color(255);
color red = color(255,0,0);
color green = color(0,255,0);
color blue = color(0,0,255);
int onX, onY;
int heading; // N=0, E=1, S=2, W=3
int speed = 25;
int nColors = 3;
int nStates = 4;
int state;
int [][][] rules;
color [] colors;
boolean isDrawing = true;
// int [][][][][] coolRules;


void setup(){
    frameRate(10000);
    size(400,400);
    background(white);

    world = new int[width][height];

    colors = new color[5];
    colors[0] = white;
    colors[1] = black;
    colors[2] = red;
    colors[3] = green;
    colors[4] = blue;
    rules = new int[nColors][nStates][3];
    setRandomRule();
    
    // Cool 2x2 rule.
    // rules[0][0][0] = 1;
    // rules[0][0][1] = 3;
    // rules[0][0][2] = 0;
    // rules[0][1][0] = 0;
    // rules[0][1][1] = 0;
    // rules[0][1][2] = 0;
    // rules[1][0][0] = 1;
    // rules[1][0][1] = 3;
    // rules[1][0][2] = 1;
    // rules[1][1][0] = 0;
    // rules[1][1][1] = 0;
    // rules[1][1][2] = 1;


    // Loop through world
    // There might be a world = zeros() function instead
    for (int x=0; x<width; x++){
        for (int y=0; y<height; y++){
            world[x][y]= 0;
        }
    }

    // Set ON cell
    onX = int(width/2);
    onY = int(height/2);
    world[onX][onY] = 1;
    heading = int(random(4));
    state = 1;
}

void draw(){
    for(int i = 0; i < speed; i++){
        int onColor = world[onX][onY];
        int writeColor = rules[onColor][state][0];
        int changeHeading = rules[onColor][state][1];
        state = rules[onColor][state][2];
        world[onX][onY] = writeColor;
        set(onX,onY,colors[writeColor]);
        heading = (heading + changeHeading) % 4; 
        // Follow heading, update onX, onY
        getNewCoor(onX, onY);
    }
}



void getNewCoor(int X, int Y){
    if (heading == 0){ // North
        onY = (Y - 1 + height) % height;
    }
    else if (heading == 1){ // East
        onX = (X + 1 + width) % width;
    }
    else if (heading == 2){ // South
        onY = (Y + 1 + height)% height;
    }
    else if (heading == 3){ // West
        onX = (X - 1 + width)% width;
    }
    // Adding size to avoid having negative numbers
}

void setRandomRule(){
    // Loop current color
    for(int i = 0; i < nColors; i++){
        // Loop current state
        for (int j = 0; j < nStates; j++){
            // New write color
            rules[i][j][0] = int(random(nColors));
            // New heading change
            rules[i][j][1] = int(random(4));
            // new write state
            rules[i][j][2] = int(random(nStates));
        }
    }
}

// Get some interactivity going
void keyPressed(){
    if (key == 'c'){
        setRandomRule();
    }
    else if (key == 'f'){
        speed++;
    }
    else if (key == 's'){
        speed--;
        if (speed < 1){speed = 1;}
    }
    else if (key == 'r'){
        // reset canvas
        background(white);
        // reset world
        for (int x=0; x<width; x++){
            for (int y=0; y<height; y++){
                world[x][y]= 0;
            }
        }
    }
    else if (key == 'p'){
        if (isDrawing){
            noLoop();
            isDrawing = false;
        }
        else{
            loop();
            isDrawing = true;
        }
    }
}
