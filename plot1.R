NEI <- readRDS("summarySCC_PM25.rds")
yearly_total <- setNames(aggregate(NEI$Emissions, list(NEI$year), sum), c("year", "emissions"))
fit <- lm(emissions ~ year, data=yearly_total)
png("plot1.png")
plot(x = yearly_total$year, 
     y = yearly_total$emissions,
     pch = 19,
     col = "red",
     cex = 2,
     xlab = "Year", 
     ylab = "Total PM2.5 Emissions (tons)", 
     main = "PM2.5 Emissions Over Time")
abline(fit)
dev.off()
rm('fit')
rm('yearly_total')
rm('NEI')