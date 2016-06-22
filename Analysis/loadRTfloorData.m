% load Experiment 1 data
clear all

subjnames = {'VJH101213','ZP101213'}; % subject IDs
%conditions = {'A','B'}; % A = FreeRT, B = ForcedRT
blocks{1} = {'A1'}; % FreeRT block names
blocks{2} = {'B1','B2'}; % ForcedRT block names

Nsubj = length(subjnames);

for i=1:Nsubj
    for k=1:2
        data{i,k} = loadTRsubjData(subjnames{i},blocks{k});
    end
end
%{
    for k = 1:length(blocks);
        clear X; clear Y; clear jump_time; clear target; clear target_post; clear start; clear jump; clear tFileAll;
        tFileAll = [];
        trial = 1;
        for blk=1:length(blocks{k})
            disp(['Subject ',num2str(i),', ',conditions{k},', Block: ',num2str(blocks{k}(blk))]);
            path = ['../Data/',subjnames{i},'/',conditions{k}];
            tFile = dlmread([path,num2str(blocks{k}(blk)),'/tFile.tgt'],' ',1,0);
            Ntrials = size(tFile,1);
            X0 = tFile(1,1);
            Y0 = tFile(1,2);
            fnames = dir([path,num2str(blocks{k}(blk))]);
            for j=1:Ntrials
                d = dlmread([path,num2str(blocks{k}(blk)),'/',fnames(j+2).name],' ',6,0);
                X{trial} = d(3:4:end,3)-X0;
                Y{trial} = d(3:4:end,4)-Y0;
                jump_time(trial) = tFile(j,8);
                target(trial,1) = tFile(j,3);
                target(trial,2) = tFile(j,4);
                target_post(trial,1) = tFile(j,6);
                target_post(trial,2) = tFile(j,7);
                start(trial,1:2) = tFile(j,1:2);
                jump(trial) = tFile(j,5); % jump trial flag
                tFileAll = [tFileAll; tFile];
                trial = trial+1;
            end
        end
        
        targAng = atan2(target(:,2)-start(:,2),target(:,1)-start(:,1));
        data{i,k}.target = mod(ceil(targAng*4/pi - .01),8);
        targAngPost = atan2(target_post(:,2)-start(:,2),target_post(:,1)-start(:,1));
        data{i,k}.target_post_jump = mod(ceil(targAngPost*4/pi - .01),8);
        data{i,k}.targAngPost = targAngPost;
        data{i,k}.X = X;
        data{i,k}.Y = Y;

        data{i,k}.Ntrials = size(target,1);
        data{i,k}.jump = jump;
        data{i,k}.jump_time = jump_time;

        data{i,k}.Xunrot = X;
        data{i,k}.Yunrot = Y;
        data{i,k}.X0 = X0;
        data{i,k}.Y0 = Y0;

        ijmp = 1;
        for j=1:data{i,k}.Ntrials % iterate through all trials
            %theta = -((2-data{i,k}.target)/8)*2*pi;
            theta(j) = -(targAngPost(j)-pi/2);
            R = [cos(theta(j)) -sin(theta(j)); sin(theta(j)) cos(theta(j))];
            %R = eye(2);
            data{i,k}.handPos{j} = (R*[data{i,k}.X{j}';data{i,k}.Y{j}'])';
                       
            data{i,k}.X{j} = data{i,k}.handPos{j}(:,1);
            data{i,k}.Y{j} = data{i,k}.handPos{j}(:,2);
            
            
            %figure(1); clf; hold on

            %{
            clf; hold on
            plot(data{1,1}.Xunrot{j},data{1,1}.Yunrot{j},'r')
            plot(data{1,1}.X{j},data{1,1}.Y{j})
            plot(target_post(j,1)-X0,target_post(j,2)-Y0,'ko')
            axis equal
            keyboard
            %}
            
        end

        iJmp = find(data{i,k}.jump);
        dat{i,k} = getSubset(data{i,k},iJmp);

        % no jump trials
        %iNoJmp = find(1-data{i,k}.jump);
        %datNJ{i,k} = getSubset(data{i,k},iNoJmp);
        
        for j=1:dat{i,k}.Ntrials
            if(mod(dat{i,k}.target(j) - dat{i,k}.target_post_jump(j),8)==7)
                %dat{i,k}.X{j} = -dat{i,k}.X{j}; % flip CCW jumps
            end
        end

        dat{i,k} = getErr_fixedT(dat{i,k});
        %datNJ{i,k} = getErr_fixedT(datNJ{i,k});

        dat{i,k}.reachDir = -dat{i,k}.reachDir;
    end
end
data = dat;
%dataNJ = datNJ;
%}
save RTfloorData
%%


%%
% load choice RT data
%{
for k=1:2
    for i=1:length(subjnames)
        disp(['Subject ',num2str(i),', ',conditions{k},', Block: RT']);
        path = ['Data/',subjnames{i},'/',conditions{k}];
        tFile = dlmread([path,'/RT/tFile.tgt'],' ',1,0);
        fnames = dir([path,'/RT']);
        for j=1:Ntrials
            d = dlmread([path,'/RT/',fnames(j+2).name],' ',6,0);
            X_rt{j} = d(3:4:end,3);
            Y_rt{j} = d(3:4:end,4);
            jump_time_rt(j) = tFile(j,8);
            target_rt(j,1) = tFile(j,3);
            target_rt(j,2) = tFile(j,4);
            target_post_rt(j,1) = tFile(j,6);
            target_post_rt(j,2) = tFile(j,7);
            start_rt(j,1:2) = tFile(j,1:2);
            jump_rt(j) = tFile(j,5); % jump trial flag
        end
        
        targAng_rt = atan2(target_rt(:,2)-start_rt(:,2),target_rt(:,1)-start_rt(:,1));
        data_rt{i,k}.target = mod(ceil(targAng_rt*4/pi - .01),8);
        targAngPost_rt = atan2(target_post_rt(:,2)-start_rt(:,2),target_post_rt(:,1)-start_rt(:,1));
        data_rt{i,k}.target_post_jump = mod(ceil(targAngPost_rt*4/pi - .01),8);
        data_rt{i,k}.X = X_rt;
        data_rt{i,k}.Y = Y_rt;
        data_rt{i,k}.Xunrot = X_rt;
        data_rt{i,k}.Yunrot = Y_rt;
        data_rt{i,k}.Ntrials = size(target_rt,1);
        data_rt{i,k}.jump = jump_rt;
        data_rt{i,k}.jump_time = jump_time_rt;
        X0 = tFile(1,1);
        Y0 = tFile(1,2);
        data_rt{i,k}.X0 = X0;
        data_rt{i,k}.Y0 = Y0;
        
        for j=1:data_rt{i,k}.Ntrials % iterate through all trials
            theta = -((2-data_rt{i,k}.target_post_jump)/8)*2*pi;
            R = [cos(theta(j)) sin(theta(j)); -sin(theta(j)) cos(theta(j))];
            
            data_rt{i,k}.handPos{j} = (R*[data_rt{i,k}.X{j}'-X0;data_rt{i,k}.Y{j}'-Y0])';
            
            data_rt{i,k}.X{j} = data_rt{i,k}.handPos{j}(:,1);
            data_rt{i,k}.Y{j} = data_rt{i,k}.handPos{j}(:,2);
        end
        
        data_rt{i,k} = getErr(data_rt{i,k});
    end
end


save TJ_obst data dataNJ data_rt subjnames
%}

