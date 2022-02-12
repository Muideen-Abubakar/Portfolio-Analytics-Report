#--------------------------------------------------------------------------------------
# Name  : Muideen Abubakar
# Step One : - End of Day Allocation
#--------------------------------------------------------------------------------------

#Trade Allocations 
Database <- conMongo$find()
SelectedTraderPositions <- Database[Database$Trader == params$TraderID, ]
Allocation <- SelectedTraderPositions[grep(params$TradeDate, SelectedTraderPositions$DateTime), ]

#Remodify the Allocation table by reducing it to the most relevant columns 
RelevantCols <- c("Symbol", "Notional", "Quantity")
Allocation_1 <- Allocation[RelevantCols]

Allocation_1 <- arrange(Allocation_1, Symbol) #sort the Symbols alphabetically

#Aggregates the Notional and Quantity based on Symbol
Allocation_2 <- aggregate(. ~ Symbol, data = Allocation_1, FUN = sum)

#Print end of day Allocation
Allocation_2
