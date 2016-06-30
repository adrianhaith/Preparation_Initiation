function Mav = meanNaN(M)
if(isempty(M))
    Mav = NaN;
else
    for i=1:size(M,2)
        iGood = find(~isnan(M(:,i)));
        Mav(i) = mean(M(iGood,i));
    end
end