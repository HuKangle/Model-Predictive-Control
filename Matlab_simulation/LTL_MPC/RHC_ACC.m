%% Real-time RHC LTL control, ACC2011
% Also comparison of rewards collected with CDC2010
close all
clear all
warning off all
addpath('.\LTL_Toolbox','.\LTL_MPCcode','.\Plot');

%% Program parameters %%
% Flag for loading existing data (data.mat)
% loadPrevData=false;
% Terminal Time (in discrete-time) for real-time algorithm
FinalT=100;
% Horizon length this is 1 larger than N defined in ACC2012
K=4;
% i.e. N=4;
ProxDiskR=29;
%% Offline Computation - Prepare for T,B,P,Energy function%%
% if loadPrevData
%     if exist('./data_ACC.mat','file')==2
%         clear all;
%         load data_ACC.mat;
%     else
%         error('Load file data_CDC.mat not found');
%     end
% else
    
    %% Transition system construction %%
    [T,N]=ACC2011_ex_feasible();
    [T_exe,N_exe]=ACC2011_ex_execution();
    %% Buchi and product automaton generation %%
    formula='G !p1 & G F p2 & G(p2 -> X(!(p5 & p4) U p3)) & G(p3 -> X(!(p2 & p4) U p5)) & G(p5 -> X(!(p2 & p3)  U p4))';
    %formula_hard='G !p1 & G F p2 ';
    B=create_buchi_modify(formula,T.alphabet);
    fprintf('LTL formula = %s\n',formula);
 
    P=autom_product(T,B);
    disp('Product automoton generated');
    disp(P);
    
    %% Compute energy function for each state of P %%
    disp('Computing Energy for each state of P');
    tic
    dist=graphallshortestpaths(P.trans);
    
    P.FS=P.F;
    needToCheck=true;
    while needToCheck
        needToCheck=false;
        for currentfs=P.FS
            minDist=inf;
            adjset=find(P.trans(currentfs,:));
            for neighstate=adjset
                minDist=min(minDist,min(dist(neighstate,P.FS)));
            end            
            if minDist==inf
                P.FS=setdiff(P.FS,currentfs);
                needToCheck=true;
                break                
            end
        end
    end
    
    if isempty(P.FS)
        error('No self-reachable accepting states, can not satisfy spec with the Transition System');        
    end
    
    P.cost=zeros(1,size(P.S,1));
    for ii=1:length(P.cost)
        P.cost(ii)=min(dist(ii,P.FS));
    end
    fprintf('Energy computation completed, took %3.2f seconds\n',toc);
% end

%% Save data for future use %%
% if ~loadPrevData
%     save data_ACC.mat;
% end

%% Real-time algorithm start %%
%% Initialization and initial plotting %%
% Accumulated total rewards
TotalReward=0;

% Horizon Length (in distance)
H=29;

% Set of reachable states on T from current state, for plotting
reachablestates=[];

% Initial time
t=1;

% Initial state
% Note that, we only consider for now where the inital state of Buchi/P is
% unique, we need to modify the code below for if otherwise
currentstate=P.S(P.S0,:);
currentPstate=P.S0;
currentword{1}=T.nodes(currentstate(1)).atomicProp;
currenttraj=currentstate;
currentPtraj=currentPstate;

%% (Initial) Assign rewards at states closer than H %%
maxRewardOverall=25;
minRewardOverall=10;

% Function R(q,k) that generates the time-varying rewards
T_exe.rewards=sparse(FinalT,N);
for ii=1:N
    if ii~=currentstate(1)
        distanceToCurrent=norm(T_exe.nodes(ii).position-T_exe.nodes(currentstate(1)).position);
        
        % 50% probability of being a targetnode if closer than H
        if distanceToCurrent<=H && randi(2,1)~=1
            %Assign reward, reward\in[minRewardOverall,maxRewardOverall]
            T_exe.rewards(t,ii)=minRewardOverall+(maxRewardOverall-minRewardOverall)*rand;
        end
    end    
end


for i=1:N
        if i~=currentstate(1) && norm(T_exe.nodes(currentstate(1)).position-T_exe.nodes(i).position)<=ProxDiskR
            %update T
            if T_exe.obs(i)~=T.obs(i)
                T_exe.nodes(i).atomicProp=T.nodes(i).atomicProp;
                T_exe.obs(i)=T.obs(i);
            end
        end
