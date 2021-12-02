
#' Import Gbif Occurence Data
#'
#' @return 
#' @export
#'



#Prepare occurence data dowload from Gbif
gbif_download_init <- function () {
  
  res <- rgbif::occ_download(
    rgbif::pred('taxonKey', 7264332), 
    rgbif::pred('hasCoordinate', TRUE),
    user = gbif_user,
    pwd = gbif_pwd,
    email = gbif_mail
  )
}

#Import data
gbif_download <- function() {
  
  dat <- occ_download_get("0000796-171109162308116")
  occ_download_import(dat)
}

#

          


