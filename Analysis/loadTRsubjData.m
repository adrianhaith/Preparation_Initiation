function [data] = loadTJsubjData(subjID,blocknames)
% load a single subject's timed response target jump data
%
% Input:    subjname    - string containing subject ID, e.g. 'S01'
%           blocknames  - cell array containing blocknames to be loaded
%                         together and concatenated, e.g. {'B1','B2'}
%
% Output:   data - data structure containing data from these blocks

Nblocks = length(blocknames);
trial = 1;
tFile = [];
for blk=1:Nblocks
    path = ['../Data/',subjID,'/',blocknames{blk}]; % data path
    disp(path);
    tF = dlmread([path,'/tFile.tgt'],' ',1,0);
    fnames = dir(path);
    Ntrials = size(tF,1);
    for i=1:Ntrials
        d = dlmread([path,'/',fnames(i+2).name],' ',6,0);
        X{trial} = d(3:4:end,3); % hand X location
        Y{trial} = d(3:4:end,4); % hand Y location
        trial = trial+1;
    end
    tFile = [tFile; tF];
end
X0 = tFile(1,1); % start position x
Y0 = tFile(1,2); % start position y

data.targPos = tFile(:,6:7)-tFile(:,1:2);
data.targAng = atan2(data.targPos(:,2),data.targPos(:,1))*180/pi;
data.targ_appear_time = tFile(:,8);

% rotate data into canonical coordinate frame
data.Ntrials = size(tFile,1);
for i=1:data.Ntrials % iterate through all trials
    theta = atan2(data.targPos(i,2),data.targPos(i,1))-pi/2;
    R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    data.handPos{i} = [X{i}'-X0; Y{i}'-Y0];
    data.handPos_rotated{i} = R*data.handPos{i};
end
data = getErr_fixedT(data);
