function flowPop = SLFSpecificCalculator(flowPop)
currGeneration = size(flowPop.howManyAnces,2) ;
binRafsPercent = [1 2 3 4 5 6 7 8 9 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100] ;

binRafsPercent = [1:1:100] ;

uniSLF = unique(flowPop.maleCurr(:));
outSLF = [uniSLF,histc(flowPop.maleCurr(:),uniSLF)];

uniRNase = unique(flowPop.femalesCurr(:));
outRNase = [uniRNase,histc(flowPop.femalesCurr(:),uniRNase)];

matCompWeighedPerc = outRNase(:,2).*flowPop.boolRnaseSlf(uniRNase,uniSLF)./length(flowPop.femalesCurr(:))*100;

for i =1:length(binRafsPercent)

    flowPop.slfNumberOfPartners(currGeneration,i) = sum((sum(matCompWeighedPerc)>=binRafsPercent(i)).*outSLF(:,2)')./sum(outSLF(:,2)) ;

end

% matCompWeighed = matCompWeighed./(size(flowPop.femalesCurr,1)*2) ;

% howMuchEachSLFCanDo = 1./sqrt(sum(matCompWeighed).^2) ;

end