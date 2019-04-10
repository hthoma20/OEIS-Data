setwd("C:/Users/Harrison/Documents/3rd_year/Sem2/Data/oeisData/OEIS")

#open a sqlite db
con <- dbConnect(RSQLite::SQLite(), "../../oeis-master/oeis-master/oeis.sqlite3")

#read the stripped data from files
stripped <- read.csv("../stripped", header= F)
names <- read.delim("../names", header= F, sep= "\n", quote= "")

names(stripped) <- c("id", 1:(length(stripped)-1))
