%% display the growth tracking  performance
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 

function  [MSE_MPC1,food_MPC1, MSE_MPC2, food_MPC2, MSE_MPC3, food_MPC3]=compare_fish_growth_noise(Wref0, Wref, t, uMPC1, yMPC1, uMPC2, yMPC2, Tag, uMPC3, yMPC3)
global  Temp_vec R

N=min([max(size(Wref)), max(size(yMPC1)), max(size(yMPC2))]);
t=t(1,1:N);
u1=R*uMPC1(1,1:N);
u2_MPC1=uMPC1(2,1:N);
yMPC1=yMPC1(1,1:N);
food_MPC1=sum(u1.*yMPC1)/100;food_MPC1=floor(100*food_MPC1)/100;

Wref=Wref(1:N);
Wref0=Wref0(1:N);
u1_MPC2=R*uMPC2(1,1:N);
u2_MPC2=uMPC2(2,1:N);
food_MPC2=sum(u1_MPC2.*yMPC2)/100; food_MPC2=floor(100*food_MPC2)/100;

MSE_MPC1=floor(100*100*mean((abs(yMPC1-Wref)/Wref).^2))/100;
MSE_MPC2=floor(100*100*mean( (abs(yMPC2-Wref)/Wref).^2))/100;

% Uref=Uref(1,1:N)
% Wref=Wref(1,1:N)
%% Plot the results
figure; 
subplot(3,1,1:2);
plot(t, Wref0,'-.g','LineWidth',3,'MarkerSize',6); hold on
plot(t, Wref,'k','LineWidth',3,'MarkerSize',6); hold on
plot(t, yMPC1,'b','LineWidth',3);  hold on;

if  nargin==8
        plot(t, yMPC2,'r','LineWidth',3); hold off;
        MSE_MPC3=-1; food_MPC3=-1;
else
    plot(t, yMPC2,'r','LineWidth',3); hold on;
    plot(t, yMPC3,'g','LineWidth',3); hold off;
    MSE_MPC3=floor(100*100*mean( (abs(yMPC3-Wref)/Wref).^2))/100;
    u1_MPC3=R*uMPC3(1,1:N);
    u2_MPC3=uMPC3(2,1:N);
    food_MPC3=sum(u1_MPC3.*yMPC3)/100;food_MPC3=floor(100*food_MPC3)/100;


end
    
grid on;

% xlabel('Culture period (days)')
ylim([min([yMPC1, yMPC2]) 1.1*max([yMPC1, yMPC2])])
xlim([min(t) max(t)])
ylabel('Mean fish weight (g)')

lng={strcat(Tag,'[w_{desired}=  ',num2str(floor(100*Wref(end))/100),' g]'),...
       strcat('Noisy tracking reference'),...
       strcat('MPC^1:[tracking error=  ',num2str(MSE_MPC1),'%, w_{final}=  ',num2str(floor(100*yMPC1(end))/100),' g]'),...
       strcat('MPC^2:[tracking error = ',num2str(max(MSE_MPC2)),'%, w_{final}=  ',num2str(floor(100*yMPC2(end))/100),' g] ') };
    
if  nargin==10
    lng{4}=strcat('MPC^3:[tracking error = ',num2str(max(MSE_MPC3)),'%, w_{final}=  ',num2str(floor(100*yMPC3(end))/100),' g] ');
end

   
legend(lng,'color','none' ,'Location','northwest')
title('Fish growth')
set(gca,'FontSize',24)



%% zooming
a2 = axes();
zoom_area=[150:180];
a2.Position = [0.600 0.4300 0.3 0.24]; % xlocation, ylocation, xsize, ysize
plot(t(zoom_area), Wref0(zoom_area),'-.g','LineWidth',3,'MarkerSize',6);  hold on
plot(t(zoom_area), Wref(zoom_area),'k','LineWidth',3,'MarkerSize',6);  hold on
plot( t(zoom_area), yMPC1(zoom_area),'b','LineWidth',3); hold on
if  nargin==8
    plot(t(zoom_area), yMPC2(zoom_area),'r','LineWidth',3); hold off;       
else
    plot(t(zoom_area), yMPC2(zoom_area),'r','LineWidth',3); hold onn;
    plot(t(zoom_area), yMPC3(zoom_area),'g','LineWidth',3); hold off;
    
    
end
title('Zoom area')
axis tight


subplot(313);
yyaxis left
plot(t, u1, '-b','LineWidth',3); hold on

if  nargin==8
    plot(t, u1_MPC2, '-r','LineWidth',3); hold off 
    
else
    plot(t, u1_MPC2, '-r','LineWidth',3); hold on
    plot(t, u1_MPC3, '-g','LineWidth',3); hold off
    
end
    

ylabel({['Percent of body weight' ] 
        ['per day(BWD)']
        })
    
ylim([min([u1_MPC2 u1]) R+1+2])
xlim([min(t) max(t)])
set(gca,'FontSize',24)

yyaxis right
plot(t, u2_MPC1(1:N),'-.b','LineWidth',3); hold on 

if  nargin==8
    plot(t, u2_MPC2(1:N),'-.r','LineWidth',3); hold off
    
%     ylim([ min(u2_MPC2) max(u2_MPC2)+2 ])
    
else
    plot(t, u2_MPC2(1:N),'-.r','LineWidth',3); hold on 
    plot(t, u2_MPC3(1:N),'-.g','LineWidth',3); hold off
    
    
%     ylim([ min([u2_MPC2, u2_MPC3]) max([u2_MPC2, u2_MPC3])+2 ])
    
end

xlim([min(t) max(t)])
xlabel('Culture period (days)')
ylabel(' Water Temperature (°C)')



if  nargin==8
    lgnd={strcat('MPC^1: [ total food= ',num2str(floor(food_MPC1)),'g]'),...
        strcat('MPC^2: [ total food= ',num2str(floor(food_MPC2)),'g]'),...
        strcat('MPC^1: water temperature'),...
        strcat('MPC^2: water temperature')};

else
    lgnd={strcat('MPC^1: [ total food= ',num2str(floor(food_MPC1)),'g]'),...
        strcat('MPC^2: [ total food= ',num2str(floor(food_MPC2)),'g]'),...
        strcat('MPC^3: [ total food= ',num2str(floor(food_MPC3)),'g]'),...
        strcat('MPC^1: optimal water temperature'),...
        strcat('MPC^2: controlled water temperature'),...
        strcat('MPC^3: random water temperature')};
    
end

legend(lgnd)%,'color','none')
% hLegend=legend(lgnd)%,'color','none')
% hLegend.Color = [0.5, 0.5, 0.5, 0.8];
% set(hLegend.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[.5;.5;.5;.7]));

title(' Feeding and temperature  control ')

set(gca,'FontSize',24)
set(gcf, 'Position', get(0, 'Screensize'));

end
