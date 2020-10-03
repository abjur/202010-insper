library(tidyverse)
library(sf)

da_cpopg <- read_rds("dados/da_cpopg_30.rds")

# Essa parte será live coding :)

da_comarcas <- da_cpopg %>%
  transmute(
    id_processo,
    comarca = str_extract(distribuicao, "(?<=Foro de ).*"),
    comarca = str_to_upper(abjutils::rm_accent(comarca))
  ) %>%
  count(comarca)

mapa <- abjMaps::d_sf$sf[[2]]

mapa %>%
  inner_join(da_comarcas, "comarca") %>%
  ggplot() +
  geom_sf(data = mapa, size = 0.1,
          fill = "white") +
  geom_sf(aes(fill = n), size = .2,
          colour = "black") +
  theme_void()
