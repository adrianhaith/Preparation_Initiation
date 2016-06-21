function data = getErr(data)
% Calculates reach direction given a data structure loaded from raw
% kinereach output using the loadSubjData function
%
% Input:  data - output from 'loadSubjData'
%                (i.e. data_ns = loadSubjdata('JC_9_23ns',100) )
%
% Output  reachDir - vector containing reach angle relative to the target
%                    on each trial

makePlots = 0;
NDIR = 13; % sample at which direction is measured (13 = 100ms)

if(makePlots)
    figure(3); % open a new figure
    clf; % clear figure
    hold on; % 'hold' the plot, so that old plots aren't deleted by new ones
    figure(4); clf; hold on
end

vel_Dir = NaN*ones(1,data.Ntrials);

for i=1:data.Ntrials
    xpos = data.X{i}';
    ypos = data.Y{i}';
    pos = [xpos; ypos];
    clear pos_filt
    w = 7;
    pos_filt(1,:) = savgolayFilt(pos(1,:),3,w);
    pos_filt(2,:) = savgolayFilt(pos(2,:),3,w);
    
    vel = [diff(pos_filt(1,:));diff(pos_filt(2,:))]; % compute velocity ('diff' computes difference between consecutive timepoints)
    clear vel_filt
    vel_filt(1,:) = savgolayFilt(vel(1,:),3,w);
    vel_filt(2,:) = savgolayFilt(vel(2,:),3,w);
    vel_filt = vel;
    
    tanVel = sqrt(sum(vel_filt.^2)); % tangential velocity (i.e. overall speed, regardless of direction)
    %tanVel = savgolayFilt(tanVel,3,7); % apply a filter to smooth the data out
    
    tanAcc = diff(tanVel);
    tanAcc = savgolayFilt(tanAcc,3,w); % smooth out acceleration data
    
    %tanJerk = diff(tanAcc);
    %tanJerk = savgolayFilt(tanJerk,3,w);
    
    VEL_THR_START = .02/130; % .01 m/s % previously .0001 m/frame;
    
    % find end of movement
    targDist = pos_filt-repmat([0;.15],1,size(pos_filt,2));
    d2 = sum(targDist.^2);
    i_end = min(find(d2<.015^2));
    %keyboard
    
    % find first peak in acceleration after movement has started
    
    if(isempty(i_end))
        % if subject never reaches target, take farther point from start
        % location
        d2 = sum(pos_filt.^2);
        [xx i_end] = max(d2);
        i_end = i_end-1; % subtract 1 to use as index for velocity
        %i_end = size(pos_filt,2)-1;
    end
    
    [pkVel i_pkVel] = max(tanVel(51:i_end)); % ignore first 50 timesteps
    VEL_THR_DIR = .0008;%pkVel/2;
    ACC_THR_INIT = .00005;
    i_pkVel = i_pkVel + 50; % compensate for ignored first 50 timesteps
    i_init = max(find(tanVel(51:i_pkVel)<VEL_THR_START));
    %iDir = max(find(tanVel(1:i_pkVel)<VEL_THR_DIR));
    
    % find first peak in acceleration after movement has started
   
    if(isempty(i_init))
        iDir = [];
    else
        i_init = i_init+50;
        %iDir = min(find(tanVel(i_init:end)>VEL_THR_DIR))+i_init;
        % find first peak in acceleration after movement has started
        i_pkAcc = min(find(diff(tanAcc(i_init:end))<0))+i_init;
        while(tanAcc(i_pkAcc)<2*10^(-5))
            i1 = min(find(diff(tanAcc(i_pkAcc:end))>0)); % next minimum in acceleration
            i2 = min(find(diff(tanAcc(i_pkAcc+i1:end))<0)); % next maximum in acceleration
            i_pkAcc = i_pkAcc+i1+i2;
            %keyboard
        end
        iDir = i_pkAcc;
        
        %i_init = max(find(tanAcc(1:iDir)<ACC_THR_INIT));
        if(isempty(find(tanAcc(i_init:iDir)>ACC_THR_INIT))) % if new movement initialization estimate is same place as peak acc, discard
            iDir = [];
        end
        
        iDirT = i_init + NDIR; % sample direction 100ms after movement onset detected
    end
    
    if(isempty(iDir))
        iDir = NaN;
        iDirT = NaN;
        i_end = NaN;
        reachDir(i) = NaN;
        reachDirT(i) = NaN;
        reachDirTv = NaN*[1:60];
        RT(i) = NaN;
        meanPerpDisp(i) = NaN;
        maxPerpDisp(i) = NaN;
    else
        
        %iDir = i_pkVel;
        
        if(isempty(i_init))
            RT(i) = NaN;
            reachDir(i) = NaN;
            reachDirT(i) = NaN;
            reachDirTv = NaN*[1:60];
        else
            RT(i) = i_init;
            reachDir(i) = atan2(vel_filt(2,iDir),vel_filt(1,iDir)); % compute angle based on instantaneous velocity
            reachDirT(i) = atan2(vel_filt(2,iDirT),vel_filt(1,iDirT));
           
            reachDirTv = atan2(vel_filt(2,i_init:i_end),vel_filt(1,i_init:i_end));
            vel_Dir(i) = tanVel(iDirT);
        end      
    end
    
    t_dir(i) = iDirT;
    t_end(i) = i_end;
    position{i} = pos_filt;
    velocity{i} = vel_filt;
    tanVelocity{i} = tanVel;
    tanAccel{i} = tanAcc;
    %tanJer{i} = tanJerk;
    if(~isempty(pkVel))
        pV(i) = pkVel;
    else
        pV(i) = NaN;
    end
    reachDirTv = reachDirTv*180/pi-90;
    ibad = find(reachDirTv<-180);
    reachDirTv(ibad) = reachDirTv(ibad)+360;
    rdv{i} = reachDirTv;
    
    if(NDIR+1>length(reachDirTv))
        d_dir(i)=NaN;
    else
        d_dir(i) = reachDirTv(NDIR+1)-reachDirTv(NDIR-1);
    end
    
end

%figure(4); axis equal

reachDir =reachDir*180/pi - 90; % convert from radians to degrees
ibad = find(reachDir < -180);
reachDir(ibad) = reachDir(ibad)+360;

reachDirT = reachDirT*180/pi - 90;
ibad = find(reachDirT < -180);
reachDirT(ibad) = reachDirT(ibad) + 360;
%figure(4);  hold on % open a new figure and plot the results
%plot(-reachDir,'g')
%xlabel('Trial Number')
%ylabel('Reach Direction / deg')


data.reachDir = reachDirT;
data.reachDirT = reachDirT;
data.reachDirTv = rdv;
data.d_dir = d_dir; % rate of change of direction estimate
data.RT = RT;
data.iDir = t_dir;
data.iEnd = t_end;
data.pos = position;
data.vel = velocity;
data.tanVel = tanVelocity;
data.tanAcc = tanAccel;
%data.tanJerk = tanJer;
data.rPT = data.jump_time - (data.RT/130 - .5);
data.rPT = data.RT/130 - data.jump_time/1000;
data.pkVel = pV;
data.velDir = vel_Dir;
%data.MTerr = -data.rPT - (data.PTg-data.jump_time);
%data.rPTg = data.PTg-data.jump_time;

%keyboard
