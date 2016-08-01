This processing sketch is inspired by Reynolds’ boids algorithm to generate a swarm of of autonomous objects which generate a collective behaviour based off a few simple rules. Much guidance to the code was found in Daniel Shiffman’s implementation of the algorithm (https://processing.org/examples/flocking.html). For large numbers of boids the code can become computationally expensive. In order to render a sequence, it might be necessary to simply save an image of each frame of the sketch and process this into a movie. 

Most of the moving parts are found within boid.pde, which implements the boid object and the necessary functions/rules for its motion. 

Enjoy!