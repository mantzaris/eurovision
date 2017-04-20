function Gatherer(stYr = 1975,endYr = 1980,windowSize = 5)

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
if( (stYr+windowSize) > endYr)
    print("not enough years between start and end for analysis")
    return
end

#THRESHOLDS
windowConf = Dict() #the threshold for significance in each year of window
yr = stYr
while( (yr+windowSize) <= endYr )
    conf5perc = GathererWindow(yr,yr+windowSize,countryYearsNum)
    yr = yr + windowSize
    windowConf[string(yr-windowSize,"-",yr)] = conf5perc
end

#MATRIX WINDOW AVGS




print(windowConf)
avgWindowScore(stYr,endYr,windowSize)
#return windowConf
#RESULTS

end


#FOR EACH TIME WINDOW
function avgWindowScore(stYr,endYr,windowSize)
windowAvgDict = Dict()
resultsFile = readdir("./data/")
for rf in resultsFile                                        #each file
    yrTmp = parse(Int,((split(rf,"."))[1]))
    if(yrTmp >= stYr && yrTmp <= endYr)    
	fileTmp = open(string("./data/",rf))                     #each file pipe
	linesTmp = readlines(fileTmp)                            #read each file lines
	countryNumTmp = length(split(linesTmp[1],","))           #head line of cntry names
	matTmp = zeros(countryNumTmp,countryNumTmp)              #init mat
	strNumLines = [split(linesTmp[ii],r",|\n",keep=false) for ii in 2:length(linesTmp)]
	for ii = 1:length(strNumLines)
	    matTmp[ii,:] = [parse(Int,strNumLines[ii][jj]) for jj in 1:length(strNumLines[ii])]	    
        end
	#windowAvgDictTmp[yrTmp] = matTmp #the allocation per year
	close(fileTmp)
    end
end

#1-DICTIONARY FOR EACH WINDOW INTERVAL
winDict = Dict()
yr = stYr
while( (yr+windowSize) <= endYr )
    winDict["$(yr)-$(yr+windowSize)"] = Dict()
    winDict["$(yr)-$(yr+windowSize)"]["countries"] = []
    winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = []
    yr = yr + windowSize
end
#print(winDict)
#2-FILL DICTIONARY WITH ALL POSSIBLE COUNTRY PAIRS IN THOSE YEARS IT COVERS
resultsFile = readdir("./data/")
namesDict = Dict()
for rf in resultsFile   
    yrTmp = parse(Int,((split(rf,"."))[1]))
    fileTmp = open(string("./data/",rf))                     #each file pipe
    linesTmp = readlines(fileTmp)                            #read each file lines
    namesDict[yrTmp] = split(linesTmp[1],r",|\n",keep=false)
end

yr = stYr
while( (yr+windowSize) <= endYr )
    winInd = 0
    while(winInd <= windowSize)        
	new = namesDict[yr + winInd]
        prev = winDict["$(yr)-$(yr+windowSize)"]["countries"]
        winDict["$(yr)-$(yr+windowSize)"]["countries"] = sort(unique(append!(prev,new)))
    
	winInd = winInd + 1
    end
    yr = yr + windowSize
end
print("__---__--")
print(winDict)
return

#3-ACCUMULATE POINTS OF EACH PARTICULAR COUNTRY TOWARDS ANOTHER DIFFERENT COUNTRY
#4-THE RESULT IS A DICTIONARY OF YR WINDOWS, HOLDING A DICTIONARY CONTAINING A COUNTRY NAME LIST AND A  MATRIX OF DIRECTIONAL SCORES FOR THESE YEARS



#=
#put the years into chunks for the window
yr = stYr
while( (yr+windowSize) <= endYr )
    winInd = 0
    #yearScaledTmpPrev = 0
    while(winInd <= windowSize)
        
	yearScaledTmp = (windowAvgDictTmp[yr+winInd]) * (1/(windowSize+1))

	if(winInd == 0)	 
	   windowAvgDict["$(yr)-$(yr+windowSize)"] = yearScaledTmp	 
	   yearScaledTmpPrev = yearScaledTmp
	elseif(winInd > 0)
          for ii=1:length(yearScaledTmpPrev[:,1])
	    for jj=1:length(yearScaledTmpPrev[1,:])
              yearScaledTmpPrev[ii,jj] = yearScaledTmpPrev[ii,jj]
          end
          
          
	  #windowAvgDict["$(yr)-$(yr+windowSize)"] =
	  
	end
	winInd = winInd + 1
        #yearScaledTmpPrev = yearScaledTmp + yearScaledTmpPrev
    end
    yr = yr + windowSize    
end
=#

#print( windowAvgDict)
end




#THRESHOLD FOR EACH TIME WINDOW
function GathererWindow(stYr,endYr,countryYearsNum)

SCORES = [12,10,8,7,6,5,4,3,2,1]

AVG_SIMULATION = []
iterNum = 250
confInd5perc = max(1,floor(Int,0.05*iterNum))

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

return conf5perc

end
