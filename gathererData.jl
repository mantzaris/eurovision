
yearNum = 5
countryNum = 10
countryYearsNum = 10*ones(1,yearNum)
scoreMax = 10
AVG_SIMULATION = []

stYr = 1
endYr = 1
iterNum = 100000
confInd1perc = floor(0.01*iterNum)
confInd5perc = floor(0.05*iterNum)

for ii in 1:iterNum
    ONE_SIMULATION = []#zeros(1,countryNum)#temporarily assume constant
    for yr in stYr:endYr
	NUM = countryNum#countryYearsNum[winInd]#number of countries voting that year  (temporarily assume constant)
	position = ceil(rand(1,1)*NUM)
	vote = maximum([scoreMax+1-position;0])
	append!(ONE_SIMULATION,[vote])	
    end
    avgSim = mean(ONE_SIMULATION)
    append!(AVG_SIMULATION,[avgSim])

end    
sortedAVG_SIMULATION = sort(AVG_SIMULATION,rev=true)
conf5perc = sortedAVG_SIMULATION[confInd5perc]

println(conf5perc)
println(mean(sortedAVG_SIMULATION))



#println([string("countryNum:",NUM);string("pos:",position);string("voteScore",vote)])
#println(avgSim)
#println(AVG_SIMULATION)
#println(sortedAVG_SIMULATION)