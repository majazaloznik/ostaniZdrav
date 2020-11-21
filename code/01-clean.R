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

