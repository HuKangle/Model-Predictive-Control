function D1=Violate_cost(current,next,T,B)

%vialate cost
X=cell2mat(B.trans(current(2),next));
for i=1:length(X)
    L_2{i}=T.alphabet(1,X(i));
end
v_1=zeros(1,length(T.alphabet));
for j=1:length(T.alphabet)
    if contains(char(T.alphabet(T.obs(current(1)))),char(T.alphabet(1,j)))
        v_1(j)=1;
    else
        v_1(j)=0;
    end
    if j==length(T.alphabet)
        v_1(j)=1; 
    end
end

v_2=zeros(length(L_2),length(T.alphabet));
for ii=1:length(L_2)
    for j=1:length(T.alphabet)
        if contains(char(L_2{ii}),char(T.alphabet(1,j)))
            v_2(ii,j)=1;
        else
            v_2(ii,j)=0;
        end
    end
    if j==length(T.alphabet)
        v_2(ii,j)=1; 
    end
end
p_fun=zeros(1,length(L_2));
for jj=1:length(L_2)
    for kk=1:length(T.alphabet)
        p_fun(jj)=p_fun(jj)+abs(v_1(kk)-v_2(jj,kk));
    end
end
D1=min(p_fun);


% V=[];
% D1=0;
% N_p=2;
% evl=0;
%  if T_soft.obs(current(1))==4
%    V=zeros(4,1);
%    V(4)=1;
%     
%  else   
%     s1=double(dec2bin(T_soft.obs(current(1)),N_p))-double('0');    
%     s1=fliplr(s1);
%     check=ismember(s1,1); 
%     Ap=s1(check);
%     for i=1:(2^N_p-1) 
%      s2=double(dec2bin(i,N_p))-double('0');    
%      s2=fliplr(s2);
%      Ap_check=s2(check);
%      if isequal(Ap,Ap_check)
%         v=1;
%      else
%         v=0;
%      end
%      V=[V;v];
%     end
%     V(i+1)=0;
%  end
% 
%      props=B_soft.trans(current(2),next);
%      Dist=[];
%      X=props{1};
%       for ap=1:length(X)   
%         V_X=[];
%        if X(ap)==4
%           V_X=zeros(4,1);
%           V_X(4)=1;
%     
%        else
%           
%             s1=double(dec2bin(X(ap),N_p))-double('0');    
%             s1=fliplr(s1);
%             check=ismember(s1,1); 
%             Ap=s1(check);
%             for i=1:(2^N_p-1) 
%             s2=double(dec2bin(i,N_p))-double('0');    
%             s2=fliplr(s2);
%             Ap_check=s2(check);
%              if isequal(Ap,Ap_check)
%                  v=1;
%              else
%                  v=0;
%              end
%             V_X=[V_X;v];
%             end
%             V_X(i+1)=0;
%        end
%       
%       for i=1:4                
%           evl=evl+abs(V(i)-V_X(i));               
%       end
%       Dist=[Dist,evl];
%       evl=0;
%       end
%       D1=min(Dist); 
   
     



