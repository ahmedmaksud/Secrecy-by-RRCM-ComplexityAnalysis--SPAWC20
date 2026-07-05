function yynew=allign_yy(yy,ya_known,k,Ny)

temp1=ya_known((((k-1)*Ny)+1):(k*Ny));
temp2=yy(1:Ny);

if norm(temp1-temp2)<norm(temp1+temp2)
    yynew=yy;
else
    yynew=-yy;
end
end