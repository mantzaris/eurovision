
function demo(stYr=1975,endYr=1985,windowSize=5)
    southWest = ["Portugal","Spain","Malta","SanMarino","Andorra","Monaco","Morocco","Italy"]
    north = ["Iceland","Denmark","Norway","Sweden","Finland"]
    northWest = ["UnitedKingdom","Ireland","Belgium","France","Luxembourg"]
    central = ["Germany","Austria","TheNetherlands","Switzerland","Slovenia","CzechRepublic","Hungary"]
    southEast = ["Greece","Montenegro","Cyprus","Albania","Bulgaria","Croatia","BosniaHerzegovina","Turkey","FYRMacedonia","Romania","Serbia","Israel","Yugoslavia"]
    east = ["Russia","Ukraine","Moldova","Belarus","Poland","Georgia","Armenia","Azerbaijan","Estonia","Lithuania","Latvia"]
    yr=stYr
    collusionDict = Mantzaris(stYr,endYr,windowSize)
    print("\n");print(collusionDict);print("\n")
    ratioTwoWay = []
    totalTwoWay = []
    totalOneWay = []
    while( (yr+windowSize) <= endYr )
        oneWays = collusionDict["1way:$(yr)-$(yr + windowSize)"]
        twoWays = collusionDict["2way:$(yr)-$(yr + windowSize)"]
        network = "digraph{"
        yrs = string("years","$(yr)","to","$(yr + windowSize)")# to "# $(yr + windowSize)"
        network = string(network,string(" graph [label=","$(yrs)",", fontsize=34]; "))
                
        seenC = []                
        for pair in oneWays
            pair = replace(pair,"&","")
            pair = replace(pair,".","")
            pairTmp = split(pair,'-')
            pairTmp[1] =  replace(pairTmp[1]," ","")
            pairTmp[2] =  replace(pairTmp[2]," ","")
            if(!(pairTmp[1] in seenC))
                if(pairTmp[1] in east)
                    network = string(network,string(pairTmp[1]," [style=filled,fillcolor=olivedrab3]; "))
                    
                elseif(pairTmp[1] in southWest)
                    network = string(network,string(pairTmp[1]," [style=filled,fillcolor=indianred1]; "))
                elseif(pairTmp[1] in north)
                    network = string(network,string(pairTmp[1]," [style=filled,fillcolor=dodgerblue]; "))
                elseif(pairTmp[1] in northWest)
                    network = string(network,string(pairTmp[1]," [style=filled,fillcolor=darkslategray2]; "))
                elseif(pairTmp[1] in central)
                    network = string(network,string(pairTmp[1]," [style=filled,fillcolor=gray]; "))
                elseif(pairTmp[1] in southEast)
                    network = string(network,string(pairTmp[1]," [style=filled,fillcolor=darkgoldenrod1]; "))    
                end
                seenC = [seenC,pairTmp[1]]    
            end
            if(!(pairTmp[2] in seenC))
                if(pairTmp[2] in east)
                    network = string(network,string(pairTmp[2]," [style=filled,fillcolor=olivedrab3]; "))
                elseif(pairTmp[2] in southWest)
                    network = string(network,string(pairTmp[2]," [style=filled,fillcolor=indianred1]; "))
                elseif(pairTmp[2] in north)
                    network = string(network,string(pairTmp[2]," [style=filled,fillcolor=dodgerblue]; "))
                elseif(pairTmp[2] in northWest)
                    network = string(network,string(pairTmp[2]," [style=filled,fillcolor=darkslategray2]; "))
                elseif(pairTmp[2] in central)
                    network = string(network,string(pairTmp[2]," [style=filled,fillcolor=gray]; "))
                elseif(pairTmp[2] in southEast)
                    network = string(network,string(pairTmp[2]," [style=filled,fillcolor=darkgoldenrod1]; "))
                end
                seenC = [seenC,pairTmp[2]]  
            end
        end
        
        collusion1 = []
        for (ind,pair) in enumerate(twoWays)
            print(pair);print("\n")
            pair = replace(pair,"&","")
            pair = replace(pair,".","")
            pairTmp = split(pair,'-')
            pairTmp[1] =  replace(pairTmp[1]," ","")
            pairTmp[2] =  replace(pairTmp[2]," ","")
            edge = string(pairTmp[1],"->",pairTmp[2]," [dir=both color=red penwidth=3];")
            network = string(network,edge)
            append!(collusion1,[string(pairTmp[1],pairTmp[2])])
            append!(collusion1,[string(pairTmp[2],pairTmp[1])])            
        end
        print(collusion1)
        for pair in oneWays
            pair = replace(pair,"&","")
            pair = replace(pair,".","")
            pairTmp = split(pair,'-')
            pairTmp[1] =  replace(pairTmp[1]," ","")
            pairTmp[2] =  replace(pairTmp[2]," ","")
            edge = string(pairTmp[1],"->",pairTmp[2],";")
            if(!( string(pairTmp[1],pairTmp[2]) in collusion1))
                network = string(network,edge)
            end
            
        end
        network = string(network,"}")
        fileName = string("network",":$(yr)-$(yr + windowSize)",".dot")
        print(fileName)
        filePNG = string("network",":$(yr)-$(yr + windowSize)",".png")
        print(filePNG)
        writedlm(string("./",fileName), [network])
        
        run(`dot $fileName -Tpng -o $filePNG`)
        print(network)
        yr = yr + windowSize

        append!(ratioTwoWay,[length(twoWays) / (length(oneWays) - length(twoWays))])
        append!(totalOneWay,length(oneWays)-length(twoWays))
        append!(totalTwoWay,length(twoWays))
    end

