# Pacotes -----------------------------------------------------------------
library(httr)

# Definição dos parâmetros ------------------------------------------------
url <- "http://www2.planalto.gov.br/acompanhe-o-planalto/discursos/discursos-da-presidenta/"
paginas <- 1:10


# Funções Auxiliares ------------------------------------------------------
pag_to_query <- function(p){
  as.character((p - 1)*100)
}

# Download ----------------------------------------------------------------

for (p in paginas) {
  GET(
    url,
    query = list("b_start:int" = pag_to_query(p)),
    write_disk(sprintf("data-raw/paginas/b_start_int_%s.html", 
               pag_to_query(p)))
  )
  Sys.sleep(1)
}







