function [popPara] = SampleIntiatorLikeAmitConvSpan(popPara,miscPara)




%% draw n Srnases

numberIWantOfRNases = ceil(popPara.numInd.*popPara.startingVariety) ; 

numberIWantOfRNases = popPara.amountSLF + 1 ;

RnaseMat = ceil(interp1([0, cumsum(miscPara.aminoFreq)],0:4,...
            gpuArray.rand(numberIWantOfRNases,popPara.numAmino) )) ;

%% create Slf pools

stillWorkingOnSLF = 1 ;

for i = 1:numberIWantOfRNases
SLFPools(i).mat = [] ;
SLFPools(i).amountIn = 0 ;
end


while stillWorkingOnSLF

    newSLf = ceil(interp1([0, cumsum(miscPara.aminoFreq)],0:4,...
            gpuArray.rand(1,popPara.numAmino) )) ;

    energyInteractionSelf = sum(miscPara.compTable(sub2ind(size(miscPara.compTable),...
    repelem(newSLf,numberIWantOfRNases,1),RnaseMat)),2) ;

    if 0==or(mean(energyInteractionSelf<=miscPara.energyBarrier)==1,mean(energyInteractionSelf<=miscPara.energyBarrier)==0)

        howManyPools2Add2 = sum(energyInteractionSelf<=miscPara.energyBarrier) ;
        whichPools2Add2 = find(energyInteractionSelf<=miscPara.energyBarrier) ;

        for i = whichPools2Add2'

            SLFPools(i).amountIn = SLFPools(i).amountIn + 1;

            SLFPools(i).mat(SLFPools(i).amountIn,:) = newSLf;


        end

    end

    if mean(horzcat(SLFPools.amountIn) >= popPara.amountSLF*10 ) ==1
        stillWorkingOnSLF = 0 ;
    end

end



%% create haplotypes
for j =1:numberIWantOfRNases
    currSLFMat = [] ;
    stillWorkingOnCurrHaplo = 1 ;

    pools2DrawFrom = 1:numberIWantOfRNases ;
    pools2DrawFrom = pools2DrawFrom(pools2DrawFrom~=j) ;

    for i = pools2DrawFrom
        currSLFOptions(i).indices = 1:SLFPools(i).amountIn ;
        currSLF2Try(i) = currSLFOptions(i).indices(randi(length(currSLFOptions(i).indices))) ;
        currSLFMat(i,:) = SLFPools(i).mat(currSLF2Try(i),:) ;
    end

    while stillWorkingOnCurrHaplo
         energyInteractionSelf = sum(miscPara.compTable(sub2ind(size(miscPara.compTable),...
           currSLFMat(pools2DrawFrom,:),repelem(RnaseMat(j,:),numberIWantOfRNases-1,1))),2) ;

         SLF2Change = energyInteractionSelf<=miscPara.energyBarrier ;

         if mean(SLF2Change)==0

            SLFStruct(j).mat = currSLFMat(pools2DrawFrom,:) ;


             stillWorkingOnCurrHaplo = 0 ;
         else

             for i = pools2DrawFrom(find(SLF2Change))

                    currSLFOptions(i).indices = currSLFOptions(i).indices(currSLFOptions(i).indices~= currSLF2Try(i));
                    currSLF2Try(i) = currSLFOptions(i).indices(randi(length(currSLFOptions(i).indices))) ;
                    currSLFMat(i,:) = SLFPools(i).mat(currSLF2Try(i),:) ;


             end
         end
    
    end


end

[popPara.startingSLF,a,b] = unique(vertcat(SLFStruct.mat),'rows') ;

popPara.startingRNase = RnaseMat ;

popPara.numStartingUniques = numberIWantOfRNases ;

for i=1:numberIWantOfRNases
    currIndices = (1:popPara.amountSLF) + (i-1).*popPara.amountSLF ;
    rnaseFinal(i) = i ;
    SLFFinal(i,:) = b(currIndices) ; 
end



numberIWantOfRNases = min(numberIWantOfRNases, ceil(popPara.numInd.*popPara.startingVariety)) ; 



popPara.firstGenFem = randi(numberIWantOfRNases,popPara.numInd,2) ;
if isfield(popPara,'SLFJumpSpan')
    popPara.convRatePerHaplo = rand(size(popPara.firstGenFem)).*diff(popPara.SLFJumpSpan) + popPara.SLFJumpSpan(1) ;
end
for i = 1:popPara.numInd
    for j = 1:2
        popPara.firstGenMal(i,j,:) = SLFFinal(popPara.firstGenFem(i,j),:) ;
    end
end

end