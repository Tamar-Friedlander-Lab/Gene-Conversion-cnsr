function [boolComb] = RNaseSLFReactor3(RNase,SLF,miscPara,checkAllComb)
%% A function to calculate the interaction energy

amountRNase = size(RNase,1) ;
amountSLf = size(SLF,1) ;

if checkAllComb == 1

    RNase = repelem(RNase,amountSLf,1) ;

    SLF = repmat(SLF,amountRNase,1) ;

end

ind4Table = sub2ind(size(miscPara.compTable),RNase,SLF) ;

energyComb = sum(miscPara.compTable(ind4Table),2) ;

boolComb = energyComb <= miscPara.energyBarrier ;

end