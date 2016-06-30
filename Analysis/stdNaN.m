function s = stdNaN(x)
if(isempty(x))
    s = NaN;
else
    for i=1:size(x,2)
        igood = find(~isnan(x(:,i)));
        if(isempty(igood))
            s(i) = NaN;
        else
            s(i) = std(x(find(~isnan(x(:,i))),i));
        end
    end
end