function flowPop = RateVaryInjectorRandom(flowPop,popPara,miscPara,currGeneration)

if currGeneration>=1e+2 
if length(unique(flowPop.convRatePerHaplo))==1

    % pick class
    stringsIn = flowPop.agesStruct.divition(end).Struct(1).strings ;

    %recreate strings
    stringsPop = [flowPop.femalesCurr(:),reshape(flowPop.maleCurr,[],popPara.amountSLF)] ;

    % start compare
    paarStrings =  permute(repelem(stringsIn,1,1,1000),[3 2 1]) - repelem(stringsPop,1,1,size(stringsIn,1)) ;

    % chack perfect comp
    whosInClass = squeeze(sum(prod(paarStrings==0,2),3)) ;

    % howManyIn class
    howMany2Switch = sum(whosInClass) ;
    %reshpe a lil
    whosInClass(:) = 0 ;
    whosInClass(randperm(size(whosInClass,1),howMany2Switch)) = 1 ;

    whosInClass = reshape(whosInClass,[],2) ;

    flowPop.convRatePerHaplo(whosInClass==1) = popPara.what2Inject - unique(flowPop.convRatePerHaplo) ;

end



end
end