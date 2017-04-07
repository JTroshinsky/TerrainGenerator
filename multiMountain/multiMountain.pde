import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;

ArrayList <face> faces = new ArrayList <face>();
ArrayList <face> nextFaces = new ArrayList <face>();

ArrayList[][]mFaces = new ArrayList[3][3];

int level=0;
float rotate=0;

PImage water;
PImage grass;
PImage rock;
PImage snow;
PImage sand;

void setup() {
  size(1200, 700, P3D); 
  frameRate(60);
  noStroke();

  textureMode(IMAGE);  
  water = loadImage("water.jpg");
  grass = loadImage("grass.jpg");
  rock = loadImage("rock.jpg");
  snow = loadImage("snow.png");
  sand = loadImage("sand.jpg");

  cam = new PeasyCam(this, 100); 
  cam.setDistance(650);
  cam.lookAt(0, 0, 90);
  cam.rotateZ(radians(180));
  cam.rotateX(-radians(56));

  for (int x=0; x<3; x++) {
    for (int y=0; y<3; y++) {
      mFaces[x][y]=new ArrayList();
      faces = new ArrayList <face>();
      faces.add(new face(new PVector(-200, 200, 0), new PVector(200, 200, 0), new PVector(200, -200, 0), new PVector(-200, -200, 0)));
      mFaces[x][y]=faces;
    }
  }
}

