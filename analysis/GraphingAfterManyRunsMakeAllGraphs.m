%% PreLoad stractures


if exist('i', 'var') && isnumeric(i) && isscalar(i)
    repAmount = i;
elseif ~exist('repAmount', 'var')
    repAmount = 7;
end
if exist('value2Check', 'var')
    combAmount = length(value2Check);
elseif ~exist('combAmount', 'var')
    combAmount = 1;
end

graphStuff.combColors = ['y','c','m','r','b','g'] ;

baseNameFormat = 'currItter %d with value %d' ;

BaseLoadedFlow = FlowerLoader(baseNameFormat,repAmount,combAmount) ;

popPara = load(sprintf(baseNameFormat, 1, 1) ,'popPara') ;

popPara = popPara.popPara ;



%% get folder name

if ~exist('repoRoot', 'var')
    repoRoot = fileparts(fileparts(mfilename('fullpath')));
end
foldNameInResults = 'newFolder' ;
resultsRoot = fullfile(repoRoot, 'Results') ;
if ~exist(resultsRoot, 'dir')
    mkdir(resultsRoot) ;
end
foldName = nextname(fullfile(resultsRoot, foldNameInResults),'1','',true) ;

mkdir(foldName) ;

save([foldName '.mat'],'-v7.3')

%% get field names 

AllNames = fieldnames(BaseLoadedFlow(1,1)) ;

graphStuff.how2Norm = 'normalize' ;

legendNames =string(popPara.value2Vary.*popPara.numInd./(2.*popPara.numInd.*(popPara.amountSLF+1).*popPara.numAmino.*popPara.mueRatePerAmino)) ;

legendNames =string(popPara.value2Vary) ;

% legendNames = {'0' ,'1e-3' ,'5e-3' ,'1e-2'} ;
% legendNames = {'5','7','9'} ;

for i = 1:length(AllNames)
fieldIWant = cell2mat(AllNames(i)) ;
try
[meFig,meHoldOut]  = badStruct2Graph(BaseLoadedFlow,fieldIWant,graphStuff) ;

grid on

aLeg = legend(legendNames,'Location','best') ;

title(aLeg,'Gene Conversion Rate') ;

title(fieldIWant)

saveas(meFig,[foldName,'/',fieldIWant,'.png'])
save([foldName,'/',fieldIWant],'meFig')

end
end

%% Define what 2 display
% fieldIWant = 'effectiveNumber' ;
% fieldIWant = 'amountOfDivitions' ;
% fieldIWant = 'totalJumps4Hist' ;
% fieldIWant = 'probComp' ;
% fieldIWant = 'averageSLFDist' ;
% fieldIWant = 'averageSLFDist2All' ;
% fieldIWant = 'amountNoRelationSpec' ;
% fieldIWant = 'amountNoRelationAll' ;
% fieldIWant = 'ratioDistSlf' ;
% fieldIWant = 'howManyDivitioned' ;
% 
% 
% 
% %% create graphs
% 
% meFig = badStruct2Graph(BaseLoadedFlow,fieldIWant,graphStuff) ;
% 






