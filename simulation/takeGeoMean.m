function [chanceConv] = takeGeoMean(convRatePerHaplo)

chanceConv = sqrt(prod(convRatePerHaplo,2)) ;


end