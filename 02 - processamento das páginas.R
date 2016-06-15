# Pacotes -----------------------------------------------------------------
library(xml2)
library(rvest)
library(stringr)
library(lubridate)
library(purrr)
library(dplyr)

# Leitura dos arquivos ----------------------------------------------------
arqs <- list.files("data-raw/paginas/", full.names = T)
arqs <- lapply(arqs, read_html)

# Funções Auxiliares ------------------------------------------------------

processar <- function(a){
  as <- a %>%
    html_nodes(".tile-document")
  # data e hora
  aux <- as %>%
    html_nodes(".summary-view-icon") %>% html_text()
  datas <- aux[c(T,F,F)] %>% str_trim()
  horas <- aux[c(F,T,F)] %>% str_trim()
  data_horas <- paste(datas, horas) %>% dmy_hm()
  
  # titulo, trecho e link
  aux <- as %>%
    html_nodes(".tileContent")
  titulos <- aux %>% html_nodes(".url") %>% html_text()
  links <- aux %>% html_nodes(".url") %>% html_attr("href")
  trechos <- aux %>% map(~html_nodes(.x, ".description") %>% html_text()) %>%
    map_if(~length(.x) == 0, ~NA) %>% unlist()
  
  #
  stopifnot(list(datas, horas, titulos, links, trechos) %>%
              map_int(length) %>% unique() %>%
              length() == 1 
            )
  
  # retornar data.frame
  data_frame(
   data_hora = data_horas,
   titulo = titulos,
   trecho = trechos,
   link = links
  )
}

# Processamento -----------------------------------------------------------

dados <- map_df(arqs, processar)
dados$id <- 1:nrow(dados)
dados <- dados %>% select(id, data_hora, titulo, trecho, link)
write.csv(dados, "data/base_intermediaria.csv", row.names = F)
