library(tidyverse)

# https://www.bls.gov/eag/eag.nc_durham_msa.htm
# https://data.bls.gov/timeseries/LAUMT372050000000003?amp%253bdata_tool=XGtable&output_view=data&include_graphs=true

# plot frequency of shelter visits over time
# plot unemployment (rate) over time
# dashboard can be used to control year and 
# can pick a client and return a summary of their visits

genPlot = function(ID){
UMD = read_tsv("data/UMD_Services_Provided_20190719.tsv") %>%
  select(`Client File Number`, Date) %>%
  mutate(formatted.date = as.Date(Date, "%m/%d/%Y")) %>%
  arrange(formatted.date, `Client File Number`) %>%
  mutate(year = as.numeric(format(formatted.date, "%Y"))) %>%
  filter(1996 <= year & formatted.date <= "2019-07-19") %>%
  mutate(year.month = cut(formatted.date, breaks = "month"))

UMD = UMD %>% filter(`Client File Number` == ID)

UMD_counts = UMD %>%
  group_by(year.month) %>%
  summarize(visits = n()) %>%
  mutate(year.month = as.Date(year.month)) %>%
  mutate(panel = "visit frequency") %>%
  mutate(unemployment_rate = "")

emp = read_csv("data/employment.csv") %>%
  gather(Jan:Dec, key = "Month", value = "unemployment_rate") %>%
  mutate(year.month = as.Date(paste(Year, Month, "01", sep = "-"), format = "%Y-%b-%d")) %>%
  arrange(year.month) %>%
  select(-Year, -Month) %>%
  mutate(panel = "Durham unemployment rate") %>%
  mutate(visits = "")

panel = rbind(UMD_counts, emp)

panel %>%
  ggplot(mapping = aes(x = year.month, y = visits)) + 
  facet_grid(panel~., scale="free") + 
  geom_bar(data = UMD_counts, stat = "identity") + 
  geom_line(data = emp, mapping=aes(y = unemployment_rate)) +
  xlab("year") +
  ylab("")
}


# 
# most frequent visitors
# test = UMD %>%
#   group_by(`Client File Number`) %>%
#   summarize(entries = n()) %>%
#   arrange(desc(entries))
# head(test,10)
# 
# 
# UMD = UMD %>%
#   filter(`Client File Number` == "3502")
# c3502_counts = c3502 %>%
#   group_by(year.month) %>%
#   summarize(visits = n()) %>%
#   mutate(year.month = as.Date(year.month)) %>%
#   mutate(panel = "visit frequency") %>%
#   mutate(unemployment_rate = "")
# 
# panel = rbind(c3502, emp)
# panel %>%
#   ggplot(mapping = aes(x = year.month, y = visits)) + 
#   facet_grid(panel~., scale="free") + 
#   geom_bar(data = UMD_counts, stat = "identity") + 
#   geom_line(data = emp, mapping=aes(y = unemployment_rate)) +
#   xlab("year") +
  ylab("")