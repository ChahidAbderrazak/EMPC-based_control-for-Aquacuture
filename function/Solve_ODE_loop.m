%% Solve ODE iteratively
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 

function [y_loop]=Solve_ODE_loop(t, dt, y0, time, Temp, DO, UIA, Feed_Q)
%%  solve the ODE iterativly
% dt=1.02*max(diff(t));
y_loop(1)=y0;
R=0.1;
for k=time+1
    k;
    %% fish growth model
    ydot=Fish_Growth_Model(y_loop(k), Feed_Q(k), Temp(k), DO(k), UIA(k));

    y_loop(k+1) = y_loop(k) + ydot*dt;
    
%     %%  LTI
%     A=-0.1462
%     x(k+1)= A*x(k)
%     
%     yy(k)=x(k);
     
end

y_loop=y_loop(1:end-1)';
% z=[y_loop; yode'];