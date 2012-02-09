function [ nn ] = nnCreate(input_dim, output_dim, hidden_layer_nodes_count)
%NNCREATE Creates a neural network struct based on the given parameters
% [nn]  =   nnCreate(input_dim, output_dim, hidden_layers_nodes_count)
%           returns a neural network structure. The structure contains the
%           following properties.
%           layers_count:   The number of hidden layers in the network.
%           theta:  An array containing weight matrix for each hidden layer
%           
%           The structure will be based on the following input parameters.
%           input_dim:  the dimensions of the input. In other words, this
%                       corresponds to the number of features.
%           output_dim: the number of output units, which corresponds to
%                       the number of classes the neural network is
%                       supposed to identify.
%           hidden_layer_nodes_count: An array that denotes the number of 
%                                     nodes in the hidden layers. The
%                                     length of the array indicates the
%                                     number of the number of hidden layers

nn.layers_count = length(hidden_layer_nodes_count);
EPSILON_INIT = 0.12;

for i = 1:(nn.layers_count + 1)
    if (i == 1)
        rows = input_dim + 1;
    else
        rows = hidden_layer_nodes_count(i - 1) + 1;
    end
    
    if(i > nn.layers_count)
        cols = output_dim;
    else
        cols = hidden_layer_nodes_count(i);
    end
    nn.theta{i} = rand(rows, cols) * 2 * EPSILON_INIT - EPSILON_INIT;
    
end

end