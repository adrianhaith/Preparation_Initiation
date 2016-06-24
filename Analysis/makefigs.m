% Initiation paper: Final Analysis and Figures
% first run: analyzeRTfloor, compute_phit, testMLEfit

clear all
clc
load RTfloorData_compact_phit_mle

ss = 2; % Example subject
DELAY = 100;
asymptErr = .95;


%% FIGURE 1
rng_phit = find(d{2}.phitS_times*1000-DELAY>0 & d{2}.phitS_times*1000-DELAY<300);
rng_RT = find(d{1}.RTdens_times*1000-DELAY>0 & d{1}.RTdens_times*1000-DELAY<300);
rng_hist = find(d{1}.RThist_bins*1000-DELAY>0 & d{1}.RThist_bins*1000-DELAY<300);
rng_dens = find(d{1}.RTdens_times*1000-DELAY>0 & d{1}.RTdens_times*1000-DELAY<300);
% make framework figure

figure(4); clf; hold on
xplt = [0:1:800];
plot(xplt,normcdf(xplt,150,50),'linewidth',2)

ypltRT = 15*normpdf(xplt,250,20);
plot(xplt,1.1+ypltRT)
area = trapz(xplt,ypltRT)

yFRT = area/350;
plot([0 50 50 400 400 800],1.1+yFRT*[0 0 1 1 0 0],'g')

%ypltRT = 15*normpdf(xplt,650,20);
%plot(xplt,1.1+ypltRT)

figure(11); clf; hold on
subplot(3,2,1); hold on
plot(1000*d{2}.RT(ss,d{2}.RT(ss,:)<.4 & d{2}.RT(ss,:)>0)-DELAY,d{2}.reachDir(ss,d{2}.RT(ss,:)<.4 & d{2}.RT(ss,:)>0)+180,'o','markersize',3,'markerfacecolor','b');
bar(1000*d{1}.RThist_bins(rng_hist)-DELAY,4*d{1}.RThist(ss,rng_hist))
plot(1000*d{1}.RTdens_times(rng_dens)-DELAY,6*d{1}.RTdens(ss,rng_dens),'g','linewidth',2)
axis([-50 350 0 360])

subplot(3,2,3); hold on
plot(1000*d{2}.phitS_times(1:end-1)-DELAY,d{2}.phitS(ss,:),'b','linewidth',2)
plot(1000*d{2}.RTdens_times-DELAY,1/8 + asymptErr*(7/8)*normcdf(d{2}.RTdens_times,d{2}.pOpt_prep(ss,1),d{2}.pOpt_prep(ss,2)),'b--','linewidth',2)
plot(1000*d{1}.RTdens_times-DELAY,d{1}.RTcdf(ss,:),'g','linewidth',2)
plot(1000*d{1}.RTdens_times-DELAY,normcdf(d{1}.RTdens_times,d{1}.pOpt_init(ss,1),d{1}.pOpt_init(ss,2)),'g--','linewidth',2)
axis([0 300 0 1])

subplot(3,2,5); hold on
plot(1000*d{2}.RTdens_times-DELAY,normpdf(d{2}.RTdens_times,d{2}.pOpt_prep(ss,1),d{2}.pOpt_prep(ss,2)),'b','linewidth',2)
plot(1000*d{1}.RTdens_times-DELAY,normpdf(d{1}.RTdens_times,d{1}.pOpt_init(ss,1),d{1}.pOpt_init(ss,2)),'g','linewidth',2)
plot(1000*d{1}.RTdens_times-DELAY,d{1}.RTdens(ss,:),'g--','linewidth',2)
axis([0 300 0 21])

subplot(3,2,2); hold on

shadederrorbar(1000*d{2}.phitS_times(rng_phit)-DELAY,meanNaN(d{2}.phitS(:,rng_phit)),seNaN(d{2}.phitS(:,rng_phit)),'b',1)
shadederrorbar(1000*d{1}.RTdens_times(rng_RT)-DELAY,meanNaN(d{1}.RTcdf(:,rng_RT)),seNaN(d{1}.RTcdf(:,rng_RT)),'g',1)
axis([0 300 0 1])

subplot(3,2,4); hold on
for i=1:d{2}.Nsubj
    d{2}.init_pdf(i,:) = normpdf(d{2}.RTdens_times,d{2}.pOpt_prep(i,1),d{2}.pOpt_prep(i,2));
