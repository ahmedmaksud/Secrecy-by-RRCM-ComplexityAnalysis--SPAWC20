function xbarprime=xbar_from_xhat(xhat,N)

temp=[];
for i=1:N
    temp1=xhat(1:N+1-i);
    xhat(1:N+1-i)=[];
    temp2=[zeros(i-1,1);temp1];
    temp=[temp,temp2];
end

temp3=diag(diag(temp));
xbarprime=temp+temp'-temp3;
end