%% BaseFlowerScript - Single-run SI/SC evolutionary simulation demo
clearvars;
repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(repoRoot));
rng('shuffle');

%% Initialize Miscellaneous Parameters
miscPara.dateFunc = @BumbleDatingMadeSimple11;

miscPara.compTable = ...
    gpuArray([-1   0     0     0 ;...
               0  -0.75 -0.25 -0.25;...
               0  -0.25  1    -1.25;...
               0  -0.25 -1.25  1]);

miscPara.selfFerDep = gpuArray(0.9);
miscPara.selfPollenRatio = gpuArray(0.9);
miscPara.energyBarrier = gpuArray(-3.99);
miscPara.aminoFreq = gpuArray([0.5, 0.265, 0.113, 0.122]);
miscPara.aminoFreq = gpuArray(miscPara.aminoFreq ./ sum(miscPara.aminoFreq));
miscPara.topTries4Match = 1e+3;
miscPara.BoringSeed = round(rand * 100000);
rng(miscPara.BoringSeed);

%% Initialize Population Parameters
popPara.numInd = gpuArray(500);
popPara.numGen = gpuArray(1e+4);          % Use 30e+4 for full paper runs
popPara.mueRatePerAmino = gpuArray(1e-4);
popPara.ForceFemaleReproduction = 0;
popPara.amountSLF = gpuArray(9);
popPara.numAmino = gpuArray(18);
popPara.startingVariety = gpuArray(2e-2);
popPara.topNumMatingAttempts = 0.5e+1;
popPara.SLFJumpRate = gpuArray(1e-2);
popPara.lowNum4Divitions = 10;

while ~isfield(popPara, 'firstGenMal')
    try
        [popPara] = SampleIntiatorLikeAmit(popPara, miscPara);
    end
end

%% Run Simulation
[flowPop] = SonicBloom(miscPara, popPara);
