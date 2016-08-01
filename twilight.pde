boidFlock sparkles;

void setup() {
  size(750,750);
  PVector centre = new PVector(width/2, height/2);
  sparkles = new boidFlock(50);
}

void draw() {
  background(0);
  sparkles.run();
  
  //if creating a movie from a sequence of images 
  //saveFrame();
}
  