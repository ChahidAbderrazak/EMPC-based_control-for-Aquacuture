%% Solve a non linear optimal feeding and temperature system to reach a final target weight Xf within a specific time horizon Tf
% this optimization used a non linear  ODE model  defined in : dae()
% used solver: OpenOCL: https://openocl.github.io/api-docs/v7/#apiocl_variable
% Modified by: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
%#######################################################################################


function [t, X, U]=optimal_experimental_feeding_temperature_O2_UIA_OPenOCL(Tf, N, x0)

%% Formulate the optimal control 
ocp = ocl.Problem( ...
  Tf, ...
  'vars', @vars, ...
  'dae', @dae, ...
  'pathcosts', @pathcosts, ...
  'terminalcost', @terminalcost, ...
  'verbose',false,...
  'N', N,'d', 3);


ocp.setInitialState('x', x0);
ocp.solve();
 
[sol,times] = ocp.solve();


%% control vector
t=times.states;
X=sol.states.x.value
u1=sol.controls.F.value;
u2=sol.controls.T.value;
u3=sol.controls.DO.value;
u4=sol.controls.UIA.value;
U=[u1; u2; u3; u4];

% save('results/ocl_optimal','Xocl','Temp','Feed_Q','t','x0')%,'DO','UIA','Fd')
% 


end


function vars(vh)
global Fmin Fmax  Tmin Tmax DOmin DOcri UIAmax UIAcri  x0 xf
vh.addState('x')%, 'lb', x0, 'ub', 10*xf);
vh.addControl('F', 'lb', Fmin, 'ub', Fmax);
vh.addControl('T', 'lb', Tmin, 'ub', Tmax);
vh.addControl('DO', 'lb', DOmin, 'ub', 2*DOcri);
vh.addControl('UIA', 'lb', 0.5*UIAcri, 'ub', UIAmax);

end



function pathcosts(ch, x, z, u, p)
global xf Temp Dcri  EMPC Fmax Tmax Tmin R
global price_kWh price_kg_food Number_fish fish_density price_fish_kg PDO_MPC4_hour Oper_duration tank_volume

lambda1=0.1;
lambda2=0.01;
lambda3=lambda2/10;
DO_pmax=3*Dcri;

%         ch.add( ((x.x - xf)/xf )^2);           % fish production   error     
%         ch.add(  lambda1*(u.F )^2);             % fish feed   cost 
%         ch.add(  lambda2*(Temp-u.T)^2/Tmin^2 );    % Thermal energy cost = Electricity bill 
% %         ch.add(  lambda3*(u.DO)/DO_pmax );  % Air pumping cost = Electricity bill    







if strcmp(EMPC,'FCR') 
        ch.add( (u.F*R*x)/(xf - x.x )) ;        % Feed Conversion Ratio (FCR)

    elseif strcmp(EMPC,'MPC') 

            ch.add( ((x.x - xf)/xf )^2);           % fish production   error     
            ch.add(  lambda1*(u.F)^2);             % fish feed   cost 

        elseif strcmp(EMPC,'EMPC') 
            
        %% parameters
        cp=4.2;
        m=1;

        ch.add( 100*price_fish_kg*((x.x - xf))^2 );                         % fish tracking   error  
        ch.add( price_kg_food*(u.F*R*x.x )^2);             % fish feed   cost 
        ch.add( Oper_duration*price_kWh*(cp*tank_volume*m*(Temp-u.T)/(60*60) )^2 );    % Thermal energy cost = Electricity bill 
        ch.add( Oper_duration*24*price_kWh*(PDO_MPC4_hour*(u.DO))^2 );  % Air pumping cost = Electricity bill    

else
    
    fprintf('\n\n--> ERROR:  The cost function %s  is not defined !!! %d \n', EMPC, errdd)

end


end


function terminalcost(ch, x, p)
global xf

ch.add( ((x.x - xf))^2 );                         % fish tracking   error  
% ch.add( -price_fish_kg*(x.x )^2); 
end




function dae(daeh,x,z,u,p)
x = x.x; 
f = u.F;
T = u.T;
DO = u.DO; 
UIA = u.UIA;


%% fish growth model
xdot=Fish_Growth_Model(x, f, T, DO, UIA);

daeh.setODE('x',  xdot);

end

