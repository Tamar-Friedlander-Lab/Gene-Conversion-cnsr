%% PreLoad stractures


repAmount = 7;
combAmount = 4 ;

graphStuff.combColors = ['r','b','g','o','c'] ;

baseNameFormat = 'currItter %d with value %d' ;

BaseLoadedFlow = FlowerLoader(baseNameFormat,repAmount,combAmount) ;


%% Define what 2 display
fieldIWant = 'effectiveNumber' ;
fieldIWant = 'amountOfDivitions' ;
fieldIWant = 'totalJumps4Hist' ;
fieldIWant = 'probComp' ;
fieldIWant = 'averageSLFDist' ;
fieldIWant = 'averageSLFDist2All' ;
fieldIWant = 'amountNoRelationSpec' ;
fieldIWant = 'amountNoRelationAll' ;
fieldIWant = 'ratioDistSlf' ;
fieldIWant = 'howManyDivitioned' ;

graphStuff.how2Norm = 'normalize' ;

%% create graphs

meFig = badStruct2Graph(BaseLoadedFlow,fieldIWant,graphStuff) ;







