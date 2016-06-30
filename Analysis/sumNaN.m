function Msum = sumNaN(M)
for i=1:size(M,2)
    iGood = find(~isnan(M(:,i)));
    Msum(i) = sum(M(iGood,i));
end