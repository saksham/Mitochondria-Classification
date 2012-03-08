path_c = '../../../data/Circle';
path_l = '../../../data/Lines';

%Paths
str = strrep(pwd, '/tests', '');
addpath(str);
str = strrep(pwd, '/tests', '/xunit');
addpath(str);

imagesToFile(path_c , path_l);