yr = stYr
    repeatWinds = Dict()
    while( (yr+windowSize) <= endYr )
        oneWays = collusionDict["1way:$(yr)-$(yr + windowSize)"]    
        twoWays = collusionDict["2way:$(yr)-$(yr + windowSize)"]
        for pair in oneWays
            pair = replace(pair,"&","")        
            pair = replace(pair,".","")        
            pairTmp = split(pair,'-')        
            pairTmp[1] =  replace(pairTmp[1]," ","")        
            pairTmp[2] =  replace(pairTmp[2]," ","")
            edgeName = string(pairTmp[1],"->",pairTmp[2])
            print(edgeName)
            if(haskey(repeatWinds, string(pairTmp[1],"->",pairTmp[2]) ))                
                repeatWinds[string(pairTmp[1],"->",pairTmp[2])] = 1 + repeatWinds[string(pairTmp[1],"->",pairTmp[2])]
            else
                repeatWinds[string(pairTmp[1],"->",pairTmp[2])] = 1
            end            
        end
        yr = yr + windowSize
    end
    print("\n the aggregrate of repeated edges \n")
    print(repeatWinds)
#####
network = "digraph{"
yrs = string("years","$(stYr)","to","$(endYr)")

network = string(network,string(" graph [label=","$(yrs)",", fontsize=34]; "))
seenC = []     
repeatWinds2 = repeatWinds
for entry in repeatWinds2
    keyTmp = entry[1]
    weight = entry[2]
    pairTmp = split(keyTmp,"->")
    
    if(!(pairTmp[1] in seenC))
        if(pairTmp[1] in east)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=olivedrab3]; "))    
        elseif(pairTmp[1] in southWest)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=indianred1]; "))
    
        elseif(pairTmp[1] in north)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=dodgerblue]; "))
        elseif(pairTmp[1] in northWest)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=darkslategray2]; "))
        elseif(pairTmp[1] in central)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=gray]; "))
        elseif(pairTmp[1] in southEast)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=darkgoldenrod1]; "))    
        end
        seenC = [seenC,pairTmp[1]]    
    end
    
    if(!(pairTmp[2] in seenC))
       if(pairTmp[2] in east)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=olivedrab3]; "))

       elseif(pairTmp[2] in southWest)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=indianred1]; "))
       elseif(pairTmp[2] in north)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=dodgerblue]; "))
       elseif(pairTmp[2] in northWest)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=darkslategray2]; "))

       elseif(pairTmp[2] in central)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=gray]; "))
       elseif(pairTmp[2] in southEast)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=darkgoldenrod1]; "))
       end
       seenC = [seenC,pairTmp[2]]  
   end
        
end

for entry in repeatWinds
    keyTmp = entry[1]
   # if(entry[2] >= ceil((0.33)*windowSize))
        weight = entry[2]*1.5
        edgeName = string(keyTmp," [penwidth=$(weight)];")
        network = string(network,edgeName)
    #end
end
    network = string(network,"}")
    fileName = string("networkTotal",":$(stYr)-$(endYr)","windowSize$(windowSize)",".dot")
    print(fileName)
    filePNG = string("networkTotal",":$(stYr)-$(endYr)","windowSize$(windowSize)",".png")
    print(filePNG)
    writedlm(string("./",fileName), [network])

    run(`dot $fileName -Tpng -o $filePNG`)
    print(network)

#######collusion now
yr = stYr
    repeatWinds = Dict()
    while( (yr+windowSize) <= endYr )
      
        twoWays = collusionDict["2way:$(yr)-$(yr + windowSize)"]
        for pair in twoWays
            pair = replace(pair,"&","")        
            pair = replace(pair,".","")        
            pairTmp = split(pair,'-')        
            pairTmp[1] =  replace(pairTmp[1]," ","")        
            pairTmp[2] =  replace(pairTmp[2]," ","")
            edgeName = string(pairTmp[1],"->",pairTmp[2])
            print(edgeName)
            if(haskey(repeatWinds, string(pairTmp[1],"->",pairTmp[2]) ))                
                repeatWinds[string(pairTmp[1],"->",pairTmp[2])] = 1 + repeatWinds[string(pairTmp[1],"->",pairTmp[2])]
            else
                repeatWinds[string(pairTmp[1],"->",pairTmp[2])] = 1
            end            
        end
        yr = yr + windowSize
    end
    print("\n the aggregrate of repeated collusion \n")
    print(repeatWinds)
