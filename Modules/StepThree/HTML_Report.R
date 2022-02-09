#--------------------------------------------------------------------------------------
# UCL -- Institute of Finance & Technology
# Student Name  : Muideen Abubakar
# Student Number : 21125043
# Coursework Three : Use Case One 
# Step Three : HTML Report
#--------------------------------------------------------------------------------------

#Run HTML----------------------------------------------------------------------------

setwd("./Modules/StepThree")
render("Report.Rmd", output_file = "../../Home.html")
setwd("../../")
browseURL("./Home.html")