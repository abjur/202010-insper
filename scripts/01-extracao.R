# importacao --------------------------------------------------------------

library(tidyverse)

da_id <- "dados/processos.csv" %>%
  read_csv(col_types = cols(id = col_character()))

# trabalhando com os números CNJ ------------------------------------------

abjutils::build_id(da_id$id[1])

abjutils::build_id(da_id$id[1]) %>%
  abjutils::clean_cnj()

abjutils::check_dig(da_id$id[1])

abjutils::extract_parts(da_id$id[1], c("N", "J"))

da_id %>%
  head() %>%
  mutate(id = abjutils::build_id(id)) %>%
  abjutils::separate_cnj(id)


# baixando numeros de processo --------------------------------------------

## Pacote {lex} é privado :(
arquivos <- lex::tjsp_cpopg_download(
  head(da_id$id, 30),
  dir = "dados/html",
  login = Sys.getenv("ESAJ_LOGIN"),
  senha = Sys.getenv("ESAJ_SENHA")
)

da_cpopg <- lex::tjsp_cpopg_parse(arquivos)

# trabalhando com as colunas ----------------------------------------------

da_cpopg %>%
  select(id_processo, movimentacoes) %>%
  unnest(movimentacoes)


# export ------------------------------------------------------------------

write_rds(da_cpopg, "dados/da_cpopg_30.rds", compress = "xz")