end
shadederrorbar(1000*d{2}.RTdens_times(rng_RT)-DELAY,meanNaN(d{2}.init_pdf(:,rng_RT)),seNaN(d{2}.init_pdf(:,rng_RT)),'b',1)
%plot(1000*d{1}.RTdens_times(rng_RT)-DELAY,d{2}.init_pdf(:,rng_RT),'b--','linewidth',1)
shadederrorbar(1000*d{1}.RTdens_times(rng_RT)-DELAY,meanNaN(d{1}.RTdens(:,rng_RT)),seNaN(d{1}.RTdens(:,rng_RT)),'g',1)
%shadederrorbar(1000*d{1}.RTdens_times(rng_RT)-DELAY,meanNaN(d{1}.init_pdf(:,rng_RT)),seNaN(d{1}.init_pdf(:,rng_RT)),'r',1)

%plot(1000*d{1}.RTdens_times-DELAY,d{1}.RTdens,'g--','linewidth',1)
axis([0 300 0 21])

subplot(3,2,6); hold on
plot(1000*d{2}.pOpt_prep(:,1)-DELAY,1000*d{1}.pOpt_init(:,1)-DELAY,'bo','markerfacecolor','b','markersize',4)
plot([0 250],[0 250],'k-')

axis([50 250 50 250])
axis square

%% FIGURE 2
figure(2); clf; hold on
ss = 2;
subplot(3,1,1); hold on
%plot(1000*d{2}.RT(d{2}.RT>.1 & d{2}.RT<.45)-DELAY,d{2}.reachDir(d{2}.RT>.1&d{2}.RT<.45),'o','color',.7*[1 1 1],'markerfacecolor',.7*[1 1 1],'markersize',4)
%plot(1000*d{1}.RT(d{1}.RT>.1 & d{1}.RT<.45)-DELAY,d{1}.reachDir(d{1}.RT>.1&d{1}.RT<.45),'o','color','r','markerfacecolor','r','markersize',4)
plot(1000*d{2}.RT(ss,d{2}.RT(ss,:)>.1 & d{2}.RT(ss,:)<.45)-DELAY,d{2}.reachDir(ss,d{2}.RT(ss,:)>.1&d{2}.RT(ss,:)<.45),'o','color',.7*[1 1 1],'markerfacecolor',.7*[1 1 1],'markersize',3)
plot(1000*d{1}.RT(ss,d{1}.RT(ss,:)>.1 & d{1}.RT(ss,:)<.45)-DELAY,d{1}.reachDir(ss,d{1}.RT(ss,:)>.1&d{1}.RT(ss,:)<.45),'o','color','r','markerfacecolor','r','markersize',3)
axis([0 300 -180 180])

subplot(3,1,2); hold on
plot(1000*d{2}.RTdens_times(rng_RT)-DELAY,normpdf(d{2}.RTdens_times(rng_RT),d{2}.pOpt_prep(ss,1),d{2}.pOpt_prep(ss,2)),'b','linewidth',2)
plot(120*[1 1],[0 15],'g','linewidth',2)

subplot(3,1,3); hold on
plot(d{1}.err_rate,d{1}.p_err_rate,'o','markerfacecolor','b','markersize',4)
plot([0 .2],[0 .2],'k')
axis equal
axis square

