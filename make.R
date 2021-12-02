rmarkdown::render(input = here::here("dashboard","GBIF_dashboard.Rmd"),
                  output_file = here::here("index.html"))