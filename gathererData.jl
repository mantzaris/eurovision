stYr = 1975
endYr = 1975
countryNum = 10
countryYearsNum = countryNum*ones(1,endYr-stYr+1)
println(countryYearsNum)
scores = [12,10,8,7,6,5,4,3,2,1]
scores1975 = countryNum <= length(scores) ? scores[1:countryNum] : append!(scores,vec(zeros(1,(countryNum-length(scores)))))
AVG_SIMULATION = []

iterNum = 100
confInd1perc = floor(Int,0.01*iterNum)
confInd5perc = floor(Int,0.05*iterNum)

for ii in collect(1:iterNum)
    ONE_SIMULATION = []
    for yr in collect(stYr:endYr)
	NUM = countryYearsNum[yr-stYr+1]#number of countries voting that year
	position = ceil(rand(1,1)*NUM)
        println(position)
	if yr >= 1975
	    score = scores1975[position]
            println(score)
	    append!(ONE_SIMULATION,[score])
	    println(ONE_SIMULATION)
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



#println([string("countryNum:",NUM);string("pos:",position);string("voteScore",vote)])
#println(avgSim)
#println(AVG_SIMULATION)
#println(sortedAVG_SIMULATION)
