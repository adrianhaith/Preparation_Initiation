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

save RTfloorData_full