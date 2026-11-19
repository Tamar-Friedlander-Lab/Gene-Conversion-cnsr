function [flowPop] = BumbleDatingMadeSimple11(popPara,miscPara,flowPop)
%% initialization
% find current generation
currGeneration = size(flowPop.howManyAnces,2) ;

% create empty mats and vecs
flowPop.femalePickInd = gpuArray.zeros(popPara.numInd,1) ;

TimesTried2SelfMateVec = gpuArray.zeros(popPara.numInd,1) ;


allHaveMate = 0 ;

happyCouples = gpuArray.zeros(popPara.numInd,1)==1 ;
currAttempt = 0 ;

flowPop.howManyHaveDated(currGeneration) = 0 ;

vecWhoCanFert = gpuArray.zeros(popPara.numInd,1) ;

selfPollenCorrected = gpuArray.zeros(popPara.numInd,1) ;

whotryingToSelfMate = gpuArray.zeros(popPara.numInd,1) ;

%% find who is SC

[whoCanSelfFert, vecsOfHaploSelf] = HaploSCTester(popPara,miscPara,flowPop) ;

flowPop.SC(currGeneration) = length(whoCanSelfFert) ;

vecWhoCanFert(whoCanSelfFert) = 1 ;


% calculate probability of selfing
selfPollenCorrected(sum(vecsOfHaploSelf,2)==1) = miscPara.selfPollenRatio/2./(1-miscPara.selfPollenRatio/2 ) ;
selfPollenCorrected(sum(vecsOfHaploSelf,2)==2) = miscPara.selfPollenRatio ;

% probability for each female haplo after death
vecOfProbPickingIncDeath = 1-selfPollenCorrected.*miscPara.selfFerDep ;

femProbOfDeath = 1- vecOfProbPickingIncDeath ;
% create vector to choose females.
cumFemProbOfPicking = cumsum(vecOfProbPickingIncDeath) ./sum(vecOfProbPickingIncDeath) ;

% create female candidates
if popPara.ForceFemaleReproduction
    currVecFemaleInd = [1:popPara.numInd]' ;
