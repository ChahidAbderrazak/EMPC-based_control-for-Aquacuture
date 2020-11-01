

function[t,To] = heater_energy(tspan, Tinit,Tfinal )
close all;tauR=0.2; beta=0.05 ; F1frac=1.2;
% program to solve Eqn (5.1-11)
% the temperature of the heated tank is disturbed by the temperatures of
% the inlet streams and the condensing temperature of the vapor in the
% heat exchanger bundle
% INPUT variables
% tauR residence time in seconds
% beta heat transfer significance parameter
% F1frac fraction of flow in stream 1
% OUTPUT variables
% To the deviation in outlet temperature is plotted
% NOTE: all system variables are in deviation form
% define equation parameters
tau = tauR/(1+beta) ; % time constant in seconds
K1 = F1frac/(1+beta) ; % stream 1 gain
% define the disturbances - first interval
 Toinit = Tinit ; % start out at reference condition
 T1 = Tfinal; % no disturbances
 % integrate the equation
 [t,Ti] = ode45(@hot_tank,tspan,Toinit,[],tau,K1,T1) ;
 
 To= awgn(Ti,60,'measured');

 % plot the solution
%   plot (t,To)

end % heated_tank


% define the differential equation in a subfunction
function dTodt = hot_tank(t,To,tau,K1,T1)
dTodt = (1*T1 - To)/tau ;
end