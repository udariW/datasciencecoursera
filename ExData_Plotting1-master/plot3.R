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
data$DateTime <- as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")
plot(Sub_metering_1 ~ DateTime, data = data, type="s", ylab="Energy sub metering")
lines(Sub_metering_2 ~ DateTime, data = data, type="s", col="red")
lines(Sub_metering_3 ~ DateTime, data = data, type="s", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lwd=2)
dev.copy(png,'plot3.png')
dev.off()

