#' Preparation of the raw data for the project
#'
#' @return A data.table extra columns for taxonomy

data_for_net <- function(){
  require(data.table)
  ranks <- c("kingdom","phylum","class","order","family","genus","species")
  dat <- fread(here::here("data","occurrence.gz"))
  dat[,species:=sub(" ","_",species)]
  dat[,full_taxo:=paste(kingdom,phylum,class,order,family,genus,species,sep=";")]
  dat[,full_taxo:=sub(";+$","",full_taxo)]

  for(i in 2:length(ranks)){
    dat[get(ranks[i])!="",(ranks[i]):=paste(get(ranks[i-1]),get(ranks[i]),sep=";")]
    dat[get(ranks[i])=="",(ranks[i]):=""]
  }
  
  dat
}

#' Node and edge data for the taxonomic network
#'
#' @return List of data.tables

data_for_net_nodes_edges <- function(dat=data_for_net()){
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
  dat_nodes[,title := paste0("<p>rank: ",
                             rank,
                             '<br><a href="dashboard/focus/',
                             label,
                             '.html" target="_blank">More info</a></p>')]
  list(dat_nodes[],dat_edges)
}

#' Generate a interactive taxonomic network
#'
#' @return A interactive taxonomic network

taxo_network <- function(edge_and_node=data_for_net_nodes_edges()){
  visNetwork(edge_and_node[[1]], edge_and_node[[2]], width = "100%") |>
    visEdges(arrows = "to")
}


#' Generate a minimal table for the per taxo dashboards
#'
#' @return A minimal data.table with MEOW info
#' 
#' 
data_for_focus <- function(tax,dat){
  #tax <- "Chromista;Ochrophyta;Phaeophyceae;Laminariales;Laminariaceae;Laminaria;Laminaria_japonica"
  
  require(meowR)
  require(data.table)
  
  last_rank_taxo <- sub("^.+;","",tax)
  
  dat <- dat[grep(tax,full_taxo),.(eventDate,decimalLatitude,decimalLongitude)] |> 
    na.omit()
  
  if(nrow(dat)!=0){
    dat <- data.table(dat,label=last_rank_taxo)
    dat <- data.table(dat,getRegions(dat[,decimalLatitude], dat[,decimalLongitude]))
    
    cols <- c("ECOREGION","PROVINCE","REALM")
    for (j in cols) set(dat, j = j, value = gsub("\\s","_",dat[[j]]))
    
    dat
  }else{
    dat
  }
}



