function Q=get_single_Q(M,N,L)

if N>M
    error('Matrix dimension not compatible');
end

if N>L
    error('Matrix dimension not compatible');
end

Q=zeros(M,N,L);

for i=1:L
    temp=normrnd(0,1,M,N);
    [Q(:,:,i),~]=my_QR(temp);
    ttemp=Q(:,:,i)'*Q(:,:,i)-eye(N);
    if norm(ttemp,'fro')>0.0000001
        error('matrix not unitary');
    end
end
end