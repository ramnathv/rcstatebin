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
