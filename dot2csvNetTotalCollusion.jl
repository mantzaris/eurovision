
function dot2csvTotalCollusion(filename)
    
    
    fileTmp = open(filename)
    linesTmp = readlines(fileTmp)
    linesStr = linesTmp[1]
#    println(linesStr)
#    println(typeof(linesStr))
    splits1 = split(linesStr,";")
    for strFrag in splits1

        if(contains(strFrag,"penwidth"))
            println(strFrag)
            c1end = search(strFrag,"-")
            c1end = collect(c1end)[1]-1
            c1 = strFrag[1:c1end]
            println(c1)
            c2start = search(strFrag,">")
            c2end = search(strFrag," [")
            c2start = collect(c2start)[1]+1
            c2end = collect(c2end)[1]-1
            c2 = strFrag[c2start:c2end]
            println(c2)
            pW1end = search(strFrag,"penwidth=")
            pW1end = collect(pW1end)[end]+1
            pW = parse(Int,strFrag[pW1end])
            println(pW)
            pW2end = search(strFrag,"penwidth=",collect(search(strFrag,"penwidth="))[end]+1)
            finalEnd = search(strFrag,"]")
            pW2end = collect(pW2end)[end]+1
            finalEnd = collect(finalEnd)[1]-1
            pWmult = parse(Int,strFrag[pW2end:finalEnd])
            println(pWmult)
        end

    end
        
end

filename = "networkTotalCollusion:1977-2017windowSize5.dot"
dot2csvTotalCollusion(filename)


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
