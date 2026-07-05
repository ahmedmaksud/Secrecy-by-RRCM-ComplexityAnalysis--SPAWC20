function [Q,R]=my_QR(M)

[m,n]=size(M);

if n>m
    error('Matrix dimension not compatible');
end

[q,r]=qr(M);
q=q(:,1:n);r=r(1:n,:);
temp=diag(r);
temp=temp./abs(temp);
temp=diag(temp);
Q=q*temp;
R=temp*r;
end