
#' Find the taxon key corresponding to the group of interest
#'
#' @param name The taxon name
#' @param rank The taxon rank
#' @return A taxon_key object containing the single identifier of the taxon in Gbif 
#' @examples
#' \dontrun{
#' find_taxon ("laminaria digitata", "species")
#' }
#'
find_taxon <- function (name, rank) {
  rgbif::name_suggest(q=name, rank=rank)$data$key[1]
}


#' Prepare occurrence data download from Gbif
#'
#' @return Metadata about the download, including download status to check when the download is ready.
#' @examples
#' \dontrun{
#' gbif_download_init()
#' }
#'
gbif_download_init <- function () {
    res <- rgbif::occ_download(
    rgbif::pred('taxonKey', taxon_key), 
    rgbif::pred('hasCoordinate', TRUE),
    user = gbif_user,
    pwd = gbif_pwd,
    email = gbif_mail
  )
    return(res)
}


#' Check status of download preparation
#' 
#' @return Messages indicating the status of the download prep (preparing, running, succedded), then metadata about the download request once the preparation has succeeded.
#' @examples
#' \dontrun{
#' check_status()
#' }
check_status <- function(){
  rgbif::occ_download_wait(status)
  rgbif::occ_download_meta(status)
}


#' Download occurrence data from gbif
#' @param dl_key The single identifier of the download prepared with the function gbif_download_init (The Download key printed by the function rgbif::occ_download_meta(res))
#' @return a zip file containing the occurrence data imported from Gbif
#' @examples
#' \dontrun{
#' gbif_download("0071104-210914110416597")
#' }
#'
gbif_download <- function(dl_key) {
    dat <- rgbif::occ_download_get(dl_key)
  rgbif::occ_download_import(dat, fill = TRUE) # If fill = TRUE then in case the rows have unequal length, blank fields are implicitly filled. (passed on to fill parameter in data.table::fread)
}


