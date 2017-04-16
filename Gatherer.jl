function Gatherer(stYr = 1975,endYr = 1975)

#load the data and add to a dictionary the number of countries in the year range
countryYearsNum = Dict{Integer,Integer}()
resultsFile = readdir("./data/")
yrMin = 100000
yrMax = -1
for rf in resultsFile
    fileTmp = open(string("./data/",rf))
    linesTmp = readlines(fileTmp)         #readfile lines
    countryNumTmp = length(split(linesTmp[1],","))
    yrTmp = parse(Int,((split(rf,"."))[1]))
    countryYearsNum[yrTmp] = countryNumTmp
    close(fileTmp)
    if(yrTmp < yrMin)
        yrMin = yrTmp
    end
    if(yrTmp > yrMax)
        yrMax = yrTmp
    end
end
#sanity check input years
if( endYr < stYr || stYr < 1975 || endYr > 2003 )
    print(string("year range improperly set, for the Gatherer approach end year must be greater than start and the smallest year is ",1975," and largest ",2003," with smallest first"))
    return
end


SCORES = [12,10,8,7,6,5,4,3,2,1]

AVG_SIMULATION = []
iterNum = 10000
confInd5perc = floor(Int,0.05*iterNum)

for ii = 1:iterNum
    ONE_SIMULATION = []
    for yr = stYr:endYr
	NUM = countryYearsNum[yr]#number of countries voting that year	
	position = ceil(rand(1,1)*NUM)	
	
	if position[1] <= length(SCORES)
	   score = SCORES[position]	       
	else
	   score = 0
	end
	append!(ONE_SIMULATION,[score])

    end
    avgSim = mean(ONE_SIMULATION)
    append!(AVG_SIMULATION,[avgSim])

end

sortedAVG_SIMULATION = sort(AVG_SIMULATION,rev=true)
conf5perc = sortedAVG_SIMULATION[confInd5perc]

println(conf5perc)

return conf5perc

end
