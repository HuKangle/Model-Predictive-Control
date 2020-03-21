function plotGraphNew(T,plotedges,t,TotalReward)

N=T.N;

% Plot Target Nodes
for ii=find(T.rewards(t,:))
    rewardsize=T.rewards(t,ii)/5;
    %fillcircle(nodes(TargetNodes(ii)).position,rewardsize,'g',.1);
    filledCircle(T.nodes(ii).position,rewardsize,1000,'g');    
    hold on
%     text(nodes(TargetNodes(ii)).position(1)-5,nodes(TargetNodes(ii))...
%         .position(2)-2,sprintf('R%i = %3.1f',ii,nodes(TargetNodes(ii))...
%         .reward));
end

% Plot Edges
if plotedges
    for ii=1:N
        for jj=find(T.adj(ii,:))            
            if jj==ii
                disp('Cannot plot self-loop');
            else
                plot([T.nodes(ii).position(1),T.nodes(jj).position(1)],...
                    [T.nodes(ii).position(2),T.nodes(jj).position(2)],'r','Linewidth',.5);
                hold on
            end
        end
    end
end

% Add info
%text(0,100,sprintf('t=%1.1f',t));
text(0,100,sprintf('Total Reward=%6.1f',TotalReward));
%text(0,100,sprintf('Trajectory of feasible'));
text(50,100,sprintf('Time="%i"',t));
%text(50,100,sprintf('Time=1:45'));
%text(50,100,sprintf('Output="%s"',mat2str(cell2mat(currentword))));

% Plot nodes
for ii=1:N
    if ~isempty(find(T.nodes(ii).atomicProp=='a'))
        filledCircle(T.nodes(ii).position,2.5,1000,'k');
    elseif ~isempty(find(T.nodes(ii).atomicProp=='b'))
        filledCircle(T.nodes(ii).position,2.5,1000,'b');
    elseif ~isempty(find(T.nodes(ii).atomicProp=='c'))
        filledCircle(T.nodes(ii).position,2.5,1000,'c');
    elseif ~isempty(find(T.nodes(ii).atomicProp=='d'))
        filledCircle(T.nodes(ii).position,2.5,1000,'m');
    elseif ~isempty(find(T.nodes(ii).atomicProp=='e'))
        filledCircle(T.nodes(ii).position,2.5,1000,'y'); 
    else
        plot(T.nodes(ii).position(1),T.nodes(ii).position(2),'-o',...
            'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
    end
    hold on
end
%title('a=cyan,b=blue,c=green,d=magenta,e=black');

axis([-20,N+20,-10,N+10]);
axis equal
axis off