void draw() {
  background(#1278C4);
  lights();  

  drawStuff();
}

void keyPressed()
{
  if (key=='n'&&level<8) next();
  if (key=='r') reset();
}

//Creates new faces------------------------------------------------------------------------
void next() {  

  level++;

  for (int z=0; z<3; z++) {
    for (int y=0; y<3; y++) {
      faces=mFaces[z][y];
      nextFaces = new ArrayList <face>();
      for (face x : faces) {
        PVector center=new PVector(0, 0, 0);

        if (level<=3)
          center = new PVector(((x.getOne().x+x.getTwo().x+x.getThree().x+x.getFour().x)/4)+((int)random(60/level*-1, 60/level)), ((x.getOne().y+x.getTwo().y+x.getThree().y+x.getFour().y)/4)+((int)random(60/level*-1, 60/level)), ((x.getOne().z+x.getTwo().z+x.getThree().z+x.getFour().z)/4)+((int)random(150/pow(level, 1.7)*-1, 250/pow(level, 1.7))));
        else if (level<=4)
          center = new PVector(((x.getOne().x+x.getTwo().x+x.getThree().x+x.getFour().x)/4)+((int)random(30/level*-1, 30/level)), ((x.getOne().y+x.getTwo().y+x.getThree().y+x.getFour().y)/4)+((int)random(30/level*-1, 30/level)), (x.getOne().z+x.getTwo().z+x.getThree().z+x.getFour().z)/4+((int)random(30/level*-1, 30/level)));
        else if (level<=6)
          center = new PVector(((x.getOne().x+x.getTwo().x+x.getThree().x+x.getFour().x)/4)+((int)random(20/level*-1, 20/level)), ((x.getOne().y+x.getTwo().y+x.getThree().y+x.getFour().y)/4)+((int)random(20/level*-1, 20/level)), (x.getOne().z+x.getTwo().z+x.getThree().z+x.getFour().z)/4+((int)random(20/level*-1, 20/level)));
        else
          center = new PVector(((x.getOne().x+x.getTwo().x+x.getThree().x+x.getFour().x)/4), ((x.getOne().y+x.getTwo().y+x.getThree().y+x.getFour().y)/4), (x.getOne().z+x.getTwo().z+x.getThree().z+x.getFour().z)/4);

        PVector left = new PVector((x.getOne().x+x.getFour().x)/2, (x.getOne().y+x.getFour().y)/2, (x.getOne().z+x.getFour().z)/2);
        PVector top = new PVector((x.getOne().x+x.getTwo().x)/2, (x.getOne().y+x.getTwo().y)/2, (x.getOne().z+x.getTwo().z)/2);
        PVector right = new PVector((x.getTwo().x+x.getThree().x)/2, (x.getTwo().y+x.getThree().y)/2, (x.getTwo().z+x.getThree().z)/2);
        PVector bottom = new PVector((x.getThree().x+x.getFour().x)/2, (x.getThree().y+x.getFour().y)/2, (x.getThree().z+x.getFour().z)/2);

        nextFaces.add(new face(x.getOne(), top, center, left));
        nextFaces.add(new face(top, x.getTwo(), right, center));
        nextFaces.add(new face(center, right, x.getThree(), bottom));
        nextFaces.add(new face(center, bottom, x.getFour(), left));
      }
      faces = new ArrayList <face>();
      faces=nextFaces;
      mFaces[z][y]=faces;
    }
  }
}

//Resets Faces---------------------------------------------------------------------------------
void reset() {
  for (int x=0; x<3; x++) {
    for (int y=0; y<3; y++) {
      mFaces[x][y]=new ArrayList();
      mFaces[x][y].add(new face(new PVector(-200, 200, 0), new PVector(200, 200, 0), new PVector(200, -200, 0), new PVector(-200, -200, 0)));
    }
  }

  level=0;
}

//Draws the stff--------------------------------------------------------------------------------
void drawStuff() {

  cam.beginHUD();
  textSize(20);  
  text("R to start new landscape", 20, 20);
  text("N to create next level", 20, 40);
  text("Current level : "+level, 20, 60);
  cam.endHUD();

  rotate+=.25;
  rotateZ(radians(rotate));

  for (int z=0; z<3; z++) {
    for (int y=0; y<3; y++) {
      faces =mFaces[z][y];

      pushMatrix();
      rotateZ(radians(rotate));
      translate(z*375-375, y*375-375);

      for (face x : faces) {     
        fill(x.getColor());       

        beginShape();

        if (x.getColor()==color(255))
          texture(snow);
        else if (x.getColor()==color(82, 57, 2))
          texture(rock);
        else if (x.getColor()==color(2, 82, 20))
          texture(grass);
        else if (x.getColor()==color(232, 195, 47))
          texture(sand);
        else 
        texture(water);  

        vertex(x.getOne().x, x.getOne().y, x.getOne().z, 0, 0);
        vertex(x.getTwo().x, x.getTwo().y, x.getTwo().z, 50, 0);     
        vertex(x.getFour().x, x.getFour().y, x.getFour().z, 25, 25);
        endShape(); 

        beginShape();

        if (x.getColor()==color(255))
          texture(snow);
        else if (x.getColor()==color(82, 57, 2))
          texture(rock);
        else if (x.getColor()==color(2, 82, 20))
          texture(grass);
        else if (x.getColor()==color(232, 195, 47))
          texture(sand);  
        else 
        texture(water); 

        vertex(x.getFour().x, x.getFour().y, x.getFour().z, 0, 0);
        vertex(x.getTwo().x, x.getTwo().y, x.getTwo().z, 50, 0);
        vertex(x.getThree().x, x.getThree().y, x.getThree().z, 25, 25);
        endShape();
      }  
      popMatrix();
    }
  }
}

//Face class----------------------------------------------------------------------------------------
class face {  
  PVector one;
  PVector two;
  PVector three;
  PVector four;
  PVector center;
  color fColor;  

  public face(PVector on, PVector tw, PVector th, PVector fo) {
    one=on;
    two=tw;
    three=th;
    four=fo;  
    center= new PVector(((one.x+two.x)/2), ((one.y+four.y)/2), ((one.z+two.z+three.z+four.z)/4));

    setColor();
  }

  private void setColor() {
    if (center.z>110)
      fColor=color(255);
    else if (center.z>60)
      fColor=color(82, 57, 2);
    else if (center.z>-10)
      fColor=color(2, 82, 20);
    else if (center.z>-20)
      fColor=color(232, 195, 47);
    else
      fColor=color(45, 17, 237);
  }

  public PVector getOne() {
    return one;
  }  
  public PVector getTwo() {
    return two;
  }  
  public PVector getThree() {
    return three;
  }  
  public PVector getFour() {
    return four;
  }  
  public PVector getCenter() {
    return center;
  }  
  public color getColor() {
    return fColor;
  }
}