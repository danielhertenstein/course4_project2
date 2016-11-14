library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
baltimore <- subset(NEI, fips == "24510" & year %in% c(1999, 2008))
baltimore_types <- setNames(aggregate(baltimore$Emissions, 
                                      by = c(list(baltimore$year), list(baltimore$type)), 
                                      sum), 
                            c("year", "type", "emissions"))
ggplot(baltimore_types, aes(year, emissions, col=type)) + 
  geom_point() +
  geom_line() +
  labs(x = "Year", y = "PM2.5 Emissions (tons)", title = "PM2.5 Emissions in Baltimore City by Type")
ggsave("plot3.png")
rm('baltimore_types')
rm('baltimore')
rm('NEI')