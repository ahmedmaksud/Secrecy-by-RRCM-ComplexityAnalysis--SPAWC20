function Qdata=gen_Q_data(M,N,L,K)

Qdata=zeros(M,N,L,K);

for i=1:K
    Qdata(:,:,:,i)=get_single_Q(M,N,L);
end
end