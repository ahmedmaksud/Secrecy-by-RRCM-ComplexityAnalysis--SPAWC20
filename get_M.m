function M=get_M(Q,x)

[dimM,~,L]=size(Q);
M=zeros(dimM,L);

for i=1:L
    M(:,i)=Q(:,:,i)*x;
end
end