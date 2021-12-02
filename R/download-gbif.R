
#' Import Gbif Occurence Data
#'
#' @return 
#' @export
#'



#Prepare occurence data dowload from Gbif
gbif_download_init <- function (taxon_key) {
  
  res <- rgbif::occ_download(
    rgbif::pred('taxonKey', taxon_key), 
    rgbif::pred('hasCoordinate', TRUE),
    user = gbif_user,
    pwd = gbif_pwd,
    email = gbif_mail
  )
}

#Import data
gbif_download <- function(dl_key) {
  
  dat <- occ_download_get(dl_key)
  occ_download_import(dat)
}

#

          


