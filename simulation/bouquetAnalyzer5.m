function flowPop = bouquetAnalyzer5(flowPop,miscPara,popPara,currGeneration)


if  nargin < 4
    currGeneration = popPara.numGen ;
end

currGeneration = currGeneration + 1 ;

if isfield(flowPop,'agesStruct')

%     if isfield(popPara,'SLFJumpSpan')
%         flowPop.agesStruct.divConvRate(currGeneration) = std(flowPop.convRatePerHaplo(:)) ;
%         flowPop.agesStruct.meanConvRate(currGeneration) = mean(flowPop.convRatePerHaplo(:)) ;
% 
%     end
%     flowPop.agesStruct.populationRemeber(currGeneration).maleCurr = flowPop.maleCurr ;
% 
%     flowPop.agesStruct.populationRemeber(currGeneration).femaleCurr = flowPop.femalesCurr ;


    [~,aaa] = HaploSCTester(popPara,miscPara,flowPop) ;

    flowPop.binarySelf(currGeneration,:) = aaa(:) ;

    flowPop = SLFSpecificCalculator(flowPop) ;

    flowPop = SLFProfessionism(flowPop,currGeneration) ;

%     [flowPop.agesStruct.averageSLFDist(currGeneration,:),flowPop.agesStruct.averageSLFDist2All(currGeneration,:),...
%         flowPop.agesStruct.ratioDistSlf(currGeneration)] = SLFDistCalculator4(flowPop) ;



    flowPop.agesStruct.effectiveNumber(currGeneration) = effectiveNumberCalc(flowPop) ;

    %     flowPop.agesStruct.slf(currGeneration,size(flowPop.listSLF,1)) = ...
    %         0 ;
    %      flowPop.agesStruct.rnase(currGeneration,size(flowPop.listRnase,1)) = ...
    %         0 ;

else
    %     flowPop.agesStruct.slf(currGeneration,:) = ...
    %         gpuArray.zeros(size(flowPop.listSLF,1),1) ;
    %      flowPop.agesStruct.rnase(currGeneration,:) = ...
    %         gpuArray.zeros(size(flowPop.listRnase,1),1) ;

end


flowPop.agesStruct.knownSLFAmount(currGeneration) = size(flowPop.listSLF,1) ;
flowPop.agesStruct.knownRnaseAmount(currGeneration) = size(flowPop.listRnase,1) ;
%
%      whichSLFExist = unique(flowPop.maleCurr) ;
%      whichRnaseExist = unique(flowPop.femalesCurr) ;

%     flowPop.agesStruct.slf(currGeneration,whichSLFExist) = 1 ;
%     flowPop.agesStruct.rnase(currGeneration,whichRnaseExist) = 1 ;

try
    %     [~,~,flowPop.agesStruct.amountOfDivitions(currGeneration)] =  Divitionator(popPara,miscPara,flowPop) ;

    [flowPop.agesStruct.divition(currGeneration).Struct,...
        flowPop.agesStruct.howManyDivitioned(currGeneration),...
        flowPop.agesStruct.amountOfDivitions(currGeneration),...
        flowPop.agesStruct.effectiveNumberOFDivitions(currGeneration),...
        flowPop.agesStruct.effectiveNumberOnlyInDiv(currGeneration),...
        flowPop.agesStruct.binaryInDiv(currGeneration,:),...
        classVector] = ...
        Divitionator11(popPara,miscPara,flowPop) ;

    if isfield(popPara,'trackClasses')
        if popPara.trackClasses
            flowPop = classTrackerLive(popPara,miscPara,flowPop,classVector) ;
        end
    end

    if isfield(popPara,'wannaInjectSome')
if popPara.wannaInjectSome
    if isfield(popPara,'typeOfInject')
        switch popPara.typeOfInject
            case 'random'
                flowPop = RateVaryInjectorRandom(flowPop,popPara,miscPara,currGeneration) ;
            otherwise
                flowPop = RateVaryInjector(flowPop,popPara,miscPara,currGeneration) ;
        end
    else
                flowPop = RateVaryInjector(flowPop,popPara,miscPara,currGeneration) ;
    end
end
end
    
end


[flowPop.maleDistributionAmino(currGeneration,:)] = countDestributions(flowPop.maleCurr(:),flowPop.listSLF) ;


[flowPop.femaleDistributionAmino(currGeneration,:)] = countDestributions(flowPop.femalesCurr(:),flowPop.listRnase) ;

end