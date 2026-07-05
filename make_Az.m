function Cz=make_Az(Y)

[~,K]=size(Y);
temp1=zeros(1,K);

temp2=[];
for i=1:K
    temp2=blkdiag(temp2,Y(:,i));
end

temp3=zeros(K,K);

Cz=[temp1;-temp2;temp3];

end