library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get the SCC codes that are related to coal combustion
coal_comb <- subset(SCC, EI.Sector %in% grep("[Cc]oal", unique(EI.Sector), value=TRUE))
coal_comb <- coal_comb$SCC

# Get the PM2.5 observations for those SCC codes
coal_obs <- subset(NEI, SCC %in% coal_comb)
coal_obs <- setNames(aggregate(coal_obs$Emissions, 
                               by = c(list(coal_obs$year), list(coal_obs$type)), 
                               sum), 
                     c("year", "type", "emissions"))

# Add the total across types
totals <- setNames(aggregate(coal_obs$emissions, list(coal_obs$year), sum), c("year", "emissions"))
totals$type = "TOTAL"
coal_obs <- rbind(coal_obs, totals)

ggplot(coal_obs, aes(year, emissions, col=type)) + 
  geom_point() +
  geom_line() +
  labs(x = "Year", y = "PM2.5 Emissions (tons)", title = "PM2.5 Emissions from Coal Combustion Related Sources")
ggsave("plot4.png")

rm('coal_comb')
rm('totals')
rm('coal_obs')
rm('SCC')
rm('NEI')