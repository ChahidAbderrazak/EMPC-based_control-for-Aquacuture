%% generate a smooth random vector of size N  in range [a,b]
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 
%#######################################################################################

function r=rand_vec(N,a,b)
u=random_smooth_control(N);

r = (b-a).*normalize(u,'range') + a;

d=1;

