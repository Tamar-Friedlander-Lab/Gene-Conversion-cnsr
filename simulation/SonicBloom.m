function [flowPop] = SonicBloom(miscPara,popPara)

flowPop.tableRnaseSlf = gpuArray.zeros(size(popPara.startingRNase,1),size(popPara.startingSLF,1)) ;

flowPop.listRnase = single(popPara.startingRNase) ;

flowPop.listSLF = single(popPara.startingSLF) ;

flowPop.amountOfJumps = gpuArray.zeros(popPara.numInd,2,popPara.amountSLF) ;

flowPop.identicalSLFProp = gpuArray.zeros(popPara.numGen,1) ;

if ~isfield(flowPop,'convRatePerHaplo')
    try
    flowPop.convRatePerHaplo = gpuArray.zeros(popPara.numInd,2) + popPara.SLFJumpRate ;
    catch
        flowPop.convRatePerHaplo = gpuArray.rand(popPara.numInd,2).*abs(diff(popPara.SLFJumpSpan)) +min(popPara.SLFJumpSpan) ;
    end
end

%% Create Basic compitability table

boolComb = RNaseSLFReactor3(popPara.startingRNase,popPara.startingSLF,miscPara,1) ;

% if length(unique(boolComb))==2
% if any(boolComb)
flowPop.boolRnaseSlf = reshape(boolComb,[],size(popPara.startingRNase,1))' ;
% else
%     flowPop.tableRnaseSlf = reshape(energyComb,popPara.numStartingUniques,[])' ;
% end


flowPop.femalesCurr = single(gpuArray(popPara.firstGenFem)) ;

flowPop.maleCurr = single(gpuArray(popPara.firstGenMal)) ;

flowPop.MalePickInd = single(gpuArray.zeros(popPara.numInd,2)) ;

if isfield(popPara,'SLFJumpSpan')
    if ~isfield(flowPop,'convRatePerHaplo')
      flowPop.convRatePerHaplo = popPara.convRatePerHaplo ;
    end

end

%
% flowPop.maleAncestorIndex = gpuArray(repelem((1:popPara.numInd)',1,2)) ;
%
% flowPop.femaleAncestorIndex = gpuArray(repelem((1:popPara.numInd)',1,2)) ;

flowPop.ancestorIndex = single(gpuArray(repelem((1:popPara.numInd)',1,2))) ;
flowPop.SLFAncestorIndex = single(gpuArray(repelem((1:popPara.numInd)',1,2,popPara.amountSLF))) ;


flowPop = bouquetAnalyzer5(flowPop,miscPara,popPara,0) ;

flowPop.numOFJumpInHistories = gpuArray.zeros(popPara.numInd,2) ;

if ~isfield(miscPara,'mat2Test')
    CurrMalePickInd = single([[1:popPara.numInd]']);
    miscPara.mat2Test.mat1 =  (repmat(CurrMalePickInd(:,1),[1,1,popPara.amountSLF])) ;
    CurrMalePickInd(:,2) = 1 ;
    miscPara.mat2Test.mat2a =  (repmat(CurrMalePickInd(:,2),[1,1,popPara.amountSLF])) ;

    CurrMalePickInd(:,2) = 2 ;
    miscPara.mat2Test.mat2b =  (repmat(CurrMalePickInd(:,2),[1,1,popPara.amountSLF])) ;

    miscPara.mat2Test.mat3 = permute(repmat([1:popPara.amountSLF],[popPara.numInd,1,1]),[1 3 2]) ;

end

%         flowPop.convRatePerHaplo = flowPop.convRatePerHaplo.*0 ;

%% Start generation loop
tic
for currGeneration = 1:popPara.numGen
    flowPop.howManyAnces(currGeneration) = length(unique(flowPop.ancestorIndex(:))) ;
    flowPop.howManySLFAnces(currGeneration) = length(unique(flowPop.SLFAncestorIndex(:))) ;

    rng(gather(currGeneration)+miscPara.BoringSeed)
    gpurng(gather(currGeneration)+miscPara.BoringSeed)


    %% Choose pairing between the sexes

    %     [flowPop] = BumbleDatingMadeSimple6(popPara,miscPara,flowPop) ;
    [flowPop] = miscPara.dateFunc(popPara,miscPara,flowPop) ;

    %% Update fitness and kill individuals
    %may add other qualifications besides SF

    %     [flowPop] = updateAndCull3(popPara,miscPara,flowPop,currGeneration) ;

    %% updatePop

    [flowPop] = MakingBabies7(popPara,flowPop) ;


    %% Mutations
    [flowPop] = MutationModule5(flowPop,popPara,miscPara,'RNase') ;

    [flowPop] = MutationModule5(flowPop,popPara,miscPara,'SLF') ;

    %% exchange some random SLFS

    [flowPop] = SLFJump7(popPara,flowPop) ;
    %
    %     WhoWillHaveAJump = gpuArray.rand(popPara.numInd,1)<=popPara.SLFJumpRate ;
    %
    %     whichSLFWillJump = ceil(gpuArray.rand(sum(WhoWillHaveAJump),1).*popPara.amountSLF) ;
    %
    %     directionOfJump = ceil(gpuArray.rand(sum(WhoWillHaveAJump),1).*2) ;
    %
    %     oppositeDirJump = 3 - directionOfJump ;
    %
    %     indOfJump = sub2ind(size(flowPop.maleCurr),find(WhoWillHaveAJump),directionOfJump,whichSLFWillJump) ;
    %
    %     indOfLanding = sub2ind(size(flowPop.maleCurr),find(WhoWillHaveAJump),oppositeDirJump,whichSLFWillJump) ;
    %
    %     flowPop.maleCurr(indOfLanding) = flowPop.maleCurr(indOfJump) ;

    %% Update some running params
    %
    flowPop.totalJumps4Hist(currGeneration) = sum(flowPop.amountOfJumps(:)) ;

    %% Check for generational events
%     [flowPop] = SLFCompatabilityMeasure(flowPop) ;
    %if a check comes up positive keep some relevent information
    if mod(currGeneration,100) == 0
        flowPop = bouquetAnalyzer5(flowPop,miscPara,popPara,currGeneration/10) ;
        try
            gather(flowPop.agesStruct.amountOfDivitions(end))
        end
    end
    if mod(currGeneration,100) == 0
        toc
        currGeneration
    end

%    if mod(currGeneration,1e+5) == 0
%        save('please dont crash','-V7.3') ;
%    end

    flowPop = GeneRenamer(miscPara,popPara,flowPop) ;
%     mean(flowPop.convRatePerHaplo(:))
%     flowPop.amountThatSelfed(end)
end

end


