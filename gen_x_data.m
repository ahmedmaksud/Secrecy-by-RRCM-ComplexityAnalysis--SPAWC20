function x=gen_x_data(n)
temp=normrnd(0,1,n,1);
temp=temp/(norm(temp));
x=temp;
end