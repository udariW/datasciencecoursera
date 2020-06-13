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

par(mfrow = c( 2, 2))

data$DateTime <- as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")

plot(Global_active_power ~ DateTime, data = data, type="s", ylab="Global Active Power (kilowatts)")

plot(Voltage ~ DateTime, data = data, type="s", ylab="Global Active Power (kilowatts)")

plot(Sub_metering_1 ~ DateTime, data = data, type="s", ylab="Energy sub metering")
lines(Sub_metering_2 ~ DateTime, data = data, type="s", col="red")
lines(Sub_metering_3 ~ DateTime, data = data, type="s", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), cex = 0.6, lwd=2)

plot(Global_reactive_power ~ DateTime, data = data, type="s", ylab="Global Reactive Power (kilowatts)")

dev.copy(png,'plot4.png')
dev.off()