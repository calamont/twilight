class boidFlock {
  boid[] boids;
  
  boidFlock(int size) {
    boids = new boid[size];
    
    for (int i=0; i<size; i++) {
      //initialise random position on the screen 
      PVector pos = new PVector(height/2,width/2);
      boids[i] = new boid(pos);
    }
  }
  
  void run() {
    
    for (boid b : boids) {
      b.run(boids);
    }

  }
}