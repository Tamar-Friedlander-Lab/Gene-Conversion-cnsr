function [divitionStruct,amountInDivitions,numDivitions,divEffectiveNumber,...
    effectiveNumberOnlyInDiv,whichHaploInDiv,vec2ConnectHaploDiv] ...
    = Divitionator11(popPara,miscPara,flowPop)
%% add checkfor gene convertion
vec2ConnectHaploDiv = zeros(popPara.numInd.*2,1) ;

%% initialize who exists
genesOfPop = [flowPop.femalesCurr(:),reshape(flowPop.maleCurr,[],popPara.amountSLF)] ;

[quirckyStrings,quirckyIndexes,index4RepCounting] = unique(genesOfPop,'rows') ;

amountOfEachString = histcounts(index4RepCounting,max(index4RepCounting)) ;

[amountOfEachString,howToSortStrings] = sort(amountOfEachString,'descend') ;

quirckyStrings = quirckyStrings(howToSortStrings,:) ;
quirckyIndexes = quirckyIndexes(howToSortStrings) ;

amountOfQuircky = size(quirckyIndexes,1) ;
%% now create a mat of interactions:

index4Table = sub2ind(size(flowPop.boolRnaseSlf),repmat(quirckyStrings(:,1),amountOfQuircky,popPara.amountSLF),...
    repelem(quirckyStrings(:,2:end),amountOfQuircky,1)) ;

eneAfterTable = flowPop.boolRnaseSlf(index4Table) ;

eneCheck = max(eneAfterTable,[],2) ;
eneCheck = reshape(eneCheck,amountOfQuircky,[]) ;


amountInDivitions = 0 ;
amountOfDivitions = 0 ;
indInDivition = [] ;
ind2Divition = [] ;

%% run ove a loop over all options:

for currInd = 1:amountOfQuircky

    currString = quirckyStrings(currInd,:) ;
    divition2Add = [] ;

    %% check if self polinate
    
    checkSelfPol = eneCheck(currInd,currInd) ;

    
    %% check if polinates others
    if checkSelfPol == 0
    if amountOfDivitions == 0
        checkXPol = 1 ;
        divition2Add = 1 ;
        itsAnewDiv = 1 ;
        amountOfDivitions = amountOfDivitions + 1 ;
    else
        vec4Semi = cat(1,indInDivition,currInd) ;
        semiTable = eneCheck(vec4Semi ,...
            vec4Semi) ;
        RnasePlusSlf = semiTable(end,1:end-1) + semiTable(1:end-1,end)' ;

        if mean (RnasePlusSlf == 2) ==1
            amountOfDivitions = amountOfDivitions + 1 ;
            divition2Add = amountOfDivitions;
            checkXPol = 1 ;
            itsAnewDiv = 1 ;
        elseif sum(RnasePlusSlf==1) > 0
            checkXPol = 0 ;
        elseif sum(RnasePlusSlf==0)>0
            notPolInd = indInDivition(find(RnasePlusSlf==0) );
            ind4PotDiv = cat(1,notPolInd,currInd) ;
            potSemiTable = eneCheck(ind4PotDiv,ind4PotDiv) ;
            divition2Add = ind2Divition(notPolInd) ;
            if all(potSemiTable(:) == 0) && (length(unique(divition2Add)) == 1)
                checkXPol = 1 ;
                divition2Add = unique(divition2Add) ;
            end
        else
            checkXPol = 0 ;
        end
    end
    %% add 2 divition memory
    if (checkXPol == 1) && (checkSelfPol == 0)
        if itsAnewDiv == 1
            divitionStruct(divition2Add).strings = [] ;
            divitionStruct(divition2Add).amounts = [] ;
            itsAnewDiv = 0 ;
        end
        divitionStruct(divition2Add).strings = ...
            cat(1,divitionStruct(divition2Add).strings,currString) ;
        divitionStruct(divition2Add).amounts = ...
            cat(1,divitionStruct(divition2Add).amounts,amountOfEachString(currInd)) ;
        amountInDivitions = amountInDivitions + amountOfEachString(currInd) ;
        ind2Divition(currInd) = divition2Add ; 
        indInDivition = cat(1,indInDivition,currInd) ;

        vec2ConnectHaploDiv(prod((genesOfPop-currString)==0,2)==1) = divition2Add ;

    end
    

    end
end

for i = 1:length(divitionStruct)
    currAmountStruct = divitionStruct(i).amounts ;
    divitionStruct(i).totalAmount = sum(currAmountStruct) ;
    
end

vecOfAmounts = vertcat(divitionStruct.totalAmount) ;

if isfield(popPara,'lowNum4Divitions')

    whichDivGood = vecOfAmounts>=popPara.lowNum4Divitions ;
    divitionStruct = divitionStruct(whichDivGood) ;
    amountOfDivitions = sum(whichDivGood) ;
    amountInDivitions = sum(vecOfAmounts(whichDivGood)) ;
vecOfAmounts = vecOfAmounts(whichDivGood) ; 
end
%% create out structs similar to old function.
numDivitions = amountOfDivitions ;

divEffectiveNumber = 1./sum((vecOfAmounts./sum(vecOfAmounts)).^2) ;

allStringsInDiv = vertcat(divitionStruct(:).strings) ;

[whichHaploInDiv] = ismember(genesOfPop,allStringsInDiv,'rows') ;

effectiveNumberOnlyInDiv = effectiveNumberCalcSpecial(genesOfPop(whichHaploInDiv,:)) ;



if isfield(flowPop,'convRatePerHaplo')
for i = 1:amountOfDivitions
    
    [whichHaploInDiv] = ismember(genesOfPop,horzcat(divitionStruct(i).strings),'rows') ;

    currGeneRate = flowPop.convRatePerHaplo(find(whichHaploInDiv)) ; 

     
    divitionStruct(i).meanGeneRate = mean(currGeneRate) ;

    divitionStruct(i).stdGeneRate = std(currGeneRate) ;


end
end


end