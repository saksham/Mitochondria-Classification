function [ new_y ] = svmClassifier( SV_X , SV_y , alpha , new_X , kernel_type_string , arg1 , arg2)
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
support_vector_counter = sample_number;

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

