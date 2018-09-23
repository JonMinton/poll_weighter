require(plotly)
require(tidyverse)
require(jsonlite)
require(mgcv)

dta_flat <- fromJSON(
  "https://pollofpolls.eu/get/polls/GB-parliament/format/json"
) %>% 
  select(date, firm, n, sd, source)  %>%
  bind_cols(
    dta_jsn %>% pull(parties)
  )  %>%
  as_tibble() %>%
  gather(con:snp, key = "party", value = "pct") %>%
  separate(firm, into = c("provider", "payer"), sep = "/") %>% 
  mutate(date = as.Date.character(date)) %>% 
  mutate(col_type = factor(party, labels = c("blue", "green", "red", "orange", "yellow", "purple")))


