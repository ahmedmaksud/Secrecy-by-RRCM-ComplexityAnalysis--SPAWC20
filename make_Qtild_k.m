function Qtild=make_Qtild_k(y,Q,kk)

[M,N,L,K]=size(Q);

if kk>K
    error('Dimension Over Parsed');
end

for i=kk:kk
    sum=zeros(M,N*N);
    for j=1:L
        temp1=y(:,i)'*Q(:,:,j,i);
        temp2=kron(temp1,Q(:,:,j,i));
        sum=sum+temp2;
    end
end
Qtild=sum;
end