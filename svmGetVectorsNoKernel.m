function [ SV , error ] = svmGetVectorsNoKernel( X , y , is_plot)
%SVMGETVECTORSNOKERNEL Summary of this function goes here
%   Detailed explanation goes here

sample_number = length(y);
sample_dimension = size(X);
H = zeros(sample_number,sample_number);
C = 1000;
% tolerance for Support Vector Detection
epsilon = C*1e-6;

for i=1:sample_number
    for j=1:sample_number
        H(i,j) = y(i)*y(j)*X(i,:)*X(j,:)';
    end
end

f = -1.*ones(sample_number,1);

% parameters for the optimization problem
vlb = zeros(sample_number,1);	% lower bound
vub = C*ones(sample_number,1);	% upper bound
A = y';                         % equality constraint
b = 0;                          % equal to 0

% quadratic optimization
warning off;
[alpha] = quadprog(H, f, [], [], A, b, vlb, vub);
for i = 1 : sample_number
    if alpha(i) < epsilon
        alpha(i) = 0;
        continue;
    end
end

if is_plot
    % compute w
    w = zeros(sample_dimension(2),1);
    support_vector_counter = 0;
    for i = 1 : sample_number
        w = w + y(i)*alpha(i)*X(i,:)';
        if alpha(i) == 0
            continue;
        end
        support_vector_counter = support_vector_counter + 1;
    end
    % euklidian norm of w
    w_norm = norm(w);
    % factor to get a normalized vector from w
    w_factor = sqrt(1/(w(1)^2+w(2)^2));
    % normalize w
    w = w_factor .* w;
    
    % compute b from supportvectors
    sum1 = 0;
    for i = 1 : sample_number
        if alpha(i) == 0
            continue;
        end
        sum2 = 0;
        for j = 1 : sample_number
            if alpha(j) == 0
                continue;
            end
            sum2 = sum2 + alpha(j)*y(j)*X(j,:)*X(i,:)';
        end
        sum1 = sum1 + (y(i) - sum2);
    end
    b = (sum1 / support_vector_counter) / w_norm;
    
        % plot
        hold on;
        axis([0 1 0 1]);
        x1_axes = 0:0.1:10;
        x2_axes = (-w(1).*x1_axes-b)./w(2);
        plot(x1_axes,x2_axes);
        for i = 1 : sample_number
            if y(i) == 1
                scatter(X(i,1),X(i,2),'X','red');
            else
                scatter(X(i,1),X(i,2),'O','green');
            end
        end
    border_matrix = NaN;
    
    x1_axes = 0:0.1:10;
    x2_axes = 0:0.1:10;
    
    for r = 1 : length(x1_axes)
        for s = 1 : length(x2_axes)
            v = [x1_axes(r) x2_axes(s)]';
            value = w'*[x1_axes(r) x2_axes(s)]' + b;
            if value > -0.001 && value < 0.001
                if isnan(border_matrix)
                    border_matrix = [x1_axes(r) x2_axes(s)];
                else
                    border_matrix = [border_matrix ; [x1_axes(r) x2_axes(s)]];
                end
            end
        end
    end
    
    %hold on;
    %axis([0 1 0 10]);
%     border_size = size(border_matrix);
%     for k = 1 : border_size(1)
%         scatter(border_matrix(k,1),border_matrix(k,2),'.','black');
%     end
    
end

SV = NaN;

for i = 1 : sample_number
    if alpha(i) == 0
        continue;
    end
    if isnan(SV)
        SV = X(i,:);
    else
        SV = [SV ; X(i,:)];
    end
end

error = sum(alpha);

end
