# Pacotes -----------------------------------------------------------------
library(xml2)
library(rvest)
library(stringr)
library(purrr)


# Leitura dos arquivos ----------------------------------------------------

arqs <- list.files("data-raw/discursos/", full.names = T)

# Funções Auxiliares ------------------------------------------------------

processar <- function(arq){
  textos <- arq %>%
    read_html() %>%
    html_node("#content") %>%
    html_node("#parent-fieldname-text") %>%
    html_text()
  data_frame(
    id = str_replace_all(arq, fixed(".html"), "") %>% 
      str_replace_all(fixed("data-raw/discursos//"), "") %>%
      as.integer(),
    texto = textos %>% str_trim()
  )
}

# Processamento dos textos ------------------------------------------------

dados_textos <- map_df(arqs, processar)

