function MMt=MMt_from_xbar(Q,xbar,k)

[M,~,L,~]=size(Q);
ttemp=zeros(M,M);
    for j=1:L
        temp1=Q(:,:,j,k);
        temp2=temp1*xbar*temp1';
        ttemp=ttemp+temp2;
    end
MMt=ttemp;
end