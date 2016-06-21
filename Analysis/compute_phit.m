% compute p(hit)
clear all
load RTfloorData_AgeSum
Nsubj = size(d{1}.reachDir,1);

tol = 22.5; % max error to be considered a 'hit'

dtimes = linspace(0,.7,200);
w = 0.02; % sliding window width;

dt = 1/130;
bins = [0:dt:.7]-dt/2; % bin boundaries

for k=1:2
    % sliding window
    d{k}.Nsubj = Nsubj;
    d{k}.tol = tol;
    for i=1:Nsubj
        for b=1:length(dtimes)-1
            ibin = find(d{k}.RT(i,:)>dtimes(b) & d{k}.RT(i,:)<dtimes(b)+w);
            phitS(i,b) = sum(abs(d{k}.reachDir(i,ibin))<tol)/length(ibin);
        end
    end
    d{k}.phitS = phitS;
    d{k}.phitS_times = dtimes;
    d{k}.phitS_w = w;
          
    % pool across all subjs
    d{k}.RTall = reshape(d{k}.RT,prod(size(d{k}.RT)),1);
    d{k}.reachDirAll = reshape(d{k}.reachDir,prod(size(d{k}.reachDir)),1);
    for b=1:length(dtimes)-1
        ibin = find(d{k}.RTall>dtimes(b) & d{k}.RTall<dtimes(b)+w);
        phitS_all(b) = sum(abs(d{k}.reachDirAll(ibin))<tol)/length(ibin);
    end
    
    % binned
    for i=1:Nsubj
        for b=1:length(bins)-1
            ibin = find(d{k}.RT(i,:)>bins(b) & d{k}.RT(i,:)<bins(b+1));
            phit(i,b) = sum(abs(d{k}.reachDir(i,ibin))<tol)/length(ibin);
        end
    end
    d{k}.phit = phit;
    d{k}.phit_bins = bins;
    d{k}.phitS_all = phitS_all;
end

%% compute densities and histograms
densTimes = [0:.001:.5];
histBins = [0:.01:.5];
histBins2 = [0.1:1/130:.5];
for k=1:2
    for i=1:Nsubj
        RTdens(i,:) = ksdensity(d{k}.RT(i,:),densTimes,'width',.005);
        RThist(i,:) = hist(d{k}.RT(i,:),histBins2);
    end
    d{k}.RTdens = RTdens;
    d{k}.RThist = RThist;
    d{k}.RTcdf = cumsum(RTdens,2)./repmat(sum(RTdens,2),1,size(RTdens,2));
    
    d{k}.RTdens_times = densTimes;
    d{k}.RThist_bins = histBins2;
    
    RTdens_all = ksdensity(d{k}.RTall,densTimes,'width',.005);
    RThist_all = hist(d{k}.RTall,histBins2);  
    d{k}.RThist_bins2 = histBins2;
    d{k}.RTdens_all = RTdens_all;
    d{k}.RThist_all = RThist_all;
end

% intended jump time
for i=1:Nsubj
    d{2}.RT_targ(i,:) = (1500-d{2}.jump_time(i,:))*.001;
end

save RTfloorData_AgeSum d

