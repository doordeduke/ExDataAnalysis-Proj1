#Read in packages of interest

library("sqldf", 
          lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

library("plyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

library("datasets", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

#Read original data file in, selecting on dates of interest

power_orig <- read.csv.sql("household_power_consumption_orig.txt",
          sql="select * from file where Date = '1/2/2007' 
          or Date = '2/2/2007' ", header = TRUE, sep=";")

#Merge date/time variables

power_datetime <- paste(power_orig$Date, power_orig$Time)

#Convert from character datatype to date/time format

power2 <- as.POSIXct(power_datetime, format = "%d/%m/%Y %H:%M:%S")

#Dataframe now contains properly formatted variables

power <- cbind(power2,power_orig[,3:9])

#Rename date/time variable as such

powerfinal <- rename(power, c("power2" = "date_time"))

#Create Plot 4

png(file = "plot4.png")

par(mfrow = c(2,2))

#upper left plot

plot(powerfinal$date_time, powerfinal$Global_active_power, 
          type = "l", xlab = "", ylab = "Global Active Power")

#upper right plot

plot(powerfinal$date_time, powerfinal$Voltage, 
          type = "l", xlab = "datetime", ylab = "Voltage")

#bottom left plot

plot(powerfinal$date_time, powerfinal$Sub_metering_1,
          type = "l", xlab ="", ylab = "Energy sub metering")

lines(powerfinal$Sub_metering_2 ~ powerfinal$date_time, col = "red")

lines(powerfinal$Sub_metering_3 ~ powerfinal$date_time, col = "blue")

legend("topright", lty = 1, col = c("black", "red", 
          "blue"), bty = "n", legend = c("Sub_metering_1", 
          "Sub_metering_2", "Sub_metering_3"))

#bottom right plot

plot(powerfinal$date_time, powerfinal$Global_reactive_power, 
          type = "l", xlab = "datetime", ylab = "Global_reactive_power")

dev.off()