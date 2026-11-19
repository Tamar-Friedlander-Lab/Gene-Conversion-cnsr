function [meFig,meHoldOut] = badStruct2Graph(BaseLoadedFlow,fieldIWant,graphStuff)

repAmount = size(BaseLoadedFlow,1) ;
combAmount = size(BaseLoadedFlow,2) ;

binRafsPercent = 1:100 ;

for i = 1:combAmount

    holdStruct = BaseLoadedFlow(:,i) ;
    meHoldCat = [];
    for j = 1:repAmount

        if size(getfield(holdStruct(j),fieldIWant),1)>size(getfield(holdStruct(j),fieldIWant),2)
           
            if strcmp(fieldIWant,'ratioSLFs2Rnase')
                meHoldCat = vertcat(meHoldCat,log(getfield(holdStruct(j),fieldIWant))) ;
            else
                meHoldCat = vertcat(meHoldCat,getfield(holdStruct(j),fieldIWant)) ;
            end
        else
            meHoldCat = horzcat(meHoldCat,getfield(holdStruct(j),fieldIWant)) ;
        end
    end
    if  size(meHoldCat,1)==1
        meHoldCat = meHoldCat' ;
    end
    if size(meHoldCat,2)==1


        if i>1
            if size(meHoldOut(:,1),1)>size(meHoldCat,1)
                meHoldOut = meHoldOut(1:size(meHoldCat,1),:) ;
            end
            meHoldOut(:,i) = meHoldCat(1:size(meHoldOut(:,1),1)) ;
        else
            meHoldOut(:,i) = meHoldCat ;
        end
    else
        meHoldOut(:,:,i) = meHoldCat ;
    end

end
meHoldOut = squeeze(meHoldOut) ;
% meFig = figure;
if ndims(meHoldOut)==2

    [meFig,zenithPoint] = multiHisto(meHoldOut,[],graphStuff.how2Norm) ;
elseif strcmp(fieldIWant,'slfNumberOfPartners')
    meFig = figure; hold on ;
    for i = 1:combAmount
        aaa = mean(squeeze(meHoldOut(:,:,i))) ;
        plot((binRafsPercent(1:end-1)+binRafsPercent(2:end))/2,aaa(1:end-1)-aaa(2:end),'LineWidth',5)
    end
else
    for i =1:size(meHoldOut,2)
        meFig(i) = multiHisto(squeeze(meHoldOut(:,i,:)),[],graphStuff.how2Norm) ;
        title(sprintf('Graph number: %d',i))
    end
end

% text(gather(zenithPoint(:,1)),gather(zenithPoint(:,2)),string(mean(meHoldOut))')

end