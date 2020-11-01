%%  Experimetal data Tilapia Thailand
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 
%#######################################################################################
global xref Temp Temp_vec  xf x0 Dn lamba A Hplus s   Fmin Fmax Tmin Tmax Topt m n a b kmin DOcri DOmin UIAmax UIAcri j  

load('./data/Experimetal_data_Tilapia_Thailand')
Tag_exprt='Experimental';
%% inputs parameters 
Tf=7*weight.weeks(end);   %% time in days
N=Tf;    % lenght of descretization scheme of the experiment 
fish_samples_weight=weight.mean(2:end);
x0=fish_samples_weight(1);
xf=fish_samples_weight(end);
time_experiemnt=7*weight.weeks(2:end);
%% Initial conditions
tspan = linspace(1,Tf,N);
time=tspan;
t=time;
xref = interp1(time_experiemnt',fish_samples_weight,t);
Data = array2table([t' xref'],'VariableNames',{'t','xf'} );
writetable(Data,'./data/Experimetal_data_Tilapia_Thailand_processed.csv')  

% 
% %% plot
% plot(time_experiemnt,fish_samples_weight,'o','LineWidth',2); hold on
% plot(t,xref,':.','LineWidth',1.6);
% 
% title('The experimental data of Tilapia growth ');
% str = {' Fish are cultured in cages for the density of 1 fish/m^2',' in oxidation pond at The Leam Phak Bia Environmental',' Study Research and Development Project under Royal',' Initiatives Petchaburi Province in Thailand'};
% text(2,400,str,'red','FontSize',14)
% xlabel('Culture period (days)')
% ylabel('Mean fish weight (g)')
% set(gca,'FontSize',14)

%% Feeding level
Fmin=0.01;                 %(g/day)
Fmax=1;                  %(g/day)

Feed=ones(1,N);% Feed([50:60 80:88 120:133])=0; % On/Off feeding
Feed_Q=rand_vec(N,Fmin, Fmax);                             %  feeding qunatity
Feed_Q=Feed_Q.*Feed;


%% Water temperature
Tmin= 27.64;
Tmax=31.76;
Topt= 29.7;

% Temp_vec=rand_vec(N,Tmin,Tmax);%Topt*ones(1,N);%rand_vec(N,Tmin,Tmax);%
Temp_vec=Topt+0*rand_vec(N,Tmin,Tmax);%+rand_vec(N,-1,1);

%% Dissolved oxygen (DO)
DOcri= 1;
DOmin= 0.3;
DO_vec=rand_vec(N, 6.19, 13.01); %  from the experiment

%% Unionized ammonia (UIA)
UIAmax=1.40;
UIAcri=0.06;
UIA_vec=rand_vec(N, 0.3500, 1.31);% from the experiment

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
xref0=xref;



