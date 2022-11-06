import geomerative.*;

PrintWriter OUTPUT;

RShape grp;
RPoint[][] pointPaths;

String fileName = "../input/image.svg"; // Name of the file you want to convert, as to be in the same directory
String outputFile = "output/gcode.nc";
String penUp= "M05"; // Command to control the pen, it change beetween differents firmware
String penDown = "M03 S20";// This settings was made for my custom CNC Drawing machine
float[] xcoord = { 0,100};// These variables define the minimum and maximum position of each axis for your output GCode 
float[] ycoord = { 0,100};// These settings also change between your configuration
int floatingPoints = 2;
float segmentationAccuracy = 1;

float xmag, ymag, newYmag, newXmag = 0;
float z = 0;

boolean ignoringStyles = false;

void setup(){
  size(600, 600, P3D);
  // VERY IMPORTANT: Allways initialize the library before using it
  
  println("loading SVG");
  RG.init(this);
  RG.ignoreStyles(ignoringStyles);
  
  RG.setPolygonizer(RG.UNIFORMSTEP);
  RG.setPolygonizerStep(segmentationAccuracy);
  
  
  grp = RG.loadShape(fileName);
  grp.centerIn(g, 100, 1, 1);
  
  pointPaths = grp.getPointsInPaths();
  
  println("Shape loaded");
  
  translate(width/2, height/2);
  
  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;
  
  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { xmag -= diff/4.0; }
  
  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { ymag -= diff/4.0; }
  
  rotateX(-ymag); 
  rotateY(-xmag); 
  
  background(255);
  stroke(0);
  noFill();
  
  OUTPUT = createWriter(sketchPath("") + outputFile);
  
  for(int i = 0; i<pointPaths.length; i++){
    if (pointPaths[i] != null) {
      beginShape();
      for(int j = 0; j<pointPaths[i].length; j++){
        vertex(pointPaths[i][j].x, pointPaths[i][j].y);
        float xmaped = map(pointPaths[i][j].x,-200, 200, xcoord[1], xcoord[0]);
        float ymaped = map(pointPaths[i][j].y,-200, 200, ycoord[0] , ycoord[1]);
        if(j == 1){
          OUTPUT.println(penDown);
        }
        String gcodeLine = "G1X"+ nf(xmaped,0,floatingPoints)+"Y"+nf(ymaped,0,floatingPoints);
        gcodeLine = gcodeLine.replace(',', '.');
        OUTPUT.println(gcodeLine); 
      }
      endShape();
    }
   OUTPUT.println(penUp);
  }
  OUTPUT.flush();
  OUTPUT.close();
  
  save("output/preview.png");
  
  println("finished");
  noLoop();
}

void draw(){  
  exit();
}

void mousePressed(){
  ignoringStyles = !ignoringStyles;
  RG.ignoreStyles(ignoringStyles);
}
