X=2:10;
X=sort(X,'descend');
p_initial=0.1;
p1=p_initial;
p2=p_initial;
P_pos1=[];
P_pos2=[];
P_y=[];
H=[];
H1=[];
E=[];
for i=1:9
p1=1.6*exp(-0.05*5*X(i));
p2=0.9;
p_obs1=1-0.9*(1-p1);
p_obs2=1-0.9*p2;
p_y=p_initial*p_obs1+p_obs2*(1-p_initial);
p_pos1=p1*p_obs1/(p1*p_obs1+p_obs2*(1-p1));
p_pos2=p2*(1-p_obs1)/(p2*(1-p_obs1)+(1-p_obs2)*(1-p2));
p1=p_pos1;
p2=p_pos2;
P_pos1=[P_pos1,p_pos1];
P_pos2=[P_pos2,p_pos2];
h=p_y*(p_pos1*log2(p_pos1)+(1-p_pos1)*log2(1-p_pos1))+(1-p_y)*(p_pos2*log2(p_pos2)+(1-p_pos2)*log2(1-p_pos2));
h1=p_y*(p_pos1*log2(p_pos1)+(1-p_pos1)*log2(1-p_pos1));
e=h*p_y;
P_y=[P_y,p_y];
H=[H,-h];
E=[E,-e];
H1=[H1,-h1];
end



X=1:10;
X=sort(X,'descend');
p_initial=0.5;
p1=p_initial;
p2=p_initial;
P_pos1=[];
P_pos2=[];
P_y=[];
H=[];
H1=[];
E=[];
for i=1:10
p1=1.6*exp(-0.025*10*i);
p2=0.9;
p_obs1=1-0.9*(1-p1);
p_obs2=1-0.9*p2;
p_y=p_initial*p_obs1+p_obs2*(1-p_initial);
p_pos1=p1*p_obs1/(p1*p_obs1+p_obs2*(1-p1));
p_pos2=p2*(1-p_obs1)/(p2*(1-p_obs1)+(1-p_obs2)*(1-p2));
p1=p_pos1;
p2=p_pos2;
P_pos1=[P_pos1,p_pos1];
P_pos2=[P_pos2,p_pos2];
h=p_y*(p_pos1*log2(p_pos1)+(1-p_pos1)*log2(1-p_pos1))+(1-p_y)*(p_pos2*log2(p_pos2)+(1-p_pos2)*log2(1-p_pos2));
P_y=[P_y,p_y];
H=[H,-h];
end
