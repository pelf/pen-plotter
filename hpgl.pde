String[] lines;
int index = 0;
String instruction;
boolean penDown = true;
int x, y = 0;

int HALF_X = 500;
int HALF_Y = 500;

void setup() {
  // size(2 * HALF_X, 2 * HALF_Y);
  size(1000,1000);
  background(255);
  stroke(0);
  frameRate(1);
  ellipseMode(RADIUS);
  noFill();
  lines = loadStrings("plot.hpgl");
}

void draw() {
  if (index < lines.length) {
    instruction = lines[index];
    println(instruction);
    
    if (instruction.matches("PU.*")) {
      println("Pen Up");
      penDown = false;
      setPos(getCoordinatesFromInstruction());
    
    } else if (instruction.matches("PD.*")) {
      println("Pen Down");
      // TODO - support more than 1 pos;
      penDown = true;
      int origX = x;
      int origY = y;
      setPos(getCoordinatesFromInstruction());
      line(origX, origY, x, y);
      
    } else if (instruction.matches("PA.*")) {
      println("Plot Absolute");
      setPos(getCoordinatesFromInstruction());
    
    } else if (instruction.matches("CI.*")) {
      println("Circle");
      penDown = true;
      int radius = getIntFromInstruction();
      ellipse(x, y, radius, radius);
      
    } else if (instruction.matches("SP.*")) {  
      println("Select Pen");
      int colour = getIntFromInstruction();
      if (colour == 1) {
        stroke(0);
      } else {
        stroke(200,0,0);
      }
      
    } else {
      println("Unknown instruction");
    }
    
    println("");
    // Go to the next line for the next run through draw()
    index = index + 1;
  }
}

int[] getCoordinatesFromInstruction() {
  String[] m = match(instruction, "(\\d+),(\\d+)");
  int[] pos = { int(m[1]), int(m[2]) };
  return pos;
}

int getIntFromInstruction() {
  String[] m = match(instruction, "(\\d+)");
  int i = int(m[1]);
  return i;
}

// coord mapping
void setPos(int[] pos) {
   x = pos[0] + HALF_X;
   y = (pos[1] * -1) + HALF_Y;
   println("Set pos " + x + ", " + y);
}