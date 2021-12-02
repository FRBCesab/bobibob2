#' Generate data for taxonomic network
#'
#' @return A formatted table

data_for_net <- function(){
  require(data.table)
  ranks <- c("kingdom","phylum","class","order","family","genus","species")
  dat <- fread(here::here("data","laminaria_occurrance.csv.gz"))
  dat[,species:=sub(" ","_",species)]
  dat[,full_taxo:=paste(kingdom,phylum,class,order,family,genus,species,sep=";")]
  dat[,full_taxo:=sub(";+$","",full_taxo)]

  for(i in 2:length(ranks)){
    dat[get(ranks[i])!="",(ranks[i]):=paste(get(ranks[i-1]),get(ranks[i]),sep=";")]
    dat[get(ranks[i])=="",(ranks[i]):=""]
  }
  
  dat
}

#' Generate a taxonomic network
#'
#' @return A taxonomic network

taxo_network <- function(dat=data_for_net()){
  #dat=data_for_net()
  require(data.table)
  require(visNetwork, quietly = TRUE)
  
  ranks <- c("kingdom","phylum","class","order","family","genus","species")
  
  rank_taxo <- lapply(ranks,function(X){
    data.table(rank=X,id=dat[get(X)!="",get(X)])
  }) |> rbindlist() |> unique()
  
  dat_edges <- lapply(1:(length(ranks)-1),function(i){
    dat[,.SD,.SDcols=ranks[c(i,i+1)]] |> unique()
  }) |>
    rbindlist(use.names = FALSE) |>
    unique()
  
  setnames(dat_edges,c("from","to"))
  
  dat_edges <- dat_edges[!(from==""|to=="")]
  
  dat_nodes <- data.table(id=c(dat_edges[,to],dat_edges[,from]) |> unique())
  dat_nodes[,label:=sub("^.+;","",id)]
  dat_nodes <- merge(dat_nodes,rank_taxo,by="id")
  dat_nodes[,title := paste0("<p>rank: ", rank,'<br><a href="dashboard/focus/',label,'.html">More info</a></p>')]
  
  visNetwork(dat_nodes, dat_edges, width = "100%") |>
    visEdges(arrows = "to")
}

  
#' Generate subseted table for focus
#'
#' @return A subseted table
#' 
#' 
data_for_focus <- function(tax){
  #tax <- "Chromista;Ochrophyta;Phaeophyceae;Laminariales;Laminariaceae;Laminaria;Laminaria_japonica"
  
  require(meowR)
  require(data.table)
  
  last_rank_taxo <- sub("^.+;","",tax)
  
  dat <- data_for_net()
  dat <- dat[grep(tax,full_taxo),.(eventDate,decimalLatitude,decimalLongitude)] |> 
    na.omit() |>
    data.table(label=last_rank_taxo)
  
  data.table(dat,getRegions(dat[,decimalLatitude], dat[,decimalLongitude]))
}



