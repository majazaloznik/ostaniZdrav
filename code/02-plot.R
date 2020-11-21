

# plot ratio of  issued to positive
###############################################################################

png(filename="figures/TAN.vs.confirmed.png", 800, 480)
plot(df$date, df$issued.confirmed, 
     type = "l",
     ylab = "",
     xlab = "", 
     ylim = c(0,50),
     xlim = as.Date(c("2020-08-19", "2020-11-20")),
     axes = FALSE,
     panel.first={
       abline(v = as.Date("2020-10-26"), lty = "92", col = "darkgrey")
     })

axis.Date(1, df$date, at = seq(min(df$date), max(df$date), by="7 day"))
axis(2, las = 2, labels = )
lines(df$date, df$publihsed.confirmed, col = "blue")
abline(h = 10, lty = 2, col = "gray")
abline(h = 20, lty = 2, col = "gray")
abline(h = 30, lty = 2, col = "gray")
abline(h = 40, lty = 2, col = "gray")
abline(h = 50, lty = 2, col = "gray")

mtext(side = 3, line = 2.5,  adj = 0, cex = 1.2,
      "Percentage of daily confirmed cases who were issued with TAN codes (black) and who published TAN codes (blue)")
mtext(side = 2, line = 2.5,   cex = 1, 
      "percent")
mtext(side = 1, line = 2.5,   cex = 1, "date")
dev.off()


# plot ratio of  issued to positive 7 day rolling average 
###############################################################################

png(filename="figures/TAN.vs.confirmed.7d.png", 800, 480)
plot(df$date, df$issued.confirmed.7d, 
     type = "l",
     ylab = "",
     xlab = "", 
     ylim = c(0,20),
     xlim = as.Date(c("2020-08-19", "2020-11-20")),
     axes = FALSE,
     panel.first={
       abline(v = as.Date("2020-10-26"), lty = "92", col = "darkgrey")
     })

axis.Date(1, df$date, at = seq(min(df$date), max(df$date), by="7 day"))
axis(2, las = 2, labels = )
lines(df$date, df$publihsed.confirmed.7d, col = "blue")
abline(h = 10, lty = 2, col = "gray")
abline(h = 15, lty = 2, col = "gray")
abline(h = 5, lty = 2, col = "gray")
abline(h = 20, lty = 2, col = "gray")

mtext(side = 3, line = 2.5,  adj = 0, cex = 1.2,
      "Percentage of daily confirmed cases who were issued with TAN codes (black) and who published TAN codes (blue)")
mtext(side = 3, line = 1.5,  adj = 0, cex = 1,
      "7 day rolling average")

mtext(side = 2, line = 2.5,   cex = 1, 
      "percent")
mtext(side = 1, line = 2.5,   cex = 1, "date")
dev.off()



