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
    cntryNum = length(winDict["$(yr)-$(yr+windowSize)"]["countries"])
    winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = zeros(cntryNum,cntryNum)
    while(winInd <= windowSize)        

        matPrev = winDict["$(yr)-$(yr+windowSize)"]["scoremat"]
	matNew  = zeros(length(matPrev[:,1]),length(matPrev[1,:]))
        namesTotal = winDict["$(yr)-$(yr+windowSize)"]["countries"]	
	yrScoresMat = scoresDict[string(yr+winInd)]#the matrix for a particular year (might not be nxn)
	print("\n yrScoresMat")
	print(yrScoresMat)		
	
        yrNames = namesDict[yr+winInd]
        print("\n---xxx'yrNames'xxx---")
	print(yrNames)
	       
	print("\n---xxx'tmpIndMat'xxx---")
	
	tmpIndMat = find(yrScoresMat[1,:])#ONLY USING A SINGLE ROW!!!
	tmpIndsMatDict = Dict()#each entry is another row!
	for ii=1:length(yrScoresMat[:,1])
	    tmpIndsMatDict[ii] = find(yrScoresMat[ii,:])
	end
	print(tmpIndsMatDict)
	
	print(tmpIndMat)			

	newInds = []
	newIndsMat = []
	
	
	for ind=1:length(yrNames[tmpIndsMatDict[1]])
	    tmpNamesMat = yrNames[tmpIndsMatDict[1]]
	    #find the ind for each name inside namesTotal
	    newIndsMat = append!(find([namesTotal[ii] == tmpNamesMat[ind] for ii in 1:length(namesTotal)]),newIndsMat)
	    newIndsMat = sort(newIndsMat)
	end
	
	print("\n---xxx'newIndsMat'xxx---")
	print(newIndsMat)
		return
	tmpScoresMat = yrScoresMat[1,tmpIndMat]
	print("\n---xxx'tmpScoresMat'xxx")
	print(tmpScoresMat)
	
	matNew[1,newIndsMat] = tmpScoresMat
	matNew = matNew       # * (1/(windowSize+1)) #+1 for the inclusion of the first year
	print("\n---xxx'matNew'xxx---\n")
	print(matNew[1,:])

	print("\n---xxx'matNew FULL'xxx---\n")
	print(matNew)
	print("\n---xxx'matPrev FULL'xxx---\n")
	print(matPrev)
	
        winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = matPrev + matNew
	print("\n---xxx'winDict'xxx---\n")
	print(winDict)	
	   # return#	
        winInd = winInd + 1
    end
    yr = yr + windowSize
end
print("\n __---SCORESTUFF__--")
print(winDict)
return

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
