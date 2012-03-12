function [ distance ] = distanceCircle( x_k, p_i )
% DISTANCECIRCLE: Calculates the distance from point to a circle.
% [ distance ] = distanceCircle( x_k, p_i )
%   x_k: point for that the distance has to be computed
%   p_i: vector containing the center and the radius of the circle

sum = 0;
[x y] = size(p_i);
for j = 2:x
    one = (x_k-p_i(:,1))';
    two = (p_i(1,j));
    sum = sum + abs(norm(one)-two);
end
distance = sum;

end

