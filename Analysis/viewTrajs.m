function viewTrajs(data,rng)

figure(1); clf; hold on

for i=1:length(rng)
    ii = rng(i);
    clf; hold on
    plot(data.handPos{ii}(1,data.iInit(ii):data.iEnd(ii)),data.handPos{ii}(2,data.iInit(ii):data.iEnd(ii)),'r')
    plot(data.handPos_rotated{ii}(1,data.iInit(ii):data.iEnd(ii)),data.handPos_rotated{ii}(2,data.iInit(ii):data.iEnd(ii)),'g')
    plot(data.targPos(ii,1),data.targPos(ii,2),'o','markersize',20)
    plot(data.handPos{ii}(1,data.iDir(ii)),data.handPos{ii}(2,data.iDir(ii)),'r.','markersize',16)
    plot(data.handPos_rotated{ii}(1,data.iDir(ii)),data.handPos_rotated{ii}(2,data.iDir(ii)),'g.','markersize',16)
    axis equal
    
    text(0,.02,['reachDir = ',num2str(data.reachDir(ii))])
    text(0,.015,['reachDirAbsolute = ',num2str(data.reachDir_absolute(ii))])
    text(0,.01,['targAng = ',num2str(data.targAng(ii))])
    pause
end