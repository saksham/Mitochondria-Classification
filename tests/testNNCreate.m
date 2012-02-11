function testNNCreate
% TESTNNCREATE: Tests nnCreate function

    nn = nnCreate(10, 5, [7, 3]);
    assertEqual(2, nn.hidden_layers_count, 'Hidden layers count');
    assertEqual(4, nn.layers_count, 'Layers count');
    assertEqual([10, 7, 3, 5], nn.layer_sizes, 'Layer sizes');
    assertEqual(3, nn.theta_count, 'Theta count'); 
    assertEqual([7, 11], size(nn.theta{1}), 'Theta{1} size');
    assertEqual([3, 8], size(nn.theta{2}), 'Theta{2} size');
    assertEqual([5, 4], size(nn.theta{3}), 'Theta{3} size');
    assertEqual(7 * 11 + 3 * 8 + 5 * 4, nn.theta_total_numel, ...
        'Total theta count');
end