###############################################################################
# load libraries
###############################################################################

library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(zoo)
###############################################################################

## import data
###############################################################################

# # UNCOMMENT TO (RE-)DOWNLOAD DATA
# download.file(paste0("https://raw.githubusercontent.com/",
#                      "sledilnik/data/master/csv/stats.csv"),
#               "data/stats.csv")
# 
# download.file(paste0("https://raw.githubusercontent.com/",
#                      "sledilnik/data/master/ostanizdrav/merged.csv"),
#               "data/merged.csv")

confirmed.cases <- read_csv("data/stats.csv")


ostani.zdrav <-   read_csv("data/merged.csv")

## clean up data
###############################################################################

confirmed.cases %>% 
  select(date, tests.positive) ->   confirmed.cases

confirmed.cases %>% 
  right_join(ostani.zdrav, by = c("date" = "Date")) %>% 
  rename(issued = TAN.issued,
         published = TAN.users, 
         users = downloads.toDate,
         confirmed = tests.positive) -> df
             

## calculate stuff 
###############################################################################

df %>% 
  mutate(issued.7d = rollmean(issued, 7, align = "right", na.pad = TRUE),
         published.7d = rollmean(published, 7, align = "right", na.pad = TRUE),
         confirmed.7d = rollmean(confirmed, 7, align = "right", na.pad = TRUE),
         issued.confirmed = issued/confirmed * 100,
         publihsed.confirmed = published/confirmed*100 ,
         issued.confirmed.7d = issued.7d/confirmed.7d * 100,
         publihsed.confirmed.7d = published.7d/confirmed.7d *100 ) -> df



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



