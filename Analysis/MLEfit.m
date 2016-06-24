% estimate parameters of cumulative distribution
clear all
load RTfloorData_compact_phit
figure(1); clf; hold on
Nsubj = size(d{2}.RT,1);
for s = 1:Nsubj;
    RT = d{2}.RT(s,:);
    reachDir = d{2}.reachDir(s,:);
    hit = abs(d{2}.reachDir(s,:))<22.5;
    
    igood = find(RT>0 & RT < 1 & ~isnan(reachDir));
    RT = RT(igood);
    reachDir = reachDir(igood);
    hit = hit(igood);
    d{2}.hit{s} = hit;
    d{2}.RTgood{s} = RT;
    d{2}.reachDirGood{s} = reachDir;
    
    ibad = find(d{1}.RT>.5);
    d{1}.RT(ibad) = NaN;
    d{1}.reachDir(ibad) = NaN;
    
    
    subplot(1,2,s); hold on
    plot(RT(find(hit)),reachDir(find(hit)),'k.','markersize',15)
    plot(RT(find(1-hit)),reachDir(find(1-hit)),'r.','markersize',15)
   
    %
    sigma = .1;
    mu = .3;
    asymptErr = .9;
    
    xplot = [0:.001:.5];
    %ycdf = normcdf(xplot,mu,sigma);
    %ypdf = normpdf(xplot,mu,sigma);
    %figure(s);
    %plot(xplot,100*ycdf);
    %plot(xplot,5*ypdf,'r');
    
    AE = .95;
    LLall = hit.*log((1/8+AE*normcdf(RT,mu,sigma)*7/8)) + (1-hit).*log(1-(1/8+AE*normcdf(RT,mu,sigma)*7/8));
    
    %LL = @(params) -sum(hit.*log((1/8+params(3)*normcdf(RT,params(1),params(2))*7/8)) + (1-hit).*log(1-(1/8+params(3)*normcdf(RT,params(1),params(2))*7/8)));
    LL = @(params) -sum(hit.*log((1/8+asymptErr*normcdf(RT,params(1),params(2))*7/8)) + (1-hit).*log(1-(1/8+asymptErr*normcdf(RT,params(1),params(2))*7/8)));
    
    % RTcdf
    %figure(2); clf; hold on
    %plot(xplot,1/8+.95*7*normcdf(xplot,mu,sigma)/8)
    
    %LL([mu sigma asymptErr])
    LL([mu sigma])
    
    pOpt(s,:) = fminsearch(LL,[mu sigma]);
    ycdf = normcdf(xplot,pOpt(s,1),pOpt(s,2));
    ypdf = normpdf(xplot,pOpt(s,1),pOpt(s,2));
    plot(xplot,100*ycdf,'b','linewidth',2);
    plot(xplot,5*ypdf,'b','linewidth',2);
    
    % free RT condition
    RT = d{1}.RT(s,:);
    reachDir = d{1}.reachDir(s,:);
    hit = abs(d{1}.reachDir(s,:))<20;
    
    LL = @(params) -sum(hit.*log((1/8+params(3)*normcdf(RT,params(1),params(2))*7/8)) + (1-hit).*log(1-(1/8+params(3)*normcdf(RT,params(1),params(2))*7/8)));
    pOptRThit(s,:) = fminsearch(LL,[mu sigma asymptErr]);
end

figure(2); clf; hold on 
for s=1:Nsubj
    ycdf = normcdf(xplot,pOpt(s,1),pOpt(s,2));
    ypdf = normpdf(xplot,pOpt(s,1),pOpt(s,2));
    %plot(xplot,100*ycdf,'b','linewidth',2);
    plot(xplot,5*ypdf,'b','linewidth',2);
end

