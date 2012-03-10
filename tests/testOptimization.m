function [x,fval,exitflag,output,lambda,grad,hessian] = testOptimization(x0,lb,ub,DiffMinChange_Data)
% This is an auto generated MATLAB file from Optimization Tool.

x0 = [0.0 0.0];
lb = [0.0 0.0];
ub = [1.0 1.0];
DiffMinChange_Data = 0.01;
A = [1 1];
b = [1];

% Start with the default options
options = optimset;
% Modify options setting
options = optimset(options,'Display', 'off');
options = optimset(options,'PlotFcns', {  @optimplotx @optimplotfval @optimplotstepsize });
options = optimset(options,'Algorithm', 'interior-point');
options = optimset(options,'DiffMinChange', DiffMinChange_Data);
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@testMapOnMitochondria,x0,A,b,[],[],lb,ub,[],options);
