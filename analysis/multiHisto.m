function [meFig,zenithPoint] = multiHisto(orgMat,limbyUser,typeOfNormailzation)

if nargin<3
    typeOfNormailzation = 'nothing' ;
end

orgMat(orgMat==inf) = nan ;

meFig = figure;
hold on
amountOfHistos = size(orgMat,2) ;

amount2Divide = 20 ;

if xor(nargin ==1,isempty(limbyUser))
    limsOfOrgMat = [min(orgMat(:)) max(orgMat(:))] ;
    if diff(limsOfOrgMat)>2
        if diff(limsOfOrgMat)<100
            amount2Divide =  ceil((diff(limsOfOrgMat) + 1)) ;
            if size(orgMat,1)/amount2Divide>100
                amount2Divide = ceil(size(orgMat,1)/300) ;
            end
            if all((ceil(orgMat(:)) - floor(orgMat(:)))==0)
                amount2Divide =  ceil((diff(limsOfOrgMat) + 1)) ;
            end

        else
        
        amount2Divide =  min(size(orgMat,1)./50,diff(limsOfOrgMat) + 1) ;
        end
    end
else
    limsOfOrgMat = limbyUser ;
end



% check if all numbers are round

ve4Hist = linspace(limsOfOrgMat(1),limsOfOrgMat(2),ceil(amount2Divide)) ;


for i = 1: amountOfHistos

    histHold = histcounts(orgMat(:,i),ve4Hist) ;

    if strcmp(typeOfNormailzation, 'normalize' )
        histHold = histHold./sum(histHold) ;
    end

    plot(ve4Hist(1:end-1),histHold,'LineWidth',5)

    [zenithPoint(i,2),indOfZenith] = max(histHold) ;

    zenithPoint(i,1)  = ve4Hist(indOfZenith);

end



end