function demo(stYr=1975,endYr=1985,windowSize=5)

    yr=stYr
    collusionDict = Mantzaris(stYr,endYr,windowSize)
    print("\n");print(collusionDict);print("\n")
    for key in keys(collusionDict)
        print(key)
        print("\n")
    end
    network = "digraph{"
    while( (yr+windowSize) <= endYr )
        oneWays = collusionDict["1way:$(yr)-$(yr + windowSize)"]
        for pair in oneWays
            pair = replace(pair,"&","")
            pair = replace(pair,".","")
            pairTmp = split(pair,'-')
            pairTmp[1] =  replace(pairTmp[1]," ","")
            pairTmp[2] =  replace(pairTmp[2]," ","")
            edge = string(pairTmp[1],"->",pairTmp[2],";")
            network = string(network,edge)
        end
        yr = yr + windowSize
    end
    network = string(network,"}")
    print(typeof(network))
    #network = append!(network,["a->b;b->c;a->c;d->c;e->c;e->a;a->e;e->fNEW;a->b;a->b;"])
    
    
    writedlm("./network.dot", [network])
    print(network)
    run(`dot network.dot -Tpng -o network.png`)
    #run(`diplsay network.png`)
    
end
