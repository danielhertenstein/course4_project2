library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get the SCC codes that are related to motor vehicles
vehicle_scc <- subset(SCC, EI.Sector %in% grep("[Vv]ehicle", unique(EI.Sector), value=TRUE))

# Get the PM2.5 observations for those SCC codes in Baltimore City
bmore_vehicles <- subset(NEI, SCC %in% vehicle_scc$SCC & fips == "24510")
# Add the EI.Sector
bmore_vehicles <- setNames(aggregate(bmore_vehicles$Emissions, 
                                     by = c(list(bmore_vehicles$year), list(bmore_vehicles$type)), 
                                     sum), 
                           c("year", "type", "emissions"))

# Add the total across types
totals <- setNames(aggregate(bmore_vehicles$emissions, list(bmore_vehicles$year), sum), c("year", "emissions"))
totals$type = "TOTAL"
bmore_vehicles <- rbind(bmore_vehicles, totals)

ggplot(bmore_vehicles, aes(year, emissions, col=type)) + 
  geom_point() +
  geom_line() +
  labs(x = "Year", y = "PM2.5 Emissions (tons)", title = "PM2.5 Emissions from Motor Vehicles in Baltimore City")
ggsave("plot5.png")

#rm('vehicle_scc')
#rm('totals')
#rm('bmore_vehicles')
#rm('SCC')
#rm('NEI')