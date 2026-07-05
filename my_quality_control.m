function qc=my_quality_control(x,Qdata,xest,Ny,K,tol)
qc=zeros(1,5);
[Y,~]=get_y(Qdata,x);
[M,~,~,Kdata]=size(Qdata);
Y_est=zeros(M,Kdata);
for i=1:Kdata
    MMt=MMt_from_xbar(Qdata,xest,i);
    [~,Y_est(:,i)]=get_ck_y_from_MMt(MMt);
end

a=Y(1:Ny,1:K);aprime=Y_est(1:Ny,1:K);
b=Y(1:Ny,K+1:end);bprime=Y_est(1:Ny,K+1:end);
c=Y(Ny+1:end,1:K);cprime=Y_est(Ny+1:end,1:K);
d=Y(Ny+1:end,K+1:end);dprime=Y_est(Ny+1:end,K+1:end);

if my_cost_func(a,aprime,tol)
    qc(1)=1;
end

if my_cost_func(b,bprime,tol*5)
    qc(2)=1;
end

if my_cost_func(c,cprime,tol*5)
    qc(3)=1;
end

if my_cost_func(d,dprime,tol*5)
    qc(4)=1;
end

if sum(qc(1:end-1))==0
    qc(5)=1;
end

if sum(qc)<1
    error('not categorized right');
end
end
    