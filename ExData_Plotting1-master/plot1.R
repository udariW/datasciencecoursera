library(sqldf)
library(gsubfn)
library(chron)

# set working dir
script.dir <- dirname(sys.frame(1)$ofile)
setwd(script.dir)

# read only subset of the data
data <- read.csv.sql(file = "household_power_consumption.txt", sep = ";",
  sql = "select * from file where 
    substr(Date, -4) 
      || '-' || 
        substr('0' || replace(substr(Date, instr(Date, '/') + 1, 2), '/', ''), -2) 
          || '-' || 
            substr('0' || replace(substr(Date, 1, 2), '/', ''), -2)
              between '2007-02-01' and '2007-02-02'")

# set data types
data$Date = as.Date(data$Date, "%d/%m/%Y")
data$Time = times(data$Time)

# draw and save
hist(data$Global_active_power, col="red", main = "Global Active Power", xlab="Global Active Power (kilowatts)")
dev.copy(png,'plot1.png')
dev.off()


