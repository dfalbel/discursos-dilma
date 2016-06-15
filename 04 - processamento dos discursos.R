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
    html_nodes("#parent-fieldname-text") %>%
    html_text()
  
  data_frame(
    id = str_replace_all(arq, fixed(".html"), "") %>% 
      str_replace_all(fixed("data-raw/discursos//"), "") %>%
      as.integer(),
    texto = paste(textos %>% str_trim())
  )
}

# Processamento dos textos ------------------------------------------------

dados_textos <- map_df(arqs, processar)


# Juntar bases ------------------------------------------------------------

dados <- read.csv("data/base_intermediaria.csv")
dados <- left_join(dados, dados_textos, by = "id")
write.csv(dados, "data/base_discursos.csv", row.names = F)