end
%% (Initial) Draw Everything %%
Fig_int=figure;
plotGraphNew(T_exe,true,t,TotalReward);
drawnow
% Draw current state
filledCircle(T_exe.nodes(currentstate(1)).position,2.5,1000,'r');
drawnow
saveas(Fig_int, '.\Plot\initial.jpg')

%draw real environment
T.rewards=zeros(FinalT,N);
fig1=figure;
plotGraphNew(T,true,t,TotalReward);
drawnow
% Draw current state
filledCircle(T.nodes(currentstate(1)).position,2.5,1000,'r');
drawnow
saveas(fig1, '.\Plot\environment1.jpg')
%savefig('.\Plot\environment1.fig')
% for ii=1:length(optPath.Ppath)
%     optPathii=optPath.path(ii,:);
%     filledCircleCustomColor(T.nodes(optPathii(1)).position,1.8,...
%         1000,[.7 .7 1]);
% end
% drawnow

%% Vectors for recording energy and rewards %%
JJ=[];
RR=[];


%% Main loop start %%
while t<FinalT
    if t==50
        [T,N]=ACC2011_ex_infeasible();
        P=autom_product(T,B);
        disp('Computing Energy for each state of P');
        tic
        dist=graphallshortestpaths(P.trans);
        P.FS=P.F;
        needToCheck=true;
        while needToCheck
            needToCheck=false;
            for currentfs=P.FS
                minDist=inf;
                adjset=find(P.trans(currentfs,:));
                for neighstate=adjset
                    minDist=min(minDist,min(dist(neighstate,P.FS)));
                end            
                if minDist==inf
                    P.FS=setdiff(P.FS,currentfs);
                    needToCheck=true;
                    break                
                end
            end
        end

        if isempty(P.FS)
            error('No self-reachable accepting states, can not satisfy spec with the Transition System');        
        end

        P.cost=zeros(1,size(P.S,1));
        for ii=1:length(P.cost)
            P.cost(ii)=min(dist(ii,P.FS));
        end
        fprintf('Energy computation completed, took %3.2f seconds\n',toc);
        T.rewards=sparse(FinalT,N);
