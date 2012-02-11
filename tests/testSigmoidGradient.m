function testSigmoidGradient
%TESTSIGMOIDGRADIENT Tests the sigmoidGradient function
% See also: SIGMOIDGRADIENT

in = [1 -0.5 0 0.5 1];
out = sigmoidGradient(in);
expected = [0.196611933241482, 0.235003712201594, 0.250000000000000, ...
    0.235003712201594, 0.196611933241482];
assertElementsAlmostEqual(expected, out);

end

