%% The input parameters of fish growth model
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 
%#######################################################################################

global Temp Temp_vec  xf Dn lamba A Hplus s   Fmin Fmax Tmin Tmax Topt m n a b kmin DOcri DOmin UIAmax UIAcri j  

Tag_exprt='Simulated';
%% inputs parameters 
Tf=50;   %% time in days
N=Tf;    % lenght of descretization scheme of the experiment 
x0=[13];
xf=100;
% R=(xf)/Tf;
noise=0;  % Enable noise 

%% Initial conditions
tspan = [0:N-1]; 
time=tspan;
t=time;
xref=xf+rand_vec(N,0,0);
%% Feeding level
Fmin=0.01;                 %(g/day)
Fmax=1;                  %(g/day)

Feed=ones(1,N);% Feed([50:60 80:88 120:133])=0; % On/Off feeding
Feed_Q=rand_vec(N,Fmin, Fmax);                             %  feeding qunatity
Feed_Q=Feed_Q.*Feed;


%% Water temperature
Tmin= 26;
Tmax=40;
Topt= 33;
% Temp_vec=rand_vec(N,Tmin,Tmax);%Topt*ones(1,N);%rand_vec(N,Tmin,Tmax);%
% Temp_vec=rand_vec(N,Topt-15,Topt+15);%Topt*ones(1,N);%rand_vec(N,Tmin,Tmax);%
% Temp_vec=rand_vec(N,Tmin,Tmax);%Topt*ones(1,N);%rand_vec(N,Tmin,Tmax);%
Temp_vec=Topt+0*rand_vec(N,Tmin,Tmax);%Topt*ones(1,N);%rand_vec(N,Tmin,Tmax);%

%% Dissolved oxygen (DO)
DOcri= 1;
DOmin= 0.3;

% DO_vec=rand_vec(N,DOmin-0.5, DOcri+0.5);
DO_vec=rand_vec(N,DOcri+1, DOcri+5); % optimal DO>DOcri
DO_vec=DOcri+1 +0*rand_vec(N,DOcri+1, DOcri+5); % optimal DO>DOcri

%% Unionized ammonia (UIA)
UIAmax=1.40;
UIAcri=0.06;
% UIA_vec=rand_vec(N,UIAcri-1, UIAmax+1);% 
% UIA_vec=rand_vec(N,UIAcri-5, UIAcri-0.1);% optimal UIA<UIAcri
UIA_vec=UIAcri-1 +0*rand_vec(N,UIAcri-5, UIAcri-0.1);% optimal UIA<UIAcri


%% Other
m=0.67;         % the exponent of body weight for net anabolism
n=0.81;         % the exponent of body weight for fasting catabolism 
a=0.53;         % accounts for further losses of metabolizable energy via heat increment and urinary excretion
b=0.62;         % refers to the proportion of the gross energy or food intake that is available as metabolizable energy
kmin=0.00133;   % the coefficient of fasting catabolism:  kkmin exp[ j(TTmin)]
j=0.0132;

%% relative feeding level ( f ) 
s= 21.38;     % the proportionality coefficient of PNPP to natural food (dimensionless) was estimated     
Dn=-1;        % the DIN (mg/L*N)
lamba=-1;     %  is the efficiency of carbon fixation (dimensionless),
A= 85;        % is the alkalinity (mg/L*CaCO3),
Hplus=8.1;    % is the hydrogen ion concentration   (mol/L),



%% noise storage variable 
Vec_noise=0*rand_vec(N,-10, 10)';     %  Additional anabolism noise 
% cnt0=1;


