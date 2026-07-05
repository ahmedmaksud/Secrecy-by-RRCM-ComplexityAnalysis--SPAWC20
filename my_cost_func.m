function my_bool=my_cost_func(Y,Yest,tol)

mb=size(Y)~=size(Yest);
if mb(1)||mb(2)
    error('matrix dimension not match')
end


tttemp=min([abs(Y(:)-Yest(:)) abs(Y(:)+Yest(:))],[],2);
if ~any(tttemp>tol)
    my_bool=true;
else
    my_bool=false;
end
end