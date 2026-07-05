function Qhat=make_Qhat_k(Qtild)

[~,N]=size(Qtild);N=sqrt(N);
Qhat=Qtild;
for i=1:N
    for j=1:N
        if i<j
            temp1=my_flatten(i,j,N);
            temp2=my_flatten(j,i,N);
            Qhat(:,temp1)=Qtild(:,temp1)+Qtild(:,temp2);
        end
    end
end

ind=[];
for i=1:N
    for j=1:N
        if i<j
            ind=[ind my_flatten(j,i,N)];
        end
    end
end

Qhat(:,ind)=[];
end

function temp=my_flatten(i,j,K)
temp=((i-1)*K)+j;
end