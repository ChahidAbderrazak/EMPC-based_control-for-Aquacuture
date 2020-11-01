%% Simulate fish growth in a tank
% M : number of fish
% N: the swiming duration
% Author: Abderrazak Chahid  |  abderrazak-chahid.com | abderrazak.chahid@gmail.com
% @2020, King Abdullah University of Science and Technology 

function simulation_tank(figr, G, F, t, M, N)
figure(figr);

global Xmin Xmax Ymin Ymax p
p=0;
Xmin=0;
Xmax=2;
Ymin=0;
Ymax=2;

G=1+100*G/max(G);
Amax=Xmax;

p0(1)=rand;p0(2)=rand;

for k=2:max(size(G))-1
    G(k);
    nz=rand;
    
    for i=1:N

                 
        % Plot trajectory 

        p=generate_randomwalk(p0,N,M,Amax);
         
        subplot(3,1,1:2)

        for m=1:M

            x1=p(1,:,m);nn=max(size(x1,2));
            y1=p(2,:,m);
            t1=1:nn;t2=1:0.25:nn;
            x1 = interp1(t1,x1,t2);
            y1 = interp1(t1,y1,t2);

            rng('shuffle')
            plot(x1(m),y1(m),'>','MarkerSize',m*nz+G(k));hold on
            xlim([Xmin Xmax])
            ylim([Ymin Ymax])
            title('Fish swiming in the aquarium ')
            set(gca,'FontSize',18)
%             
        end 
        
        food=G(k)*F(k)/max(G.*F);
        rectangle('Position',[Xmin Ymin+0.2 Xmin+0.1 Ymin+food],'Curvature',1, 'FaceColor',[0 .5 .5]);hold off
        text(Xmin,Ymin+0.1,strcat(' food =',num2str(G(k)*F(k)),'g'))
        xlim([Xmin Xmax])
        ylim([Ymin Ymax])

%         xlim([-Amax Amax]); ylim([-Amax Amax])

            
        p0(1)=p(1,N,M);p0(2)=p(2,N,M);
        
        G
        k
         % Plot growth 
        subplot(3,1,3)
        plot(t(1:k),G(1:k),'-k','LineWidth',3)
        title('Fish growth')
        xlabel('Culture period (days)')
        ylabel('Mean fish weight (g)')
        set(gca,'FontSize',18)
        pause(0.01)
        
    end
    

    
end

function pnew=generate_randomwalk(p0,N,M,Amax)
global Xmin Xmax Ymin Ymax  p
pp=p;
for m=1:M
    
    if pp==0
        rng('shuffle') ; x_t(1) = rand;%p0(1);
        rng('shuffle') ; y_t(1) = rand;%p0(2);
        
    else
        
        x_t(1) = pp(1,end,m);
        y_t(1) = pp(1,end,m);
        
    end

      for n = 1:N % Looping all values of N into x_t(n).
        
                  
           %% x position

            x_t(n+1)=update_step( x_t(n),Amax,0.1);

            if x_t(n+1)>Xmax-0.1
                x_t(n+1)=Xmax-0.01;

            elseif x_t(n+1)<Xmin+0.1
                x_t(n+1)=Xmin+1;

            end

            %% y position
            y_t(n+1)=update_step( y_t(n),Amax,0.3);

            if y_t(n+1)>Ymax-1
                y_t(n+1)=Ymax-0.01;

            elseif y_t(n+1)<Ymin +1
                y_t(n+1)=Ymin+1;

            end

        

      end
  
  pnew(:,:,m)=[x_t;y_t];
end



function x=update_step(x,Amax,c)
%     rng('shuffle') ; 
    A = c*sign(randn); % Generates either +1/-1 depending on the SIGN of RAND.
    x_new= x + A; 
     if abs(x_new)<Amax
         x = x + A;
     else

         x=x-Amax;
     end
         