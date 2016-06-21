function subdata = getSubset(data,trials)
% extract a subset of trials from data

subdata.target = data.target(trials);
subdata.jump_time = data.jump_time(trials);
subdata.target_post_jump = data.target_post_jump(trials);
subdata.X = data.X(trials);
subdata.Y = data.Y(trials);
subdata.Xunrot = data.Xunrot(trials);
subdata.Yunrot = data.Yunrot(trials);
subdata.X0 = data.X0;
subdata.Y0 = data.Y0;
%subdata.PTa = data.PTa(trials);
%subdata.PTg = data.PTg(trials);
subdata.Ntrials = length(trials);
%subdata.xpos = data.xpos(trials,:);
%subdata.ypos = data.ypos(trials,:);
%subdata.reachDir = data.reachDir(trials);
%subdata.RT = data.RT(trials);
%subdata.meanPerpDisp = data.meanPerpDisp(trials);
%subdata.maxPerpDisp = data.maxPerpDisp(trials);
%{
subdata.iDir = data.iDir(trials);
subdata.iEnd = data.iEnd(trials);
subdata.pos = data.pos(trials);
subdata.vel = data.vel(trials);
subdata.tanVel = data.tanVel(trials);
subdata.handPos = data.handPos(trials);
subdata.cursorPos = data.cursorPos(trials);
subdata.rPT = data.rPT(trials);
subdata.MTerr = data.MTerr(trials);
subdata.rPTg = data.rPTg(trials);
subdata.tanAcc = data.tanAcc(trials);
%}
%subdata.tanJerk = data.tanJerk(trials);