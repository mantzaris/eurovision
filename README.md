# Which countries exhibit collusion or biases when voting in the Eurovision song contest?
(this research was done between Alexander V. Mantzaris, Samuel R. Rein, Alexander D. Hopkins; based at the University of Central Florida)

## background 
* written in Julia
* the dataTables folder provides in CSV format the judges scores for each country during the competitions from 1957 till 2017 with row and column headers to understand easily 'for a country in a particular year, how did that country award the scores it had available'? 
* The code provided computes statistically significant edges between countries for periods of years. We compute the edge set for periods of years (annual event) over time window producing a set of edges which allows use to see different networks of edges representing biases (1 way or 2 way)

### This answers the questions, 
1. Did country X give country Y substantially more scores from 1995-2005? (1 way bias)
2. How many times did country X give country Y substantial votes in 1975-2010 over periods of 5 years?
3. Do Countries X and Y reciprocate the biased voting to 'collude' in sharing scores? (2 way bias)
4. Can we see in a graph the set of edges between all countries that exhibited 1 way or 2 way bias?
5. If we look at a period of X years, is the collusion present in both halfs of this period if we brea the years into 2 different segments?

### Running the code for the hypothetical scenario, of looking at the period 1990-2010 where the significance is determined in every 5 years.
1. include("Mantzaris.jl)
2. include("demo.jl")
3. demo(1990,2010, 5)

    ![Alt vmware](https://github.com/mantzaris/eurovision/raw/sampleFigs/ 		
	networkTotalCollusion20072017windowSize5.png)







