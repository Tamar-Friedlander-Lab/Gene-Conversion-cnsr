function [DaNumber] = effectiveNumberCalcSpecial(RnaseSlfCond)

% RnaseSlfCond = cat(3,flowPop.femalesCurr,flowPop.maleCurr) ;
% 
% RnaseSlfCond = reshape(RnaseSlfCond,[],size(RnaseSlfCond,3)) ;

[~,~,numbB4Hist] = unique(RnaseSlfCond,'rows') ;

amountOfEach = histcounts(numbB4Hist,max(numbB4Hist));

amountOfEach = amountOfEach./sum(amountOfEach) ;

DaNumber = 1./sum(amountOfEach.^(2)) ;

end