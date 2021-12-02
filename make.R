source("R/taxo-network.R")

rmarkdown::render(input = here::here("dashboard","focus","Laminaria_japonica.Rmd"))

rmarkdown::render(here::here("dashboard","focus","template_focus.Rmd"), params = list(
  tax = "Chromista;Ochrophyta;Phaeophyceae;Laminariales;Laminariaceae;Laminaria;Laminaria_digitata",
  region = "Asia"
),output_file = here::here("dashboard","focus","Laminaria_digitata.html"))

rmarkdown::render(input = here::here("dashboard","GBIF_dashboard.Rmd"),
                  output_file = here::here("index.html"))

