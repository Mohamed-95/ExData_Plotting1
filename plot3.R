# 1st downloading the file if it doesn't already exist in the working directory


if (!file.exists("household_power_consumption.txt")) {
  
  # downloads the zipped data file as 'data.zip'
  message("The file 'household_power_consumption.txt' ",
          "doesn't exists in the working directory. \n",
          "Trying to download the zipped data file ...")
  
  zip_data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(zip_data_url, "data.zip")
  
  message("\t ... zipped data file was successfully downloaded.")
  
  
  # unzips the 'data.zip' file
  message("Trying to extract the data file...")
  unzip("data.zip")
  
  # removes the 'data.zip' file
  file.remove("data.zip")
  
  message("\t ... data file was successfully extracted ",
          "and the zipped file removed. \n",
          "The data file 'household_power_consumption.txt'",
          " is present in the working directory.")
}


# 2nd reading the data 
project_data <- read.table(
  # Arguments that should be provided,
  # to read the data correctly : file, sep, na.strings, colClasses
  file = "household_power_consumption.txt",
  sep = ";",
  na.strings = "?",
  colClasses = c("character",   # 1. Date
                 "character",   # 2. Time
                 "numeric",     # 3. Global_active_power
                 "numeric",     # 4. Global_reactive_power
                 "numeric",     # 5. Voltage
                 "numeric",     # 6. Global_intensity
                 "numeric",     # 7. Sub_metering_1
                 "numeric",     # 8. Sub_metering_2
                 "numeric"),    # 9. Sub_metering_3
  
  # Argument that should be provided to read only the part of the file needed
  ## with this setup the first 66637 lines will be skipped,
  ## (1 line for the headers and 66636 lines for the first
  ##  unnecessary observations) then the it reads the next 2880 lines because:
  ##    (60 minutes)  x  (24 hours)  x  (2 days)  =  (2880 observations)
  skip = 66637,
  nrows = 2880,
  ## this setup assumes the default value of 'headers' argument
  ## so variables names will not be present in the 'project_data'
  header = FALSE,   # Can be omitted. The default value is the same.
  
  # Arguments that can be omitted, although they increase loading speed
  quote = "",
  comment.char = "",
  ## it is supplied just to highlight the decimal mark used in the data file
  dec = "."   # Can be omitted. The default value is the same.
)

# 3rd creating a dataframe required to construct plot3
# Creates a new variable for datetime in POSIXct format as 'datetime',
# based on 'Date' and 'Time' variables from 'project_data'
datetime <- strptime(
  x = paste(project_data[[1]],  # Date
            project_data[[2]]), # Time
  format = "%d/%m/%Y %H:%M:%S"
)

# Creates a data frame only with the required variables for 'plot3.png'
target_data <- data.frame(
  "Datetime" = datetime,
  "Sub_metering_1" = project_data[[7]], 
  "Sub_metering_2" = project_data[[8]],
  "Sub_metering_3" = project_data[[9]]
)

#4th constructing plot3 and saving it as a plot3.png file
# Opens a new png graphical device, with resolution 480x480 pixels.
png(filename = "plot3.png", width = 480, height = 480)

# Constructs Plot 3
with(target_data, {
  
  # creates axis and labels but doesn't plot anything in it
  plot(x = Datetime, y =  Sub_metering_1, 
       type = "n", # to avoid plotting any points
       # but will use the values to specify 
       # the x-axis and y-axis limits
       xlab = "", ylab = "Energy sub metering")
  
  # plots the lines for the target variables over the datetime
  points(x = Datetime, y = Sub_metering_1, type = "l", col = "black")
  points(x = Datetime, y = Sub_metering_2, type = "l", col = "red")
  points(x = Datetime, y = Sub_metering_3, type = "l", col = "blue")
  
  # adds a legend to indicate which color corresponds to each variable
  legend(x = "topright",
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
         col = c("black", "red", "blue"),
         lty = 1)
})

# Closes the graphical device and saves Plot 3 as 'plot3.png'
dev.off()
