import controlP5.*;

int [][] world;
color black = color(0);
color white = color(255);
color red = color(255,0,0);
color green = color(0,255,0);
color blue = color(0,0,255);
color yellow = color(255, 255, 0);
color lightBlue = color(0, 255, 255);
color purple = color(255,0,255);
int onX, onY;
int heading; // N=0, E=1, S=2, W=3
int speed = 100;
int maxSpeed = 5000;
int nColors = 3;
int nStates = 3;
int maxColors = 8;
int maxStates = 6;
int state;
int [][][] rules;
color [] colors;
boolean isDrawing = true;
StringList coolRules;
int drawX = 400;
int drawY = 400;
int offsetX;
int offsetY;
ControlP5 cp5;
Textlabel nColorsText;
Textlabel nStatesText;
Slider speedslider;

void setup(){
    frameRate(10000);
    size(drawX + 300, drawY + 100);
    background(blue);

    // Trying CP5
    cp5 = new ControlP5(this);
    
    // Possibly speed up rendering by changing font
    //cp5.setFont(createFont("",10));
    int startButtonX = 500;
    int startButtonY = 50;
    int buttonWidth = 120;
    int buttonHeight = 19;
    int buttonPadding = 5;
    
    int row = 0;
    
    cp5.addButton("cp5RandomRule")
        .setPosition(startButtonX,startButtonY+ row* ( buttonHeight + buttonPadding))
        .setSize(buttonWidth,buttonHeight)
        .setCaptionLabel("Get new random rule (c)")
        ;
    row++;

    cp5.addButton("cp5ResetWorld")
        .setPosition(startButtonX,startButtonY+ row* ( buttonHeight + buttonPadding))
        .setSize(buttonWidth, buttonHeight)
        .setCaptionLabel("Reset the World (r)")
        ;
    row++;

    cp5.addButton("cp5CoolRule")
        .setPosition(startButtonX,startButtonY+ row* ( buttonHeight + buttonPadding))
        .setSize(buttonWidth, buttonHeight)
        .setCaptionLabel("Load a saved rule (l)")
        ;
    row++;

    cp5.addButton("cp5SaveRule")
        .setPosition(startButtonX,startButtonY+ row* ( buttonHeight + buttonPadding))
        .setSize(buttonWidth, buttonHeight)
        .setCaptionLabel("Save current rule")
        ;
    row++;

    speedslider = cp5.addSlider("speed")
        .setPosition(startButtonX,startButtonY+ row* ( buttonHeight + buttonPadding))
        .setSize(buttonWidth, buttonHeight)
        .setRange(1, maxSpeed)
        .setValue(speed)
        .setCaptionLabel("Speed")
        ;
    row++;
    
    cp5.addButton("lessSpeed")
        .setPosition(startButtonX,startButtonY + row*(buttonHeight + buttonPadding))
        .setSize(buttonWidth/2 - buttonPadding, buttonHeight)
        .setCaptionLabel("-Speed")
        ;      
    
    cp5.addButton("moreSpeed")
        .setPosition(startButtonX + buttonWidth/2 ,startButtonY + row*(buttonHeight + buttonPadding))
        .setSize(buttonWidth/2, buttonHeight)
        .setCaptionLabel("+Speed")
        ;  
    row++;
 
    cp5.addButton("lessColor")
        .setPosition(startButtonX,startButtonY + row*(buttonHeight + buttonPadding))
        .setSize(buttonWidth/2 - buttonPadding, buttonHeight)
        .setCaptionLabel("-Color")
        ;      
    
    cp5.addButton("moreColor")
        .setPosition(startButtonX + buttonWidth/2 ,startButtonY + row*(buttonHeight + buttonPadding))
        .setSize(buttonWidth/2, buttonHeight)
        .setCaptionLabel("+Color")
        ;  

    nColorsText = cp5.addTextlabel("nColorsText")
        .setText(""+nColors)
        .setPosition(startButtonX + buttonWidth + 5 ,startButtonY + row*(buttonHeight + buttonPadding) + 5)
        ;
    row++;

    cp5.addButton("lessState")
        .setPosition(startButtonX,startButtonY + row*(buttonHeight + buttonPadding))
        .setSize(buttonWidth/2 - buttonPadding, buttonHeight)
        .setCaptionLabel("-State")
        ;      
    
    cp5.addButton("moreState")
        .setPosition(startButtonX + buttonWidth/2 ,startButtonY + row*(buttonHeight + buttonPadding))
        .setSize(buttonWidth/2, buttonHeight)
        .setCaptionLabel("+State")
        ;  

    nStatesText = cp5.addTextlabel("nStatesText")
        .setText(""+nStates)
        .setPosition(startButtonX + buttonWidth + 5 ,startButtonY + row*(buttonHeight + buttonPadding) + 5)
        ;
    row++;


    // cp5.addTextlabel("title")
    //     .setText("Turing drawings/turmites")
    //     .setPosition(50,25)
    //     .setFont(createFont("FreeMono Bold",30))
    //     .setColorValue(white);
    //     ;


    // cp5.addTextlabel("subtitle")
    //     .setText("by Kasper P. Lauritzen")
    //     .setPosition(50,55)
    //     .setFont(createFont("Monospaced",20))
    //     .setColorValue(white);
    //     ;

    //     String[] fontList = PFont.list();
    //     println(fontList);
        
        
    world = new int[drawX][drawY];

    colors = new color[maxColors];
    colors[0] = white;
    colors[1] = black;
    colors[2] = red;
    colors[3] = green;
    colors[4] = blue;
    colors[5] = yellow;
    colors[6] = lightBlue;
    colors[7] = purple;
    rules = new int[nColors][nStates][3];
    
    loadCoolRules();
    getCoolRule();
    // Loop through world
    // There might be a world = zeros() function instead
    for (int x=0; x<drawX; x++){
        for (int y=0; y<drawY; y++){
            world[x][y]= 0;
        }
    }


    offsetX = (width - drawX)/2 - 100;
    offsetY = (height - drawY)/2;
    resetWorld();        
    // draw border
    rect(offsetX,offsetY, drawX,drawY);
}

