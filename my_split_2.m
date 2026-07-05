function [Aya,ya,Ayb,yb]=my_split_2(Ay,y,known_ind)

ya=[];Aya=[];
for i=1:length(known_ind)
    temp=known_ind(i);
    ya=[ya;y(temp)];
    Aya=[Aya Ay(:,temp)];
end

Ay(:,known_ind)=[];
y(known_ind)=[];

Ayb=Ay;yb=y;

end