function knownind=get_ind(M,K,Ny)

knownind=[];

for i=1:K
    for j=1:Ny
        knownind=[knownind (i-1)*M+j];
    end
end
end