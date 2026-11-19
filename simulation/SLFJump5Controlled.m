function [flowPop] = SLFJump5Controlled(popPara,flowPop,WhoWillHaveAJump,whichSLFWillJump,directionOfJump,miscPara) 


currRNase = flowPop.femalesCurr ;
currRNase = currRNase(:) ;

vec4RNaseHist = 0.5:1:size(flowPop.listRnase,1)+0.5 ;

amountEachRnase = histcounts(currRNase,vec4RNaseHist)./length(currRNase) ;


[whoCanSelfFert, vecsOfHaploSelfPrev] = HaploSCTester(popPara,miscPara,flowPop) ;

vecsOfHaploSelfPrev = vecsOfHaploSelfPrev(:) ;

% WhoWillHaveAJump = gpuArray.rand(popPara.numInd,1)<=popPara.SLFJumpRate ;

% whichSLFWillJump = ceil(gpuArray.rand(sum(WhoWillHaveAJump),1).*popPara.amountSLF) ;

% directionOfJump = ceil(gpuArray.rand(sum(WhoWillHaveAJump),1).*2) ;

oppositeDirJump = 3 - directionOfJump ;

indOfJump = sub2ind(size(flowPop.maleCurr),find(WhoWillHaveAJump),directionOfJump,whichSLFWillJump) ;

indOfLanding = sub2ind(size(flowPop.maleCurr),find(WhoWillHaveAJump),oppositeDirJump,whichSLFWillJump) ;

holdMale = flowPop.maleCurr(indOfLanding) ;
holdAnces = flowPop.SLFAncestorIndex(indOfLanding) ;

indNearLanding = sub2ind(size(flowPop.maleCurr),repelem(find(WhoWillHaveAJump),1,popPara.amountSLF),...
    repelem(oppositeDirJump,1,popPara.amountSLF),repelem(1:popPara.amountSLF,sum(WhoWillHaveAJump),1)) ;

preVecOfCompSLFs = flowPop.boolRnaseSlf(:,flowPop.maleCurr(indNearLanding));
vec4Summing = repelem(diag(ones(sum(WhoWillHaveAJump),1)),1,popPara.amountSLF) ;
 
prevCompOfMales = preVecOfCompSLFs * vec4Summing'~=0 ;
prevScoreEachMale = sum(prevCompOfMales .*amountEachRnase') ;



flowPop.maleCurr(indOfLanding) = flowPop.maleCurr(indOfJump) ; 

flowPop.SLFAncestorIndex(indOfLanding) = flowPop.SLFAncestorIndex(indOfJump) ;

% 
% flowPop.maleCurr(indOfJump) = holdMale;
% flowPop.SLFAncestorIndex(indOfJump) = holdAnces;

indOfHistory = sub2ind(size(flowPop.numOFJumpInHistories),find(WhoWillHaveAJump),oppositeDirJump) ;

flowPop.numOFJumpInHistories(indOfHistory) = flowPop.numOFJumpInHistories(indOfHistory) + 1 ;

flowPop.amountOfJumps(indOfLanding) = flowPop.amountOfJumps(indOfJump) ;

flowPop.amountOfJumps(indOfLanding) = flowPop.amountOfJumps(indOfLanding) + 1 ;



indNearLanding = sub2ind(size(flowPop.maleCurr),repelem(find(WhoWillHaveAJump),1,popPara.amountSLF),...
    repelem(oppositeDirJump,1,popPara.amountSLF),repelem(1:popPara.amountSLF,sum(WhoWillHaveAJump),1)) ;

postreVecOfCompSLFs = flowPop.boolRnaseSlf(:,flowPop.maleCurr(indNearLanding));
 
postCompOfMales = postreVecOfCompSLFs * vec4Summing'~=0 ;
postvScoreEachMale = sum(postCompOfMales .*amountEachRnase') ;
if isfield(flowPop,'totalJumps4Hist')
    currGenGuess = length(flowPop.totalJumps4Hist) ; 
else
    currGenGuess = 1 ; 
end

flowPop.compJump(currGenGuess,1).impact = postvScoreEachMale./prevScoreEachMale ;
flowPop.compJump(currGenGuess,1).prev = prevScoreEachMale ;
flowPop.compJump(currGenGuess,1).post = postvScoreEachMale ;

RNaseOFJumps = flowPop.femalesCurr(WhoWillHaveAJump,:) ;

RNaseOFJumps = RNaseOFJumps(oppositeDirJump' + [0:length(oppositeDirJump)-1]*2) ;

[whoCanSelfFert, vecsOfHaploSelfPost] = HaploSCTester(popPara,miscPara,flowPop) ;

vecsOfHaploSelfPost = vecsOfHaploSelfPost(:) ;




flowPop.compJump(currGenGuess,1).prevSelf = vecsOfHaploSelfPrev ;
flowPop.compJump(currGenGuess,1).postSelf = vecsOfHaploSelfPost ;

flowPop.compJump(currGenGuess,1).medianImp = median(flowPop.compJump(currGenGuess,1).impact) ;

end