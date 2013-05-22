int [][] world;
color black = color(0);
color white = color(255);
int onX, onY;
int heading; // N=0, E=1, S=2, W=3
int CW = 1; // Turn clockwise
int CCW = 3; // Turn counterclockwise

void setup(){
    frameRate(1000);
    println(-1 % 100);
    size(200, 200);
    background(white);
    world = new int[width][height];

    // Loop through world
    for (int x=0; x<width; x++){
        for (int y=0; y<height; y++){
            world[x][y]= 0;
        }
    }

    // Set ON cell
    onX = int(random(width));
    onY = int(random(height));
    world[onX][onY] = 1;
    heading = int(random(4));
}

void draw(){
    if (world[onX][onY] == 0){
        set(onX,onY, white);
        world[onX][onY] = 1;
        heading = (heading + CW) % 4;
    }
    else if (world[onX][onY] == 1){
        set(onX,onY, black);
        world[onX][onY] = 0;
        heading = (heading + CCW) % 4;
    }
    getNewCoor(onX, onY);
    // println(frameRate);
}



void getNewCoor(int X, int Y){
    if (heading == 0){ // North
        onY = (Y - 1 + height) % height;
    }
    if (heading == 1){ // East
        onX = (X + 1 + width) % width;
    }
    if (heading == 2){
        onY = (Y + 1 + height)% height;
    }
    if (heading == 3){
        onX = (X - 1 + width)% width;
    }
    // Adding size to avoid having negative numbers
}
