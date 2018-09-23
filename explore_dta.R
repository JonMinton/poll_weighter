require(jsonlite)
require(plotly)
require(tidyverse)

dta_jsn <- fromJSON(
  "https://pollofpolls.eu/get/polls/GB-parliament/format/json"
) 

dta_jsn %>% 
  select(date, firm, n, sd, source) %>% 
  bind_cols(
    dta_jsn %>% pull(parties)
  ) %>% 
  as_tibble() %>% 
  gather(con:snp, key = "party", value = "pct") %>% 
  separate(firm, into = c("provider", "payer"), sep = "/")


