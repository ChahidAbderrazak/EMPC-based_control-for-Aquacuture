%% display the growth tracking  performance of EMPC controller
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 

function  controller_EMPC_performance(t, W, U, Wref, Uref)
global  Temp_vec

N=min([max(size(Wref)), max(size(W))]);
t=t(1,1:N);
u1=U(1,1:N);
u2=U(2,1:N);
u3=U(3,1:N);
u4=U(4,1:N);


W=W(1,1:N);
food_MPC1=sum(u1.*W);

Wref=Wref(1:N);
Uref=Uref(1:N);

MSE_MPC=floor(10000*mean(((W-Wref)/Wref).^2))/100;

% Uref=Uref(1,1:N)
% Wref=Wref(1,1:N)
%% Plot the results
figure; 
subplot(3,1,1:2);
plot(t, Wref,':.k','LineWidth',3); hold on
plot(t, W,'b','LineWidth',3);  hold off; grid on;

xlabel('Culture period (days)')
ylabel('Mean fish weight (g)')
legend(strcat('Experimental growth '),...
       strcat('EMPC^1:[Tracking error=  ',num2str(MSE_MPC),'%], [ Total food= ',num2str(floor(food_MPC1)),'g]'))
title('Fish growth')
set(gca,'FontSize',14)


subplot(313);
yyaxis left
plot(t, u1, '-r','LineWidth',2); hold on 
plot(t, u3, '-k','LineWidth',2); hold on 
plot(t, u4, '-b','LineWidth',2); hold off 

ylabel('Feeding rate (g/day) (BWD)')
% ylim([0.8*min(min((U))) 1.2*max(max((U)))])

yyaxis right
plot(t, u2,'g','LineWidth',2); hold on 

xlabel('Culture period (days)')
ylabel(' Water Temperature (°C)')
legend(strcat('Feeding'),...
   strcat('DO'),...
   strcat('UIA'),...
   strcat('Temperature'))

title('EMPC control ')

set(gca,'FontSize',14)
    

end