function [T,N]=ACC2011_ex_feasible()
% number of state
N=100;
% number of rows
T.numRow=10;

T.N=N;
T.Q = 1:N;
% Assign initial state of T
T.Q0 = 1;
fprintf('Initial state of T is %i\n',T.Q0);

% Create Nodes
T.nodes=[];
for ii=1:N
    T.nodes=[T.nodes, struct('position',[T.numRow*floor((ii-1)/T.numRow),...
        T.numRow*mod((ii-1),T.numRow)],'atomicProp',[])];
end

% Atomic Proposition Assignment
for ii=1:N
    switch ii
        case T.numRow
            T.nodes(ii).atomicProp=[T.nodes(ii).atomicProp, 'b'];
        case N
            T.nodes(ii).atomicProp=[T.nodes(ii).atomicProp, 'c'];
        case N-T.numRow+1
            T.nodes(ii).atomicProp=[T.nodes(ii).atomicProp, 'd'];
        case {N/2-T.numRow/2, N/2-T.numRow/2+T.numRow+1}
            T.nodes(ii).atomicProp=[T.nodes(ii).atomicProp, 'e'];
        case {4,5,6,7,16,24,28,29,35,36,38,41,51,80,86,94,99,73,82,68}
        %feasible
        %case {3,5,6,7,19,26,28,55,35,36,38,46,51,66,86,94,96,73,82,68,42,59,77}
            T.nodes(ii).atomicProp=[T.nodes(ii).atomicProp, 'a'];
%         otherwise
%             %4,5,6,7,13,16,24,28,29,35,36,38,41,51,80,86,94,99,73,82
%             if randi(3)==1
%                 if ii~=T.Q0
%                     T.nodes(ii).atomicProp=[T.nodes(ii).atomicProp, 'a'];
%                 end
%             end
    end   
end


T.N_p = 5;
T.alphabet = alphabet_set(obtainAlphabet(T.N_p));

T.adj = sparse(N,N);

for ii=1:N    
    %Assign neighbour based on proximity
    ProxDiskR=T.numRow;
    for jj=1:N
        if jj~=ii && norm(T.nodes(ii).position-T.nodes(jj).position)<=ProxDiskR
            T.adj(ii,jj)=2.5*norm(T.nodes(ii).position-T.nodes(jj).position);
        end
    end
    
    % Put in observations
    if isempty(T.nodes(ii).atomicProp)
        T.obs(ii)=2^T.N_p;
        continue
    end
    ap_obs=[];
    for jj=1:length(T.nodes(ii).atomicProp)
        switch T.nodes(ii).atomicProp(jj)
            case 'a'
                ap_obs=[ap_obs, 5];
            case 'b'
                ap_obs=[ap_obs, 4];
            case 'c'
                ap_obs=[ap_obs, 3];
            case 'd'
                ap_obs=[ap_obs, 2];
            case 'e'
                ap_obs=[ap_obs, 1];
            otherwise
                disp(T.nodes(ii).atomicProp);
                error('Atomic Proposition not expected!');
        end
        ap_obs=sort(ap_obs);
    end
    alph_ind=zeros(1,T.N_p);
    alph_ind(ap_obs)=1;
    T.obs(ii)=bin2dec(char(alph_ind+double('0')));
end