function [geneDistribution] = countDestributions(currGenes,aminosInGene)

currAminoMat = aminosInGene(currGenes,:) ;

for i = 1:4
geneDistribution(i) = mean(currAminoMat(:)==i) ;
end




end