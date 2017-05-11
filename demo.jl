function demo(stYr=1975,endYr=1985,windowSize=5)

    yr=stYr
    collusionDict = Mantzaris(stYr,endYr,windowSize)
    print("\n");print(collusionDict);print("\n")
    for key in keys(collusionDict)
        print(key)
        print("\n")
    end
    
    while( (yr+windowSize) <= endYr )
        oneWays = collusionDict["1way:$(yr)-$(yr + windowSize)"]
        twoWays = collusionDict["2way:$(yr)-$(yr + windowSize)"]
        network = "digraph{"
        yrs = string("years","$(yr)","to","$(yr + windowSize)")# to "# $(yr + windowSize)"
        network = string(network,string(" graph [label=","$(yrs)",", fontsize=34]; "))
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
        fileName = string("network","1way:$(yr)-$(yr + windowSize)",".dot")
        print(fileName)
        filePNG = string("network","1way:$(yr)-$(yr + windowSize)",".png")
        print(filePNG)
        writedlm(string("./",fileName), [network])
        
        run(`dot $fileName -Tpng -o $filePNG`)
        print(network)
        yr = yr + windowSize
    end
    
  
     
end

#run(`diplsay network.png`) 
