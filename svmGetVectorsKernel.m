function [ SV_X , SV_y ] = svmGetVectorsNoKernel( X , y , is_plot , softness , kernel_type_string , arg1 , arg2)
%SVMGETVECTORSNOKERNEL Summary of this function goes here
%   Detailed explanation goes here

power = 1;
additive_constant = 0;
sigma2 = 0.25;

kernel_type = 0;
switch kernel_type_string
    case 'poly'
        kernel_type = 1;
        power = arg1;
        additive_constant = arg2;
    case 'gauss'
        kernel_type = 2;
        sigma2 = arg1;
end

sample_number = length(y);
C = softness;
% tolerance for support vector detection
epsilon = C*1e-6;

% construct the hessian
H = zeros(sample_number,sample_number);
for i=1:sample_number
    for j=1:sample_number
        H(i,j) = y(i)*y(j)*getKernelValue(X(i,:),X(j,:));
    end
end

% parameters for the optimization problem

% negative sign for first derivative
f = -1.*ones(sample_number,1);

% 0 <= alpha <= C
% lower bound
vlb = zeros(sample_number,1);
% upper bound
vub = C*ones(sample_number,1);

% sum(alpha * y) = 0
A = y';
b = 0;

% quadratic optimization
[alpha] = quadprog(H, f, [], [], A, b, vlb, vub);

support_vector_counter = 0;
for i = 1 : sample_number
    if alpha(i) < epsilon
        alpha(i) = 0;
        continue;
    end
    support_vector_counter = support_vector_counter + 1;
end

if is_plot
    % compute b from support vectors
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
            sum2 = sum2 + alpha(j)*y(j)*getKernelValue(X(j,:),X(i,:));
        end
        sum1 = sum1 + (y(i) - sum2);
    end
    b = (sum1 / support_vector_counter);
    
    % start plotting
    x1_axes = -1:0.1:1;
    x2_axes = -1:0.1:1;
    
    hold on;
    axis([-1 1 -1 1]);
    
    % plot areas
    for r = 1 : length(x1_axes)
        for s = 1 : length(x2_axes)
            w_sum = 0;
            for p = 1 : sample_number
                w_sum = w_sum + alpha(p)*y(p)*getKernelValue(X(p,:),[x1_axes(r) x2_axes(s)]);
            end
            value = w_sum + b;
            if value < 0
                scatter(x1_axes(r), x2_axes(s),'O','green');
            else
                scatter(x1_axes(r), x2_axes(s),'O','red');
            end
        end
    end
    
    % plot data and support vectors
    for i = 1 : sample_number
        if y(i) == 1
            scatter(X(i,1),X(i,2),'X','red');
        else
            scatter(X(i,1),X(i,2),'X','green');
        end
        if alpha(i) ~= 0
            scatter(X(i,1),X(i,2),'.','black');
        end
    end
end

% find support vectors in data set
SV_X = NaN;
SV_y = NaN;
for i = 1 : sample_number
    if alpha(i) == 0
        continue;
    end
    if isnan(SV_X)
        SV_X = X(i,:);
    else
        SV_X = [SV_X ; X(i,:)];
    end
    if isnan(SV_y)
        SV_y = y(i,:);
    else
        SV_y = [SV_y ; y(i,:)];
    end
end

    function [ value ] = getKernelValue( x1 , x2)        
        if kernel_type == 1
            value = svmKernelPolynomial(x1 , x2 , power , additive_constant);
        elseif kernel_type == 2
            value = svmKernelGaussian(x1 , x2 , sigma2);
        else
            value = 0;
        end
    end

end