%{
%% FIGURE 3
%clear all
DELAY = 100;
load ../../RTcondition/RTconditionData
figure(3); clf; hold on
%subplot(3,3,[2 3]); hold on
subplot(2,4,[1 2]); hold on

srng = [1:4 6:12];
%srng = [1:12];
trng = [49:96];

% eliminate really bad trials
ibad = find(dd.RT>.5 | dd.RT<-.2); % .5 , .2
dd.RT(ibad) = NaN;
dd.hit_ = +dd.hit;
dd.hit_(ibad) = NaN;

disp(['discarded trials = ',num2str(length(ibad)/prod(size(dd.RT))*100),'%'])

ss = 11; % sample subject
sbad = 5; % the 'bad' subject

Nt = 96+4;
Nblocks = 8;
rng_phit = find(dd.phitS_times*1000-DELAY>0 & dd.phitS_times*1000-DELAY<300);
rng_RT = find(dd.RTdens_times*1000-DELAY>0 & dd.RTdens_times*1000-DELAY<300);

plot(repmat(0:Nt:Nblocks*Nt,2,1),repmat([-100 400],Nblocks+1,1)','k','linewidth',2)
plot([Nt*[0:Nblocks-1]' Nt*[1:Nblocks]']',repmat(dd.deadline,2,1)-DELAY,'r','linewidth',2)
for j=1:Nblocks
    %ihit = find(abs(d{2}.reachDir(ss,:,j))<d{2}.tol);
    %d{2}.hitRate(ss,j) = sum(ihit)/Nt;
    %imiss = find(abs(d{2}.reachDir(ss,:,j))>d{2}.tol);
    plot(find(abs(dd.reachDir(ss,:,j))<dd.tol)+(j-1)*Nt,1000*dd.RT(ss,abs(dd.reachDir(ss,:,j))<dd.tol,j)-DELAY,'o','color',.7*[1 1 1],'markerfacecolor',.7*[1 1 1],'markersize',3)
    plot(find(abs(dd.reachDir(ss,:,j))>dd.tol)+(j-1)*Nt,1000*dd.RT(ss,abs(dd.reachDir(ss,:,j))>dd.tol,j)-DELAY,'ro','markerfacecolor','r','markersize',3)
    %plot(imiss+(j-1)*Nt,d{2}.RT(iS,imiss,j)-DELAY,'ro') 
end
axis([0 800 -100 400])

for j=1:8
    dd.RTav(:,j) = meanNaN(dd.RT(:,trng,j)');
    %dd.err_rate(:,j) = meanNaN(abs(dd.reachDir(:,:,j))>dd.tol)';
    dd.RTstd(:,j) = stdNaN(dd.RT(:,trng,j)');
end
%subplot(3,3,4); hold on
subplot(2,4,5); hold on
shadederrorbar(1:8,meanNaN(1000*dd.RTav(srng,:))-DELAY,seNaN(1000*dd.RTav(srng,:)),'go-',1);
plot([[0:Nblocks-1]' [1:Nblocks]']'+.5,repmat(dd.deadline,2,1)-DELAY,'k','linewidth',2)
axis([0 9 0 300])

%subplot(3,3,5); hold on
subplot(2,4,6); hold on
shadederrorbar(1:8,meanNaN(dd.err_rate(srng,:)),seNaN(dd.err_rate(srng,:)),'ro-',1);
axis([0 9 0 .5])

%subplot(3,3,6); hold on
subplot(2,4,7); hold on
shadederrorbar(1:8,meanNaN(1000*dd.RTstd(srng,:)),seNaN(1000*dd.RTstd(srng,:)),'mo-',1);
axis([0 9 0 100])

%subplot(3,3,[7 8]); hold on
subplot(2,4,[3 4]); hold on
shadederrorbar(1000*dF.phitS_times(rng_phit)-DELAY,meanNaN(dF.phitS(srng,rng_phit)),seNaN(dF.phitS(srng,rng_phit)),'b',1);
for j=1:8
    %shadederrorbar(dd.RTdens_t % imes,meanNaN(dd.RTcdf(:,:,j)),seNaN(dd.RTcdf(:,:,j)),'g',1)
    plot(1000*dd.RTdens_times(rng_RT)-DELAY,meanNaN(dd.RTcdf(srng,rng_RT,j)),'color',[0 (j-1)/8 0])
end

%subplot(3,3,9); hold on
subplot(2,4,8); hold on
%figure(5); clf; hold on
sty = {'.','o','^','v','s','x','d','p'};
for j=1:8
    %plot(dd.err_rate(srng,j),dd.err_rate_predicted(srng,j),sty{j},'color',[0 (j-1)/8 0],'markerfacecolor',[1-(j-1)/8 (j-1)/8 0],'markersize',5)
end
plot(dd.err_rate(srng,:),dd.err_rate_predicted(srng,:),'bo','markerfacecolor','b','markersize',3)
plot([0 1],[0 1],'k')
%axis square
axis equal
axis([0 .8 0 .8])
plot(dd.err_rate(sbad,:),dd.err_rate_predicted(sbad,:),'ro','markerfacecolor','r','markersize',3)


%% Experiment 1 stats
clc
ss = 4; % example subject (make sure this agrees with figures!

% compute 10th percentile
for s = 1:10
    d{1}.pctiles(s,:) = prctile(1000*d{1}.RT(s,:)-DELAY,[10 90]);
    d{1}.pctiles95(s,:) = prctile(1000*d{1}.RT(s,:)-DELAY,[10 95]);
end

disp('Experiment 1')
disp('============')
disp(' ')
disp('Example Subject:')
disp([' Mean RT = ',num2str(meanNaN(1000*d{1}.RT(ss,:)'-DELAY))])
disp([' RT variability = ',num2str(stdNaN(1000*d{1}.RT(ss,:)'-DELAY))])
disp([' 10th percentile = ',num2str(mean(d{1}.pctiles(ss,1)))])
disp([' 90th percentile = ',num2str(mean(d{1}.pctiles(ss,2)))])
disp([' 95th percentile = ',num2str(mean(d{1}.pctiles95(ss,2)))])
disp(' ')

disp('All Subjects:')
disp([' Mean RT = ',num2str(mean(meanNaN(1000*d{1}.RT'-DELAY))),' +/- ',num2str(std(meanNaN(1000*d{1}.RT'-DELAY))),'ms std'])
disp([' RT variability = ',num2str(mean(stdNaN(1000*d{1}.RT'-DELAY))),' +/- ',num2str(std(stdNaN(1000*d{1}.RT'-DELAY))),'ms'])
disp(['10th percentile = ',num2str(mean(d{1}.pctiles(:,1))),' +/- ',num2str(std(d{1}.pctiles(:,1)))])
disp(['90th percentile = ',num2str(mean(d{1}.pctiles(:,2))),' +/- ',num2str(std(d{1}.pctiles(:,2)))])
disp(' ')
d{1}.pctile_rng = diff(d{1}.pctiles');

disp('Example subject:')
disp(['  PT mean = ',num2str(1000*d{2}.pOpt_prep(ss,1)-DELAY)])
disp(['  PT std = ',num2str(1000*d{2}.pOpt_prep(ss,2))])
disp(['  diff between prep and initiation = ',num2str(1000*meanNaN(d{1}.RT(ss,:)')-1000*d{2}.pOpt_prep(ss,1))])
disp('  ')
disp('All subjects:')
disp(['  PT mean = ',num2str(mean(1000*d{2}.pOpt_prep(:,1)-DELAY)),' +/- ',num2str(std(1000*d{2}.pOpt_prep(:,1)-DELAY))])
disp(['  PT std = ',num2str(mean(1000*d{2}.pOpt_prep(:,2))),' +/- ',num2str(std(1000*d{2}.pOpt_prep(:,2)))])
disp(' ')

disp(['Diff between prep and initiation = ',num2str(1000*mean(d{1}.pOpt_init(:,1)-d{2}.pOpt_prep(:,1))),' +/- ',num2str(1000*std(d{1}.pOpt_init(:,1)-d{2}.pOpt_prep(:,1)))]);
[t_diff p_diff] = ttest(d{1}.pOpt_init(:,1),d{2}.pOpt_prep(:,1),2,'paired');
disp(['    Difference: t = ',num2str(t_diff),', p = ',num2str(p_diff)])
[rho_corr p_corr] = corr(d{1}.pOpt_init(:,1),d{2}.pOpt_prep(:,1));
disp(['    Correlation: rho = ',num2str(rho_corr),', p = ',num2str(p_corr)])
disp(' ')
disp(['Increase above limit = ',num2str(100*mean((meanNaN(1000*d{1}.RT')'-1000*d{2}.pOpt_prep(:,1))./(1000*d{2}.pOpt_prep(:,1)-DELAY))),'% +/- ',num2str(100*std((meanNaN(1000*d{1}.RT')'-1000*d{2}.pOpt_prep(:,1))./(1000*d{2}.pOpt_prep(:,1)-DELAY)))])
disp(['   Dwell = ',num2str(100*mean((meanNaN(1000*d{1}.RT')'-1000*d{2}.pOpt_prep(:,1))./(meanNaN(1000*d{1}.RT')'-DELAY))),'% of RT'])
disp(' ')

disp('Predicted vs actual error rate:')
[t_pred p_pred] = ttest(d{1}.err_rate,d{1}.p_err_rate,2,'paired');
disp(['    Difference: t = ',num2str(t_pred),', p = ',num2str(p_pred)])
[rho_pred p_pred_corr] = corr(d{1}.err_rate',d{1}.p_err_rate');
disp(['    Correlation: rho = ',num2str(rho_pred),', p = ',num2str(p_pred_corr)])
d{1}.residual = d{1}.err_rate - d{1}.p_err_rate;
r2 = 1-sum(sum(d{1}.residual.^2))/sum(sum((d{1}.err_rate-mean(mean(d{1}.err_rate))).^2));
disp(['    r^2 = ',num2str(r2)])
disp(' ')
disp(' ')
%% Experiment 2 stats




disp('Experiment 2')
disp('============')
disp(' ')
disp('Pressured RT')
disp('------------')
disp(' ')
disp([' Block 1 RT = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,1)'-DELAY))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,1)-DELAY)))])
disp([' Block 2 RT = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,2)'-DELAY))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,2)-DELAY)))])
disp([' Block 7 RT = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,7)'-DELAY))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,7)-DELAY)))])
disp([' Block 8 RT = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,8)'-DELAY))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,8)-DELAY)))])
disp(' ')
disp(['RT Difference 2-1 = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,2)')-meanNaN(1000*dd.RT(srng,trng,1)'))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,2)')-meanNaN(1000*dd.RT(srng,trng,1)')))])
[t_pressure21 p_pressure21] = ttest(meanNaN(dd.RT(srng,trng,1)'),meanNaN(dd.RT(srng,trng,2)'),2,'paired');
disp(['    t = ',num2str(t_pressure21),', p = ',num2str(p_pressure21)])
disp(' ')
disp(['Difference 7-1 = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,7)')-meanNaN(1000*dd.RT(srng,trng,1)'))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,7)')-meanNaN(1000*dd.RT(srng,trng,1)')))])
[t_pressure71 p_pressure71] = ttest(meanNaN(dd.RT(srng,trng,1)'),meanNaN(dd.RT(srng,trng,7)'),2,'paired');
%disp(['    t = ',num2str(t_pressure71),', p = ',num2str(p_pressure71)])
%disp(' ')
disp(['Difference 8-1 = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,8)')-meanNaN(1000*dd.RT(srng,trng,1)'))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,8)')-meanNaN(1000*dd.RT(srng,:,1)')))])
%[t_pressure81 p_pressure81] = ttest(meanNaN(dd.RT(srng,trng,1)'),meanNaN(dd.RT(srng,trng,8)'),2,'paired');
%disp(['    t = ',num2str(t_pressure81),', p = ',num2str(p_pressure81)])
%disp(' ')
disp(['Difference 7-2 = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,7)')-meanNaN(1000*dd.RT(srng,trng,2)'))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,7)')-meanNaN(1000*dd.RT(srng,:,2)')))])
disp(['Difference 8-2 = ',num2str(mean(meanNaN(1000*dd.RT(srng,trng,8)')-meanNaN(1000*dd.RT(srng,trng,2)'))),' +/- ',num2str(std(meanNaN(1000*dd.RT(srng,trng,8)')-meanNaN(1000*dd.RT(srng,:,2)')))])
[t_pressure82 p_pressure82] = ttest(meanNaN(dd.RT(srng,trng,2)'),meanNaN(dd.RT(srng,trng,8)'),2,'paired');
%disp(['    t = ',num2str(t_pressure72),', p = ',num2str(p_pressure72)])
disp(' ')
%{
disp([' Block 1 Err Rate = ',num2str(mean(dd.err_rate(srng,1))),' +/- ',num2str(std(dd.err_rate(srng,1)))]);
disp([' Block 2 Err Rate = ',num2str(mean(dd.err_rate(srng,2))),' +/- ',num2str(std(dd.err_rate(srng,2)))]);
disp([' Block 7 Err Rate = ',num2str(mean(dd.err_rate(srng,7))),' +/- ',num2str(std(dd.err_rate(srng,7)))]);
disp([' Block 8 Err Rate = ',num2str(mean(dd.err_rate(srng,8))),' +/- ',num2str(std(dd.err_rate(srng,8)))]);

disp(['Accuracy Difference 1-2 = ',num2str(100*mean(dd.err_rate(srng,1)-dd.err_rate(srng,2))),'% +/- ',num2str(100*std(dd.err_rate(srng,1)-dd.err_rate(srng,2)))])
[t_acc21 p_acc21] = ttest(dd.err_rate(srng,1),dd.err_rate(srng,2),2,'paired');
disp(['Accuracy Difference 1-7 = ',num2str(100*mean(dd.err_rate(srng,1)-dd.err_rate(srng,7))),'% +/- ',num2str(100*std(dd.err_rate(srng,1)-dd.err_rate(srng,7)))])
[t_acc71 p_acc71] = ttest(dd.err_rate(srng,1),dd.err_rate(srng,7),2,'paired');
disp(['Accuracy Difference 1-8 = ',num2str(100*mean(dd.err_rate(srng,1)-dd.err_rate(srng,8))),'% +/- ',num2str(100*std(dd.err_rate(srng,1)-dd.err_rate(srng,8)))])
[t_acc81 p_acc81] = ttest(dd.err_rate(srng,1),dd.err_rate(srng,8),2,'paired');
%}
disp([' Block 1 Err Rate = ',num2str(100*mean(meanNaN(1-dd.hit(srng,trng,1)'))),' +/- ',num2str(100*std(meanNaN(1-dd.hit(srng,trng,1))))]);
disp([' Block 2 Err Rate = ',num2str(100*mean(meanNaN(1-dd.hit(srng,trng,2)'))),' +/- ',num2str(100*std(meanNaN(1-dd.hit(srng,trng,2))))]);
disp([' Block 7 Err Rate = ',num2str(100*mean(meanNaN(1-dd.hit(srng,trng,7)'))),' +/- ',num2str(100*std(meanNaN(1-dd.hit(srng,trng,7))))]);
disp([' Block 8 Err Rate = ',num2str(100*mean(meanNaN(1-dd.hit(srng,trng,8)'))),' +/- ',num2str(100*std(meanNaN(1-dd.hit(srng,trng,8))))]);
disp([' Difference 2-1:'])
ttest(meanNaN(1-dd.hit(srng,trng,1)'),meanNaN(1-dd.hit(srng,trng,2)'),2,'paired')
disp('Difference 7-1:')
[t_err_rate81 p_err_rate81]= ttest(meanNaN(1-dd.hit(srng,trng,1)'),meanNaN(1-dd.hit(srng,trng,7)'),2,'paired')
disp(' ')
disp(['Accuracy difference 2-1 = ',num2str(100*mean(meanNaN(1-dd.hit(srng,trng,2)')-meanNaN(1-dd.hit(srng,trng,1)'))),' +/- ',num2str(100*std(meanNaN(1-dd.hit(srng,trng,2)')-meanNaN(1-dd.hit(srng,trng,1)')))])
disp(['Accuracy difference 7-1 = ',num2str(100*mean(meanNaN(1-dd.hit(srng,trng,7)')-meanNaN(1-dd.hit(srng,trng,1)'))),' +/- ',num2str(100*std(meanNaN(1-dd.hit(srng,trng,7)')-meanNaN(1-dd.hit(srng,trng,1)')))])
disp(['Accuracy difference 8-1 = ',num2str(100*mean(meanNaN(1-dd.hit(srng,trng,8)')-meanNaN(1-dd.hit(srng,trng,1)'))),' +/- ',num2str(100*std(meanNaN(1-dd.hit(srng,trng,8)')-meanNaN(1-dd.hit(srng,trng,1)')))])
disp(['Accuracy difference 8-1 = ',num2str(100*mean(meanNaN(1-dd.hit(srng,trng,8)')-meanNaN(1-dd.hit(srng,trng,2)'))),' +/- ',num2str(100*std(meanNaN(1-dd.hit(srng,trng,8)')-meanNaN(1-dd.hit(srng,trng,2)')))])
disp(' ')
disp(['Variability difference 7-1 = ',num2str(meanNaN(1000*dd.RTstd(srng,7)-1000*dd.RTstd(srng,1))),' +/- ',num2str(seNaN(1000*dd.RTstd(srng,7)-1000*dd.RTstd(srng,1)))])
[t_var71 p_var71] = ttest(1000*dd.RTstd(srng,7),1000*dd.RTstd(srng,1),2,'paired');
disp(' ')

disp('Forced RT')
disp('---------')
disp(' ')
disp(['Mean preparation time = ',num2str(mean(1000*dF.pOpt(srng,1)-DELAY)),' +/- ',num2str(std(1000*dF.pOpt(srng,1)-DELAY))])
disp(['   Block 1 delay = ',num2str(1000*mean(meanNaN(dd.RT(srng,trng,1)')-dF.pOpt(srng,1)')),' +/- ',num2str(1000*std(meanNaN(dd.RT(srng,trng,1)')-dF.pOpt(srng,1)'))])
disp(['   Block 2 delay = ',num2str(1000*mean(meanNaN(dd.RT(srng,trng,2)')-dF.pOpt(srng,1)')),' +/- ',num2str(1000*std(meanNaN(dd.RT(srng,trng,2)')-dF.pOpt(srng,1)'))])
disp(['   Block 7 delay = ',num2str(1000*mean(meanNaN(dd.RT(srng,trng,7)')-dF.pOpt(srng,1)')),' +/- ',num2str(1000*std(meanNaN(dd.RT(srng,trng,7)')-dF.pOpt(srng,1)'))])
disp(['   Block 8 delay = ',num2str(1000*mean(meanNaN(dd.RT(srng,trng,8)')-dF.pOpt(srng,1)')),' +/- ',num2str(1000*std(meanNaN(dd.RT(srng,trng,8)')-dF.pOpt(srng,1)'))])
disp(' ')

disp('Predicted vs actual error rates:')
[t_pred2 p_pred2] = ttest(reshape(dd.err_rate(srng,:),length(srng)*8,1),reshape(dd.err_rate_predicted(srng,:),length(srng)*8,1),2,'paired');
disp(['    Difference: t = ',num2str(t_pred2),', p = ',num2str(p_pred2)])
[rho_pred2 p_pred_corr2] = corr(reshape(dd.err_rate(srng,:),length(srng)*8,1),reshape(dd.err_rate_predicted(srng,:),length(srng)*8,1));
disp(['    Correlation: rho = ',num2str(rho_pred2),', p = ',num2str(p_pred_corr2)])
dd.residual = dd.err_rate - dd.err_rate_predicted;
r2 = 1-sum(sum(dd.residual(srng,:).^2))/sum(sum((dd.err_rate(srng,:)-mean(mean(dd.err_rate(srng,:)))).^2));
disp(['    r^2 = ',num2str(r2)])
disp(' ')

for i=1:dd.Nsubj
    r2i(i) = 1-sum(dd.residual(i,:).^2)/sum((dd.err_rate(i,:)-mean(dd.err_rate(i,:))).^2);
end

disp(['per subject r^2 = ',num2str(mean(r2i)),' +/- ',num2str(std(r2i))])
disp(['r^2 for erratic subject = ',num2str(r2i(5))])

%% subject demographics:


E1_s = [21 0; 23 1; 24 1; 20 0; 38 1; 18 1; 32 1; 19 0; 20 0; 21 0];
E2_s = [22 0; 23 1; 23 1; 25 1; 21 0; 38 0; 20 1; 24 1; 23 0; 21 1; 19 0; 23 1];

disp(' ')
disp('Subject Demographics')
disp('--------------------')
disp(['    E1: ',num2str(size(E1_s,1)),' subjects, ',num2str(sum(E1_s(:,2))),' Females; Age = ',num2str(mean(E1_s(:,1))),' +/- ',num2str(std(E1_s(:,1)))])
disp(['    E2: ',num2str(size(E2_s,1)),' subjects, ',num2str(sum(E2_s(:,2))),' Females; Age = ',num2str(mean(E2_s(:,1))),' +/- ',num2str(std(E2_s(:,1)))])

subjIDs = {'066','067','068','070','071','073','074','075','076','079','080','081'};


%}
%{
% calculate r^2
dd.residual = dd.err_rate - dd.err_rate_predicted;
r2 = 1-sum(sum(dd.residual(srng,:).^2))/sum(sum((dd.err_rate(srng,:)-mean(mean(dd.err_rate(srng,:)))).^2))


%% check RT distribution
figure(10); clf; hold on
for s=1:10
    subplot(2,5,s); hold on
    hist(d{2}.jump_time(s,d{2}.jump_time(s,:)<1600 & d{2}.jump_time(s,:)>500));
end

figure(11); clf; hold on
for s=1:12
    subplot(2,6,s); hold on
    hist(dF.jump_time(s,dF.jump_time(s,:)<1600 & dF.jump_time(s,:)>500));
end

figure(12); clf; hold on
for s=1:10
    subplot(2,5,s); hold on
    hist(1000*d{2}.RT(s,1000*d{2}.RT(s,:)<500 & 1000*d{2}.RT(s,:)>-100));
end
%}