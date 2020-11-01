%% Solve a non linear optimal feeding system to reach a final target weight Xf within a specific time horizon Tf
% this optimization used a non linear  ODE model  defined in : dae()
% used solver: OpenOCL: https://openocl.github.io/api-docs/v7/#apiocl_variable
% Modified by: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
%#######################################################################################


function [t, X, U]=optimal_experimental_feeding_only_OPenOCL(Tf, N, x0)

%% Formulate the optimal control 
ocp = ocl.Problem( ...
  Tf, ...
  'vars', @vars, ...
  'dae', @dae, ...
  'pathcosts', @pathcosts, ...
  'terminalcost', @terminalcost, ...
  'N', N,'d', 3);


ocp.setInitialState('x', x0);
ocp.solve();
 
[sol,times] = ocp.solve();


%% control vector
t=times.states;
X=sol.states.x.value
u1=sol.controls.F.value;
U=[u1];

% save('results/ocl_optimal','Xocl','Temp','Feed_Q','t','x0')%,'DO','UIA','Fd')
% 


end


function vars(vh)
global Fmin Fmax 
vh.addState('x');
vh.addControl('F', 'lb', Fmin, 'ub', Fmax);

end



function pathcosts(ch, x, z, u, p)
global xf EMPC R Fmax

lambda=0.1;

if strcmp(EMPC,'yes') 
        ch.add( (x.x - xf)^2/xf);
        ch.add(  lambda*u.F^2/Fmax^2 ); 
    
else
        ch.add( u.F*R*x/(x.x - xf)) ;

end

%Cost function 
% ch.add( (x.x - xf)^2/xf);
% ch.add(  lambda*u.F^2 ); 

% ch.add( u.F^2/(x.x - xf)^2);





end


function terminalcost(ch, x, p)
global  xf
ch.add( (x.x - xf)^2  );

end




function dae(daeh,x,z,u,p)
global  DO UIA   cnt Vec_noise   Temp
x = x.x; 
f = u.F;


%% fish growth model
T=Temp;
xdot=Fish_Growth_Model(x, f, T, DO, UIA);

daeh.setODE('x',  xdot);

end

