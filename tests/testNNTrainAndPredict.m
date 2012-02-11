function testNNTrainAndPredict
%TESTNNTRAINANDPREDICT Tests NN train and predict functions
% testNNTrainAndPredict: This function trains and tests neural network for 
%   digit recognition problem.
%
% ACKNOWLEDGEMENT: This test is largely based on the Assignment sheet for
% Machine Learning online class taught by professor Andrew NG. For more
% details, please visit: http://ml-class.org/
%
    
    % Load the training data and parameters
    fprintf('\nLoading data and parameters...')
    load('data/ml-class_ex4data1.mat');

    % Create a neural network
    input_layer_size = 400;     % 20x20 imput images of digits
    hidden_layer_size = 25;     % Just 1 hidden layer with 25 nodes
    num_labels = 10;            % 10 labels, from 1 to 10 (label 0 = 10)
    nn = nnCreate(input_layer_size, num_labels, hidden_layer_size);
    
    % Train the neural network
    fprintf('\nTraining the neural network...');
    nn = nnTrain(nn, X, y, 2, 50);
    displayData(nn.theta{1}(:, 2:end));
    
    % Make predictions
    fprintf('\nMaking predictions on the input dataset...');
    pred = nnPredict(nn, X);
    trainingSetAccuracy = mean(double(pred == y)) * 100;
    assert(trainingSetAccuracy > 93, 'Training set accuracy should be ~95%');
end