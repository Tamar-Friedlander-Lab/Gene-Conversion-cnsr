function [flowPop] = MakingBabies6(popPara,flowPop)


whichFemalePass = gpuArray.randi(2,[popPara.numInd,1]) ;

index2PassFromFemale = sub2ind(size(flowPop.femalesCurr),flowPop.femalePickInd,whichFemalePass) ;

index2PassFromMale = sub2ind(size(flowPop.femalesCurr),flowPop.MalePickInd(:,1),flowPop.MalePickInd(:,2)) ;

newFemales(:,1) = flowPop.femalesCurr(index2PassFromMale) ;

newFemales(:,2) = flowPop.femalesCurr(index2PassFromFemale) ;

index2PassMale5Ind = sub2ind(size(flowPop.maleCurr),...
    repmat(flowPop.MalePickInd(:,1),[1,1,popPara.amountSLF]),...
    repmat(flowPop.MalePickInd(:,2),[1,1,popPara.amountSLF]),...
    permute(repmat([1:popPara.amountSLF],[popPara.numInd,1,1]),[ 1 3 2])) ;

index2PassFemale5Ind = sub2ind(size(flowPop.maleCurr),...
    repmat(flowPop.femalePickInd(:,1),[1,1,popPara.amountSLF]),...
    repmat(whichFemalePass,[1,1,popPara.amountSLF]),...
    permute(repmat([1:popPara.amountSLF],[popPara.numInd,1,1]),[1 3 2])) ;

newMale(:,1,:) = flowPop.maleCurr(index2PassMale5Ind) ;

newMale(:,2,:) = flowPop.maleCurr(index2PassFemale5Ind) ;

flowPop.femalesCurr = newFemales ;
flowPop.maleCurr = newMale ;

newAncestor(:,1) = flowPop.ancestorIndex(index2PassFromMale) ;

newAncestor(:,2) = flowPop.ancestorIndex(index2PassFromFemale) ;

flowPop.ancestorIndex = newAncestor ;

malePickIndExpanded = sub2ind(size(flowPop.SLFAncestorIndex),...
    repelem(flowPop.MalePickInd(:,1),1,1,popPara.amountSLF),...
    repelem(flowPop.MalePickInd(:,2),1,1,popPara.amountSLF),...
    permute(repelem(1:popPara.amountSLF,popPara.numInd,1,1),[1 3 2 ])) ;

femalePickIndExpanded = sub2ind(size(flowPop.SLFAncestorIndex),...
    repelem(flowPop.femalePickInd(:,1),1,1,popPara.amountSLF),...
    repelem(whichFemalePass,1,1,popPara.amountSLF),...
    permute(repelem(1:popPara.amountSLF,popPara.numInd,1,1), [ 1 3 2])) ;

newSLFAncestor(:,1,:) = flowPop.SLFAncestorIndex(malePickIndExpanded) ;

newSLFAncestor(:,2,:) = flowPop.SLFAncestorIndex(femalePickIndExpanded) ;

flowPop.SLFAncestorIndex(:,1,:) = newSLFAncestor(:,1,:) ;
flowPop.SLFAncestorIndex(:,2,:) = newSLFAncestor(:,2,:) ;


newAmountJumps(:,1,:) = flowPop.amountOfJumps(index2PassMale5Ind) ;

newAmountJumps(:,2,:) = flowPop.amountOfJumps(index2PassFemale5Ind) ;

flowPop.amountOfJumps = newAmountJumps ;
if isfield(flowPop,'totalJumps4Hist')
    currGenGuess = length(flowPop.totalJumps4Hist) ; 
else
    currGenGuess = 1 ; 
end
flowPop.amountThatSelfed(currGenGuess) = sum(flowPop.MalePickInd(:,1)==flowPop.femalePickInd) ;

% flowPop.treeAncestorIndexes(:,currGenGuess) = vertcat(index2PassFromMale,index2PassFromFemale) ;
if isfield(popPara,'SLFJumpSpan')

    newconvRatePerHaplo(:,1) = flowPop.convRatePerHaplo(index2PassFromMale) ;

    newconvRatePerHaplo(:,2) = flowPop.convRatePerHaplo(index2PassFromFemale) ;
switch popPara.typeOfConvMute
    case 'AddBell'

    whoWillGetAnAdditionConv = gpuArray.rand(size(flowPop.convRatePerHaplo))<= popPara.prob2ChangeRate ;

    add2Conv = whoWillGetAnAdditionConv.*(gpuArray.randn(size(flowPop.convRatePerHaplo))/popPara.widthVarOfAddRate) ;

    topSpanChange = abs(diff(popPara.SLFJumpSpan)) ;

    add2Conv(abs(add2Conv)>=topSpanChange) = sign(add2Conv(abs(add2Conv)>=topSpanChange)).*topSpanChange ;

    flowPop.convRatePerHaplo = newconvRatePerHaplo +add2Conv  ;

    flowPop.convRatePerHaplo(flowPop.convRatePerHaplo<popPara.SLFJumpSpan(1)) = popPara.SLFJumpSpan(1)-flowPop.convRatePerHaplo(flowPop.convRatePerHaplo<popPara.SLFJumpSpan(1)) ;
    flowPop.convRatePerHaplo(flowPop.convRatePerHaplo>popPara.SLFJumpSpan(2)) = 2.*popPara.SLFJumpSpan(2)-flowPop.convRatePerHaplo(flowPop.convRatePerHaplo>popPara.SLFJumpSpan(2)) ;
 


    case 'Multiply'
    factor4Conv = (1 +randn(size(flowPop.convRatePerHaplo)).*popPara.mueRatePerAmino./diff(popPara.SLFJumpSpan)) ; 

    factor4Conv(factor4Conv<1) = 1./(2-factor4Conv(factor4Conv<1)) ;

    factor4Conv(factor4Conv<=0) = 1 ;

    factor4Conv(factor4Conv>=2) = 1 ;

    flowPop.convRatePerHaplo = newconvRatePerHaplo.*factor4Conv  ;

    case 'Add'
add2Conv = (rand(size(flowPop.convRatePerHaplo))<=popPara.mueRatePerAmino.*100).*...
   ((rand(size(flowPop.convRatePerHaplo))<0.5).*2- 1 ).*1./10000 ;
    

    flowPop.convRatePerHaplo = newconvRatePerHaplo +add2Conv  ;

    flowPop.convRatePerHaplo(flowPop.convRatePerHaplo<popPara.SLFJumpSpan(1)) = popPara.SLFJumpSpan(1) ;
    flowPop.convRatePerHaplo(flowPop.convRatePerHaplo>popPara.SLFJumpSpan(2)) = popPara.SLFJumpSpan(2) ;
    otherwise
    flowPop.convRatePerHaplo = newconvRatePerHaplo ;    
 
end

    flowPop.divConvRate(currGenGuess) = std(flowPop.convRatePerHaplo(:)) ;
    
    flowPop.meanConvRate(currGenGuess) = mean(flowPop.convRatePerHaplo(:)) ;

end

end