% tidy up data structure
clear all
load RTfloorData_Age

%%
clear d
for i=1:Nsubj
    for j=1:2
        d{j}.reachDir(i,:) = data{i,j}.reachDir;
        d{j}.curvature(i,:) = data{i,j}.d_dir;
        d{j}.RT(i,:) = data{i,j}.rPT;
        
        d{j}.reachDirG(i,:) = d{j}.reachDir(i,:)-360*(data{i,j}.target_post_jump'-2)/8;
        ibad = find(d{j}.reachDirG>180+22.5);
        d{j}.reachDirG(ibad)=d{j}.reachDirG(ibad)-360;
        ibad = find(d{j}.reachDirG<-180+22.5);
        d{j}.reachDirG(ibad)=d{j}.reachDirG(ibad)+360;
        
        d{j}.pkVel(i,:) = data{i,j}.pkVel;
        d{j}.velDir(i,:) = data{i,j}.velDir;
        %dd{j}.jump_time = data{i,j}.jump_time;
    end
    %d{4}.reachDir(i,:) = [d{1}.reachDir(i,:) d{3}.reachDir(i,:)];
    %d{4}.reachDirG(i,:) = [d{1}.reachDirG(i,:) d{3}.reachDirG(i,:)];
    %d{4}.RT(i,:) = [d{1}.RT(i,:) d{3}.RT(i,:)];
    %d{4}.curvature(i,:) = [d{1}.curvature(i,:) d{3}.curvature(i,:)];
    
    icatch = find(data{i,2}.jump_time);
    
    d{2}.jump_time(i,:) = data{i,2}.jump_time;
    
end

save RTfloorData_AgeSum d
%%
% check absolute reach direction
%{
figure(1); clf; hold on
l= .05;
for i=12:20
    
    cla
    s = 1; j = 1;
    plot(data{s,j}.X{i},data{s,j}.Y{i},'k')
    axis equal
    plot(data{s,j}.Xunrot{i},data{s,j}.Yunrot{i},'g')
    plot([0 l*sin(data{s,j}.reachDir(i)*pi/180)],[0 l*cos(data{s,j}.reachDir(i)*pi/180)],'k--')
    plot([0 l*sin(d{j}.reachDirG(s,i)*pi/180)],[0 l*cos(d{j}.reachDirG(s,i)*pi/180)],'g--')
    disp(['Trial Num: ',num2str(i),'  Relative Reach Dir: ',num2str(data{s,j}.reachDir(i)),'  Absolute Reach Dir: ',num2str(d{j}.reachDirG(s,i))])
    pause
end
%}