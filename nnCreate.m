function [ nn ] = nnCreate(input_dim, output_dim, hidden_layer_sizes)
%NNCREATE Creates a neural network struct based on the given parameters
% [nn]  =   nnCreate(input_dim, output_dim, hidden_layer_sizes)
%           returns a neural network structure. The structure contains the
%           following properties.
%           hidden_layers_count: The number of hidden layers in the network
%           layers_count: The total number of layers in the network
%           layer_sizes: The number of nodes in all layers including the
%                        input and output layers
%           theta:  An array containing weight matrix for each hidden layer
%           
%           The structure will be based on the following input parameters.
%           input_dim:  the dimensions of the input. In other words, this
%                       corresponds to the number of features.
%           output_dim: the number of output units, which corresponds to
%                       the number of classes the neural network is
%                       supposed to identify.
%           hidden_layer_sizes: An array that denotes the number of nodes 
%                               in the hidden layers. The length of the
%                               array indicates the number of hidden
%                               layers.

nn.hidden_layers_count = numel(hidden_layer_sizes);
nn.layers_count = 2 + nn.hidden_layers_count;
nn.layer_sizes = [input_dim, hidden_layer_sizes, output_dim];

EPSILON_INIT = 0.12;

for i = 1:(nn.layers_count - 1)
    rows = nn.layer_sizes(i) + 1;
    cols = nn.layer_sizes(i + 1);
    nn.theta{i} = rand(rows, cols) * 2 * EPSILON_INIT - EPSILON_INIT;
    
end

end