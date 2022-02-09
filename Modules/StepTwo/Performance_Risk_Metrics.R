#--------------------------------------------------------------------------------------
# UCL -- Institute of Finance & Technology
# Student Name  : Muideen Abubakar
# Student Number : 21125043
# Coursework Three : Use Case One 
# Step Two : Performance and Risk Metrics
#--------------------------------------------------------------------------------------


#Portfolio Performance Metrics --------------------------------------------------------

#Compute the marked-to-market portfolio size (based on current prices)
#Get latest price data from Yahoo Finance

#Some companies have changed their tickers, so change the Symbols to match the ticker as quoted on Yahoo Finance
Allocation_2$Symbol[Allocation_2$Symbol == "SYMC"] <- "SYMC.VI" 
Allocation_2$Symbol[Allocation_2$Symbol == "BRK.B"] <- "BRK-B"
Allocation_2$Symbol[Allocation_2$Symbol == "BHGE"] <- "BKR"
Allocation_2$Symbol[Allocation_2$Symbol == "HRS"] <- "HRS.DU"

CurrentPrice <- getQuote(Allocation_2$Symbol, what=yahooQF("Last Trade (Price Only)")) 

Allocation_2$CurrentPrice <- CurrentPrice$Last

Portfolio_Size <- sum(Allocation_2$Quantity * Allocation_2$CurrentPrice)

#Print portfolio size
Portfolio_Size <- label_comma()(Portfolio_Size)

#Calculate Portfolio Performance
#The performance of the portfolio is assessed on four different metrics;

# a.Return-to-Date (Nov-12 portfolio value vs the market value of the portfolio using marked-to-market prices) 
#Compute the average unit price
Allocation_2$UnitPrice <- Allocation_2$Notional/Allocation_2$Quantity

#Compute the return per stock based on current market price
Allocation_2$Return <- ((Allocation_2$CurrentPrice/Allocation_2$UnitPrice)-1)*100

#Compute the weight of each stock relative to the portfolio size
Allocation_2$Weight <- (Allocation_2$Notional/Portfolio_Size)

#Compute the weighted return for each stock
Allocation_2$WeightedReturn <- Allocation_2$Return*Allocation_2$Weight

#Compute the overall portfolio weighted return to date
ReturnToDate <- sum(Allocation_2$WeightedReturn)

#Print return to date, and round to 2 decimal points
ReturnToDate <- round(ReturnToDate, 2)

# b.Return from inception (i.e. compare the current portfolio value to what it was when it started in Jan-06-20)

# Get the portfolio allocation at inception
AllocInception <- SelectedTraderPositions[grep(params$InceptionDate, SelectedTraderPositions$DateTime), ]
AllocInception <- AllocInception[, c("Symbol", "Quantity", "Notional")]

#Aggregate based on Quantity and Notional
Agg_AllocInception <- aggregate(. ~ Symbol, data = AllocInception, FUN = sum)

SinceInception <- (sum(Allocation_2$Notional)/sum(Agg_AllocInception$Notional)-1)*100

#Print return from inception
SinceInception <- round(SinceInception,2)

# c. 1-day return (which compares the value of the portfolio on Nov-12 to the value on Nov-11)

AllocDay11 <- SelectedTraderPositions[grep(as.Date(params$TradeDate)-1, SelectedTraderPositions$DateTime), ]
AllocDay11 <- AllocDay11[, c("Symbol", "Quantity", "Notional")]

#Aggregate based on Quantity and Notional
Agg_AllocDay11 <- aggregate(. ~ Symbol, data = AllocDay11, FUN = sum)

Day12Return <- (sum(Allocation_2$Notional)/sum(Agg_AllocDay11$Notional)-1)*100

#Print 1-day return
Day12Return <- round(Day12Return, 2)

# d.Alpha return, using the S&P 500 as benchmark

#Get the S&P Index level as at params$TradeDate
GSPC <- getSymbols("^GSPC", from = params$TradeDate, to = as.Date(params$TradeDate)+1, warnings = FALSE, auto.assign = FALSE)
SP500_1 <- head(GSPC)
SP500_1 <- SP500_1$GSPC.Adjusted
SP500_1 <- as.numeric(SP500_1)

SP500_Current <- getQuote("^GSPC", what=yahooQF("Last Trade (Price Only)")) 
SP500_Current <- SP500_Current$Last

Rb <- as.numeric(((SP500_Current/SP500_1)-1)*100)

Alpha = ReturnToDate - Rb

#Print Alpha return
Alpha <- round(Alpha, 2)

#Risk-free rate (US 10-yr Treasury)
#Get the risk-free rate (US 10-yr Treasury yield) from Yahoo Finance
Rf <- getQuote("^TNX", what=yahooQF("Last Trade (Price Only)")) 
Rf <- Rf$Last

#Portfolio risk metrics ------------------------------------------------------

#Standard deviation
StandardDev <- StdDev(Allocation_2$WeightedReturn)

#Print standard deviation
StandardDev <- as.numeric(round(StandardDev, 2))

#Sharpe ratio
SharpeRatio <- (ReturnToDate - Rf)/StandardDev

#Print Sharpe ratio
SharpeRatio <- as.numeric(round(SharpeRatio, 2))

#Tracking error
TrackingErr <- StdDev(Allocation_2$WeightedReturn - Rb)^0.5

#Print tracking error
TrackingErr <- as.numeric(round(TrackingErr, 2))

#Information ratio
InformationRatio <- (ReturnToDate-Rb)/TrackingErr

#Print information ratio
InformationRatio <- as.numeric(round(InformationRatio, 2))

