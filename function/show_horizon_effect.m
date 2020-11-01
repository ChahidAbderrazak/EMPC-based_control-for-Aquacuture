function show_horizon_effect(T)
    %% Plot the results
    

    L_list=T.L(T.EMPC==-1);
    
    FCR_MSE=T.MSE(T.EMPC==-1);
    MPC_MSE=T.MSE(T.EMPC==0);
    EMPC_MSE= T.MSE(T.EMPC==1);
    
    %% tracking
    figure; 
    subplot(311);
    plot(T.L(T.EMPC==-1), FCR_MSE,'k','LineWidth',3,'MarkerSize',6); hold on
    plot(T.L(T.EMPC==0), MPC_MSE,'b','LineWidth',3,'MarkerSize',6); hold on
    plot(T.L(T.EMPC==1), EMPC_MSE,'r','LineWidth',3,'MarkerSize',6); hold on
    grid on;

    ylabel('Tracking error (MSE)')
%     xlabel('Prediction horizon length (days)')
    xlim([L_list(1) L_list(end)])

    lng={strcat('FCR [average error =  ',num2str(floor(100*mean(FCR_MSE))/100),' %]'),...
         strcat('MPC [average error =  ',num2str(floor(100*mean(MPC_MSE))/100),' %]'),...
         strcat('EMPC[average error =  ',num2str(floor(100*mean(EMPC_MSE))/100),' %]')};
    %    , ...
    %         ' Revenue=',num2str(floor(100*revenue)/100),'$') };%, Profit=',num2str(floor(100*Cost_effeciency)/100),'%]') };


    legend(lng,'color','none','Location','northwest')
    set(gca,'FontSize',24)
    
    
    %% food
    FCR_food=T.FeedQuatity(T.EMPC==-1);
    MPC_food=T.FeedQuatity(T.EMPC==0);
    EMPC_food= T.FeedQuatity(T.EMPC==1);
    
    subplot(312);
    plot(T.L(T.EMPC==-1), FCR_food,'k','LineWidth',3,'MarkerSize',6); hold on
    plot(T.L(T.EMPC==0), MPC_food,'b','LineWidth',3,'MarkerSize',6); hold on
    plot(T.L(T.EMPC==1), EMPC_food,'r','LineWidth',3,'MarkerSize',6); hold on
    grid on;

    ylabel('Total Feed Quatity')
%     xlabel('Prediction horizon length (days)')
    xlim([L_list(1) L_list(end)])

    lng={strcat('FCR [average food =  ',num2str(floor(100*mean(FCR_food))/100),' g]'),...
         strcat('MPC [average food =  ',num2str(floor(100*mean(MPC_food))/100),' g]'),...
         strcat('EMPC[average food =  ',num2str(floor(100*mean(EMPC_food))/100),' g]')};
    %    , ...
    %         ' Revenue=',num2str(floor(100*revenue)/100),'$') };%, Profit=',num2str(floor(100*Cost_effeciency)/100),'%]') };


    legend(lng,'color','none','Location','northwest')
    set(gca,'FontSize',24)
    
    
    
    %% FCR
    FCR_ElapsedTime=T.ElapsedTime(T.EMPC==-1);
    MPC_ElapsedTime=T.ElapsedTime(T.EMPC==0);
    EMPC_ElapsedTime= T.ElapsedTime(T.EMPC==1);
    
    subplot(313);
    plot(T.L(T.EMPC==-1), FCR_ElapsedTime,'k','LineWidth',3,'MarkerSize',6); hold on
    plot(T.L(T.EMPC==0), MPC_ElapsedTime,'b','LineWidth',3,'MarkerSize',6); hold on
    plot(T.L(T.EMPC==1), EMPC_ElapsedTime,'r','LineWidth',3,'MarkerSize',6); hold on
    grid on;

    ylabel('Computation time(s)')
    xlabel('Prediction horizon length (days)')
    xlim([L_list(1) L_list(end)])

    lng={strcat('FCR [average time =  ',num2str(floor(100*mean(FCR_ElapsedTime))/100),' s]'),...
         strcat('MPC [average time =  ',num2str(floor(100*mean(MPC_ElapsedTime))/100),' s]'),...
         strcat('EMPC[average time =  ',num2str(floor(100*mean(EMPC_ElapsedTime))/100),' s]')};
    %    , ...
    %         ' Revenue=',num2str(floor(100*revenue)/100),'$') };%, Profit=',num2str(floor(100*Cost_effeciency)/100),'%]') };


    legend(lng,'color','none','Location','northwest')
    set(gca,'FontSize',24)
    
    

    
end