else   
    [~,currVecFemaleInd] = max((cumFemProbOfPicking' - gpuArray.rand([popPara.numInd,1]))'>0) ;
end
% probability to self and staying alive
ChanceOfSelfingAndAlive = selfPollenCorrected*(1 - miscPara.selfFerDep) ./(1-miscPara.selfFerDep*selfPollenCorrected) ;
% find which female candidates are SC
fertAbilityOfFem  = find(vecWhoCanFert(currVecFemaleInd)) ;
currHaploAbility = vecsOfHaploSelf(currVecFemaleInd,:) ;
% randomly chooe who will self
whoWillSelfFert = fertAbilityOfFem(gpuArray.rand(length(fertAbilityOfFem),1) ...
    <= ChanceOfSelfingAndAlive(currVecFemaleInd(fertAbilityOfFem))) ;


whotryingToSelfMate(whoWillSelfFert) = 1 ;

whotryingToSelfMate= whotryingToSelfMate==1 ;

% choose which diploid 2 self
haploOptions = currHaploAbility(whoWillSelfFert,:) ;
[~,randIndexDumb] = max((gpuArray.rand(length(whoWillSelfFert),2).*haploOptions)') ;
whichHaploSelf2Try = gpuArray.zeros(popPara.numInd,1) ;
whichHaploSelf2Try(whotryingToSelfMate==1) = randIndexDumb' ;

%% start candidate election loop.
while allHaveMate==0
% calculate how many times we repeated the loop.
    flowPop.howManyHaveDated(currGeneration) = ...
        flowPop.howManyHaveDated(currGeneration) + sum(happyCouples == 0 ) ;

    % get details of females
    datingFemaleVec = flowPop.femalesCurr( currVecFemaleInd,:) ;

    currAttempt = currAttempt + 1 ;
    % choose males
    CurrMalePickInd = [gpuArray.randi(popPara.numInd,[popPara.numInd,1]),...
        gpuArray.randi(2,[popPara.numInd,1])];
    % males who are selfing are changed
    CurrMalePickInd(whotryingToSelfMate==1,1) = currVecFemaleInd(whotryingToSelfMate==1) ;
    % count how many selfed this time
    TimesTried2SelfMateVec(whotryingToSelfMate==1) = TimesTried2SelfMateVec(whotryingToSelfMate==1) + 1 ;
    % take a diploid that can self
    CurrMalePickInd(whotryingToSelfMate,2) = whichHaploSelf2Try(whotryingToSelfMate) ;

    whichHaploSelf2Try(whotryingToSelfMate) = 3 - whichHaploSelf2Try(whotryingToSelfMate) ;

    whotryingToSelfMate(:) = 0 ;

    %% calculate energy

    male5Ind = sub2ind(size(flowPop.maleCurr),...
        repmat(CurrMalePickInd(:,1),[1,1,popPara.amountSLF]),...
        repmat(CurrMalePickInd(:,2),[1,1,popPara.amountSLF]),...
        miscPara.mat2Test.mat3) ;
    


    maleDateVec = flowPop.maleCurr(male5Ind) ;

    currIntMatInd = sub2ind(size(flowPop.boolRnaseSlf),...
        repmat(datingFemaleVec,1,1,popPara.amountSLF),...
        repmat(maleDateVec,[1,2,1])) ;

    energyMat = flowPop.boolRnaseSlf(currIntMatInd) ;

    singleRnaseCheck = max(energyMat==1,[],3) ;

    doubleRnaseCheck = min(singleRnaseCheck,[],2) ;

    % update pairs which are ready

    doubleRnaseCheck(happyCouples==1) = 0 ;

    flowPop.femalePickInd(doubleRnaseCheck==1) =  currVecFemaleInd(doubleRnaseCheck==1);

    flowPop.MalePickInd(doubleRnaseCheck==1,:) = CurrMalePickInd(doubleRnaseCheck==1,:) ;

    happyCouples(doubleRnaseCheck) = 1 ;

    if all(happyCouples == 1)
        allHaveMate = 1 ;
    else

%         CurrMalePickInd = [gpuArray.randi(popPara.numInd,[popPara.numInd,1]),...
%             gpuArray.randi(2,[popPara.numInd,1])];

        if mod(currAttempt,popPara.topNumMatingAttempts) == 0
%             currVecFemaleInd = gpuArray.randi(popPara.numInd,[popPara.numInd,1]) ;
%             currVecFemaleInd = differentChancePicking(vecOfProbPickingIncDeath,popPara.numInd)  ;
          [~,currVecFemaleInd] = max((cumFemProbOfPicking' - gpuArray.rand([popPara.numInd,1]))'>0) ;


ChanceOfSelfingAndAlive = selfPollenCorrected*(1 - miscPara.selfFerDep) ./(1-miscPara.selfFerDep*selfPollenCorrected) ;

fertAbilityOfFem  = find(vecWhoCanFert(currVecFemaleInd)) ;
currHaploAbility = vecsOfHaploSelf(currVecFemaleInd,:) ;

whoWillSelfFert = fertAbilityOfFem(gpuArray.rand(length(fertAbilityOfFem),1) ...
    <= ChanceOfSelfingAndAlive(currVecFemaleInd(fertAbilityOfFem))) ;

whotryingToSelfMate = gpuArray.zeros(popPara.numInd,1) ;
whotryingToSelfMate(whoWillSelfFert) = 1 ;

whotryingToSelfMate= whotryingToSelfMate==1 ;

haploOptions = currHaploAbility(whoWillSelfFert,:) ;
[~,randIndexDumb] = max((gpuArray.rand(length(whoWillSelfFert),2).*haploOptions)') ;
whichHaploSelf2Try = gpuArray.zeros(popPara.numInd,1) ;
whichHaploSelf2Try(whotryingToSelfMate==1) = randIndexDumb' ;


        end
    end
end


% flowPop.howManyHaveDated


end