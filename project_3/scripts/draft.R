library(tidyverse)

# Get ZIP code for each entry. Note that ZIP code is "of last permanent address" and
# each client may have more than one entry. (Each entry denotes a single visit).
# Presumbly, `EE UID` gives the chronological order.
zip = read_tsv("https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/EE_UDES_191102.tsv") %>% 
  select(`Client ID`, `EE UID`, `Zip Code (of Last Permanent Address, if known)(1932)`) %>%
  arrange(`Client ID`, `EE UID`) %>%
  mutate(ZC = substr(`Zip Code (of Last Permanent Address, if known)(1932)`, 1, 5)) %>% # returns 5 digits from ZIP+4
  filter(str_detect(ZC, '\\d{5}')) %>% # removes rows that are not exactly 5 digits 
  select(-`Zip Code (of Last Permanent Address, if known)(1932)`)
head(zip)


# Get the year corresponding to each visit.
year = read_tsv("https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/ENTRY_EXIT_191102.tsv") %>%
  select(`EE UID`, `Entry Date`) %>%
  mutate(year = as.numeric(str_sub(`Entry Date`, -4, -1))) %>%
  select(-`Entry Date`)
head(year)


# Get housing price index per year per ZIP code.
hpi = read_csv("https://raw.githubusercontent.com/datasci611/bios611-projects-fall-2019-b-phung/master/project_3/data/hpi.csv", skip = 6) %>%
  select(`Five-Digit ZIP Code`, `Year`, `HPI`) %>%
  mutate(HPI = as.numeric(HPI))
head(hpi)


# Create main dataset by adding columns for the year during the given visit and HPI for the given year and ZIP code.
main = zip %>%
  left_join(year, by = "EE UID") %>%
  left_join(hpi, by = c("year" = "Year", "ZC" = "Five-Digit ZIP Code")) %>%
  drop_na() %>%
  group_by(`Client ID`) %>% 
  slice(1)                 
# Note: here I make the choice to only count the first visit if a client visits multiple times,
# so as to not overrepresent ZIP codes with a lot of repeat visitors.
# However, there is an argument for not subsetting. I might explore how this affects the results.


# There are 290 unique ZIP codes, so to limit how many to plot,
# we can choose those that had at least some threshold (e.g. 15 here) clients.
length(unique(main$ZC))


# Here, I want to get an idea what the HPI is like for each ZIP code and how that might
# relate to the number of visitors UMD gets from each of them (the label at the top of each ZC).
# To be honest, I'm not totally satisfied with this and I'm sure there's a better way to graph it.
# After all, HPI is also a function of year, so it would be nice to capture that as well.
# Feedback regarding this is esepcially welcome.
min_visits = 15
main2 = main %>% group_by(ZC) %>% mutate(ZCcounts=n()) %>% filter(ZCcounts >= min_visits)
main2 %>%
  ggplot(aes(factor(ZC), HPI)) +
  geom_violin(scale = "count") +
  geom_text(aes(x=factor(ZC), y=max(HPI)+25, label=ZCcounts))
# Note that UMD is located in 27701.
# 276**s are in Raleigh.
# Besides from these, and 27713, 27701 is directly adjacent all the ZIP codes.
# Planning to plot these out geographically in Part 2 below.


# Breaking further down into counts per year per zipcode.
# Again, not really happy with this.
main3 = main2 %>% group_by(ZC, year) %>% mutate(ZCyearcounts=n())
main3 %>% ggplot(aes(factor(ZC), year)) +
  geom_violin(scale = "count") +
  geom_text(aes(label = ZCyearcounts), color = "#000000", nudge_y = .15) +
  geom_text(aes(label = HPI), color = "#000000", nudge_y = -.15)


# Might be better to take a single ZIP code at a time and panel them together later.
test = main3 %>% filter(ZC == 27701)
test %>% ggplot(aes(year, HPI)) +
  geom_line()
test %>% ggplot(aes(year, ZCyearcounts)) +
  geom_line()

# adapted from https://gist.github.com/sebastianrothbucher/de847063f32fdff02c83b75f59c36a7d
test2 = test %>% select(ZC, year, HPI, ZCyearcounts) %>% distinct() %>%
  gather("panel", "value", c(HPI, ZCyearcounts))
test2 %>% ggplot(mapping = aes(x = year, y = value)) +
  facet_grid(panel~., scale = "free") +
  geom_line(data=test2[test2$panel=="HPI",]) +
  geom_line(data=test2[test2$panel=="ZCyearcounts",])


# Part 2
# adapted from https://stackoverflow.com/a/47608134
# Installing all these packages and cloning down the files might be a pain, so feel free to skip this part.
# Docker and Make should streamline this part but I haven't gotten to it yet.
library(rgdal)
library(rgeos)
library(maptools)
library(ggalt)
library(ggthemes)
library(ggrepel)
library(RColorBrewer)

mydata <- readOGR(dsn = "./data/cb_2018_us_zcta510_500k", layer = "cb_2018_us_zcta510_500k")
durham = main2$ZC %>% unique()
mypoly <- subset(mydata, ZCTA5CE10 %in% durham)
mymap <- fortify(mypoly)
plot(mypoly)
centers <- data.frame(gCentroid(spgeom = mypoly, byid = TRUE))
centers$zip <- rownames(centers)
ggplot() +
  geom_cartogram(data = mymap, aes(x = long, y = lat, map_id = id), map = mymap) +
  geom_cartogram(data = mypoly.df, aes(fill = value, map_id = group), map = mymap) #+
  # geom_text_repel(data = centers, aes(label = zip, x = x, y = y), size = 3) +
  # scale_fill_gradientn(colours = rev(brewer.pal(10, "Spectral"))) +
  # coord_map() +
  # theme_map()

