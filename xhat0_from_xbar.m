function xhat0=xhat0_from_xbar(xbar)

[N,~]=size(xbar);
xhat0=[];

for i=1:N
    xhat0=[xhat0;xbar(i:end,i)];
end
xhat0(2)=[];
end