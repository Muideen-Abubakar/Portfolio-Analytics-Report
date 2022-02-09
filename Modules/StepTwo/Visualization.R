#--------------------------------------------------------------------------------------
# UCL -- Institute of Finance & Technology
# Student Name  : Muideen Abubakar
# Student Number : 21125043
# Coursework Three : Use Case One 
# Step Two : Performance and Risk Metrics - visualization
#--------------------------------------------------------------------------------------

#Top Portfolio Holdings -------------------------------------------------------

#Table

#Sort Allocation_2 in descending order by Weight
Desc_Allocation_2 <- Allocation_2[order(-Allocation_2$Weight),]

#Convert the weights to %
Desc_Allocation_2$Weight <- round(Desc_Allocation_2$Weight *100,2)

#Include only Symbols and the weights
TopHoldings <- Desc_Allocation_2[, c("Symbol", "Weight")]

#Reorder the row numberings
rownames(TopHoldings) <- 1:nrow(TopHoldings)

TopTenHoldings <- head(TopHoldings, 10)

#Print TopHoldings table
TopTenHoldings

# Chart

TopTenHoldingsPie <- pie3D(TopTenHoldings$Weight, border = "white", labels = TopTenHoldings$Symbol, labelcex = 0.75, explode = 0.15, shade = 0.3)

#Print chart
TopTenHoldingsPie

#Relative stock performance-----------------------------------------------------
Tickers = c(TopTenHoldings$Symbol)
stocks <- tq_get(Tickers, from = params$InceptionDate)

RelativePerformance <- stocks %>% 
                        dplyr::select(symbol, date, adjusted) %>% 
                        tidyr::spread(key = symbol, value = adjusted) %>% 
                        timetk::tk_xts() %>% 
                        dygraph() %>%
                        dyRebase(value = 100) %>% 
                        dyRangeSelector()
