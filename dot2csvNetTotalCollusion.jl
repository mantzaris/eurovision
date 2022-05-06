
function dot2csvTotalCollusion(filename)
    println("in dot2csvTotalCollusion")
    matCntryEdges = []
    
    fileTmp = open(filename)
    linesTmp = readlines(fileTmp)
    linesStr = linesTmp[1]#println(linesStr)#println(typeof(linesStr))
    splits1 = split(linesStr,";")
    for strFrag in splits1

        if(contains(strFrag,"penwidth"))#println(strFrag)
            c1end = search(strFrag,"-")
            c1end = collect(c1end)[1]-1
            c1 = strFrag[1:c1end]#println(c1)
            c2start = search(strFrag,">")
            c2end = search(strFrag," [")
            c2start = collect(c2start)[1]+1
            c2end = collect(c2end)[1]-1
            c2 = strFrag[c2start:c2end]#println(c2)
            pW1end = search(strFrag,"penwidth=")
            pW1end = collect(pW1end)[end]+1
            pW = parse(Int,strFrag[pW1end])#println(pW)
            pW2end = search(strFrag,"penwidth=",collect(search(strFrag,"penwidth="))[end]+1)
            finalEnd = search(strFrag,"]")
            pW2end = collect(pW2end)[end]+1
            finalEnd = collect(finalEnd)[1]-1
            pWmult = parse(Int,strFrag[pW2end:finalEnd])#println(pWmult)
            edgeWeight = pWmult/pW#println(edgeWeight)
            if(isempty(matCntryEdges))
                matCntryEdges = [c1 c2 edgeWeight]
            else
                matCntryEdges = vcat(matCntryEdges,[c1 c2 edgeWeight])
            end
        end               
    end    
    writedlm(string(filename,".csv"),matCntryEdges,',')#println(matCntryEdges)
    close(fileTmp)
end


function dot2csvOneWayTwoWay(filename)
    println("in dot2csvOneWayTwoWay!")
    matCntryEdges = []
    
    fileTmp = open(filename)
    linesTmp = readlines(fileTmp)
    linesStr = linesTmp[1]#
    #println(linesStr)#
    #println(typeof(linesStr))
    splits1 = split(linesStr,";")
       
    for strFrag in splits1
        
        if(contains(strFrag,"->"))#
            c1end = search(strFrag,"-")
            c1end = collect(c1end)[1]-1
            c1 = strFrag[1:c1end]#println(c1)
            
            c2start = search(strFrag,">")
            c2start = collect(c2start)[1]+1
            c2end = -1
            way = "oneWay"
            if(isempty(collect(search(strFrag," ["))))
                c2end = length(strFrag)#collect(c2end)[1]-1                
            else
                c2end = search(strFrag," [")
                c2end = collect(c2end)[1]-1
                way = "twoWay"
            end                    
            c2 = strFrag[c2start:c2end]#
            if(isempty(matCntryEdges))
                matCntryEdges = [c1 c2 way]
                if(way == "twoWay")
                    matCntryEdges = vcat(matCntryEdges,[c2 c1 way])
                end
            else
                matCntryEdges = vcat(matCntryEdges,[c1 c2 way])
                if(way == "twoWay")
                    matCntryEdges = vcat(matCntryEdges,[c2 c1 way])
                end
            end            
        end               
    end    
    writedlm(string(filename,".csv"),matCntryEdges,',')#println(matCntryEdges)
    close(fileTmp)
end

#these files have the one ways which may not be balanced
function dot2csvTotalOneWays(filename)
    println("in dot2csvTotalOneWays")
    matCntryEdges = []
    
    fileTmp = open(filename)
    linesTmp = readlines(fileTmp)
    linesStr = linesTmp[1]#println(linesStr)#println(typeof(linesStr))
    splits1 = split(linesStr,";")
    for strFrag in splits1

        if(contains(strFrag,"penwidth"))#println(strFrag)
            c1end = search(strFrag,"-")
            c1end = collect(c1end)[1]-1
            c1 = strFrag[1:c1end]#println(c1)
            c2start = search(strFrag,">")
            c2end = search(strFrag," [")
            c2start = collect(c2start)[1]+1
            c2end = collect(c2end)[1]-1
            c2 = strFrag[c2start:c2end]#println(c2)
            
            pW1end = search(strFrag,"penwidth=")
            pW1end = collect(pW1end)[end]+1
            #pW = parse(Int,strFrag[pW1end])#println(pW)
            #pW2end = search(strFrag,"penwidth=",collect(search(strFrag,"penwidth="))[end]+1)
            finalEnd = search(strFrag,"]")
            #pW2end = collect(pW2end)[end]+1
            finalEnd = collect(finalEnd)[1]-1
            pW = parse(Float64,strFrag[pW1end:finalEnd])#println(pWmult)
            edgeWeight = Int(pW/1.5)#println(edgeWeight)
            if(isempty(matCntryEdges))
                matCntryEdges = [c1 c2 edgeWeight]
            else
                matCntryEdges = vcat(matCntryEdges,[c1 c2 edgeWeight])
            end
        end               
    end    
    writedlm(string(filename,".csv"),matCntryEdges,',')
    #println(matCntryEdges)
    close(fileTmp)
end

#
function dot2csvConvert()
    resultsFile = readdir("./")
    for rf in resultsFile
        extS = contains(rf,".dot")
        extC = contains(rf,".csv")
        if(!isempty(collect(extS)))
            if(isempty(collect(extC)))
                if((collect(extS)[end]) == (length(rf)))
                    if(rf[1] == 'n')
                        println(rf)
                        if(contains(rf,"network:"))
                            dot2csvOneWayTwoWay(rf)
                            println("dot2csvOneWayTwoWay(filename)")
                        elseif(contains(rf,"networkTotal:"))
                            dot2csvTotalOneWays(rf)
                            println("dot2csvTotalOneWays(filename)")
                        elseif(contains(rf,"networkTotalCollusion:"))
                            dot2csvTotalCollusion(rf)
                            println("dot2csvTotalCollusion(filename)")
                        end
                    end
                end
            end
        end
    end
end
#
#filename = "network:1977-1982.dot"
#dot2csvOneWayTwoWay(filename)

#filename = "networkTotal:1977-2017windowSize5.dot"
#dot2csvTotalOneWays(filename)


#filename = "networkTotalCollusion:1977-2017windowSize5.dot"
#dot2csvTotalCollusion(filename)







    #=
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
    =#
