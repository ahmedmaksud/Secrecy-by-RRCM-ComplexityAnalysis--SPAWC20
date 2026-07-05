function [sigma,yy]=get_ck_y_from_MMt(MMt)

[V,D]=eig(MMt);
D=diag(D);
pos=proces_D(D);
sigma=D(pos);
yy=V(:,pos);
end