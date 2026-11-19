function flowPop = SLFProfessionism(flowPop,currGeneration)

amountOfRnase2Check = 10 ;

sub4Rnases = sub2ind(size(flowPop.femalesCurr),...
    gpuArray.randi(size(flowPop.femalesCurr,1),amountOfRnase2Check,1),...
    gpuArray.randi(size(flowPop.femalesCurr,2),amountOfRnase2Check,1)) ;

indexesOfRnase = flowPop.femalesCurr(sub4Rnases) ;

vecOfWhoCanDeTox = flowPop.boolRnaseSlf(indexesOfRnase,:) ;

for i = 1:size(flowPop.maleCurr,3)
[vecSlf(i).amounts,vecSlf(i).names] = groupcounts(reshape(...
    flowPop.maleCurr(:,:,i),[],1)) ;

amountDetox(i,:) = sum(vecOfWhoCanDeTox(:,vecSlf(i).names).*vecSlf(i).amounts',2) ;

end

% flowPop.agesStruct.ratioSLFs2Rnase(:,currGeneration) = max(amountDetox)./(sum(amountDetox)-max(amountDetox)) ;
flowPop.agesStruct.ratioSLFs2Rnase(:,currGeneration) = max(amountDetox)./(sum(amountDetox)) ;

end