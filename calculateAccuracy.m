function [errorTrain, errorCv] = calculateAccuracy(X, y, trainFn, predictFn, k)
% CALCULATEACCURACY Calculates accuracy for the ML algorithm
%   [errorTrain, errorCv] = CALCULATEACCURACY(X, y, trainFn, predictFn, k)
%   the function computes training and cross-validation errors using k-fold
%   validation
%       X: input data
%       y: labels for the input data
%       trainFn: ML train function with the following signature
%                [params] = trainFn(Xtrain, ytrain)
%       classifyFn: prediction function with the following signature
%                [predictions] = predictFn(X, params)
%
m = size(X, 1);
dim_X = size(size(X),2);
cp = cvpartition(m, 'kfold', k);

errorTrain_vec = zeros(size(cp.TrainSize, 1));
errorCv_vec = zeros(size(cp.TestSize, 1));
cvStart = 0;

for i = 1:cp.NumTestSets
    % --------------- Compute the indices
    trainIndices = zeros(1, cp.TrainSize(i));
    nextTrainIndex = 1;
    if(i > 1)
        up = sum(cp.TestSize(1:i-1));
        trainIndices(nextTrainIndex:up)= 1:up;
        nextTrainIndex = nextTrainIndex + up;
    end
    
    % Cross validation indices
    cvEnd = cvStart + cp.TestSize(i);
    cvIndices = (cvStart + 1):cvEnd;
    
    if(i < cp.NumTestSets)
        trainIndices(nextTrainIndex:end) = (cvEnd + 1):cp.N;
    end
    
    % ------ Train the learning algorithm
    if dim_X == 3
        xTrain = X(trainIndices, :, :);
    else
        xTrain = X(trainIndices, :);
    end
    yTrain = y(trainIndices);
    params = trainFn(xTrain, yTrain);
    predictionTrain = predictFn(xTrain, params);
    errorTrain_vec(i) = 1.0 - mean(double(predictionTrain == yTrain));
    
    % ------ Perform cross validation
    if dim_X == 3
        xCv = X(cvIndices, :, :);
    else
        xCv = X(cvIndices, :);
    end
    yCv = y(cvIndices);
    predictionCv = predictFn(xCv, params);
    errorCv_vec(i) = 1.0 - mean(double(predictionCv == yCv));
    
    cvStart = cvEnd;
end

errorTrain = mean(errorTrain_vec);
errorCv = mean(errorCv_vec);
end