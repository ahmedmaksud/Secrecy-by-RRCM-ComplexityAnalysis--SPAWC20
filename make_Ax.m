function Ax=make_Ax(y,Q)

[~,N,~,K]=size(Q);
c=make_c(N);
Ax=[];
for i=1:K
    Qtild=make_Qtild_k(y,Q,i);
    Qhat=make_Qhat_k(Qtild);
    Ax=[Ax;Qhat];
end
Ax=[c;Ax;zeros(K,0.5*N*(N+1))];
Ax(:,2)=[];
end

function c=make_c(N)
c=[];
for i=1:N
    temp=[1,zeros(1,(N-i))];
    c=[c,temp];
end
end