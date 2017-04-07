import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

//-----**NEXT() IS THE MAIN ALGORITH**--------

PeasyCam cam;

//Lists containing all the faces, next and current
ArrayList <face> faces = new ArrayList <face>();
ArrayList <face> nextFaces = new ArrayList <face>();

//Images for the textures
PImage water;
PImage grass;
PImage rock;
PImage snow;
PImage sand;

//Random stuff for a cool sheep
PShape sheep;
PShape boat;
PVector sheepLocation= new PVector(0, 0);
PVector newLocation;
int sheepHeight=0;
boolean move=false;

//Ints for current level and ratation
int level=0;
float rotate=0;

void setup() {
  size(1200, 700, P3D); 
  frameRate(60);
  noStroke();

  //Loads in textures
  textureMode(IMAGE);  
  water = loadImage("water.jpg");
  grass = loadImage("grass.jpg");
  rock = loadImage("rock.jpg");
  snow = loadImage("snow.png");
  sand = loadImage("sand.jpg");

  //Loads in optional 3d objects
  sheep=loadShape("sheep.obj");
  boat=loadShape("boat.obj");

  //Creates camrea
  cam = new PeasyCam(this, 100); 
  cam.setDistance(400);
  cam.lookAt(0, 0, 90);
  cam.rotateZ(radians(180));
  cam.rotateX(-radians(70));

  //Sets the first face 
  faces.add(new face(new PVector(-200, 200, 0), new PVector(200, 200, 0), new PVector(200, -200, 0), new PVector(-200, -200, 0)));
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

//-----------***THIS IS THE MAIN ALGORITHM***-------------------
void next() {  
  level++;

  //Reset the list for new faces
  nextFaces = new ArrayList <face>();
  //Run through all curent level faces
  for (face x : faces) {
    PVector center=new PVector(0, 0, 0);

    //Selects a new center points. I made higher levels have lower variability to make it smoother as you do more
    if (level<=3)
      center = new PVector(((x.getOne().x+x.getTwo().x+x.getThree().x+x.getFour().x)/4)+((int)random(60/level*-1, 60/level)), ((x.getOne().y+x.getTwo().y+x.getThree().y+x.getFour().y)/4)+((int)random(60/level*-1, 60/level)), ((x.getOne().z+x.getTwo().z+x.getThree().z+x.getFour().z)/4)+((int)random(150/pow(level, 1.7)*-1, 250/pow(level, 1.7))));
    else if (level<=4)
      center = new PVector(((x.getOne().x+x.getTwo().x+x.getThree().x+x.getFour().x)/4)+((int)random(30/level*-1, 30/level)), ((x.getOne().y+x.getTwo().y+x.getThree().y+x.getFour().y)/4)+((int)random(30/level*-1, 30/level)), (x.getOne().z+x.getTwo().z+x.getThree().z+x.getFour().z)/4+((int)random(30/level*-1, 30/level)));
    else if (level<=5)
      center = new PVector(((x.getOne().x+x.getTwo().x+x.getThree().x+x.getFour().x)/4)+((int)random(20/level*-1, 20/level)), ((x.getOne().y+x.getTwo().y+x.getThree().y+x.getFour().y)/4)+((int)random(20/level*-1, 20/level)), (x.getOne().z+x.getTwo().z+x.getThree().z+x.getFour().z)/4+((int)random(20/level*-1, 20/level)));
    else
      center = new PVector(((x.getOne().x+x.getTwo().x+x.getThree().x+x.getFour().x)/4), ((x.getOne().y+x.getTwo().y+x.getThree().y+x.getFour().y)/4), (x.getOne().z+x.getTwo().z+x.getThree().z+x.getFour().z)/4);

    //Find new points to for dividing up face
    PVector left = new PVector((x.getOne().x+x.getFour().x)/2, (x.getOne().y+x.getFour().y)/2, (x.getOne().z+x.getFour().z)/2);
    PVector top = new PVector((x.getOne().x+x.getTwo().x)/2, (x.getOne().y+x.getTwo().y)/2, (x.getOne().z+x.getTwo().z)/2);
    PVector right = new PVector((x.getTwo().x+x.getThree().x)/2, (x.getTwo().y+x.getThree().y)/2, (x.getTwo().z+x.getThree().z)/2);
    PVector bottom = new PVector((x.getThree().x+x.getFour().x)/2, (x.getThree().y+x.getFour().y)/2, (x.getThree().z+x.getFour().z)/2);

    //Create the new faces from current level using center and points above
    nextFaces.add(new face(x.getOne(), top, center, left));
    nextFaces.add(new face(top, x.getTwo(), right, center));
    nextFaces.add(new face(center, right, x.getThree(), bottom));
    nextFaces.add(new face(center, bottom, x.getFour(), left));
  }

  //Make new faces the current faces
  faces = new ArrayList <face>();
  faces=nextFaces;
}

//Resets Faces---------------------------------------------------------------------------------
void reset() {
  faces = new ArrayList <face>();  
  faces.add(new face(new PVector(-200, 200, 0), new PVector(200, 200, 0), new PVector(200, -200, 0), new PVector(-200, -200, 0)));  

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

  for (int z=0; z<1; z++) {
    for (int y=0; y<1; y++) {
      pushMatrix();
      rotateZ(radians(rotate));
      translate(z*375, y*375);

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
        vertex(x.getThree().x, x.getThree().y, x.getThree().z, 25, 25);
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
        vertex(x.getOne().x, x.getOne().y, x.getOne().z, 50, 0);
        vertex(x.getThree().x, x.getThree().y, x.getThree().z, 25, 25);
        endShape();
      }  
      popMatrix();
    }
  }

  //Uncomment to get a cool sheep
  //sheepFunStuff();
}

