###############################################################################
# load libraries
###############################################################################

library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(tidyjson) 
library(lubridate)

###############################################################################

## import data
###############################################################################

# # UNCOMMENT TO (RE-)DOWNLOAD DATA
# download.file(paste0("https://raw.githubusercontent.com/",
#                      "sledilnik/data/master/csv/stats.csv"),
#               "data/stats.csv")
# download.file(paste0("https://raw.githubusercontent.com/",
#                      "sledilnik/data/master/ostanizdrav/podatki.gov.si/tanstatistika.csv"),
#               "data/issued.csv")
# 
# download.file(paste0("https://raw.githubusercontent.com/",
#                      "sledilnik/data/master/ostanizdrav/ctt/data.json"),
#               "data/published.json")

confirmed.cases <- read_csv("data/stats.csv")

tan.issued <- read_csv("data/issued.csv",
                       col_types = 
                         cols_only('created_at' = col_date("%d.%m.%Y"), 
                                   'count' = col_double())) 

tan.published <- fromJSON("data/published.json")
    
    
## clean up data
###############################################################################

confirmed.cases %>% 
  select(date, tests.positive) ->   confirmed.cases

tan.published %>% 
  mutate(date = as.Date(date, "%Y-%m-%d")) -> tan.published

tan.issued %>% 
  rename("date" = "created_at") -> tan.issued

left_join(tan.published, confirmed.cases) %>% 
  left_join(tan.issued) -> df 

## calculate stuff 
###############################################################################

df %>% 
  mutate(issued.confirmed = count/tests.positive* 100,
         publihsed.confirmed = users_published/tests.positive*100 ) -> df



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


