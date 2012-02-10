function [new_nn] = nnRoll(nn, theta_vec)
%NNROLL Rolls up the given vector and returns an adjusted neural network
%   NNROLL(nn, theta_vec): Given a neural network and an an unrolled 
%   theta vector, this method first creates a copy of the given neural
%   network, and then it rolls up the given theta vector and sets
%   the theta matrices of the new neural network to correspond to the 
%   rolled-up vectors.
%
%   See also NNUNROLL

new_nn = nn;
start_index = 1;
for i = 1:new_nn.theta_count
    count = numel(new_nn.theta{i});
    new_nn.theta{i} = reshape(theta_vec(start_index: ...
        start_index + count - 1), size(nn.theta{i}));
    start_index = start_index + count;
end

end

