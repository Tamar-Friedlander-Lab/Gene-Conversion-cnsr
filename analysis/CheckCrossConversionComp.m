function conversionStruct = CheckCrossConversionComp(popPara,miscPara,flowPop)

[~,...
    ~,...
    ~,...
    ~,...
    ~,whoIsClassed] = ...
    Divitionator8(popPara,miscPara,flowPop) ;

[whoCanSelfFert, vecsOfHaploSelf] = HaploSCTester(popPara,miscPara,flowPop) ;

vecsOfHaploSelf = vecsOfHaploSelf(:) ;

vecUnClassUnSelf = 1 - vecsOfHaploSelf - whoIsClassed ;

coolMaty = whoIsClassed  + vecUnClassUnSelf*2 + vecsOfHaploSelf*3 ;

typeOfEach = prod(reshape(coolMaty,[],2)') ;



WhoWillHaveAJump = gpuArray.ones(popPara.numInd,1);

whichSLFWillJump = gpuArray.ones(sum(WhoWillHaveAJump),1) ;

directionOfJump = gpuArray.ones(sum(WhoWillHaveAJump),1) ;

amountOfEachInteractionDir1 = zeros(3,3,popPara.numInd) ;

ind4Amounts = sub2ind(size(amountOfEachInteractionDir1),...
    coolMaty(1:popPara.numInd),...
    coolMaty(popPara.numInd+1:end),(1:popPara.numInd)') ;


amountOfEachInteractionDir1(ind4Amounts) = 1 ;

amountOfEachInteractionDir2 = permute(amountOfEachInteractionDir1,[2,1,3]) ;

impactOFEachInteraction = zeros(3,3,popPara.numInd*2,popPara.amountSLF) ;


turning2Self = nan +zeros(3,3,popPara.numInd*2,popPara.amountSLF) ;


for currDir = 1:2

    for currSLF = 1:popPara.amountSLF

        directionOfJump = gpuArray.ones(sum(WhoWillHaveAJump),1).*currDir ;

        WhoWillHaveAJump = gpuArray.ones(popPara.numInd,1)==1;

        whichSLFWillJump = currSLF.*gpuArray.ones(sum(WhoWillHaveAJump),1) ;

%         whichSLFWillJump = randi(currSLF,sum(WhoWillHaveAJump),1) ;

        [flowPopPost] = SLFJump5Controlled(popPara,flowPop,WhoWillHaveAJump,whichSLFWillJump,directionOfJump,miscPara) ;

        [whoCanSelfFertPost, vecsOfHaploSelfPost] = HaploSCTester(popPara,miscPara,flowPopPost) ;


        currImpact = flowPopPost.compJump(end).impact ;
        currPrevSelf = flowPopPost.compJump(end).prevSelf ;
        currPostSelf = flowPopPost.compJump(end).postSelf ;

         currPrevSelf = vecsOfHaploSelf ;
        currPostSelf =  vecsOfHaploSelfPost ;



        if currDir ==1
            currInd = sub2ind(size(impactOFEachInteraction),...
                coolMaty(1:popPara.numInd),...
                coolMaty(popPara.numInd+1:end),...
                (1:popPara.numInd)',...
                repelem(currSLF,popPara.numInd,1)) ;

            startOfSelf = 2 ;

              currPostSelf = currPostSelf(:) ;


        currStartingSelfInd = currInd(currPrevSelf(popPara.numInd+1:end)==0) ;
        aaa = (currPostSelf(popPara.numInd+1:end)) ;
        turning2Self(currStartingSelfInd) = aaa(currPrevSelf(popPara.numInd+1:end)==0) ;
 


        else
            currInd = sub2ind(size(impactOFEachInteraction),...
                coolMaty(popPara.numInd+1:end),...
                coolMaty(1:popPara.numInd),...
                (1:popPara.numInd)',...
                repelem(currSLF,popPara.numInd,1)) ;
             startOfSelf = 1 ;

             currPostSelf = currPostSelf(:) ;

        currStartingSelfInd = currInd(currPrevSelf(1:popPara.numInd)==0) ;
        aaa = (currPostSelf(1:popPara.numInd)) ;
        turning2Self(currStartingSelfInd) = aaa(currPrevSelf(1:popPara.numInd)==0) ;
 
             
        end

        impactOFEachInteraction(currInd) =  currImpact ;
%         turning2Self(currInd(currPrevSelf==0)) = currPostSelf(currPrevSelf==0) ;
% 
%         currStartingSelfInd = currInd(currPrevSelf(startOfSelf:2:end)==0) ;
%         aaa = (currPostSelf(startOfSelf:2:end)) ;
%         turning2Self(currStartingSelfInd) = aaa(currPrevSelf(startOfSelf:2:end)==0) ;

    end
end

totalConMat = amountOfEachInteractionDir1 ;
totalConMat(amountOfEachInteractionDir2 == 1) = 1 ;

conversionStruct.finConMat = sum(sum(impactOFEachInteraction==1,4),3)./sum(totalConMat,3)./popPara.amountSLF ;

conversionStruct.finSelfMat = mean(mean(turning2Self,4,'omitnan'),3,'omitnan')/2 ;

end