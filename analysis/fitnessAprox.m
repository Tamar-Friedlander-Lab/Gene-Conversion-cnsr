function [fitEachHaplo,fitEachHaploFix,fitSI,fitFSC,fitHSCP,fitHSCN] = fitnessAprox(popPara,miscPara,flowPop)

genesOfPop = [flowPop.femalesCurr(:),reshape(flowPop.maleCurr,[],popPara.amountSLF)] ;

quirckyStrings = genesOfPop ;
amountOfQuircky = size(genesOfPop,1) ;

index4Table = sub2ind(size(flowPop.boolRnaseSlf),repmat(quirckyStrings(:,1),amountOfQuircky,popPara.amountSLF),...
repelem(quirckyStrings(:,2:end),amountOfQuircky,1)) ;
eneAfterTable = flowPop.boolRnaseSlf(index4Table) ;
eneCheck = max(eneAfterTable,[],2) ;
eneCheck = reshape(eneCheck,amountOfQuircky,[]) ;

dipCheck = (eneCheck(1:500,:)+eneCheck(501:end,:))==2 ;
fitEachHaplo = sum(dipCheck)/500 ;

% fitEachHaplo = fitEachHaplo ;

chance2Partner = 500./flowPop.howManyHaveDated(end) ;

NumberOFAttempts4Males = 1./chance2Partner ;

ScMat = dipCheck(:,1:500) + dipCheck(:,501:end) ;

SCVec = diag(ScMat) ;

whoIsSI = repmat(SCVec == 0,2,1) ;

whoIsFSC = repmat(SCVec == 2,2,1) ;
whoISHSC = repmat(SCVec == 1,2,1) ;

whoISHSCPos(1:500) = whoISHSC(1:500).*diag(dipCheck(:,1:500)) ;
whoISHSCPos(501:1000) = whoISHSC(501:end).*diag(dipCheck(:,501:end)) ;

whoISHSCNeg(1:500) = whoISHSC(1:500).*(diag(dipCheck(:,1:500))==0) ;
whoISHSCNeg(501:1000) = whoISHSC(501:end).*(diag(dipCheck(:,501:end))==0)  ;

alphaTag = miscPara.selfPollenRatio/2./(1-miscPara.selfPollenRatio/2 ) ; ;

fitEchDiplo = repmat(sum(dipCheck,2),2,1)'/1000 ;

fSI = whoIsSI'.*(0.5*(1-(1-fitEachHaplo).^NumberOFAttempts4Males) + 0.5.*(1-(1-fitEchDiplo).^5)) ;

fFSC = whoIsFSC'.*(0.5*(1-(1-fitEachHaplo).^NumberOFAttempts4Males) + miscPara.selfPollenRatio.*(1- miscPara.selfFerDep) +...
    (1-miscPara.selfPollenRatio)/2.*(1-(1-fitEchDiplo).^5)) ;

fHSCPos = whoISHSCPos.*(0.5*(1-(1-fitEachHaplo).^NumberOFAttempts4Males)  +alphaTag.*1.5.*(1-miscPara.selfFerDep) ...
    + (1-alphaTag)/2.*(1-(1-fitEchDiplo).^5)) ;

fHSCNeg = whoISHSCNeg.*(0.5*(1-(1-fitEachHaplo).^NumberOFAttempts4Males)  +alphaTag.*0.5.*(1-miscPara.selfFerDep) ...
    + (1-alphaTag)/2.*(1-(1-fitEchDiplo).^5)) ;
fitEachHaploFix = fSI + fFSC + fHSCPos + fHSCNeg ;

fitEachHaploFix = fitEachHaploFix./mean(fitEachHaploFix) ;

fitSI = fitEachHaploFix(whoIsSI==1) ;

fitFSC = fitEachHaploFix(whoIsFSC==1) ;

fitHSCP = fitEachHaploFix(whoISHSCPos==1) ;

fitHSCN = fitEachHaploFix(whoISHSCNeg==1) ;



end