function [Ay,Ynew,z]=make_Ay(Q,xbar,ya_known,Ny)

[M,~,~,K]=size(Q);

temp3=[];temp4=[];Ynew=[];z=[];

for i=1:K
    MMt=MMt_from_xbar(Q,xbar,i);
    [sigma,yy]=get_ck_y_from_MMt(MMt);
    yynew=allign_yy(yy,ya_known,i,Ny);
    z=[z;sigma];
    Ynew=[Ynew,yynew];
    MMt=MMt-sigma*eye(M);
    temp3=blkdiag(temp3,MMt);
    temp4=blkdiag(temp4,yy');
end
    Ay=[zeros(1,M*K);temp3;temp4];
end