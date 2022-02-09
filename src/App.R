#--------------------------------------------------------------------------------------
# UCL -- Institute of Finance & Technology
# Student Name  : Muideen Abubakar
# Student Number : 21125043
# Coursework Three : Use Case One
#--------------------------------------------------------------------------------------

#Import Packages
library(lubridate)
library(dplyr)
library(stringi)
library(RSQLite)             
library(mongolite)
library(ggplot2)
library(quantmod)
library(PerformanceAnalytics)
library(tidyquant)
library(plotrix)
library(scales)
library(dygraphs)
library(timetk)

#Set up directory and load Config and Params
#Args = c("C:/Users/user/Documents/BigData_in_Q.fin/Coursework/Coursework1/MuideenAbubakar/3.CourseworkThree", "script.config", "script.params")

Args <- commandArgs(TRUE)

setwd(Args[1])

# Source config
source(paste0("./Config/", Args[2]))

# Source params
source(paste0("./Config/", Args[3]))

#Source HelperFunctions
source(Config$Directories$HelperFunctions)

printInfoLog("App.R :: Scripts Settings Loaded...", type = "info")

#Set up connection with MongoDB and SQL
conMongo <- mongo(collection = "CourseworkTwo", db = "Equity", url = "mongodb://localhost",
                  verbose = FALSE, options = ssl_options())

conSql <- dbConnect(RSQLite::SQLite(), Config$Directories$SQLDataBase)

#End of Day portfolio Allocation

source(Config$Directories$PortfolioAllocation)

printInfoLog("End of Day Portfolio Allocation...complete")


#Historical Trends, Return and Risk Metrics

source(Config$Directories$PerformanceRiskMetrics)

#Performance
Portfolio_Size
ReturnToDate
SinceInception
Day12Return
Alpha

#Risk
StandardDev
Sharperatio
TrackingErr
InformationRatio

printInfoLog("Portfolio trends, return and risk metrics...complete")

#Visualization of portfolio and performance

source(Config$Directories$Visualization)
TopTenHoldings
TopTenHoldingsPie
RelativePerformance

printInfoLog("Relative perfomance chart...complete")

#Create HTML

source(Config$Directories$HTML)

printInfoLog("HTML Report...complete")


#Close Mongo and SQL connections
dbDisconnect(consql)
conMongo$disconnect()

printInfoLog("App.R :: Script Completed")

# End of script--------------------------------------------------------------