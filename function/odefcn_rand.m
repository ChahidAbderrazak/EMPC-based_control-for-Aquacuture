
function dydt = odefcn_rand(t,y, time, vec)

global Tmin Tmax Topt m n a b kmin DOcri DOmin UIAmax UIAcri

%% Compute (tau): the effects of temperature on food consumption and therefore anabolism using the function

tau=1;
% if T>Topt
%      tau= exp( -4.6*(Topt-T)/(Topt-Tmin)^4 );
%    
% else
%      tau= exp( -4.6*(T-Topt)/(Tmax-Topt)^4 );
% 
% end


%% coefficient of catabolism (k) increases  with temperature.     
k= kmin;%;   % (g^(1-n)/ day)

% k= kmin*exp( i*(T-Tmin) );   % (g^(1-n)/ day)


%% Photoperiod factor (ru) 0< ru < 2: many cultured fish species including tilapias tended  to feed only during daylight hours.
ru=1; 

%% the coefficient of food consumption
h=rand();%0.8; 

%% food consumption  affected when DO
sigma=1;
% if DO>DOcri
%      sigma=1;
%    
% elseif DO>DOmin
%      sigma= (DO-DOmin)/(DOcri-DOmin);
%      
% else
%     
%     sigma=0;
% end

%% food consumption  affected when UIA

v=1;
% if UIA<UIAcri
%      v=1;
%    
% elseif UIA<UIAmax
%      v= (UIAmax-UIA)/(UIAmax-UIAcri);
%      
% else
%     
%     v=0;
% end


% link the relative feeding level ( f ) with potential net primary productivity (PNPP) and standing crop 
 f=0.5;
% s=1;    % is the proportionality coefficient
% P= ??;    %  is concentration of natural food ( g/m3)
% B= ??;    %  is the number of fish.
% f=1-exp(-s*(P/B));



%% the growth rates equation
vec = interp1(time, vec, t); % Interpolate the data set (ft, f) at times t
% dydt = b*(1-a)*tau*ru*sigma*v*h*f*y^m - k*y^n ;%
dydt = vec*(b*(1-a)*tau*ru*sigma*v*h*f*y^m - k*y^n) ;%