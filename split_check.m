function split_check(Ay,y,Aya,ya,Ayb,yb)

if norm(Ay*y-Aya*ya-Ayb*yb)>0.00000001
    disp('not good split');
end

end