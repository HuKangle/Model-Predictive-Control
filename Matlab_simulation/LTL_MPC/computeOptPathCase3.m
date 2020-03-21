function optPath=computeOptPathCase3(currentstate,currentPstate,T,P,H,...
    currentpath,optPath,K,t)
%% Energy of current state cannot be infinite, sanity check %%
if P.cost(currentPstate)==inf
    error('Current PA state (%i,%i) has inf energy', currentstate(1),currentstate(2));
end

%% Append current state to the end of current path %%
if ~isempty(currentpath.Ppath)   
    currentpath.path=[currentpath.path;currentstate];
    currentpath.Ppath=[currentpath.Ppath,currentPstate]; 
else
    currentpath.path=currentstate;
    currentpath.Ppath=currentPstate;
end

%% Check if horizon too long (shouldn't trigger!) %%
if length(currentpath.Ppath)>K
    error('Horizon of current path > %i',K);
end

%% Obtain reward from the current state (if not reached before) %%

% Given the current path, compute reward
% Note that since we never encounter path with cycles, we simply add the
% reward of the current state to the current path's cumulated rewards
% dont collect reward if already taken
if isempty(find(currentpath.path(1:(end-1),1)==currentstate(1)))
    currentpath.rewards=currentpath.rewards+T.rewards(t,currentstate(1));
end

if length(currentpath.Ppath)==K
    V=0;
    COST=0;
    for i=1:(K-1)
        V=V+100*P.DIST(currentpath.Ppath(i),currentpath.Ppath(i+1));
    end
    currentpath.totalcost=currentpath.rewards+15000-100*V;
    if optPath.totalcost<=currentpath.totalcost
        optPath=currentpath;
%         fprintf('Optimal path set to: %s\n', mat2str(optPath.path));
%         fprintf('Optimal path rewards now: %3.2f\n', optPath.rewards);
    end
    return
else
%% Recursive call with cycle detection %%
    for ii=find(P.trans(currentPstate,:))
        if isempty(find(currentpath.Ppath==ii)) && P.cost(ii)~=inf
            nextPstate=ii;
            nextstate=P.S(nextPstate,:);
            optPath=computeOptPathCase3(nextstate,nextPstate,T,P,H,currentpath,optPath,K,t);
        end
    end
end