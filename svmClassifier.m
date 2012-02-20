function [ new_y ] = svmClassifier( SV_X , SV_y , new_X , softness , kernel_type_string , arg1 , arg2)
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

sample_number = length(SV_y);
C = softness;
% tolerance for support vector detection
epsilon = C*1e-6;

% construct the hessian
H = zeros(sample_number,sample_number);
for i=1:sample_number
    for j=1:sample_number
        H(i,j) = SV_y(i)*SV_y(j)*getKernelValue(SV_X(i,:),SV_X(j,:));
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
A = SV_y';
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
        sum2 = sum2 + alpha(j)*SV_y(j)*getKernelValue(SV_X(j,:),SV_X(i,:));
    end
    sum1 = sum1 + (SV_y(i) - sum2);
end
b = (sum1 / support_vector_counter);

% compute classes for new data
new_data_number_mat = size(new_X);
new_data_number = new_data_number_mat(1);
new_y = zeros(new_data_number,1);
for i = 1 : new_data_number
    w_sum = 0;
    for p = 1 : sample_number
        w_sum = w_sum + alpha(p)*SV_y(p)*getKernelValue(SV_X(p,:),new_X(i,:));
    end
    value = w_sum + b;
    if value < 0
        new_y(i,1) = -1;
    else
        new_y(i,1) = 1;
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

