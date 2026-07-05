function xprime=add_noise_b(x,beta)

if abs(norm(x)-1)>0.0000001
    error('x not unit norm');
end

w=normrnd(0,1,length(x),1);
w=w-x*(x'*w);
w=w/norm(w);

if abs(w'*x)>0.0000001
    error('noise not orthogonal');
end

if abs(norm(w)-1)>0.0000001
    error('noise not normalized');
end

xprime=(sqrt(1-beta)*x)+(sqrt(beta)*w);

if abs(norm(xprime)-1)>0.0000001
    error('xprime not unit norm');
end

end