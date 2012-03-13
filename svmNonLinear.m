function param = ...
    svmNonLinear( X , y , C , kernel_type_string , arg1 , arg2)
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

% find support vectors in data set
SV_X = NaN;
SV_y = NaN;
alpha_return = NaN;
for i = 1 : sample_number
    if alpha(i) == 0
        continue;
    end
    if isnan(alpha_return)
        alpha_return = alpha(i);
    else
        alpha_return = [alpha_return ; alpha(i)];
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

param = struct('SV_X', SV_X, 'SV_y', SV_y, 'alpha', alpha_return, ...
    'kernel_type_string', kernel_type_string, 'arg1', arg1, 'arg2', arg2);

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