#####
network = "digraph{"
yrs = string("years","$(stYr)","to","$(endYr)")


network = string(network,string(" graph [label=","$(yrs)",", fontsize=34]; "))
seenC = []     
repeatWinds2 = repeatWinds
for entry in repeatWinds2
    keyTmp = entry[1]
    weight = entry[2]
    pairTmp = split(keyTmp,"->")
    
    if(!(pairTmp[1] in seenC))
        if(pairTmp[1] in east)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=olivedrab3]; "))    
        elseif(pairTmp[1] in southWest)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=indianred1]; "))
    
        elseif(pairTmp[1] in north)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=dodgerblue]; "))
        elseif(pairTmp[1] in northWest)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=darkslategray2]; "))
        elseif(pairTmp[1] in central)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=gray]; "))
        elseif(pairTmp[1] in southEast)
            network = string(network,string(pairTmp[1]," [style=filled,fillcolor=darkgoldenrod1]; "))    
        end
        seenC = [seenC,pairTmp[1]]    
    end
    
    if(!(pairTmp[2] in seenC))
       if(pairTmp[2] in east)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=olivedrab3]; "))

       elseif(pairTmp[2] in southWest)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=indianred1]; "))
       elseif(pairTmp[2] in north)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=dodgerblue]; "))
       elseif(pairTmp[2] in northWest)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=darkslategray2]; "))

       elseif(pairTmp[2] in central)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=gray]; "))
       elseif(pairTmp[2] in southEast)
           network = string(network,string(pairTmp[2]," [style=filled,fillcolor=darkgoldenrod1]; "))
       end
       seenC = [seenC,pairTmp[2]]  
   end
        
end

for entry in repeatWinds
    keyTmp = entry[1]
    weight = entry[2]*3
    edgeName = string(keyTmp," [dir=both color=red penwidth=3 penwidth=$(weight)];")
    network = string(network,edgeName)
end
    network = string(network,"}")
    fileName = string("networkTotalCollusion",":$(stYr)-$(endYr)","windowSize$(windowSize)",".dot")
    print(fileName)
    filePNG = string("networkTotalCollusion",":$(stYr)-$(endYr)","windowSize$(windowSize)",".png")
    print(filePNG)
    writedlm(string("./",fileName), [network])

    run(`dot $fileName -Tpng -o $filePNG`)
    print(network)




#print("\n two way $(yr)-$(yr + windowSize) ratio=")
print("\n the ratio of the two Way\n")
println(ratioTwoWay)
fileNameTmp = string("netRatios",":$(stYr)-$(endYr)","windowSize$(windowSize)",".txt")
writedlm(string("./",fileNameTmp), ratioTwoWay)

print("\n the total of the two Way\n")
println(totalTwoWay)
fileNameTmp = string("netTotalTwoWays",":$(stYr)-$(endYr)","windowSize$(windowSize)",".txt")
writedlm(string("./",fileNameTmp), totalTwoWay)

print("\n the total of the one Way\n")
println(totalOneWay)
fileNameTmp = string("netTotalOneWays",":$(stYr)-$(endYr)","windowSize$(windowSize)",".txt")
writedlm(string("./",fileNameTmp), totalOneWay)

cntryNumYrs = countryYrNumber()

twoWayCntryRatio = []
oneWayCntryRatio = []
yr=stYr
ii = 1
while( (yr) < endYr )
    mNum = mean([cntryNumYrs[tmp1] for tmp1 in (yr:(yr+windowSize))])
    #println(totalTwoWay[ii] / mNum)
    println(mNum)
    append!(twoWayCntryRatio,totalTwoWay[ii] / mNum)
    append!(oneWayCntryRatio,totalOneWay[ii] / mNum)
    yr = yr + windowSize
    ii += 1
end
print("\n the total of the two Way country Ratio\n")
println(twoWayCntryRatio)
fileNameTmp = string("netTotalTwoWaysCntryRatio",":$(stYr)-$(endYr)","windowSize$(windowSize)",".txt")
writedlm(string("./",fileNameTmp), twoWayCntryRatio)

print("\n the total of the one Way country Ratio\n")
println(oneWayCntryRatio)
fileNameTmp = string("netTotalOneWaysCntryRatio",":$(stYr)-$(endYr)","windowSize$(windowSize)",".txt")
writedlm(string("./",fileNameTmp), oneWayCntryRatio)


end


#run(`diplsay network.png`) 

function countryYrNumber()
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
    countryYearsNum
end
