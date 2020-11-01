%% display the growth tracking  performance
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 

function  [MSE_MPC4,food_MPC4,  FCR,costs, costname,revenue, Cost_effeciency]=show_fish_growth_MPC4(Wref, t, uMPC4, yMPC4, Tag)
global  Temp_vec R EMPC 
global price_kWh price_kg_food Number_fish fish_density price_fish_kg PDO_MPC4_hour Oper_duration tank_volume

cp=4.2;
m=1;
                                       % Average percentage of operation every day
%% 
N=min([max(size(Wref)), max(size(yMPC4))]);
t=t(1,1:N);
Wref=Wref(1:N);
uMPC4=uMPC4(:,1:N);


%% revenue production 
yMPC4=yMPC4(1,1:N);
total_weight_fish_kg=Number_fish*0.001*yMPC4(end);
Total_revenue_fish_selling=total_weight_fish_kg*price_fish_kg;

%% Food cost 
uMPC4(1,:)=R*uMPC4(1,:);
u1=uMPC4(1,:);
food_MPC4=sum(u1.*yMPC4)/100;food_MPC4=floor(100*food_MPC4)/100;
total_weight_food_kg=Number_fish*0.001*food_MPC4;
Total_cost_food_MPC4=total_weight_food_kg*price_kg_food;

%% FCR
[FCR, FCR_avg, FCR_t]=Compute_FCR(uMPC4(1,:),yMPC4);


%% temperature cost  < E_hour = cp*dT*m>
% sumDeltaT=cumulated_heat_change_seconds(uMPC4(2,:)); %Compute the cumultad heat every second
sumDeltaT=gradiant_T(uMPC4(2,:));

PT_MPC4_hour=cp*tank_volume*m*sumDeltaT/(60*60);   % thermal power in kWh
number_days=(t(end)-t(1));
PT=Oper_duration*number_days*PT_MPC4_hour;
Total_cost_PT=PT*price_kWh;

%% DO cost 
PDO=Oper_duration*24*sum(uMPC4(3,:))*0.1;
Total_cost_PDO=PDO*price_kWh;


%% revenue
total_cost=Total_cost_food_MPC4 + Total_cost_PT + Total_cost_PDO;
revenue= Total_revenue_fish_selling - total_cost;

Cost_effeciency=100*(revenue)/(total_cost);



costs= [Total_revenue_fish_selling, Total_cost_food_MPC4, Total_cost_PT, Total_cost_PDO];
costname={'fish_selling', 'food_cost', 'Energy_Temp', 'Energy_DO'};
%% Traking error
MSE_MPC4=floor(100*100*mean((abs(yMPC4-Wref)/Wref).^2))/100;



%% flooring
Cost_effeciency=floor(100*Cost_effeciency)/100;
FCR=floor(100*FCR)/100;
Total_cost_PDO=floor(100*Total_cost_PDO)/100;
revenue=floor(100*revenue)/100;
Total_cost_PT=floor(100*Total_cost_PT)/100;
Total_cost_food_MPC4=floor(100*Total_cost_food_MPC4)/100;


%% Plot the results
figure; 
% subplot(4,1,1:2);
subplot(3,1,1:2);

plot(t, Wref,'--ko','LineWidth',3,'MarkerSize',6); hold on
plot(t, yMPC4,'b','LineWidth',3);  hold on;
grid on;

% xlabel('Culture period (days)')
ylim([min([Wref yMPC4]) 1.1*max([Wref yMPC4])])
xlim([min(t) max(t)])
ylabel('Mean fish weight (g)')

lng={strcat(Tag,'[w_{desired}=  ',num2str(floor(100*Wref(end))/100),' g]'),...
       strcat(EMPC,':[tracking error=  ',num2str(MSE_MPC4),'%, w_{final}=  ',num2str(floor(100*yMPC4(end))/100),' g, FCR=',num2str(FCR))};
%    , ...
%         ' Revenue=',num2str(floor(100*revenue)/100),'$') };%, Profit=',num2str(floor(100*Cost_effeciency)/100),'%]') };
    
  
legend(lng,'color','none','Location','northwest')
title('Fish growth')
set(gca,'FontSize',24)



%% zooming
a2 = axes();
zoom_area=[1:80];
% a2.Position = [0.600 0.5800 0.3 0.18]; % xlocation, ylocation, xsize, ysize
a2.Position = [0.600 0.4300 0.3 0.24]; % xlocation, ylocation, xsize, ysize

plot(t(zoom_area), Wref(zoom_area),'k','LineWidth',3,'MarkerSize',6);  hold on
plot( t(zoom_area), yMPC4(zoom_area),'b','LineWidth',3); hold on
title(' Nursery stage for tilapia farming (Zoom)')
axis tight


% subplot(413);
subplot(313);

yyaxis left
plot(t, uMPC4(1,:), '-b','LineWidth',3); hold on
plot(t, uMPC4(3,:), '-k','LineWidth',3); hold on
% ylabel({['Percent of body weight' ] 
%         ['per day(BWD)']
%         })
    
ylabel('BWD (%) / DO')

ylim([min([uMPC4(1,:)]) max(uMPC4(1,:))+1])
xlim([min(t) max(t)])
set(gca,'FontSize',24)

yyaxis right
plot(t, uMPC4(2,:),'-r','LineWidth',3); hold on 
xlim([min(t) max(t)])
xlabel('Culture period (days)')
ylabel(' Water Temperature')


lgnd={strcat('Feeding (%): [ food quantity= ',num2str(floor(food_MPC4)),'g/fish, total cost=',num2str(floor(100*Total_cost_food_MPC4)/100),'$]'),...
      strcat('DO (mg/l): [oxygenation energy= ',num2str(floor(100*PDO)/100),'kWh, total cost=',num2str(floor(Total_cost_PDO)),'$]'),...
      strcat('Temperature (°C): [heating energy= ',num2str(floor(100*PT)/100),'kWh, total cost=',num2str(floor(100*Total_cost_PT)/100),'$]')};

legend(lgnd)%,'color','none')
% hLegend=legend(lgnd)%,'color','none')
% hLegend.Color = [0.5, 0.5, 0.5, 0.8];
% set(hLegend.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[.5;.5;.5;.7]));

title(' Controlled inputs ')

set(gca,'FontSize',24)
set(gcf, 'Position', get(0, 'Screensize'));


% 
% subplot(414);
% yyaxis left
% plot(t, uMPC4(3,:), '-b','LineWidth',3); hold on
% ylabel('Dissolved Oxygen')
%     
% % ylim([min([uMPC4(2,:)]) max(uMPC4(2,:))+1])
% xlim([min(t) max(t)])
% set(gca,'FontSize',24)
% 
% yyaxis right
% plot(t, uMPC4(4,:),'-r','LineWidth',3); hold on 
% xlim([min(t) max(t)])
% xlabel('Culture period (days)')
% ylabel(' Unionized ammonia ')
% 
% 
% lgnd={strcat('DO: [ total energy= ',num2str(floor(100*PDO_MPC4_hour)/100),'kWh, cost=',num2str(floor(Total_cost_PDO)),'$]'),...
%        strcat('UIA: Unionized ammonia]')};
% legend(lgnd)%,'color','none')
% title(' Water Oxygen and amonia  control ')

set(gca,'FontSize',24)
set(gcf, 'Position', get(0, 'Screensize'));






end


function dT=gradiant_T(T)
global disturbance
Delta_T=diff(T);
Delta_T(abs(Delta_T)<1.5) = 0;
dT=sum(Delta_T);

end

