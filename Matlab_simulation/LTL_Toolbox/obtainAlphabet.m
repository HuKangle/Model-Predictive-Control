function alphabet=obtainAlphabet(N_p)
% This function simply creates the alphabet cell array of strings to be
% used in create_buchi.m

pad_no=num2str(length(num2str(N_p+1)));   %number of positions to represent propositions no (e.g. for 2: p01,p02,...)

for i=1:N_p
    alphabet{i}=sprintf(['p%0' pad_no 'd'],i);   %alphabet; we add zeros between 'p' and number
end

alphabet{i+1}=sprintf(['p%0' pad_no 'd'],i+1);   %add a proposition (observable) for the leftover space (i=N_p), name it 'px', x=n_p+1 (n_p - initial number of propositions)
%alphabet has the form {'p01' 'p02' ... 'p10' ...}