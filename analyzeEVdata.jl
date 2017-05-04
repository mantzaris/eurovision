function analyzeEVdata(stYr = 1975,endYr = 1980,windowSize = 5)

#load the data and add to a dictionary the number of countries in the year range
countryYearsNum = Dict{Integer,Integer}()
resultsFile = readdir("./dataTables/")
yrMin = 100000
yrMax = -1
for rf in resultsFile
    fileTmp = open(string("./dataTables/",rf))
    linesTmp = readlines(fileTmp)         #readfile lines
    yrTmp = parse(Int,((split(rf,"."))[1]))
    countryNumTmp = length(split(linesTmp[1],",")) - 1#COLUMN NAME LIST (still the same regarding large set mapping to small set in cols) OF WHO CAN RECEIVE VOTES
    countryYearsNum[yrTmp] = countryNumTmp #NUM that receives votes
    close(fileTmp)
    if(yrTmp < yrMin)
        yrMin = yrTmp
    end
    if(yrTmp > yrMax)
        yrMax = yrTmp
    end
end

#sanity check input years
if( endYr < stYr || stYr < yrMin || endYr > yrMax )
    print(string("year range improperly set, for the analysis end year must be greater than start and the smallest year is $(yrMin) and largest $(yrMax) with smallest first"))
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
    conf5perc = Allocated(yr,yr+windowSize,countryYearsNum)#what a typical scenario of unbiased voting towards candidate set of receivers
    yr = yr + windowSize
    windowConf[string(yr-windowSize,"-",yr)] = conf5perc
end

#MATRIX WINDOW AVGS

print(windowConf)
winDicts = windowScores(stYr,endYr,windowSize)
print(winDicts)

collusionDict = countryCollusion(stYr,endYr,windowSize,windowConf,winDicts)

print(collusionDict)
end



function countryCollusion(stYr,endYr,windowSize,windowConf,winDicts)
#FROM THE THRESHOLDS DETERMINE THE COUNTRY PAIRS OF COLLUSION

    collusionDict = Dict()
    yr = stYr
    while( (yr+windowSize) <= endYr )

	threshold = windowConf["$(yr)-$(yr + windowSize)"]

	cntryNames = winDicts["$(yr)-$(yr + windowSize)"]["countries"]
	scoremat = winDicts["$(yr)-$(yr + windowSize)"]["scoremat"]
	scorematAVG = scoremat * (1/(windowSize+1))
	
	collusionDict["$(yr)-$(yr + windowSize)"] = []
	for ii=1:(size(scoremat)[1])
	    for jj=1:(size(scoremat)[2])
		if(scorematAVG[ii,jj] >= threshold)
		    c1 = cntryNames[ii]
		    c2 = cntryNames[jj]
		    prev = collusionDict["$(yr)-$(yr + windowSize)"]
		    
		    new = append!(prev, ["$(c1)-$(c2)"])
		    collusionDict["$(yr)-$(yr + windowSize)"] = new
		end
	    end
	end
	yr = yr + windowSize
    end

return collusionDict
end





#FOR EACH TIME WINDOW
function windowScores(stYr,endYr,windowSize)
#(make the output overall score matrices symmetric)
    #1-DICTIONARY FOR EACH WINDOW INTERVAL
    winDict = Dict()
    yr = stYr
    while( (yr+windowSize) <= endYr )
	winDict["$(yr)-$(yr+windowSize)"] = Dict()
	winDict["$(yr)-$(yr+windowSize)"]["countries"] = [] #this gets filled with the total set.
	winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = []
	yr = yr + windowSize
    end

    #2-FILL DICTIONARY WITH ALL POSSIBLE COUNTRY PAIRS IN THOSE YEARS IT COVERS
    resultsFile = readdir("./dataTables/")
    namesDict = Dict()
    scoresDict = Dict()
    for rf in resultsFile   
	yrTmp = parse(Int,((split(rf,"."))[1]))   
	fileTmp = open(string("./dataTables/",rf))                     #each file pipe
	linesTmp = readlines(fileTmp)                            #read each file lines
	origColNames = split(linesTmp[1],r",|\n",keep=false) #store the COL name list of the columns
        #print(origColNames);print("\n")
	splice!(origColNames,1) #remove first entry
        #print(origColNames);print("\n")
        rowNAMES =[]
        
        for ii=2:length(linesTmp)#get the ROW's name list
            rowNAMEStmp = split(linesTmp[ii],r",|\n",keep=false)
            #print(rowNAMEStmp[1]);print("\n")
            append!(rowNAMES, [rowNAMEStmp[1]])
        end
        
        totalNames = sort(unique(append!(rowNAMES,origColNames)))
        #>>>>>>>>>><<<<<<<<<<
	namesDict[yrTmp] = totalNames#IMPORTANT! here is the name list of the year stored
        #>>>>>>>>><<<<<<<<<<
	nameNum = length(totalNames)    
	scoreMat = zeros(nameNum,nameNum)
        #print(totalNames);print(scoreMat);print("\n")
	for ii=2:length(linesTmp)#fill the scoremat
	    lineScores = split(linesTmp[ii],r",|\n",keep=false)
            votingCNTRY = lineScores[1]
            splice!(lineScores,1)
            lineScores = [parse(Int,lineScores[tt]) for tt in 1:length(lineScores)]
            for jj=1:length(lineScores)
                scoreTMP = lineScores[jj]
                colNAME = origColNames[jj]
                newColNamePos = find([totalNames[tt] == colNAME for tt in 1:length(totalNames)])
                scoreMat[ii-1,newColNamePos] = scoreTMP
            end

	end  	    	     
	scoresDict[string(yrTmp)] = scoreMat
        
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
	    yrNames = namesDict[yr+winInd]        

	    for rowNum=1:length(yrScoresMat[:,1])#change the year nameInds to the total window Inds of names
		newIndsMat = []	    
		for colNum=1:length(find(yrScoresMat[rowNum,:]))	    
		    tmpNamesMat = yrNames[find(yrScoresMat[rowNum,:])]	#non-zero cols
		    newIndsMat = sort(append!(find([namesTotal[ii] == tmpNamesMat[colNum] for ii in 1:length(namesTotal)]),newIndsMat))	
		end
		rowNumNew = find([namesTotal[ii] == yrNames[rowNum] for ii in 1:length(namesTotal)])
		matNew[rowNumNew,newIndsMat] = yrScoresMat[rowNum,find(yrScoresMat[rowNum,:])]	    
	    end				

	    winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = matPrev + matNew

	    winInd = winInd + 1
	end
	yr = yr + windowSize
    end

    
    return winDict

end




#THRESHOLD FOR EACH TIME WINDOW
function Allocated(stYr,endYr,countryYearsNum)


SCORES1 = [3,2,1]
SCORES2 = [5,4,3,2,1]
SCORES3 = [12,10,8,7,6,5,4,3,2,1]
    
AVG_SIMULATION = []
iterNum = 250
confInd5perc = max(1,floor(Int,0.05*iterNum))

for ii = 1:iterNum
    ONE_SIMULATION = []
    for yr = stYr:endYr
	NUM = countryYearsNum[yr]#number of countries voting that year	
	position = ceil(rand(1,1)*NUM)	

        if(yr >= 1975 && yr <= 2016)
            SCORES = SCORES3
        elseif(yr == 1962)
            SCORES = SCORES1
        elseif(yr == 1963)
            SCORES = SCORES2
        else
            SCORES = SCORES3
        end
        
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
