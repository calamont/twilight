class boid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector centre;
  PVector centrespeed;
  
  float angle;
  float prox;
  float maxforce, maxspeed;
  float scaler;
  
  int opacity;
  int opacitychanger;
  int trigger;
  
  boid(PVector l) {
    location = l.copy();
    velocity = new PVector(random(0,0.2),random(0,4));
    acceleration = new PVector(0,0);
    centre = new PVector(0,0);
    centrespeed = new PVector(0,0);
    
    scaler = 750/width; //changes many of the variables in proportion to the size of the window used
    maxforce = 0.015*scaler;
    maxspeed = 3*scaler;
    prox = 100; //determines how close boids can come before being repulsed
    
    opacity = 255;
    opacitychanger = -5;
    trigger = 0;
  }
  
  void run(boid[] boids) {
    flock(boids);
    update();
    borders();
    display();
  }
  
  void update() {
    //randomly 
    if (trigger == 0 && random(0,1) > 0.9999) {
      trigger = 1;
    } else if (trigger > 1) {
      trigger -= 1;
    }
    
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display() {
    int colour = colourboid(centre,centrespeed);
    flash();
    stroke(colour,opacity);
    fill(colour);
    pushMatrix();
    translate(location.x,location.y);
    rectMode(CENTER);
    ellipse(0,0,1,1);
    popMatrix();
  }
  
  void borders() {
    //if you want have a square perimeter inwardly applying a force restricting the boids
    if (location.x < 150*scaler) applyForce(new PVector(3.5*maxforce,0));
    if (location.y < 150*scaler) applyForce(new PVector(0,3.5*maxforce));
    if (location.x > width-150*scaler) applyForce(new PVector(-3.5*maxforce,0));
    if (location.y > height-150*scaler) applyForce(new PVector(0,-3.5*maxforce));
    
    //if you want a circle boundry constraining the boids
    //PVector fromcentre = PVector.sub(new PVector(width/2,height/2),location);
    //if (fromcentre.mag() > 200) {
    //  fromcentre.normalize();
    //  fromcentre.mult(5*maxforce);
    //  applyForce(fromcentre);
    //}
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void flock(boid[] boids) {
    PVector sep = separate(boids);
    PVector uni = unite(boids);
    PVector mat = matchspeed(boids);
    
    //providing weights to the respective rules controlling boid flock motion
    sep.mult(1.2);
    uni.mult(0.8);
    mat.mult(1);
   
    applyForce(sep);
    applyForce(uni);
    applyForce(mat);
  }
 
  //determines the direction of motion which a given boid should move based on the boids around it
  PVector move(PVector direction) {
    PVector direct = new PVector(0,0);
    direct = direction.copy();
    direct.normalize();
    direct.mult(maxspeed);
    direct.sub(velocity);
    direct.limit(maxforce);
     
    return direct;
  }
  
  PVector unite(boid[] boids) {
    //calculates where the centre of the flock is and moves the boid towards it
    PVector u = new PVector(0,0);
    float count = 0;
    for (boid b : boids) {
      float dist = PVector.dist(location,b.location);
      if ((dist > 0) && (dist < prox)) {
        u.add(b.location);
        count++;
      }
    }
    if (count > 0) {
      u.div(count);
      centre.set(u);
      u.sub(location);
      u.set(move(u));
    } else {
      u.set(new PVector(0,0));
    }
    return u;
  }
 
  PVector separate(boid[] boids) {
    //keeps all the boids separated from each other
    PVector s = new PVector(0,0);
    float count = 0;
    for (boid b : boids) {
      float dist = PVector.dist(location,b.location);
      if (dist > 0 && dist < 100) {
        PVector difference = PVector.sub(location,b.location);
        difference.normalize();
        difference.div(dist);
        s.add(difference);
        count++;
        if (dist < 10 && b.trigger == 1 && trigger == 0) {
          trigger = 30;
        }
      }
    }
    
    if (count>0) {
      s.div(count);
    }
    
    if (s.mag() > 0) {
      s.set(move(s));
    } else { 
      s.set(new PVector(0,0));
    }    
    return s;
  }
 
  PVector matchspeed(boid[] boids) {
    //tries to match the speed of a given boid with the average speed of the flock
    PVector v = new PVector(0,0);
    float count = 0;
    for (boid b : boids) {
      float dist = PVector.dist(location,b.location);
      if ((dist > 0) && (dist < prox)) {
        v.add(b.velocity);
        count++;
      }
      if (count > 0) {
        v.div(count);
        centrespeed.set(v);
        v.set(move(v));
      } else {
        v.set(new PVector(0,0));
      }
    }
    return v;
  }
  
  //colours a boid on a scale from orange to blue based on its position with the flock
  int colourboid(PVector c, PVector s) {
    s.normalize();
    s.rotate(PI);
    PVector loc = location.copy();
    loc.sub(c);
    float centredist = ((loc.dot(s))+100)/200;
    pow(centredist,2);
    constrain(centredist,0,1);
    
    color from = color(255,128,0);
    color to = color(0,128,255);
    color col = lerpColor(from,to,centredist);
    return col;
  }
  
  //ellicits a sudden change in transparancy of a boid, which propagates to its neighbours throughout the flock
  void flash() {
    if (opacity > 0 && trigger == 1) {
      opacity += opacitychanger;
      if (opacity == 255) {
        trigger = 0;
        opacitychanger *= -1;
      }
    } else if (opacity <= 0) {
      opacitychanger *= -1;
      opacity += opacitychanger;
    }
  }
}