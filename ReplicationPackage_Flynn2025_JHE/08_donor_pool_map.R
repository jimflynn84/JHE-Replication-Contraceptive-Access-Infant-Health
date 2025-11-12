#these are the necessary packages 
packages = c("tidyverse","usmap", "tidycensus","ggplot2","ggthemes")

#this function checks if you have the necessary packages
#if you have them it loads them, if you don't it installs and loads them
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

rm(list = ls())

#let's do the same thing at the county level
counties <- utils::read.csv(system.file("extdata", "county_fips.csv", package = "usmap"))

county_list <- haven::read_dta("data/county_map_label.dta")
colnames(county_list) <- c("fips","label")

county_map <- merge(counties, county_list, by = "fips", all=TRUE)

county_map$label[is.na(county_map$label)==TRUE] <- "Dropped"

#county_map <- county_map %>%
#  mutate(donor = Donor == "Donor")


counties <- plot_usmap(data = county_map, values = "label",  color = "black", labels=FALSE, exclude = c("AK")) +  
  scale_fill_manual(values = c(`Dropped` = "white", `10k` = "black", `8k` = "darkgray", `6k`="lightgray"), name = "") + 
  theme(legend.position = "right") + 
  theme(panel.background = element_rect(colour = "black"))
counties

states <- plot_usmap("states", exclude = c("AK"),
                     color = "red",
                     fill = alpha(0.01))
states

#now to map it
ggplot() +  
  geom_polygon(data=counties[[1]], 
               aes(x=x, 
                   y=y, 
                   group=group, 
                   fill = counties[[1]]$label), 
               color = "grey75",
               size = 0.1) +  
  geom_polygon(data=states[[1]], 
               aes(x=x, 
                   y=y, 
                   group=group), 
               color = "black", 
               fill = alpha(0.01)) + 
  coord_equal() +
  theme_map() +
  theme(legend.position="right") +
  scale_fill_manual(values = c(`10k` = "black", `8k` = "gray45", `6k`="gray82", `Dropped` = "white"), name = "") 

