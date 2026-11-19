function [whichCellIsNew,oldMemb] = aminoMemberChecker(CellMuteTable,listSLF)

representativeCellNum = sum(4.^[(1:size(CellMuteTable,2))-1]...
    .*double(CellMuteTable-1),2) ;

representativeListNum = sum(4.^[(1:size(CellMuteTable,2))-1]...
    .*double((listSLF-1)),2) ;

DaDifferenceBetweenThem = abs(representativeListNum - representativeCellNum') ;

[whichCellIsNew,oldMemb] = min(DaDifferenceBetweenThem) ;

end