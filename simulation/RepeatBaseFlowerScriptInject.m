%% Quick Script to check the performance of some different techniques
clearvars;
repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(repoRoot));
sprintf('ITS WORKING')
rng('shuffle')
% rand('twister',sum(100*clock))
% randn('state',sum(100*clock))
%% Initialize Miscelanious Parameters

miscPara.dateFunc = @BumbleDatingMadeSimple11 ;

miscPara.compTable = ...
    gpuArray([-1   0     0     0 ;...
               0  -0.75 -0.25 -0.25;...
               0  -0.25  1    -1.25;...
               0  -0.25 -1.25  1]) ;

miscPara.selfFerDep = gpuArray(0.9); 

miscPara.selfPollenRatio = gpuArray(0.9);

miscPara.energyBarrier= gpuArray(-3.99 );

miscPara.aminoFreq = gpuArray([0.5,0.265,0.113,0.122] );

miscPara.aminoFreq = gpuArray(miscPara.aminoFreq./sum(miscPara.aminoFreq) );

miscPara.topTries4Match = 1e+3 ;

miscPara.BoringSeed = round(rand*100000) ;
rng(miscPara.BoringSeed) ;
%% Initialize Population

%% Initialize Population

% num of individuals in population
popPara.numInd = gpuArray(500 );

% how many generations we want
popPara.numGen = gpuArray(30e+4);

% mutation rate per amino acid
popPara.mueRatePerAmino = gpuArray(1e-4);

% Should each female be given an equal and very chance of reproduction.
popPara.ForceFemaleReproduction = 0 ; 

% amount of slf in a string
popPara.amountSLF = gpuArray(9) ;

% amount of amino acids in SLF/RNase
popPara.numAmino= gpuArray(18 ) ;

% a measure for the starting diversity. if we have a population of e+5 and
% starting diversity of e-4, we would have 100 unique SLF and RNase
popPara.startingVariety = gpuArray(2e-2 );
% popPara.startingVariety = gpuArray(1e-2 );

% how many dates can a female go out on before she loses her chance
popPara.topNumMatingAttempts = 0.5e+1 ;

popPara.SLFJumpRate = 0*gpuArray(1e-2);

%minimum size for divitions 
popPara.lowNum4Divitions  = 10 ;

%wanna do some injecting 
popPara.wannaInjectSome = 1 ;

popPara.SLFJumpSpan = 0 ;
popPara.typeOfConvMute = 'Nothing' ;

popPara.typeOfInject = 'random' ; 

popPara.trackClasses = 1 ;

%% Run the simulation
% QuickCheckFreq

% value2Check = [0.95 0.9 0.83] ;

% value2Check = [0 5e-3 1e-2 2e-2] ;
value2Check =  gpuArray([0.05 0.1]);
% value2Check = gpuArray([-7.99,-5.99,-3.99]) ;
% value2Check = [5 7 9] ;

foldNameInResults = 'newFolder' ;
rawResultsRoot = fullfile(repoRoot, 'RawResults') ;
if ~exist(rawResultsRoot, 'dir')
    mkdir(rawResultsRoot) ;
end
foldName = nextname(fullfile(rawResultsRoot, foldNameInResults),'1','',true) ;
mkdir(foldName) ;

for i = 1:7
    
       
%         popPara.amountSLF = value2Check(i) ;
        popPara.value2Vary = value2Check ; 

try
        rmfield(popPara,'firstGenMal')
        end

        while ~isfield(popPara,'firstGenMal')
try
        [popPara] = SampleIntiatorLikeAmit(popPara,miscPara) ;
end
        end
    for j = 1:length(value2Check)
%         popPara.topNumMatingAttempts = value2Check(j) ;   
%        popPara.mueRatePerAmino= value2Check(j) ; 
%          miscPara.energyBarrier = value2Check(j) ;
%         miscPara.selfPollenRatio = value2Check(j) ; 
        popPara.what2Inject = value2Check(j) ;
        miscPara.BoringSeed = round(rand*100000) ;
        rng(miscPara.BoringSeed) ;
        
% 
%         popPara.amountSLF = value2Check(i) ;
% 
%         [popPara] = SampleInitiator4(popPara,miscPara) ;
        popPara.SLFJumpRate=  popPara.what2Inject ;
        miscPara.name2Save = sprintf('currItter %d with value %d', i, j) ;
        [flowPop] = SonicBloom(miscPara,popPara) ;
        save([foldName,'/',miscPara.name2Save],'-V7.3')
        clear flowPop
    end
end
%% Do Other cool stuff i forget about

% [divitionStruct,vecOfDivitionsIndex,numDivitions] = Divitionator(popPara,miscPara,flowPop) ;
% 
% [amountInDivitions] = DivitionTracker(flowPop,miscPara,popPara,[400 5000]) ;
% save('Please b nice')
addpath(foldName)
GraphingAfterManyRunsMakeAllGraphs ;
