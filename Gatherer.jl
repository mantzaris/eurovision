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

#1-DICTIONARY FOR EACH WINDOW INTERVAL
winDict = Dict()
yr = stYr
while( (yr+windowSize) <= endYr )
    winDict["$(yr)-$(yr+windowSize)"] = Dict()
    winDict["$(yr)-$(yr+windowSize)"]["countries"] = []
    winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = []
    yr = yr + windowSize
end

#2-FILL DICTIONARY WITH ALL POSSIBLE COUNTRY PAIRS IN THOSE YEARS IT COVERS
resultsFile = readdir("./data/")
namesDict = Dict()
scoresDict = Dict()
for rf in resultsFile   
    yrTmp = parse(Int,((split(rf,"."))[1]))
    fileTmp = open(string("./data/",rf))                     #each file pipe
    linesTmp = readlines(fileTmp)                            #read each file lines
    namesDict[yrTmp] = split(linesTmp[1],r",|\n",keep=false) #store the name list
    nameNum = length(namesDict[yrTmp])    
    rowNumMat = length(linesTmp)-1
    colNumMat = nameNum
    tmp2 = zeros(rowNumMat,colNumMat)
    for ii=2:length(linesTmp)
	tmp1 = split(linesTmp[ii],r",|\n",keep=false)	
	tmp2[ii-1,:] = [parse(Int,tmp1[jj]) for jj in 1:length(tmp1)]	#each row of the matrix/data     
    end  	    	     
    scoresDict[string(yrTmp)] = tmp2     
    close(fileTmp)
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
print("--xxx'winDict'xxx--")
print(winDict)

#3-ACCUMULATE POINTS OF EACH PARTICULAR COUNTRY TOWARDS ANOTHER DIFFERENT COUNTRY
yr = stYr
while( (yr+windowSize) <= endYr )
    winInd = 0
    cntryNum = length(winDict["$(yr)-$(yr+windowSize)"]["countries"])#WILL BECOME ARRAAY FOR ROW AND COL SIZE
    
    winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = zeros(cntryNum,cntryNum)#WILL BECOME ASSYMETRIC!!!
    while(winInd <= windowSize)        

        matPrev = winDict["$(yr)-$(yr+windowSize)"]["scoremat"]
	matNew  = zeros(length(matPrev[:,1]),length(matPrev[1,:]))
        namesTotal = winDict["$(yr)-$(yr+windowSize)"]["countries"]	
	yrScoresMat = scoresDict[string(yr+winInd)]#the matrix for a PARTICULAR YEAR (might not be nxn)
	#=
	print("\n--- year---$(yr+winInd)")
	print("\n ---'matprev'---");print(matPrev)	
	print("\n ---'yrScoresMat'---");print(yrScoresMat)
	=#
	
        yrNames = namesDict[yr+winInd]        
	       			
	for rowNum=1:length(yrScoresMat[:,1])#change the year nameInds to the total window Inds of names
	    newIndsMat = []	    
	    for ind=1:length(find(yrScoresMat[rowNum,:]))	    
		tmpNamesMat = yrNames[find(yrScoresMat[rowNum,:])]	
		newIndsMat = sort(append!(find([namesTotal[ii] == tmpNamesMat[ind] for ii in 1:length(namesTotal)]),newIndsMat))	
	    end
	    rowNumNew = find([namesTotal[ii] == yrNames[rowNum] for ii in 1:length(namesTotal)])
	    matNew[rowNumNew,newIndsMat] = yrScoresMat[rowNum,find(yrScoresMat[rowNum,:])]	    
	end				
	#=
	print("\n ---'matNew'---");print(matNew)
	print("\n ---matNew+matPrev---\n");print(matNew+matPrev)
	print(winDict["$(yr)-$(yr+windowSize)"]["countries"])
	=#	
        winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = matPrev + matNew
		
        winInd = winInd + 1
    end
    yr = yr + windowSize
end
print("\n __---winDict__--")
print(winDict)
return winDict


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
