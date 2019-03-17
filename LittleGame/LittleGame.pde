
Pipe[] p;
Bird[] birds;
float[] scores;


void setup() {
  size(800, 800);
  frameRate(30);
  birds = new Bird[100];
  scores = new float[100];
  p = new Pipe[2];
  for (int i = 0; i < p.length; i++) {
    p[i] = new Pipe(width/p.length * (i+1));
  }
  for (int i = 0; i < birds.length;i ++) {
    birds[i] = new Bird();   
  }
}

void draw() {
  background(255);
  for (int i = 0; i < p.length; i++) {
    p[i].update();
    p[i].show();
  }
  for (int i = 0; i < birds.length; i++) {
    birds[i].update(p, true);
    scores[i] = birds[i].score;
    birds[i].show(); 
  }
  println(max(scores));
}

class Pipe {

  float x;
  private float space = 150;
  private float top = random(space, height - space);
  private float bottom = top + space;

  Pipe(float startX) {
    x = startX;
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(x, 0, x, top);
    line(x, height, x, bottom);
  }

  void update() {
    if (x > 0) {
      x -= 5;
    } else {
      x = width;
      top = random(space, height - space);
      bottom = top + space;
    }
  }
}

class Bird {

  float speed = 0;
  float y = 200;
  float score = 0;
  private float x = 100;
  private float g = 15;
  private float boost = -8;
  private float diameter = 20;
  NN brain = new NN(4, 1);

  Bird() {
    brain.randomize();
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    fill(255);
    ellipse(x, y, diameter, diameter);
  }

  void update(Pipe[] pipes, boolean AI) {
    score += 1;
    if (!AI) {
      if (keyPressed) {
        if (key == 'w') {
          speed = boost;
        }
      }
    } else {
      Pipe closest = pipes[0];
      float[] input = new float[4];
      float[] output;
      for (int i = 0;i < pipes.length;i++) {
        if (pipes[i].x < closest.x){
          closest = pipes[i];    
        }
      }
      input[0] = y/height;
      input[1] = closest.top/height;
      input[2] = closest.bottom/height;
      input[3] = (closest.x - x)/width;
      brain.input = input.clone();
      output = brain.predict();
      //for (int i = 0;i < 4;i++) {
      //  print(input[i]," ");  
      //}
      //println(output[0]);
      if (output[0] > 0.5) {
        speed = boost;  
      }
      
    }
    speed += g/frameRate;  
      y += speed;
      if (y > height || y < 0) {
        score = 0;
        //reset(pipes);
      }
    for (int i = 0; i < pipes.length; i++) {
      if (pipes[i].x == x) {
        if (!(y > pipes[i].top + diameter/2 && y < pipes[i].bottom - diameter/2)) {
          score = 0;
          //reset(pipes);
        }
      }
    }
  }
  
  void reset(Pipe[] pipes) {
    y = 200;
    speed = 0;
    for (int j = 0; j < pipes.length; j++) {
      pipes[j] = new Pipe(width/pipes.length * (j+1));
    }
    brain.randomize();
  }
}
