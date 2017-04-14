function Gatherer(stYr = 1975,endYr = 1975,countryNum = 10)


countryYearsNum = countryNum*ones(1,endYr-stYr+1)
scores1975 = [12,10,8,7,6,5,4,3,2,1]

AVG_SIMULATION = []
iterNum = 100
confInd1perc = floor(Int,0.01*iterNum)
confInd5perc = floor(Int,0.05*iterNum)


for ii in collect(1:iterNum)
    ONE_SIMULATION = []
    for yr in collect(stYr:endYr)
	NUM = countryYearsNum[yr-stYr+1]#number of countries voting that year	
	position = ceil(rand(1,1)*NUM)	
	if yr >= 1975
	    if position[1] <= 10
	       score = scores1975[position]	       
	    else
	       score = 0
	    end
	    append!(ONE_SIMULATION,[score])
	end
    end
    avgSim = mean(ONE_SIMULATION)
    append!(AVG_SIMULATION,[avgSim])

end    
sortedAVG_SIMULATION = sort(AVG_SIMULATION,rev=true)
conf5perc = sortedAVG_SIMULATION[confInd5perc]
println("finished")
println(conf5perc)
println(mean(sortedAVG_SIMULATION))

return conf5perc

end