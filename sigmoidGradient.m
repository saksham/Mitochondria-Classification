function g = sigmoidGradient(z)
%SIGMOIDGRADIENT returns the gradient of the sigmoid function
%evaluated at z
%   g = SIGMOIDGRADIENT(z) computes the gradient of the sigmoid function
%   evaluated at z. This works regardless if z is a matrix or a vector.
%   In particular, if z is a vector or matrix, it returns the gradient
%   for each element.

temp = sigmoid(z);
ones_matrix = ones(size(z));
g = temp .* (ones_matrix - temp);
end
