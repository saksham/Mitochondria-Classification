function [ error ] = fuzzyCShells( X )
% FUZZYCSHELLS: Finds a circle that produces the smallest error on
% distances between the data set X and the circle. The error is returned at
% the end.
% [ error ] = fuzzyCShells( X )
%   X: data set

sizeOfX = size(X);
n = sizeOfX(2);

% calculate center and radius
P = ones(2,2);
P(:,1) = [0 0];
P(:,2) = [0 0];
sum_x = 0;
sum_all = 0;
for k = 1:n
    sum_x = sum_x + X(:,k);
    sum_all = sum_all + 1;
end
P(:,1) = sum_x / sum_all;
[x y] = size(P(:,:));
for j = 2:x
    sum_x = 0;
    for k = 1:n
        sum_x = sum_x + norm(X(:,k)-P(:,1));
    end
    P(1,j) = sum_x / sum_all;
end

% calculate distances from each data point
distanceSum = zeros(1,n);
for k = 1:n
    distance = distanceCircle(X(:,k),P(:,:));
    distanceSum(k) = distance;
end
error = sum(distanceSum);

% plot
% figure;
% hold on;
% for i = 1:n
%     if U(1,i) > 0.5
%         scatter(X(1,i),X(2,i),'X');
%     else
%         scatter(X(1,i),X(2,i),'O');
%     end
% end
% for i = 1:c
%     [x1,y1,z1] = cylinder(P(1,j,i),200);
%     x1 = x1 + P(1,1,i);
%     y1 = y1 + P(2,1,i);
%     plot(x1(1,:),y1(1,:))
% end

end
