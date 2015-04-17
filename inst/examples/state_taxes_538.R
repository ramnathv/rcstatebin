library(dplyr)
library(tidyr)
library(readxl)

taxdata = "http://www2.census.gov/govs/statetax/14staxcd.txt" %>%
  read.csv() %>%
  rename(category = X) %>%
  gather(state, share, -category) %>%
  group_by(state) %>%
  mutate(share = share/sum(share)*100)

codes = '~/Downloads/TaxItemCodesandDescriptions.xls' %>%
  read_excel() %>%
  rename(category = `Item Code`, description = `Description`)

data_ = inner_join(taxdata, codes)


statebin(data = data_, opts = list(
  x = "state",
  y = "share",
  group = "description",
  heading =  "<b>Where do your state's taxes come from?</b>",
  footer = "<small>Source: Census <a href='http://www2.census.gov/govs/statetax/14staxcd.txt'>(Data)</a>",
  colors = RColorBrewer::brewer.pal(5, 'PuRd'),
  control = 'dropdown'
))