//Face class----------------------------------------------------------------------------------------
class face {  
  PVector one;
  PVector two;
  PVector three;
  PVector four;
  PVector center;
  color fColor;  

  //Class is for one face, a face contains 4 points, one for each corner. Also is able to return face color and vector of the center.

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

//Cool stuff for a sheep, completely unnecessary
void sheepFunStuff() {

  float closestDist=1000;
  for (face x : faces) {
    if (dist(x.getCenter().x, x.getCenter().y, sheepLocation.x, sheepLocation.y)<closestDist) {
      closestDist=dist(x.getCenter().x, x.getCenter().y, sheepLocation.x, sheepLocation.y);
      sheepHeight=(int)x.getCenter().z;
    }
  }

  if (move) {
    if (sheepLocation.x<newLocation.x)
      sheepLocation.x++;
    else if (sheepLocation.x>newLocation.x)
      sheepLocation.x--;
    if (sheepLocation.y<newLocation.y)
      sheepLocation.y++;
    else if (sheepLocation.y>newLocation.y)
      sheepLocation.y--;  

    if (abs(sheepLocation.x-newLocation.x)<5&&abs(sheepLocation.y-newLocation.y)<5) {
      move=false;
    }
  } else {
    newLocation=new PVector((int)random(-200, 200), (int)random(-200, 200));
    move=true;
  }
  if (sheepHeight<=-10)
    sheepHeight=-20;

  translate(sheepLocation.x, sheepLocation.y, sheepHeight);
  rotateX(radians(90));
  if (newLocation.x>sheepLocation.x) {
    rotateY(radians(90));
    if (newLocation.y>sheepLocation.y)
     rotateY(radians(45));
    else if (newLocation.y<sheepLocation.y)
     rotateY(radians(-45));
  } else if (newLocation.x<sheepLocation.x) {
    rotateY(radians(-90));
    if (newLocation.y>sheepLocation.y)
     rotateY(radians(-45));
    else if (newLocation.y<sheepLocation.y)
     rotateY(radians(45));
  }
  else if (newLocation.y>sheepLocation.y)
      rotateY(radians(-180));
  else if (newLocation.y<sheepLocation.y)
      rotateY(radians(0));


  scale(8);
  shape(sheep);
  if (sheepHeight<=-10) {
    rotateY(radians(-90));
    scale(.05);
    shape(boat);
  }
}