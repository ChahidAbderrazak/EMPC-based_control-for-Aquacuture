%% Solve ODE problem iteratively
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 

function [x]=Solve_ODE_loop2(t, dt, y0, Temp, DO, UIA, Feed_Q)
%%  solve the ODE iterativly
% dt=1.02*max(diff(t));
x(1)=y0;
dt;
x(1)=y0;
for k=1:max(size(t))-1
    m=0.67;
    n=0.81;
    x(k+1) = x(k) + (1.5*x(k)^m - 0.1*x(k)^n )*dt;
       
end
% y_loop=y_loop(1:N);
% z=[y_loop; yode'];