X=0:10;
X=sort(X,'descend');
%p_initial=0.1;
p_initial=0.5;
P_pos1=[];
P_pos2=[];
P_y=[];
P_y1=[];
P_1=[];
H=[];
H1=[];
M=[];
for i=1:11
p1=0.5*exp(-0.01*(10*X(i)))
%p1=1.6*exp(-0.05*(10*X(i)/2+5));
p2=0.9;
p_obs1=p1;
p_obs2=0.1;
p_y=p_initial*p_obs1+p_obs2*(1-p_initial);
py_1=(1-p_obs1)*p_initial+(1-p_obs2)*(1-p_initial);
p_pos1=p_initial*p_obs1/p_y;
p_pos2=p_initial*(1-p_obs1)/py_1;
h=p_y*(p_pos1*log2(p_pos1)+(1-p_pos1)*log2(1-p_pos1))+(1-p_y)*(p_pos2*log2(p_pos2)+(1-p_pos2)*log2(1-p_pos2));

m=p_y*(p_pos1*log2(p_pos1/p_initial)+(1-p_pos1)*log2((1-p_pos1)/(1-p_initial)))+(1-p_y)*(p_pos2*log2(p_pos2/p_initial)+(1-p_pos2)*log2((1-p_pos2)/(1-p_initial)));

P_pos1=[P_pos1,p_pos1];
P_pos2=[P_pos2,p_pos2];
P_y=[P_y,p_y];
H=[H,-h];
M=[M,m];
P_1=[P_1,p1];
out=randsrc(1,1,[1,0;p_y,py_1]);
    if out==1
        p_initial=p_pos1;
    else
        p_initial=p_pos2;
    end
end



X=0:10;
%p_initial=0.1;
p_initial=0.9
P_pos1=[];
P_pos2=[];
P_y=[];
P_1=[];
H=[];
H1=[];
M=[];
for i=1:11
 p1=0.99*exp(-0.01*(10*X(i)))
%p1=1.6*exp(-0.05*(10*X(i)/2+5));
p2=0.9;
p_obs1=p1;
p_obs2=0.1;
p_y=p_initial*p_obs1+p_obs2*(1-p_initial);
py_1=(1-p_obs1)*p_initial+(1-p_obs2)*(1-p_initial);
p_pos1=p_initial*p_obs1/p_y;
p_pos2=p_initial*(1-p_obs1)/py_1;
h=p_y*(p_pos1*log2(p_pos1)+(1-p_pos1)*log2(1-p_pos1))+(1-p_y)*(p_pos2*log2(p_pos2)+(1-p_pos2)*log2(1-p_pos2));

m=p_y*(p_pos1*log2(p_pos1/p_initial)+(1-p_pos1)*log2((1-p_pos1)/(1-p_initial)))+(1-p_y)*(p_pos2*log2(p_pos2/p_initial)+(1-p_pos2)*log2((1-p_pos2)/(1-p_initial)));

P_pos1=[P_pos1,p_pos1];
P_pos2=[P_pos2,p_pos2];
P_y=[P_y,p_y];
H=[H,-h];
M=[M,m];
P_1=[P_1,p1];
end




X=1:10;
X=sort(X,'descend');
p_initial=0.9;
P_pos1=[];
P_pos2=[];
P_y=[];
H=[];
for i=1:10
p1=1.6*exp(-0.05*10*i);
p2=0.9;
p_obs1=1-0.9*(1-p1);
p_obs2=1-0.9*p2;
p_y=p_initial*p_obs1+p_obs2*(1-p_initial);
p_pos1=p_initial*p_obs1/p_y;
p_pos2=p_initial*(1-p_obs1)/(1-p_y);
h=p_y*(p_pos1*log2(p_pos1)+(1-p_pos1)*log2(1-p_pos1))+(1-p_y)*(p_pos2*log2(p_pos2)+(1-p_pos2)*log2(1-p_pos2));
P_pos1=[P_pos1,p_pos1];
P_pos2=[P_pos2,p_pos2];
P_y=[P_y,p_y];
H=[H,-h];
end