source("R/taxo-network.R")

rmarkdown::render(input = here::here("dashboard","focus","Laminaria_japonica.Rmd"))

rmarkdown::render(input = here::here("dashboard","GBIF_dashboard.Rmd"),
                  output_file = here::here("index.html"))


