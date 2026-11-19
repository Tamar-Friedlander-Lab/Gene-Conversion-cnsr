
figure; hold on
for i = 1:6
    for j = 2:6

wasSelf = BaseLoadedFlow(i,j).prevSelfJump ;

wasSelf = wasSelf(floor(end/3):end) ;

keptUnSelfExp = BaseLoadedFlow(i,j).postSelfJump ;

keptUnSelfExp = keptUnSelfExp(floor(end/3):end) ;


keptUnSelfExp = keptUnSelfExp(wasSelf==0) ;

impactUnSelfExp = BaseLoadedFlow(i,j).impactOfJump ;

impactUnSelfExp = impactUnSelfExp(floor(end/3):end) ;

impactUnSelfExp = impactUnSelfExp(wasSelf==0) ;
aa(i,j) = mean(keptUnSelfExp==1) ;
scatter(value2Check(i),mean(keptUnSelfExp==1),'filled','k')
bb(i,j) = mean(impactUnSelfExp==1) ;

scatter(value2Check(i),mean(impactUnSelfExp==1),'filled','r')

% scatter(i,mean(BaseLoadedFlow(i,i).impactOfJump(BaseLoadedFlow(i,i).prevSelfJump==0)==1)+keptUnSelf),'filled','b')
end
end

set(gca,'xscale','log')

save(gca,'ImReallyTryingHere')










