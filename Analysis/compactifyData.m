% tidy up data structure
clear all
load RTfloorData_full

%%
clear d
for i=1:Nsubj % subjects
    for j=1:2 % conditions
        d{j}.reachDir(i,:) = data{i,j}.reachDir; % reach direction relative to target
        d{j}.RT(i,:) = data{i,j}.RT; % reaction time (between targ appearance and movement initiation
        d{j}.reachDir_absolute(i,:) = data{i,j}.reachDir_absolute;%360*(data{i,j}.target_post_jump'-2)/8; % 
        d{j}.pkVel(i,:) = data{i,j}.pkVel;
    end

    %d{j}.icatch = find(data{i,2}.jump_time);
    
    %d{2}.jump_time(i,:) = data{i,2}.jump_time;
    
end

save RTfloorData_compact d
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