function [flowPop] = SLFJump7(popPara,flowPop) 

if isfield(flowPop,'totalJumps4Hist')
    currGenGuess = length(flowPop.totalJumps4Hist) ; 
else
    currGenGuess = 1 ; 
end

preVecOfCompSLFs = flowPop.boolRnaseSlf(:,flowPop.maleCurr);


currRNase = flowPop.femalesCurr ;
currRNase = currRNase(:) ;

vec4RNaseHist = 0.5:1:size(flowPop.listRnase,1)+0.5 ;

amountEachRnase = histcounts(currRNase,vec4RNaseHist)./length(currRNase) ;

ratePerSLF = repelem(1 - (1-flowPop.convRatePerHaplo).^(1/popPara.amountSLF),1,1,popPara.amountSLF) ;

slfBinWillLand = gpuArray.rand(size(ratePerSLF))<=ratePerSLF ;

Cancel2Dir = sum(slfBinWillLand,2)==2 ;

slfBinWillLand(:,1,:) = slfBinWillLand(:,1,:).*(Cancel2Dir==0) ;

slfBinWillLand(:,2,:) = slfBinWillLand(:,2,:).*(Cancel2Dir==0) ;

slfBinWillJump = flip(slfBinWillLand,2) ;

WhoWillHaveAJump = sum(slfBinWillLand,2).*[1:500]' ;

whichSLFLocWillLand = slfBinWillLand.*permute(repmat([1:popPara.amountSLF],[popPara.numInd,1,2]),[1,3,2]) ;

whichSLFLocWillJump = slfBinWillJump.*permute(repmat([1:popPara.amountSLF],[popPara.numInd,1,2]),[1,3,2]) ;

SLFAllPop = flowPop.maleCurr ;

SLF2Jump = SLFAllPop(slfBinWillJump == 1) ;

SLF2Land = SLFAllPop(slfBinWillLand == 1) ;

SLFAllPop(slfBinWillLand == 1) = SLF2Jump ;

SLFAllPop(slfBinWillLand == 1) = SLF2Jump ;

flowPop.maleCurr = SLFAllPop ;

flowPop.numOFJumpInHistories = flowPop.numOFJumpInHistories + sum(slfBinWillLand,3) ;

flowPop.amountOfJumps(slfBinWillLand) = flowPop.amountOfJumps(slfBinWillJump) ;

flowPop.amountOfJumps(slfBinWillLand) = flowPop.amountOfJumps(slfBinWillLand) + 1 ;

postreVecOfCompSLFs = flowPop.boolRnaseSlf(:,flowPop.maleCurr);

preVecOfCompSLFs = reshape(preVecOfCompSLFs,[],popPara.numInd,2,popPara.amountSLF) ;

postreVecOfCompSLFs = reshape(postreVecOfCompSLFs,[],popPara.numInd,2,popPara.amountSLF) ;

% sum(squeeze(sum(postreVecOfCompSLFs == preVecOfCompSLFs)),3)

preComp = squeeze(sum(preVecOfCompSLFs,4))>0 ;

postComp = squeeze(sum(postreVecOfCompSLFs,4))>0 ;

RnaseInPlay = unique(flowPop.femalesCurr) ;

compRat = squeeze(mean(postComp(RnaseInPlay,:,:))./mean(preComp(RnaseInPlay,:,:))) ;

haploHasRecieved = squeeze(sum(slfBinWillLand,3)>0) ;
try
flowPop.compJump(currGenGuess,1).impact = compRat(haploHasRecieved) ;

flowPop.compJump(currGenGuess,1).medianImp = median(flowPop.compJump(currGenGuess,1).impact) ;
end

flowPop.identicalSLFProp(currGenGuess) = mean(mean(flowPop.maleCurr(:,1,:)==flowPop.maleCurr(:,2,:))) ;

