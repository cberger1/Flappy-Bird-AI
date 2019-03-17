
class NN {
  //a simple Neural Network with out hidden layers nor training (yet)
  float[] input, output, bias;
  float[][] weights;

  NN(int inputs, int outputs) {
    input = new float[inputs];
    output = new float[outputs];
    bias = new float[outputs];
    weights = new float[inputs][outputs];
  }

  float[] predict() {
    for (int o = 0; o < output.length; o++) {
      output[o] = 0;
      for (int i = 0; i < input.length; i++) {
        output[o] += input[i] * weights[i][o];
      }
      output[o] += bias[o];
      if (output[o] > 1) {
        output[o] = 1;
      } else if (output[o] < 0) {
        output[o] = 0;
      }
    }
    return output;
  }

  void mutate(float probability, float var) {
    for (int i = 0; i < weights.length; i++) {
      for (int o = 0; o < weights[i].length; o++) {
        if (probability < random(1)) {
          weights[i][o] += random(-var, var);
        }
      }
    }
    for (int i = 0; i < bias.length; i++) {
      if (probability < random(1)) {
        bias[i] += random(-var, var);
      }
    }
  }

  void randomize() {
    for (int i = 0; i < weights.length; i++) {
      for (int o = 0; o < weights[i].length; o++) {
        weights[i][o] = randomGaussian();
        //weights[i][o] = random(1);
        print(weights[i][o], " ");
      }
      println();
    }
    for (int i = 0; i < bias.length; i++) {
      bias[i] = randomGaussian();
    }
  }
}
