function xbarprime=get_xbar_prime_from_xprime(xprime)

temp0=xprime*xprime';
temp1=temp0(1,2);
alpha=1-(1/temp1);
[N,~]=size(temp0);
xbarprime=alpha*eye(N)+(1-alpha)*temp0;

if abs(xbarprime(1,2)-1)>0.0000001 || abs(xbarprime(2,1)-1)>0.0000001
    error('transformation not correct');
end
end

