% do everything necessary for loading and analyzing RT floor data
clear all
clc

loadRTfloorData
compactifyData
compute_phit
MLEfit
makefigs