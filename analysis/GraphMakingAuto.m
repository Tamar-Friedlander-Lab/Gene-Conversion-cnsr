function [BaseLoadedFlow] = GraphMakingAuto(foldNameInResults)

repoRoot = fileparts(fileparts(mfilename('fullpath')));
rawDir = fullfile(repoRoot, 'RawResults', foldNameInResults);
filePattern = fullfile(rawDir, '*.*'); 

% Get a list of all files and folders that match the pattern
namesOfFiles = dir(rawDir) ; 
matRepCombNumbs = [] ;
for i = 1:length(namesOfFiles)

    currFileName = namesOfFiles(i).name ;
    numStrHolder = regexp(currFileName,'\d{1,2}','match') ;

    for j = 1:length(numStrHolder)
    matNumItter(i,j) = double(string(numStrHolder(j))) ;
    end

    try
        matRepCombNumbs(matNumItter(i,1),matNumItter(i,2)) = matNumItter(i,1).*matNumItter(i,2) ;
    end

end

[~,ind2Trans] = max(matRepCombNumbs(:)) ;
[repAmount,combAmount] = ind2sub(size(matRepCombNumbs),ind2Trans) ;

% repAmount = max(matNumItter(:,1));
% combAmount = max(matNumItter(:,2));



graphStuff.combColors = ['y','c','m','r','b','g'] ;

baseNameFormat = fullfile(rawDir, 'currItter %d with value %d') ;

BaseLoadedFlow = FlowerLoader(baseNameFormat,repAmount,combAmount) ;

popPara = load(sprintf(baseNameFormat, 1, 1) ,'popPara') ;

popPara = popPara.popPara ;



%% get folder name

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
try
legendNames =string(popPara.value2Vary.*popPara.numInd./(2.*popPara.numInd.*(popPara.amountSLF+1).*popPara.numAmino.*popPara.mueRatePerAmino)) ;

legendNames =string(popPara.value2Vary) ;
catch
    legendNAme = [] ;
end
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
pause(0.1)
saveas(meFig,[foldName,'/',fieldIWant,'.png'])
save([foldName,'/',fieldIWant],'meFig')

end
end



end