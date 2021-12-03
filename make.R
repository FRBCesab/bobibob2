source("R/taxo-network.R")

if(!file.exists(here::here("images","kelp_intro.jpg"))){
  download.file("https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Seaweed_in_Ensenada_Baja_California.jpg/640px-Seaweed_in_Ensenada_Baja_California.jpg",
                destfile = here::here("images","kelp_intro.jpg"))
}

# rmarkdown::render(input = here::here("dashboard","focus","Laminaria_japonica.Rmd"))

node_list <- data_for_net_nodes_edges()[[1]][label!="Laminaria_japonica",id]

for(i in node_list){
  label <- sub("^.+;","",i)
  rmarkdown::render(here::here("dashboard","focus","template_focus.Rmd"), params = list(
    tax = i),output_file = here::here("dashboard","focus",paste0(label,".html")))
}

rmarkdown::render(input = here::here("dashboard","GBIF_dashboard.Rmd"),
                  output_file = here::here("index.html"))

