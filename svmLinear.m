function param = svmLinear( X , y , C)
% SVMLINEAR Function to train a Support Vector Machine on a two class
% classification problem. The values w and b of the decision boundary will
% be returned.
%   X: training features
%   y: classification for training features
%   C: 'hardness' of the decision boundary concerning missclassification

sample_number = length(y);
sample_dimension = size(X);

% tolerance for Support Vector Detection
epsilon = C*1e-6;

% computing the Hessian
H = zeros(sample_number,sample_number);
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

param = struct('W', w, 'b', b);

end
