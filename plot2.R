NEI <- readRDS("summarySCC_PM25.rds")
baltimore <- subset(NEI, fips == "24510")
baltimore_totals <- setNames(aggregate(baltimore$Emissions, list(baltimore$year), sum), c("year", "emissions"))
fit <- lm(emissions ~ year, data=baltimore_totals)
png("plot2.png")
plot(x = baltimore_totals$year, 
     y = baltimore_totals$emissions,
     pch = 19,
     col = "red",
     cex = 2,
     xlab = "Year", 
     ylab = "Total PM2.5 Emissions (tons)", 
     main = "PM2.5 Emissions Over Time in Baltimore City")
abline(fit)
dev.off()
rm('fit')
rm('baltimore_totals')
rm('baltimore')
rm('NEI')