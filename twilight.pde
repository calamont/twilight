boidFlock birds;
int window;

void setup() {
  size(750,750);
  window = width;
  PVector centre = new PVector(width/2, height/2);
  birds = new boidFlock(5000);
}

void draw() {
  background(0);
  birds.run();
  saveFrame();
}
  