function [y,sigma]=get_y(Q,x)

[M,~,~,K]=size(Q);
y=zeros(M,K);sigma=zeros(1,K);
for i=1:K
    [y(:,i),sigma(i)]=get_single_y(Q(:,:,:,i),x);
end
end