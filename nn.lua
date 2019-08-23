require 'matrix'
require 'class'

function sigmoid(x)
  return 1 / ( 1 + math.exp(-x) )
end

function sigmoid_dx(x)
  return x * (1 - x)
end

local function nn_base(nn, input_size, hidden_size, output_size, lr)
  nn.input_size = input_size
  nn.hidden_size = hidden_size
  nn.output_size = output_size

  nn.bias_input_hidden = Matrix(nn.hidden_size, 1)
  nn.bias_hidden_output = Matrix(nn.output_size, 1)

  nn.weights_input_hidden = Matrix(nn.hidden_size, nn.input_size)
  nn.weights_hidden_output = Matrix(nn.output_size, nn.hidden_size)

  if lr then
    nn.lr = lr
  else
    nn.lr = 0.1
  end

end

NN = Class(nn_base)

--------------------------------------------------------------------------------
function NN:train(x, y)
  
  -- INPUT => HIDDEN 
  input = arrayToMatrix(x)
  hidden = multiply(self.weights_input_hidden, input)
  hidden = add(hidden, self.bias_input_hidden)
  
  hidden = apply(hidden, sigmoid)
  
  -- HIDDEN => OUTPUT
  output = multiply(self.weights_hidden_output, hidden)
  output = add(output, self.bias_hidden_output)
  
  output = apply(output, sigmoid)

  -- BACKPROPAGATION

  -- OUTPUT => HIDDEN
  expected = arrayToMatrix(y)
  output_error = subtract(expected, output)
  d_output = apply(output, sigmoid_dx)
  hidden_T = transpose(hidden)

  gradient = hadamard(d_output, output_error)
  gradient = escalarMultiply(gradient, self.lr)
  

  -- ADJUSTING BIAS: OUTPUT => HIDDEN
  self.bias_hidden_output = add(self.bias_hidden_output, gradient)
  -- ADJUSTING WEIGHTS: OUTPUT => HIDDEN
  weights_hidden_output_deltas = multiply(gradient, hidden_T)
  self.weights_hidden_output = add(self.weights_hidden_output,
                                    weights_hidden_output_deltas)

  -- HIDDEN => INPUT
  weights_hidden_output_T = transpose(self.weights_hidden_output)
  hidden_error = multiply(weights_hidden_output_T, output_error)
  d_hidden = apply(hidden, sigmoid_dx)
  input_T = transpose(input)

  gradient = hadamard(d_hidden, hidden_error)
  gradient = escalarMultiply(gradient, self.lr)

  -- ADJUSTING BIAS: HIDDEN => INPUT
  self.bias_input_hidden = add(self.bias_input_hidden, gradient)
  -- ADJUSTING WEIGHTS: HIDDEN => INPUT
  weights_input_hidden_deltas = multiply(gradient, input_T)
  self.weights_input_hidden = add(self.weights_input_hidden,
                                  weights_input_hidden_deltas)

end

function NN:predict(x)
  -- INPUT => HIDDEN
  input = arrayToMatrix(x)
  hidden = multiply(self.weights_input_hidden, input)
  hidden = add(hidden, self.bias_input_hidden)
  hidden = apply(hidden, sigmoid)

  -- HIDDEN => OUTPUT
  output = multiply(self.weights_hidden_output, hidden)
  output = add(output, self.bias_hidden_output)
  output = apply(output, sigmoid)

  output = matrixToArray(output)
  return output
end