%         for ii=1:N
%             if ii~=currentstate(1)
%                 distanceToCurrent=norm(T.nodes(ii).position-T.nodes(currentstate(1)).position);
% 
%                 % 50% probability of being a targetnode if closer than H
%                 if distanceToCurrent<=H && randi(2,1)~=1
%                     %Assign reward, reward\in[minRewardOverall,maxRewardOverall]
%                     T.rewards(t,ii)=minRewardOverall+(maxRewardOverall-minRewardOverall)*rand;
%                 end
%             end    
%         end
        fig2=figure;
        plotGraphNew(T,true,t,TotalReward);
        drawnow
        % Draw current state
        filledCircle(T.nodes(currentstate(1)).position,2.5,1000,'r');
        drawnow
        saveas(fig2, '.\Plot\environment2.jpg')
    end
    
    for i=1:N
        if i~=currentstate(1) && norm(T_exe.nodes(currentstate(1)).position-T_exe.nodes(i).position)<=ProxDiskR
            %update T
            if T_exe.obs(i)~=T.obs(i)
                T_exe.nodes(i).atomicProp=T.nodes(i).atomicProp;
                T_exe.obs(i)=T.obs(i);
            end
        end
    end
    
    
    % Sanity check for current energy
    if P.cost(currentPstate)==inf
        error('Current PA state (%i,%i) has inf energy', currentstate(1),currentstate(2));
    end
    
    fprintf('Current state: %i,%i\n',currentstate(1),currentstate(2));
    fprintf('V(currentstate)=%3.2f\n',P.cost(currentPstate));
    JJ=[JJ,P.cost(currentPstate)];
    %disp('Current word:');
    %disp(currentword);
    fprintf('Total Reward=%6.1f\n',TotalReward);
    RR=[RR,TotalReward];
    
    %% Find optimal finite path
    % Reinitialize p and optPath
    p.path=[];
    p.Ppath=[];
    p.length=0;
    p.rewards=0;
    p.totalcost=0;
    if t>1
        prevPpath=optPath.Ppath(2:end);
    end
    optPath=p;
    % Compute optimal path
    if t==1
        optPath=computeOptPathCase3(currentstate,currentPstate,T,P,H,p,optPath,K,t);
    elseif P.cost(currentPstate)>0 && isempty(find(P.cost(prevPpath)==0))
        optPath=computeOptPathCase1(currentstate,currentPstate,T,P,H,...
            p,prevPpath(end),optPath,K,t);
    elseif P.cost(currentPstate)>0 && ~isempty(find(P.cost(prevPpath)==0))
        energy0=find(P.cost(prevPpath)==0);
        optPath=computeOptPathCase2(currentstate,currentPstate,T,P,H,...
            p,energy0(1),optPath,K,t);
    elseif P.cost(currentPstate)==0
        optPath=computeOptPathCase3(currentstate,currentPstate,T,P,H,p,optPath,K,t);
    end
    
    fprintf('Optimal Path=%s\n',mat2str(optPath.path));
    
    if isempty(optPath.Ppath)
        error('returned empty optPath!');
    end
    
    %% Draw Everything %%
    fig3=figure;
    plotGraphNew(T_exe,true,t,TotalReward);
    drawnow
    % Draw current state
    filledCircle(T_exe.nodes(currentstate(1)).position,2.5,1000,'r');
    drawnow
    
    temp=['.\Plot\','fig',num2str(t),'.',num2str(1),'.jpg'];
    %savefig(temp);
    saveas(fig3, temp);
    close(fig3)
    
    fig4=figure;
    plotGraphNew(T_exe,true,t,TotalReward);

    % Draw current state
    filledCircle(T_exe.nodes(currentstate(1)).position,2.5,1000,'r');

    % Draw optimal path
    for ii=1:length(optPath.Ppath)
        optPathii=optPath.path(ii,:);
        filledCircleCustomColor(T_exe.nodes(optPathii(1)).position,1.8,...
            1000,[.7 .5 0]);
    end
    drawnow
    temp=['.\Plot\','fig',num2str(t),'.',num2str(2),'.jpg'];
    %savefig(temp);
    saveas(fig4, temp);
    close(fig4)
   
    %% Implement the control, collect rewards %%
    fprintf('Implmenting next state %s\n',mat2str(optPath.path(2,:)));
    
    % Update time
    t=t+1;
    
    % Update state
    currentstate=optPath.path(2,:);
    currentPstate=optPath.Ppath(2);
    
    % Update trajectories
    currenttraj=[currenttraj;currentstate];
    currentPtraj=[currentPtraj,currentPstate];
        
    % Update rewards collected
    TotalReward=TotalReward+T.rewards(t-1,currentstate(1));
    
    % Update word
    currentword=[currentword, T.nodes(currentstate(1)).atomicProp];
    
    for ii=1:N
        if ii~=currentstate(1)
            distanceToCurrent=norm(T_exe.nodes(ii).position-T_exe.nodes(currentstate(1)).position);
            
            % 50% probability of being a targetnode if closer than H
            if distanceToCurrent<=H && randi(2,1)~=1
                %Assign reward, reward\in[minRewardOverall,maxRewardOverall]
                T_exe.rewards(t,ii)=minRewardOverall+(maxRewardOverall-minRewardOverall)*rand;
            end
        end
    end
    
    %% Draw Everything %%
%     fig5=figure;
%     plotGraphNew(T,true,t,TotalReward);
%     drawnow
%     % Draw current state
%     filledCircle(T.nodes(currentstate(1)).position,2.5,1000,'r');
%     drawnow
%     temp=['.\Plot\','fig',num2str(t),'.',num2str(3),'.jpg'];
%     %savefig(temp);
%     saveas(fig5, temp);
%     close(fig5)
end

figure;
subplot(2,1,1)
plot(JJ,'-o','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',4);
ylabel('Energy');
xlabel('time');
subplot(2,1,2)
hold on
plot(RR,'b');
%plot(RR2,'r');
ylabel('Rewards');
xlabel('Iterations');


