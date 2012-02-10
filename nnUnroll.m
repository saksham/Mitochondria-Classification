function [new_nn] = nnUnroll(nn, theta_vec)
%NNUNROLL Unrolls the given vector and returns an adjusted neural network
%   NNUNROLL(nn, theta_vec): Given a neural network and an an unrolled 
%   theta vector, this method first creates a copy of the given neural
%   network, and then it unrolls the given theta vector and sets
%   the theta matrices of the new neural network to correspond to the 
%   unrolled matrices.
%
%   See also NNROLL

new_nn = nn;
start_index = 1;
for i = 1:new_nn.theta_count
    count = numel(new_nn.theta{i});
    new_nn.theta{i} = reshape(theta_vec(start_index: ...
        start_index + count - 1), size(nn.theta{i}));
    start_index = start_index + count;
end

end

