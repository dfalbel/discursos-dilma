# Pacotes -----------------------------------------------------------------
library(httr)
library(stringr)

# Leitura da base com links -----------------------------------------------
dados <- read.csv("data/base_intermediaria.csv", stringsAsFactors = F)

# Download dos discursos --------------------------------------------------

for (id in dados$id) {
  link <- dados$link[dados$id == id]
  GET(
    link,
    write_disk(sprintf("data-raw/discursos/%s.html", 
                       id))
  )
  Sys.sleep(0.7)
}
