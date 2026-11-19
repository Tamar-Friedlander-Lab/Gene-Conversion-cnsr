function [whoCanSelfFert, doubleRnaseCheck] = HaploSCTester(popPara,miscPara,flowPop)
    
    currVecFemaleInd = [1:popPara.numInd]' ;

    datingFemaleVec = flowPop.femalesCurr( currVecFemaleInd,:) ;
    CurrMalePickInd = single([[1:popPara.numInd]']);

    if ~isfield(miscPara,'mat2Test')

        miscPara.mat2Test.mat1 =  repmat(CurrMalePickInd(:,1),[1,1,popPara.amountSLF]) ;
        CurrMalePickInd(:,2) = 1 ;
        miscPara.mat2Test.mat2a =  repmat(CurrMalePickInd(:,2),[1,1,popPara.amountSLF]) ;
    
        CurrMalePickInd(:,2) = 2 ;
        miscPara.mat2Test.mat2b =  repmat(CurrMalePickInd(:,2),[1,1,popPara.amountSLF]) ;

        miscPara.mat2Test.mat3 = repmat([1:popPara.amountSLF],[popPara.numInd,1,1]) ;

    end

    if size(datingFemaleVec,2)==2
    for i = 1:2
    CurrMalePickInd(:,2) = i ;

%     male5Ind = sub2ind(size(flowPop.maleCurr),...
%         repmat(CurrMalePickInd(:,1),[1,1,popPara.amountSLF]),...
%         repmat(CurrMalePickInd(:,2),[1,1,popPara.amountSLF]),...
%         repmat([1:popPara.amountSLF],[popPara.numInd,1,1])) ;
    if i == 1
         currMat2 = miscPara.mat2Test.mat2a ;
    else
         currMat2 = miscPara.mat2Test.mat2b ;
    end

     male5Ind = sub2ind(size(flowPop.maleCurr),...
        miscPara.mat2Test.mat1,...
        currMat2,...
        miscPara.mat2Test.mat3) ;
   

    maleDateVec = flowPop.maleCurr(male5Ind) ;

    currIntMatInd = sub2ind(size(flowPop.boolRnaseSlf),...
            repmat(datingFemaleVec,1,1,popPara.amountSLF),...
            repmat(maleDateVec,1,2,1)) ;

    energyMat = flowPop.boolRnaseSlf(currIntMatInd) ;

    
    singleRnaseCheck = max(energyMat==1,[],3) ; 
    
    doubleRnaseCheck(:,i) = min(singleRnaseCheck,[],2) ;

    end

    whoCanSelfFert = find(sum(doubleRnaseCheck')> 0) ;
    else
        male5Ind = sub2ind(size(flowPop.maleCurr),...
        repmat(CurrMalePickInd(:,1),1,1,popPara.amountSLF),...
        repmat([1:popPara.amountSLF],popPara.numInd,1,1)) ;

        maleDateVec = flowPop.maleCurr(male5Ind) ;

        currIntMatInd = sub2ind(size(flowPop.boolRnaseSlf),...
            repmat(datingFemaleVec,1,1,popPara.amountSLF),...
            maleDateVec) ;

        energyMat = flowPop.boolRnaseSlf(currIntMatInd) ;

        singleRnaseCheck = max(energyMat==1,[],3) ; 
    
         doubleRnaseCheck = min(singleRnaseCheck,[],2) ;

         whoCanSelfFert = find(sum(doubleRnaseCheck')> 0) ;

    end

end