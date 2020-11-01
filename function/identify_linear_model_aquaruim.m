%% Linear model identification of fish growth 
% Identify Linear model for fish growth model based on nonlinear ODE equations
% the ODE model is defined in : Solve_ODE_loop
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 

function    [A, B, C, D, Ts]=identify_linear_model_aquaruim()
 
addpath function;  addpath animation; addpath(genpath('function/chebfun'));

global noise Gstar Tmin Tmax Topt m n a b kmin DOcri DOmin UIAmax UIAcri j xf DO UIA Fd cnt

%%  ODE configuration 
setup_input_parameters  % list of all  states/parameters and initial conditions 


%% Solve the ODE numerically
disp('--> Solve the growth ODE'); tic
Ts=max(diff(t));
u1=Feed_Q' ;
u2=Temp';
y=Solve_ODE_loop(t, Ts, x0, time, u2, DO, UIA, u1);

%% model identification

disp('--> model identification'); 

% Collect the measured data using the |iddata| command and plot it.
data = iddata(y,[u1, u2],Ts);
data.InputName  = {'Feed','Temp'};
data.InputUnit  = {'g/day','°C'};;
data.OutputName = 'fish weight';
data.OutputUnit = 'g';
data.TimeUnit   = 'days';

% plot(data)


%% Transfer Function Estimation
sysTF = tfest(data,1,0,nan)

%%
% The |compare| and |resid| commands allow us to investigate how well the
% estimated model matches the measured data.
set(gcf,'DefaultAxesTitleFontSizeMultiplier',1,...
   'DefaultAxesTitleFontWeight','normal',...
   'Position',[100 100 780 520]);
% resid(sysTF,data);

%% Process Model Estimation
sysP1D  = procest(data,'P1D')
%
% resid(sysP1D,data);
%%
clf
compare(data,sysTF,sysP1D)

%% get the linear SS
% disp('###########################################')
% disp('--> Model sysTF = '); 
aqurium=ss(sysTF);

disp('###########################################')
disp('--> Model sysP1D = '); 
aqurium=ss(sysP1D);

%% Get the matrices
A=aqurium.A;
B=aqurium.B;
C=aqurium.C;
D=aqurium.D;




%% Validate/Test the identified model using input control  
N=size(u1,1);
t = Ts*[0:N-1];                 % simulation time = 10 seconds

% input vector
gnd={'Feeding (g/day)','Temperature (°C)'};

% U = [rand([1 size(t,2)]);...             % u1 = Feeding 
%      20*rand([1 size(t,2)])];            % u2 = temperature
U=[u1';u2'];
 
sys = ss(A,B,C,D);             % construct a system model

X0=[0 13/C(2)]';
[Y, tsim, X] = lsim(sys,U,t, X0);  % simulate


%% plot figure

figure;
subplot(211)
plot(tsim,Y) ; hold on % plot the output vs. time
title('Identified  system response')
xlabel('time (days)')

subplot(212)
plot(tsim,U) ; hold on
title('Input control U')
legend(gnd)
xlabel('time (days)')


%% save the model
mkdir('mat')
save('mat/aquarium_model.mat','u1','u2','y','A','B','C','D','Ts','N','data','sysTF','sysP1D')
