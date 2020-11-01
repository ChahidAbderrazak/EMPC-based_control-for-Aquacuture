%% generate a smooth random vector of size N 
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 
%#######################################################################################


function  u=random_smooth_control(N)

rng(floor(100*rand))
t=linspace(-1,1,N);
f2 = smoothie(1);
u=f2(t);
