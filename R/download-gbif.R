
#' Import Gbif Occurence Data
#'
#' @return 
#' @export
#'

#Set up your Gbif credentials (you have to set these)
gbif_user <- Sys.getenv("GBIF_USER")
gbif_pwd <- Sys.getenv("GBIF_PWD")
gbif_mail <- Sys.getenv("GBIF_EMAIL")

#Prepare occurence data dowload from Gbif
gbif_download_init <- function () {
  
  res <- rgbif::occ_download(
    rgbif::pred('taxonKey', 7264332), 
    rgbif::pred('hasCoordinate', TRUE),
    user = gbif_user,
    pwd = gbif_pwd,
    email = gbif_mail
  )
  rgbif::occ_download_meta(res) # this step has to be repeated until STATUS = SUCCEEDED
}

#Retreive download key

#Once download is ready (occ_download_meta$ = SUCCEEDED), fetch and import data
gbif_download <- function() {
  
  dat <- occ_download_get("0000796-171109162308116")
  occ_download_import(dat)
}

#

          


