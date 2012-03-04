function [ error ] = fuzzyCShells( X )

%X = [6 7 7 8 ;...
%    5 4 6 5];
sizeOfX = size(X);
n = sizeOfX(2);
m = 2;

P = ones(2,2,1);
P(:,1,1) = [1 3];
P(:,2,1) = [1 0];
U = 0.5*ones(2,n);

c = 1;

oldDistances = zeros(c,n);

%figure;
%hold on;

%bestimme U
for i = 1:c
    for k = 1:n
        sum_x = 0;
        isZero = false;
        for j = 1:c
            one = distanceCircle(X(:,k),P(:,:,i));
            two = distanceCircle(X(:,k),P(:,:,j));
            if two <= 0.0001 && two >= -0.0001
                isZero = true;
                break;
            end
            sum_x = sum_x + (one / two)^(2/(m-1));
        end
        if isZero
            U(i,k) = 0;
        elseif sum_x <= 0.0001 && sum_x >= -0.0001
            U(i,k) = 1;
        else
            U(i,k) = 1/(sum_x);
        end
    end
end

%bestimme P
for i = 1:c
    sum_x = 0;
    sum_all = 0;
    for k = 1:n
        sum_x = sum_x + ( U(i,k)^m * X(:,k));
        sum_all = sum_all + U(i,k)^m;
    end
    P(:,1,i) = sum_x / sum_all;
    [x y] = size(P(:,:,i));
    for j = 2:x
        sum_x = 0;
        for k = 1:n
            sum_x = sum_x + (U(i,k)^m * norm(X(:,k)-P(:,1,i)));
        end
        P(1,j,i) = sum_x / sum_all;
    end
end

%checke auf Abbruchbedingung
for k = 1:n
    for i = 1:c
        distance = distanceCircle(X(:,k),P(:,:,i));
        oldDistances(i,k) = distance;
    end
end

% for i = 1:n
%     if U(1,i) > 0.5
%         scatter(X(1,i),X(2,i),'X');
%     else
%         scatter(X(1,i),X(2,i),'O');
%     end
% end
% 
% for i = 1:c
%     [x1,y1,z1] = cylinder(P(1,j,i),200);
%     x1 = x1 + P(1,1,i);
%     y1 = y1 + P(2,1,i);
%     plot(x1(1,:),y1(1,:))
% end

error = sum(oldDistances);

end
