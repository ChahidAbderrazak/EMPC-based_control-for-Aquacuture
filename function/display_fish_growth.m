%% display the traking control perdormance
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 


function  display_fish_growth(t, W, U, xf, x0)
global  Temp_vec

u1=U(1,:);
N=max(size(u1))
food_MPC=sum(u1.*W);


%% Plot the results
figure; 
subplot(3,1,1:2);
plot(t, W, 'b','LineWidth',3); hold off; grid on;
xlabel('Culture period (days)')
ylabel('Mean fish weight (g)')
legend(strcat('MPC^1:[W_{final}=  ',num2str(floor(100*W(end))/100),' g, W_{desired} = ',num2str(floor(100*max(xf))/100),'g] '), 'Desired fish size')
title('Fish growth')
set(gca,'FontSize',14)


subplot(313);
yyaxis left
plot(t, u1, 'b','LineWidth',3)
ylabel('Feeding rate (g/day) (BWD)')
title('Optimal feeding control ')
ylim([-0.5 1.2*max([u1] )])
set(gca,'FontSize',14)
    
yyaxis right

if size(U,1)==2 
    u2=U(2,:);
    plot(t, u2,'g','LineWidth',3)
    title('Optimal feeding/temperature control ')

    
else
    
    plot(t, Temp_vec(1:N), 'g','LineWidth',2)
    title('Optimal feeding control ')
end

xlabel('Culture period (days)')
ylabel('Water Temperature (°C)')
legend(strcat('MPC^1 [ Total food=',num2str(floor(food_MPC)),'g]'),...
      'Water Temperature (°C) ')
set(gca,'FontSize',14)
    
 

end