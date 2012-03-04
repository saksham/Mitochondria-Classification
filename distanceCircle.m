function [ distance ] = distanceCircle( x_k, p_i )

sum = 0;
[x y] = size(p_i);
for j = 2:x
    one = (x_k-p_i(:,1))';
    two = (p_i(1,j));
    sum = sum + abs(norm(one)-two);
end
distance = sum;
end

