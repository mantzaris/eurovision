println("howdy chara")
#synthetic data
#simple set of matrices
countryNum = 10
yearNum = 3
scoreMax = 5
dataSynth = zeros(countryNum,countryNum,yearNum)#dim1=origin country, dim2=destination vote
#model for synthData production
clusterSize = 3
clusterSet = randperm(countryNum)[1:clusterSize]#first cluster

for yr in 1:yearNum
    for ii in 1:countryNum
    	scoreInds = randperm(countryNum-1)[1:scoreMax]
	for si in 1:length(scoreInds)
	    if scoreInds[si] >= ii
	       scoreInds[si] = scoreInds[si] + 1
	    end
	end
    	for sc in 1:scoreMax
    	    dataSynth[ii,scoreInds[sc],yr] = sc
    	end
    
    end
end

println(dataSynth)

#replicate previous model

#simulate and present