%% compare to RT distribution for same subject
for s=1:Nsubj
    muRT(s) = meanNaN(d{1}.RT(s,:)');
    sigmaRT(s) = stdNaN(d{1}.RT(s,:)');
    ypdf = normpdf(xplot,muRT(s),sigmaRT(s));
%    plot(d{1}.RTdens_times,d{1}.RTdens(s,:),'g','linewidth',2)
    plot(xplot,5*ypdf,'g','linewidth',2);
end

for s=1:Nsubj
    ypdf = normpdf(xplot,pOptRThit(s,1),pOptRThit(s,2));
    %plot(xplot,5*ypdf,'r','linewidth',2)
    axis([0 .5 0 150])
end

%
figure(3); clf; hold on
for s=1:Nsubj
    subplot(1,2,s); hold on
    plot(xplot,normpdf(xplot,pOpt(s,1),pOpt(s,2)),'b','linewidth',2);
    plot(xplot,normpdf(xplot,muRT(s),sigmaRT(s)),'g','linewidth',2)
    axis([0 .5 0 25])
end

%% mean diff
delta = muRT'-pOpt(:,1);
mean(delta)
disp(['diff initiation - planning = ',num2str(mean(1000*delta)),' +/- ',num2str(std(1000*delta))])

%% plot smoothed Gaussians
figure(4); clf; hold on
for s=1:Nsubj
    planPDF(s,:) = normpdf(xplot,pOpt(s,1),pOpt(s,2));
    planCDF(s,:) = normcdf(xplot,pOpt(s,1),pOpt(s,2));
    initPDF(s,:) = normpdf(xplot,muRT(s),sigmaRT(s));
    initCDF(s,:) = normcdf(xplot,muRT(s),sigmaRT(s));
end
shadederrorbar(xplot,mean(planPDF),std(planPDF)/sqrt(10),'b',1)
shadederrorbar(xplot,mean(initPDF),std(initPDF)/sqrt(10),'g',1)

%%
figure(5); clf; hold on
subplot(1,2,1); hold on
plot([0 1],[pOpt(:,1) muRT'],'k.-')
xlabel('planning / initiation')
ylabel('mean time / s')
subplot(1,2,2); hold on
plot([0 1],[pOpt(:,2) sigmaRT'],'k.-')
xlabel('planning / initiation')
ylabel('variability / s')

[t p] = ttest(pOpt(:,1),muRT',2,'paired')

%% overlap probability
for s=1:Nsubj
    p_err(s) = normcdf(0,muRT(s)-pOpt(s,1),sqrt(pOpt(s,2)^2+sigmaRT(s)^2));
end

%% compare gaussian fit to nonparametric estimate
figure(6); clf; hold on
for s=1:Nsubj
    subplot(1,2,s); hold on
    plot(xplot-.1,1/8+asymptErr*planCDF(s,:)*7/8,'b','linewidth',2)
    plot(d{2}.phitS_times(1:end-1)-.1+d{2}.phitS_w/2,d{2}.phitS(s,:),'k','linewidth',2)
end

%%
figure(7); clf; hold on
rtblock = 1;
for s=1:Nsubj
    subplot(1,2,s); hold on
    plot(d{rtblock}.RT(s,:),d{rtblock}.reachDir(s,:),'.','markersize',15)
    axis([0 .5 -100 100])
    
    d{rtblock}.hit(s,:) = abs(d{rtblock}.reachDir(s,:))<22.5;
    d{rtblock}.err_rate(s) = mean(1-d{rtblock}.hit(s,:));
end

figure(8); clf; hold on
%plot(log(p_err'),log(d{1}.err_rate'),'o')
plot(p_err',d{rtblock}.err_rate','o')
plot([0 .2],[0 .2],'k-')
axis equal
xlabel('model p(err)')
ylabel('observed p(err)')
[rho p] = corr(p_err',d{rtblock}.err_rate')

figure(9); clf; hold on
plot(delta,d{rtblock}.err_rate','ko')
xlabel('initiation latency')
ylabel('error rate')

figure(10); clf; hold on
for s=1:Nsubj
    p_err_thr(s) = normcdf(pOpt(s,1),muRT(s),sigmaRT(s))
end
plot(d{rtblock}.err_rate',p_err_thr,'o')
axis equal
plot([0 .15],[0 .15],'k')
[rho p] = corr(p_err_thr',d{rtblock}.err_rate')
xlabel('observed error rate')
ylabel('predicted marginal error rate')
%% compare mean initiation time and mean planning time
figure(11); clf; hold on
plot(pOpt(:,1),muRT,'ko');
axis equal
axis([.18 .35 .18 .35])
plot([.15 .35],[.15 .35],'k')
[rho p] = corr(pOpt(:,1),muRT')
xlabel('Planning mean')
ylabel('Initiation mean')

%% more exact prediction of error rate
for s=1:Nsubj
    p_err_precise_all(s,:) = 1-(1/8 + normcdf(d{rtblock}.RT(s,:),pOpt(s,1),pOpt(s,2))*7/8);
    p_err_precise(s) = 1-(1/8+meanNaN(normcdf(d{rtblock}.RT(s,:),pOpt(s,1),pOpt(s,2))')*7/8);
end
figure(12); clf; hold on
plot(d{rtblock}.err_rate,p_err_precise,'ko','linewidth',2)
xlabel('actual error rate')
ylabel('RT-specific predicted error rate')
[rho p] = corr(d{rtblock}.err_rate',p_err_precise')
plot([0 .2],[0 .2],'k')
axis equal
%axis([0 .2 0 .2])

%% show free RT misses
figure(13); clf; hold on
for s=1:Nsubj
    subplot(1,2,s); hold on
    plot(d{2}.RT(s,:),d{2}.reachDir(s,:),'.','color',.7*[1 1 1],'markersize',15)
    plot(d{rtblock}.RT(s,find(d{rtblock}.hit(s,:))),d{rtblock}.reachDir(s,find(d{rtblock}.hit(s,:))),'k.','markersize',15)
    plot(d{rtblock}.RT(s,find(1-d{rtblock}.hit(s,:))),d{rtblock}.reachDir(s,find(1-d{rtblock}.hit(s,:))),'r.','markersize',15)
    axis([0 .5 -180 180])
end

d{2}.pOpt_prep = pOpt;
d{1}.pOpt_init = [muRT' sigmaRT'];
d{1}.p_err_pred = p_err_precise_all;
d{1}.p_err_rate = p_err_precise;

save RTfloorData_compact_phit_mle d