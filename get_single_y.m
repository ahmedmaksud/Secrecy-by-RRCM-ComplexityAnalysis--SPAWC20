function [y,s]=get_single_y(Q,x)

M=get_M(Q,x);
MMt=M*M';
[y,s,~]=svds(MMt,1);
end