function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
% -------------------------------------------------------------

%%% Implement Part A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A1 = [ones(1, m); X'];

Z2 = Theta1 * A1;

A2 = [ ones(1, m); sigmoid(Z2) ];

Z3 = Theta2 * A2;

A3 = sigmoid(Z3);

J1 = 0;



for i = 1:num_labels
  for j = 1:m
    if(i == y(j))
      J1 = J1 + log( A3(i, j) );
    else
      J1 = J1 + log(1 - A3(i, j));
    end
  end
end



J1 = -J1 / m;

J2 = sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2));

J2 = ( lambda * J2) / 2 / m;

J = J1 + J2;


%%%%%%%%%%%%%%%%% Implement Part B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = eye(num_labels);

D3 = A3;


for i = 1:m
  D3(:, i) = A3(:, i) - I(:, y(i));
end

DTT2 = (Theta2' * D3);

DT2 = DTT2(2:end, :);

t = sigmoidGradient(Z2);

D2 = DT2.*t;

Theta1_grad = D2 * A1' / m;

Theta2_grad = D3 * A2' / m;


r1 = [zeros(size(Theta1(:,1))), Theta1(:, 2:end)] * lambda / m;
r2 = [zeros(size(Theta2(:,1))), Theta2(:, 2:end)] * lambda / m;

Theta1_grad = Theta1_grad + r1;
Theta2_grad = Theta2_grad + r2;

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
