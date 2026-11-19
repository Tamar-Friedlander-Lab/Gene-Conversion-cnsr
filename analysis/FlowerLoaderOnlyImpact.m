function BaseLoadedFlow = FlowerLoaderOnlyImpact(baseNameFormat,repAmount,combAmount)

sperAges = 10 ;
sperGen = 10 ;
startOFGoodGen = 50000 ;
num2LimDist = 5e-2 ;
startOfGoodAge = startOFGoodGen./sperGen ;


for currRep = 2:repAmount
    for currComb = 2: combAmount
        % save('pleaseWork')
        [currRep,currComb]
        currFlow = load(sprintf(baseNameFormat, currRep, currComb) ,'flowPop') ;
        currFlow = currFlow.flowPop ;
        currAge = currFlow.agesStruct ;
        try
            BaseLoadedFlow(currRep,currComb).convRatePerHaplo = currFlow.convRatePerHaplo ;
        end
        AgesInd = (startOfGoodAge+ 1):sperAges:length(currAge.amountOfDivitions) ;
        try
            BaseLoadedFlow(currRep,currComb).maleDistributionAmino = currFlow.maleDistributionAmino(startOFGoodGen:end,:) ;
        end
        try


            BaseLoadedFlow(currRep,currComb).meanConvRate = currFlow.meanConvRate(startOFGoodGen:end) ;
            %        BaseLoadedFlow(currRep,currComb).femaleDistributionAmino = currFlow.femaleDistributionAmino(startOFGoodGen:end,:) ;


            BaseLoadedFlow(currRep,currComb).impactOfJump = gather(reshape(...
                vertcat(currFlow.compJump(:).impact)...
                ,[],1)) ;

            BaseLoadedFlow(currRep,currComb).prevSelfJump = gather(reshape(...
                vertcat(currFlow.compJump(:).prevSelf)...
                ,[],1)) ;

            BaseLoadedFlow(currRep,currComb).postSelfJump = gather(reshape(...
                vertcat(currFlow.compJump(:).postSelf)...
                ,[],1)) ;
        end

     



    end
end






end