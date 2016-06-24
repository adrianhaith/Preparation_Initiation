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
    clear pos_filt

    pos_filt = savgolayFilt(data.handPos_rotated{i},3,7);
    vel = diff(pos_filt')';
    clear vel_filt
    vel_filt = savgolayFilt(vel,3,7);
        tanVel = sqrt(sum(vel_filt.^2)); % tangential velocity (i.e. overall speed, regardless of direction)
    
    VEL_THR_START = .02/130; % .02 m/s 
    
    % find movement end
    targDist = pos_filt-repmat([0;.15],1,size(pos_filt,2));
    d2 = sum(pos_filt.^2);
    [xx iEnd(i)] = max(d2);
    iEnd(i) = iEnd(i)-1; % subtract 1 to use as index for velocity

    % find movement initiaton
    [pkVel(i) i_pkVel(i)] = max(tanVel(51:iEnd(i))); % get peak vel (ignore first 50 timesteps)
    i_pkVel(i) = i_pkVel(i) + 50; % compensate for ignored first 50 timesteps
    i_init = max(find(tanVel(51:i_pkVel(i))<VEL_THR_START)); % find first point before pkVel at which vel is < .02 m/s
    
    if(isempty(i_init)) % blank out bad trials with NaNs
        iDir(i) = NaN;
        iEnd(i) = NaN;
        reachDir(i) = NaN;
        iInit(i) = NaN;
        pkVel(i) = NaN;
    else
        iInit(i) = i_init+50;
        iDir(i) = iInit(i) + NDIR; % sample direction 100ms after movement onset detected
        reachDir(i) = atan2(vel_filt(2,iDir(i)),vel_filt(1,iDir(i)));
    end
   
    tanVelocity{i} = tanVel;
end

% convert from radians to degrees
reachDir =reachDir*180/pi - 90; 
ibad = find(reachDir < -180);
reachDir(ibad) = reachDir(ibad)+360;

% absolute reach direction
reachDir_absolute = reachDir+data.targAng';
ibad = find(reachDir_absolute < -180);
reachDir_absolute(ibad) = reachDir_absolute(ibad)+360;

data.reachDir = reachDir;
data.reachDir_absolute = reachDir_absolute;
data.iInit = iInit;
data.iDir = iDir;
data.iEnd = iEnd;
data.tanVel = tanVelocity;
data.RT = data.iInit/130 - data.targ_appear_time'/1000;
data.pkVel = pkVel;

