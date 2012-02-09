function testNNCostFunction
    % Tests the neural network functions
    clear; close all; clc;
    cd('..');

    % Load the training data and parameters
    fprintf('\nLoading data and parameters...')

    load('data/ml-class_ex4data1.mat');
    load('data/ml-class_ex4weights.mat');

    % Initialize some important values
    input_layer_size = 400;     % 20x20 imput images of digits
    hidden_layer_size = 25;     % Just 1 hidden layer with 25 nodes
    num_labels = 10;            % 10 labels, from 1 to 10 (label 0 = 10)

    % Construct the neural network
    fprintf('\nConstructing the neural network ...')
    nn = nnCreate(input_layer_size, num_labels, hidden_layer_size);
    nn.theta{1} = Theta1;
    nn.theta{2} = Theta2;

    % Compute cost without regularization
    fprintf('\nFeedforward Using Neural Network ...')
    fprintf('\nComputing cost without regularization...');
    lambda = 0;
    expected = 0.287629;
    actual = nnCostFunction(nn, X, y, lambda);
    fprintf('\n\tActual: %f \n\tExpected: %f', actual, expected);
    assertElementsAlmostEqual(expected,actual, 'absolute',1e-6);
    
    % Compute cost with regularization
    fprintf('\nComputing cost with regularization...');
    lambda = 1;
    expected = 0.383770;
    actual = nnCostFunction(nn, X, y, lambda);
    fprintf('\n\tActual: %f \n\tExpected: %f', actual, expected);
    assertElementsAlmostEqual(expected, actual,'absolute', 1e-6);
end