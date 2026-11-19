function BaseLoadedFlow = FlowerLoader(baseNameFormat,repAmount,combAmount) 

sperAges = 10 ;
sperGen = 10 ;
startOFGoodGen = 50000 ;
        num2LimDist = 5e-2 ;
startOfGoodAge = startOFGoodGen./sperGen ;


for currRep = 1:repAmount
    for currComb = 1: combAmount
% save('pleaseWork')
        [currRep,currComb]
        currFlow = load(sprintf(baseNameFormat, currRep, currComb) ,'flowPop') ;
        currFlow = currFlow.flowPop ;
        currAge = currFlow.agesStruct ;
    try
        BaseLoadedFlow(currRep,currComb).convRatePerHaplo = currFlow.convRatePerHaplo ;
    end
        AgesInd = (startOfGoodAge+ 1):sperAges:length(currAge.amountOfDivitions) ;

        BaseLoadedFlow(currRep,currComb).identicalSLFProp = currFlow.identicalSLFProp ;

        BaseLoadedFlow(currRep,currComb).maleCurr = currFlow.maleCurr ;

        BaseLoadedFlow(currRep,currComb).howManyHaveDated = currFlow.howManyHaveDated ;

        BaseLoadedFlow(currRep,currComb).femalesCurr = currFlow.femalesCurr ;


       BaseLoadedFlow(currRep,currComb).boolRnaseSlf = gather(currFlow.boolRnaseSlf) ;

        BaseLoadedFlow(currRep,currComb).ageStruct= currAge.divition(AgesInd) ;

        BaseLoadedFlow(currRep,currComb).SC = currFlow.SC(startOFGoodGen:end) ;
try
        BaseLoadedFlow(currRep,currComb).maleDistributionAmino = currFlow.maleDistributionAmino(startOFGoodGen:end,:) ;
end
try
        

        BaseLoadedFlow(currRep,currComb).meanConvRate = currFlow.meanConvRate(startOFGoodGen:end) ;
%        BaseLoadedFlow(currRep,currComb).femaleDistributionAmino = currFlow.femaleDistributionAmino(startOFGoodGen:end,:) ;


        BaseLoadedFlow(currRep,currComb).impactOfJump = gather(reshape(...
            [currFlow.compJump(:).impact]...
            ,[],1)) ;

        BaseLoadedFlow(currRep,currComb).prevSelfJump = gather(reshape(...
            [currFlow.compJump(:).prevSelf]...
            ,[],1)) ;

        BaseLoadedFlow(currRep,currComb).postSelfJump = gather(reshape(...
            [currFlow.compJump(:).postSelf]...
            ,[],1)) ;
end

        BaseLoadedFlow(currRep,currComb).ratioSLFs2Rnase = ...
            reshape(currAge.ratioSLFs2Rnase(:,AgesInd),[],1) ;

        BaseLoadedFlow(currRep,currComb).effectiveNumberOnlyInDiv = ...
            currAge.effectiveNumberOnlyInDiv(AgesInd) ;

        BaseLoadedFlow(currRep,currComb).amountOfDivitions = ...
            currAge.amountOfDivitions(AgesInd) ;
        
        BaseLoadedFlow(currRep,currComb).effectiveNumberOFDivitions = ...
            currAge.effectiveNumberOFDivitions(AgesInd) ;

%         BaseLoadedFlow(currRep,currComb).howManyAnces = ...
%              currAge.howManyAnces(AgesInd) ;

         BaseLoadedFlow(currRep,currComb).howManyDivitioned = ...
             currAge.howManyDivitioned(AgesInd) ;

        BaseLoadedFlow(currRep,currComb).effectiveNumber = ...
             currAge.effectiveNumber(AgesInd) ;
        
%         BaseLoadedFlow(currRep,currComb).probComp = ...
%              currFlow.probComp(startOFGoodGen:end,:) ;
        
%         BaseLoadedFlow(currRep,currComb).CompDist = ...
%              currFlow.CompDist(startOFGoodGen:end,:) ;

%        BaseLoadedFlow(currRep,currComb).slfNumberOfPartners = ...
%        currFlow.slfNumberOfPartners(startOFGoodGen:end,:) ;
        

        BaseLoadedFlow(currRep,currComb).totalJumps4Hist = ...
             currFlow.totalJumps4Hist(startOFGoodGen:end) ;
    
        BaseLoadedFlow(currRep,currComb).amountThatSelfed = ...
             currFlow.amountThatSelfed(startOFGoodGen:end) ;
    
      try  
        BaseLoadedFlow(currRep,currComb).averageSLFDist = ...
            currAge.averageSLFDist(AgesInd,:) ;
        
        BaseLoadedFlow(currRep,currComb).amountNoRelationSpec = sum(BaseLoadedFlow(currRep,currComb).averageSLFDist<=num2LimDist,2) ;


        BaseLoadedFlow(currRep,currComb).averageSLFDist = BaseLoadedFlow(currRep,currComb).averageSLFDist(:) ;
     
        BaseLoadedFlow(currRep,currComb).ratioDistSlf = ...
            currAge.ratioDistSlf(AgesInd) ;

        BaseLoadedFlow(currRep,currComb).averageSLFDist2All = ...
            currAge.averageSLFDist2All(AgesInd,:) ;

        
        BaseLoadedFlow(currRep,currComb).amountNoRelationAll = sum(BaseLoadedFlow(currRep,currComb).averageSLFDist2All<=num2LimDist,2) ;


        BaseLoadedFlow(currRep,currComb).averageSLFDist2All = BaseLoadedFlow(currRep,currComb).averageSLFDist2All(:) ;



      

        BaseLoadedFlow(currRep,currComb).averageSLFDist = BaseLoadedFlow(currRep,currComb).averageSLFDist(BaseLoadedFlow(currRep,currComb).averageSLFDist>num2LimDist) ;
        
        BaseLoadedFlow(currRep,currComb).averageSLFDist2All = BaseLoadedFlow(currRep,currComb).averageSLFDist2All(BaseLoadedFlow(currRep,currComb).averageSLFDist2All>num2LimDist) ;
      end



    end
end






end