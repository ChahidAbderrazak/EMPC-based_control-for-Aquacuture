function sumDeltaT=cumulated_heat_change_seconds(T)
global dt
N=max(size(T));
plot(T)
% tank_volume=160*1000 % in litters
Delta_T=diff(T);
Delta_T(Delta_T<0) = 0;
plot(Delta_T)
sumDeltaT=0;
for k=1:N-1
    
    
    if Delta_T(k)>0 % if heating
        
        time=[0, dt]*60*60*24;  % convert in seconds
%         time=[0, dt]*10; % convert in seconds
        Tinit=T(k); Tfinal=T(k+1);
        [t,y] = heater_energy(time, Tinit, Tfinal);
         (Tfinal- Tinit)/3600
         
         gradiant_T(y)/(60*60)
         
         
        sumDeltaT=sumDeltaT+gradiant_T(y);
        
    end
    
end

end

function dT=gradiant_T(T)

Delta_T=diff(T);
Delta_T(Delta_T<0) = 0;
dT=sum(Delta_T);

end

