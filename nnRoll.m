function [ theta_vec ] = nnRoll( nn )
%NNROLL Rolls the theta matrices into a 1-dimensional vector
%   NNROLL(nn) Given a neural network, it rolls all the theta matrices into
%   a single 1 dimensional vector
%
% See also NNUNROLL

theta_vec = zeros(nn.theta_total_numel, 1);
start_index = 1;
for i = 1:nn.theta_count
    count = numel(nn.theta{i});
    theta_vec(start_index:start_index + count - 1) = nn.theta{i}(:);
    start_index = start_index + count;
end

end

