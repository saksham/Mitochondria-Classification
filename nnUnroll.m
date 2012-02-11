function [ theta_vec ] = nnUnroll( nn )
%NNUNROLL Unrolls the theta matrices into a 1-dimensional vector
%   theta_vec = NNUNROLL(nn) Given a neural network, it unrolls all the 
%   theta matrices into a single 1 dimensional vector
%
% See also NNROLL

theta_vec = zeros(nn.theta_total_numel, 1);
start_index = 1;
for i = 1:nn.theta_count
    count = numel(nn.theta{i});
    theta_vec(start_index:start_index + count - 1) = nn.theta{i}(:);
    start_index = start_index + count;
end

end

