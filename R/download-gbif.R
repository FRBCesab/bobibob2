
#' Find the taxon key corresponding to the group of interest
#'
#' @param name The taxon name
#' @param rank The taxon rank
#' @return A tibble containing the taxon key, taxon name and taxon rank. The taxon key 
#' @example
#' taxon_key ("laminaria digitata", "species")
#'
find_taxon <- function (name, rank) {
  rgbif::name_suggest(q=name, rank=rank)
  #taxon_key<-
}

#' Prepare occurrence data download from Gbif
#'
#' @param taxon_key The Gbif key identifier of the taxon
#' @return Metadata about the download, including download status to check when the download is ready.
#' @example
#' gbif_download_init("5522479")
#'
gbif_download_init <- function (taxon_key) {
  
  res <- rgbif::occ_download(
    rgbif::pred('taxonKey', taxon_key), 
    rgbif::pred('hasCoordinate', TRUE),
    user = gbif_user,
    pwd = gbif_pwd,
    email = gbif_mail
  )
}

#' Download occurrence data from gbif
#' @param dl_key The single identifier of the download prepared with the function gbif_download_init (The Download key printed by the function rgbif::occ_download_meta(res))
#' @return a zip file containing the occurrence data imported from Gbif
#' @example
#' gbif_download("0071069-210914110416597")
#'
gbif_download <- function(dl_key) {
  
  dat <- rgbif::occ_download_get(dl_key)
  rgbif::occ_download_import(dat)
}


          


