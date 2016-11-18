library(plyr)
library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get the SCC codes that are related to motor vehicles
vehicle_scc <- subset(SCC, EI.Sector %in% grep("[Vv]ehicle", unique(EI.Sector), value=TRUE))

# Get the PM2.5 observations for those SCC codes in Baltimore City
bmore_vehicles <- subset(NEI, SCC %in% vehicle_scc$SCC & fips %in% c("24510", "06037"))
# Add the EI.Sector
bmore_vehicles$EI.Sector <- vehicle_scc$EI.Sector[match(bmore_vehicles$SCC, vehicle_scc$SCC)]
bmore_vehicles$Vehicle.Type <- mapvalues(bmore_vehicles$EI.Sector, 
                                         from=unique(bmore_vehicles$EI.Sector), 
                                         to=c('Light Duty Gasoline Vehicles', 
                                              'Heavy Duty Gasoline Vehicles', 
                                              'Light Duty Diesel Vehicles', 
                                              'Heavy Duty Diesel Vehicles'))

# Change fips codes to names
bmore_vehicles$fips <- ifelse(bmore_vehicles$fips == '06037', 'Los Angeles County', 'Baltimore City')

# Compute the total across vehicle type and year
totals <- bmore_vehicles %>% group_by(fips, Vehicle.Type, year) %>% summarize(Emissions = sum(Emissions))

ggplot(totals, aes(year, Emissions, color=Vehicle.Type)) + 
  geom_point() + 
  geom_line() + 
  facet_grid(~ fips) + 
  labs(x = "Year", 
       y = "PM2.5 Emissions (ton)", 
       title = "PM2.5 Emissions from Motor Vehicles in Baltimore City and Los Angeles County from 1999-2008")
ggsave("plot6.png", width = 12, height = 7)

rm('vehicle_scc')
rm('totals')
rm('bmore_vehicles')
rm('SCC')
rm('NEI')