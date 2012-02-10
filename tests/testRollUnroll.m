function testRollUnroll
% TESTROLLUNROLL Tests whether or not roll and unroll are inverse
    
    nn = nnCreate(3, 4, 2);
    theta_1_original = nn.theta{1};
    theta_2_original = nn.theta{2};
    
    theta_vec = nnUnroll(nn);
    nn.theta{1} = zeros(size(nn.theta{1}));
    nn.theta{2} = zeros(size(nn.theta{2}));
    nn = nnRoll(nn, theta_vec);
    assertEqual(theta_1_original, nn.theta{1});
    assertEqual(theta_2_original, nn.theta{2});
end