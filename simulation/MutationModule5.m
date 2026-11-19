function [flowPop] = MutationModule5(flowPop,popPara,miscPara,WhoMutates)

if isequal(WhoMutates, 'RNase')
    whoWillBMutated = gpuArray.rand(popPara.numInd,2,popPara.numAmino)<popPara.mueRatePerAmino ;
elseif isequal(WhoMutates,'SLF')
    whoWillBMutated = gpuArray.rand(popPara.numInd,2.*popPara.amountSLF,popPara.numAmino)<popPara.mueRatePerAmino;
end

[Cellloc2MuteRow,Cellloc2MuteCol] = find (sum(whoWillBMutated,3)~=0) ;

if isequal(WhoMutates, 'RNase')
    Cellloc2MuteInd = sub2ind([popPara.numInd,2],Cellloc2MuteRow,Cellloc2MuteCol) ;

    CellThatRGonnaMute  = flowPop.femalesCurr(Cellloc2MuteInd) ;
elseif isequal(WhoMutates,'SLF')
Cellloc2MuteInd = sub2ind([popPara.numInd,popPara.amountSLF.*2],Cellloc2MuteRow,Cellloc2MuteCol) ;

    CellThatRGonnaMute  = flowPop.maleCurr(Cellloc2MuteInd) ;
end
%     RNaseMute2Happen = reshape(permute(whoWillBMutated(RNaseloc2MuteRow,1:2,:),[2,1,3]),[],18) ;
CellMute2Happen = reshape(whoWillBMutated(Cellloc2MuteRow,:,:),[],18) ;

CellMute2Happen = CellMute2Happen((1:size(Cellloc2MuteCol,1))'+(Cellloc2MuteCol-1).*size(Cellloc2MuteCol,1),:) ;

[~,newAmino] = min(gpuArray.rand(size(CellMute2Happen(:))) - cumsum(miscPara.aminoFreq)>0,[],2) ;
newAmino = reshape(newAmino,size(CellMute2Happen)) ;
if isequal(WhoMutates, 'RNase')
% CellMuteTable = mod(flowPop.listRnase(CellThatRGonnaMute,:) + CellMute2Happen.*...
%     (ceil(gpuArray.rand(size(CellMute2Happen)).*3)),4) ;


CellMuteTable = flowPop.listSLF(CellThatRGonnaMute,:) ;
CellMuteTable(CellMute2Happen==1) = newAmino(CellMute2Happen==1) ;


elseif isequal(WhoMutates,'SLF')
% CellMuteTable = mod(flowPop.listSLF(CellThatRGonnaMute,:) + CellMute2Happen.*...
%     (ceil(gpuArray.rand(size(CellMute2Happen)).*3)),4) ;

CellMuteTable = flowPop.listSLF(CellThatRGonnaMute,:) ;
CellMuteTable(CellMute2Happen==1) = newAmino(CellMute2Happen==1) ;

end    

CellMuteTable(CellMuteTable==0) = 4;
if isequal(WhoMutates, 'RNase')
    [whichCellIsNew,oldMemb] = aminoMemberChecker(CellMuteTable,flowPop.listRnase) ;
    whichCellIsNew = whichCellIsNew~= 0 ;
elseif isequal(WhoMutates,'SLF')
   [whichCellIsNew,oldMemb] = aminoMemberChecker(CellMuteTable,flowPop.listSLF)  ;
whichCellIsNew = whichCellIsNew~= 0 ;
end
wholeCell2MuteTable = CellMuteTable ;
CellMuteTable = CellMuteTable(whichCellIsNew==1,:) ;



[CellMuteTable,ia,WhichMuteRepeat] = unique(CellMuteTable,'rows','stable') ;

if isequal(WhoMutates, 'RNase')
    flowPop.femalesCurr(Cellloc2MuteInd(whichCellIsNew==1)) = size(flowPop.listRnase,1) +WhichMuteRepeat ;
    flowPop.femalesCurr(Cellloc2MuteInd(whichCellIsNew==0)) = oldMemb(whichCellIsNew==0) ;
elseif isequal(WhoMutates,'SLF')
    flowPop.maleCurr(Cellloc2MuteInd(whichCellIsNew==1)) = size(flowPop.listSLF,1) +WhichMuteRepeat ;
    flowPop.maleCurr(Cellloc2MuteInd(whichCellIsNew==0)) = oldMemb(whichCellIsNew==0) ;
end

%     whichRNaseIsNew = ismember(RNaseMuteTable,flowPop.listRnase,'rows') ==0 ;

%     flowPop.listRnase = vertcat(flowPop.listRnase,RNaseMuteTable(whichRNaseIsNew==1,:)) ;

if isequal(WhoMutates, 'RNase')
    flowPop.listRnase = vertcat(flowPop.listRnase,CellMuteTable) ;
elseif isequal(WhoMutates,'SLF')
    flowPop.listSLF = vertcat(flowPop.listSLF,CellMuteTable) ;
end
%     newInteractions2Add = reshape(RNaseSLFReactor(RNaseMuteTable(whichRNaseIsNew==1,:),...
%         flowPop.listSLF,miscPara,1),sum(whichRNaseIsNew),size(flowPop.listSLF,1)) ;

if isequal(WhoMutates, 'RNase')
    newInteractions2Add = reshape(RNaseSLFReactor3(CellMuteTable,...
    flowPop.listSLF,miscPara,1),size(flowPop.listSLF,1),length(ia))' ;
elseif isequal(WhoMutates,'SLF')
    newInteractions2Add = reshape(RNaseSLFReactor3(flowPop.listRnase,...
    CellMuteTable,miscPara,1),length(ia),size(flowPop.listRnase,1))' ;
end

if isequal(WhoMutates, 'RNase')
    flowPop.boolRnaseSlf = vertcat(flowPop.boolRnaseSlf,newInteractions2Add) ;
elseif isequal(WhoMutates,'SLF')
    flowPop.boolRnaseSlf = horzcat(flowPop.boolRnaseSlf,newInteractions2Add) ;
end


end