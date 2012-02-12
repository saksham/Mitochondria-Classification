function testHandwrittenDigit
%TESTHANDWRITTENDIGIT tries to identify hand-written digit
%

% Since the image is blue on white, we need to invert the image
I = rgb2gray(imread('data/Three.png'));
I = 255 - normalizeImage(I);
I = double(I(:))';

% Create the neural network
input_layer_size = 400;     % 20x20 imput images of digits
hidden_layer_size = 25;     % Just 1 hidden layer with 25 nodes
num_labels = 10;            % 10 labels, from 1 to 10 (label 0 = 10)
nn = nnCreate(input_layer_size, num_labels, hidden_layer_size);

% Train the neural nimetwork
fprintf('\nTraining the neural network...');
load('data/ml-class_ex4data1.mat');
nn = nnTrain(nn, X, y, 2, 50);

digit = nnPredict(nn, I);
assertEqual(3, digit);
end