% 
% 
% WhoWillHaveAJump(WhoWillHaveAJump)
% 
% initialHaplos = flowPop.maleCurr(WhoWillHaveAJump(:),1)
% 
% if isfield(popPara,'SLFJumpSpan')
% %     WhoWillHaveAJump = gpuArray.rand(popPara.numInd,1)<=sqrt(prod(flowPop.convRatePerHaplo,2)) ;
%     WhoWillHaveAJump = gpuArray.rand(popPara.numInd,1)<=popPara.func4DiffConv(flowPop.convRatePerHaplo) ;
% 
% else
%     WhoWillHaveAJump = gpuArray.rand(popPara.numInd,1)<=popPara.SLFJumpRate ;
% end
% whichSLFWillJump = ceil(gpuArray.rand(sum(WhoWillHaveAJump),1).*popPara.amountSLF) ;
% if isfield(popPara,'SLFJumpSpan')
%     if strcmp(func2str(popPara.func4DiffConv),'JustMean')
% 
% %         directionOfJump = ceil(gpuArray.rand(sum(WhoWillHaveAJump),1).*2) ;
%     
%         directionOfJump = 3 -((gpuArray.rand(sum(WhoWillHaveAJump),1).*sum(flowPop.convRatePerHaplo(WhoWillHaveAJump,:),2) ...
%             - flowPop.convRatePerHaplo(WhoWillHaveAJump,1)<0) + 1) ;
% 
%     else
%     
%         directionOfJump = ceil(gpuArray.rand(sum(WhoWillHaveAJump),1).*2) ;
%     end
%     else
% 
%         directionOfJump = ceil(gpuArray.rand(sum(WhoWillHaveAJump),1).*2) ;
% 
% end
% oppositeDirJump = 3 - directionOfJump ;
% 
% indOfJump = sub2ind(size(flowPop.maleCurr),find(WhoWillHaveAJump),directionOfJump,whichSLFWillJump) ;
% 
% indOfLanding = sub2ind(size(flowPop.maleCurr),find(WhoWillHaveAJump),oppositeDirJump,whichSLFWillJump) ;
% 
% holdMale = flowPop.maleCurr(indOfLanding) ;
% holdAnces = flowPop.SLFAncestorIndex(indOfLanding) ;
% 
% indNearLanding = sub2ind(size(flowPop.maleCurr),repelem(find(WhoWillHaveAJump),1,popPara.amountSLF),...
%     repelem(oppositeDirJump,1,popPara.amountSLF),repelem(1:popPara.amountSLF,sum(WhoWillHaveAJump),1)) ;
% 
% preVecOfCompSLFs = flowPop.boolRnaseSlf(:,flowPop.maleCurr(indNearLanding));
% vec4Summing = repelem(diag(ones(sum(WhoWillHaveAJump),1)),1,popPara.amountSLF) ;
%  
% prevCompOfMales = preVecOfCompSLFs * vec4Summing'~=0 ;
% prevScoreEachMale = sum(prevCompOfMales .*amountEachRnase') ;
% 
% 
% 
% flowPop.maleCurr(indOfLanding) = flowPop.maleCurr(indOfJump) ; 
% 
% flowPop.SLFAncestorIndex(indOfLanding) = flowPop.SLFAncestorIndex(indOfJump) ;
% 
% 
% % flowPop.maleCurr(indOfJump) = holdMale;
% % flowPop.SLFAncestorIndex(indOfJump) = holdAnces;
% 
% indOfHistory = sub2ind(size(flowPop.numOFJumpInHistories),find(WhoWillHaveAJump),oppositeDirJump) ;
% 
% flowPop.numOFJumpInHistories(indOfHistory) = flowPop.numOFJumpInHistories(indOfHistory) + 1 ;
% 
% flowPop.amountOfJumps(indOfLanding) = flowPop.amountOfJumps(indOfJump) ;
% 
% flowPop.amountOfJumps(indOfLanding) = flowPop.amountOfJumps(indOfLanding) + 1 ;
% 
% 
% 
% indNearLanding = sub2ind(size(flowPop.maleCurr),repelem(find(WhoWillHaveAJump),1,popPara.amountSLF),...
%     repelem(oppositeDirJump,1,popPara.amountSLF),repelem(1:popPara.amountSLF,sum(WhoWillHaveAJump),1)) ;
% 
% postreVecOfCompSLFs = flowPop.boolRnaseSlf(:,flowPop.maleCurr(indNearLanding));
%  
% postCompOfMales = postreVecOfCompSLFs * vec4Summing'~=0 ;
% postvScoreEachMale = sum(postCompOfMales .*amountEachRnase') ;
% if isfield(flowPop,'totalJumps4Hist')
%     currGenGuess = length(flowPop.totalJumps4Hist) ; 
% else
%     currGenGuess = 1 ; 
% end
% 
% flowPop.compJump(currGenGuess,1).impact = postvScoreEachMale./prevScoreEachMale ;
% flowPop.compJump(currGenGuess,1).prev = prevScoreEachMale ;
% flowPop.compJump(currGenGuess,1).post = postvScoreEachMale ;
% 
% RNaseOFJumps = flowPop.femalesCurr(WhoWillHaveAJump,:) ;
% 
% RNaseOFJumps = RNaseOFJumps(oppositeDirJump' + [0:length(oppositeDirJump)-1]*2) ;
% 
% flowPop.compJump(currGenGuess,1).prevSelf = prevCompOfMales(RNaseOFJumps) ;
% flowPop.compJump(currGenGuess,1).postSelf = postCompOfMales(RNaseOFJumps) ;
% 
% flowPop.compJump(currGenGuess,1).medianImp = median(flowPop.compJump(currGenGuess,1).impact) ;
% 
end