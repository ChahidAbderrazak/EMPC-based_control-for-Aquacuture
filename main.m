%%####################################################################################
%% Optimal experimental growth tracking  with MPC 
% Control feeding   
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 
%%####################################################################################
clear all; close all
addpath function;  addpath animation; addpath(genpath('function/chebfun')); 
global DO UIA Temp  EMPC R  dt disturbance

% EMPC='EMPC' % determines if fast growth wil be considered in the MPC cost functions
R=10;          % maximal daily ration defined as $3\%$ of the body weight
results_path='./results/'
L_list=[1:2:10];

%%  prices
global price_kWh price_kg_food Number_fish fish_density price_fish_kg PDO_MPC4_hour Oper_duration tank_volume
price_kWh=0.14;                                           %  Ghana, electricity price 0.13$/kWh
price_kg_food=0.4;                                        % in Ghana, electricity price 0.4$/kg
Number_fish= 1000; 
fish_density= 0.9;                                        % fish density kg/m3
% price_fish_kg=2.20;                                       % large  tilapia  cage  farm  in  Ghana farm-gate prices are reported  as  around  US$2.20/kg.
price_fish_kg=1.20;                                       %  https://www.tandfonline.com/doi/pdf/10.1080/13657305.2016.1156190
tank_volume=454.2;                                        % tank volume in Liters
PDO_MPC4_hour=0.102;                                      % maximum oxygenation power
Oper_duration= 0.1;                                       % Average percentage of elecity operation time per day

%%  Start
Lmin=L_list(1); Lmax=L_list(end);
Table_results=[];cnt=1;

for disturbance=[0]            % apply the diturbance related to temperature control
    
    for empc=[1]  % 0: MPC    1: EMPC,  2: FCR

        EMPC='FCR';if empc==0, EMPC='MPC';elseif empc==1, EMPC='EMPC'; end
 
        for L= L_list                        % horizon length in days           
            %%  Fish growth model parameters 
            setup_experimental_parameters  % list of all  states/parameters and initial conditions 
            dt=max(diff(t));
            time=0;
            
            fprintf('\n\n--> %s , noise = %d \n', EMPC, disturbance)
            %% ######################## Loop MPC4: control (f,T)    ########################
            F0=0; T0=25;  DO0=0.5*DOcri ; UIA0=3*UIAcri;
            U=[F0;T0; DO0; UIA0];    % control vector initialization
            X=x0;
            tStart = tic; 
            for day=1:N-L
                
                xf=xref(day);
                x0=X(end);
                Tfk=dt*L;
                Temp=U(2,end);
                
                [t, x, u]= optimal_experimental_feeding_temperature_O2_UIA_OPenOCL(Tfk, L, X(day));

                % update
                X = [X x(2)];
                U = [U u(:,1)];
                time=[time day];
                fprintf('%s | noise = %d : progress %.1f %%',EMPC,disturbance, 100*day/(N-L) )
                
            end
            
            ups_MPC4=floor(100*toc(tStart))/100;
            yMPC4=X;
            uMPC4=U;
            clearvars X  U to yo


            %% plot the results
            close all
            Tag='Experimental fish growth';
            [MSE_MPC4,food_MPC4, FCR, costs, costname, revenue, Cost_effeciency]=show_fish_growth_MPC4(xref, time, uMPC4, yMPC4, Tag);

            % save
            filename=strcat(results_path,EMPC,'_',Tag_exprt,'_R',num2str(R),'_Distrb-',num2str(disturbance),'_L',num2str(L), '_mse2-',num2str(MSE_MPC4), '_eff',num2str(Cost_effeciency),'.fig')
            saveas(gcf,filename)


            %% save the obtained results
            Table_results(cnt,:)=[empc, disturbance, L,MSE_MPC4, Number_fish, yMPC4(end) , food_MPC4, ups_MPC4, costs, revenue, Cost_effeciency, FCR]; cnt=cnt+1;


        end

    end
end

if cnt>2
    col_names={'EMPC','Disturbance','L','MSE','Number_fish','FishWeight(g)','FeedQuatity','ElapsedTime', 'fish_selling', 'FeedCost', 'HeatingCost', 'OxygenationCost','Revenue','Profit_percentage','FCR'};
    T = array2table(Table_results,'VariableNames',col_names)
    
    filename=strcat(results_path,EMPC,'_',Tag_exprt,'_R',num2str(R),'_cnt',num2str(cnt),'_eff',num2str(max(T.Profit_percentage)),'.csv')

    writetable(T,filename) 
    
end

T

% %% animation of fish growth using MPC
% M=8;                 % M : number of fish
% N=10;                % N: the swiming duration
% simulation_tank(12, X, U, time, M, N)
% 

%% plot the Horizon effect plot 
show_horizon_effect(T)