void draw(){
    loadPixels();
    for(int i = 0; i < speed; i++){
        int onColor = world[onX][onY];
        int writeColor = rules[onColor][state][0];
        int changeHeading = rules[onColor][state][1];
        state = rules[onColor][state][2];
        world[onX][onY] = writeColor;
        pixels[(onY + offsetY) * width + (onX + offsetX)] = colors[writeColor];
        //set(onX + offsetX, onY + offsetY,colors[writeColor]);
        heading = (heading + changeHeading) % 4; 
        // Follow heading, update onX, onY
        getNewCoor(onX, onY);
    }
    updatePixels();
}



void getNewCoor(int X, int Y){
    if (heading == 0){ // North
        onY = (Y - 1 + drawY) % drawY;
    }
    else if (heading == 1){ // East
        onX = (X + 1 + drawX) % drawX;
    }
    else if (heading == 2){ // South
        onY = (Y + 1 + drawY)% drawY;
    }
    else if (heading == 3){ // West
        onX = (X - 1 + drawX)% drawX;
    }
    // Adding size to avoid having negative numbers
}

void setRandomRule(){
    rules = new int[nColors][nStates][3];
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
        resetWorld();
    }
    else if (key == 'r'){
        resetWorld();
    }
    // Pause
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
    else if (key == 'l'){
        resetWorld();
        getCoolRule();
    }
}

String rules2str(){
    String str = nColors+","+nStates+",";
    // Loop current color
    for(int i = 0; i < nColors; i++){
        // Loop current state
        for (int j = 0; j < nStates; j++){
            // loop rules
            for (int k = 0; k<3; k++){
                str+=rules[i][j][k]+",";
            }
        }
    }
    // Remove the last comma
    str = str.substring(0,str.length()-1);
    //println(str);
    return str;
}

void str2rules(String str){
    // Stop looping to avoid weird stuff with changing sizes of arrays
    noLoop();
    int[] list = int(split(str,","));
    nColors = list[0];
    nStates = list[1];
    // Re-initialize rules
    rules = new int[nColors][nStates][3];
    // Loop current color
    for(int i = 0; i < nColors; i++){
        // Loop current state
        for (int j = 0; j < nStates; j++){
            // loop rules
            for (int k = 0; k<3; k++){
                rules[i][j][k] = int(list[2 + i* nStates * 3 + j*3 + k]);
            }
        }
    }
    // Start runnging draw() again
    loop();
}

void loadCoolRules(){
    String[] listCoolRules = loadStrings("coolRules.txt");
    coolRules = new StringList();
    for (int i =0; i<listCoolRules.length; i++){
        coolRules.append(listCoolRules[i]);
    }
}

void saveRules(){
    int nRules = coolRules.size();
    String[] listCoolRules = new String[nRules];
    for (int i=0; i<nRules; i++){
        listCoolRules[i] = coolRules.get(i);
    }
    saveStrings("coolRules.txt",listCoolRules);
}

void resetWorld(){
    // reset canvas
    background(blue);
    // reset world
    for (int x=0; x<drawX; x++){
        for (int y=0; y<drawY; y++){
            world[x][y]= 0;
        }
    }
    onX = int(drawX/2);
    onY = int(drawY/2);
    world[onX][onY] = 1;
    heading = int(random(4));
    state = 1;
    
    // draw border
    rect(offsetX, offsetY, drawX, drawY);

    nColorsText.setText(""+nColors);
    nStatesText.setText(""+nStates);
}

void getCoolRule(){
    int nRules = coolRules.size();
    int randRule = int(random(nRules));
    str2rules(coolRules.get(randRule));
    resetWorld();
}

void cp5RandomRule(){
    setRandomRule();
}

void cp5ResetWorld(){
    resetWorld();
}

void cp5CoolRule(){
    getCoolRule();
}

void cp5SaveRule(){
    String str = rules2str();
    coolRules.append(str);
    saveRules();
}

void moreColor() {
    noLoop();
    if (nColors >= maxColors){
        nColors = maxColors;
        println("Max no. of colors: "+maxColors);
    }
    else {
        nColors++ ;
    }
    setRandomRule();
    resetWorld();
    loop();
}

void lessColor() {
    noLoop();
    if (nColors <= 2){
        nColors = 2;
        println("Min no. of colors: 2");
    }
    else {
        nColors-- ;
    }
    setRandomRule();
    resetWorld();
    loop();
}

void moreState() {
    noLoop();
    if (nStates >= maxStates){
        nStates = maxStates;
        println("Max no. of states: "+maxStates);
    }
    else {
        nStates++ ;
    }
    setRandomRule();
    resetWorld();
    loop();
}

void lessState() {
    noLoop();
    if (nStates <= 2){
        nStates = 2;
        println("Min no. of states: 2");
    }
    else {
        nStates-- ;
    }
    setRandomRule();
    resetWorld();
    loop();
}

void moreSpeed() {
    if (speed >= maxSpeed){
        speed = maxSpeed;
        println("Max speed: "+maxSpeed);
    }
    else {
        speed = int(speed * 1.05) + 2;
    }
    speedslider.setValue(speed);
}

void lessSpeed() {
    if (speed <= 2){
        speed = 2;
        println("Min. speed: 2");
    }
    else {
        speed = int(speed / 1.05);
    }
    speedslider.setValue(speed);
}


