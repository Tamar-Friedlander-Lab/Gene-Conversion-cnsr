function flowPop = GeneRenamer(miscPara,popPara,flowPop) 

if ~isfield(flowPop,'whereGeneResetHappend')
    flowPop.whereGeneResetHappend = [] ;
end
currGeneration = size(flowPop.howManyAnces,2) ;

if numel(flowPop.boolRnaseSlf)>=0.5e+8

    [oldIndOfNewMales,~,maleCurrRenamed] = unique(flowPop.maleCurr) ;

    maleCurrRenamed = reshape(maleCurrRenamed,size(flowPop.maleCurr)) ;

     [oldIndOfNewFemales,~,femaleCurrRenamed] = unique(flowPop.femalesCurr) ;

    femaleCurrRenamed = reshape(femaleCurrRenamed,size(flowPop.femalesCurr)) ;
    
    newSlfList = flowPop.listSLF(oldIndOfNewMales,:) ;

    newRnaseList = flowPop.listRnase(oldIndOfNewFemales,:) ;
    
%     newBool = RNaseSLFReactor3(newRnaseList,newSlfList,miscPara,1) ;
% 
%     flowPop.boolRnaseSlf = reshape(newBool,size(newSlfList,1),[])' ;

    flowPop.boolRnaseSlf =  flowPop.boolRnaseSlf(oldIndOfNewFemales,oldIndOfNewMales) ;


    flowPop.maleCurr = maleCurrRenamed ;

    flowPop.femalesCurr = femaleCurrRenamed ;

    flowPop.listSLF = newSlfList ;

    flowPop.listRnase = newRnaseList ;

    flowPop.whereGeneResetHappend(end+1) = currGeneration ;

end





end