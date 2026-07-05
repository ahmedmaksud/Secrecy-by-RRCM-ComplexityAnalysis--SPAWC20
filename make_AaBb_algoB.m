function  [A,B,aa,bb]=make_AaBb_algoB(Ny,Q,xbarprime,ya_known)

[M,~,~,K]=size(Q);

[Ay,Yprime,z]=make_Ay(Q,xbarprime,ya_known,Ny);
y=Yprime(:);
Ax=make_Ax(Yprime,Q);
Az=make_Az(Yprime);

known_ind=get_ind(M,K,Ny);
[Aya,ya,Ayb,yb]=my_split_2(Ay,y,known_ind);
split_check(Ay,y,Aya,ya,Ayb,yb);

xhat0prime=xhat0_from_xbar(xbarprime);

B=[Ax Ayb Az];
A=Aya;
aa=ya;
bb=[xhat0prime;yb;z];

end