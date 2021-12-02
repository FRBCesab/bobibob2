#' Generate a taxonomic network
#'
#' @return A taxonomic network

taxo_network <- function(){
  require(data.table)
  require(visNetwork, quietly = TRUE)
  
  dat <- fread(here::here("data","laminaria_occurrance.csv.gz"))
  dat[,species:=sub(" ","+",species)]
  #dat_nodes[,full_taxo:=paste(kingdom,phylum,class,order,family,genus,species,sep="|")]
  
  tmp <- c("kingdom","phylum","class","order","family","genus","species")
  
  for(i in 2:length(tmp)){
    dat[get(tmp[i])!="",(tmp[i]):=paste(get(tmp[i-1]),get(tmp[i]),sep=";")]
    dat[get(tmp[i])=="",(tmp[i]):=""]
  }
  
  dat_edges <- lapply(1:(length(tmp)-1),function(i){
    dat[,.SD,.SDcols=tmp[c(i,i+1)]] |> unique()
  }) |>
    rbindlist(use.names = FALSE) |>
    unique()
  
  setnames(dat_edges,c("from","to"))
  
  dat_edges <- dat_edges[!(from==""|to=="")]
  
  dat_nodes <- data.table(id=c(dat_edges[,to],dat_edges[,from]) |> unique())
  dat_nodes[,label:=sub("^.+;","",id)]
  
  visNetwork(dat_nodes, dat_edges, width = "100%") |>
    visEdges(arrows = "to")
  
}
