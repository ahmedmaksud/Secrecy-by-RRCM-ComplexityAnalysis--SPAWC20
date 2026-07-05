function [xest,Yest,i]=SNS_B(Ny,Q,xbarprime,ya_known,eta,tol,my_iter)

[~,N,~,~]=size(Q);
train=zeros(1,500);

for i=1:my_iter
    [A,B,aa,bb]=make_AaBb_algoB(Ny,Q,xbarprime,ya_known);
    
    [xxx,yyy]=size(B);
    if yyy>xxx || rank(B)<yyy
        rank(B);
        disp('Matrix B not full rank');
        break;
    end
    warning('off','all');
    temp1=((inv(B'*B))*B'*A)*(ya_known-aa);
    bb=bb-eta*temp1;
    
    temp2=[bb(1);1;bb(2:(0.5*N*(N+1)-1))];
    xbarprime=xbar_from_xhat(temp2,N);
    
    train=[train(2:end) norm(ya_known-aa)];
    
    if sum(abs(train-mean(train)))<0.0000001
        i=my_iter;
        break;
    end
    %norm(ya_known-aa)

    if my_cost_func(ya_known,aa,tol)
        break;
    end
end
xest=xbarprime;
[~,Yest,~]=make_Ay(Q,xbarprime,ya_known,Ny);
end