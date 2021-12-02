
#Set up your Gbif credentials (you have to set these in R.environ first, see Help section in the dashboard)
gbif_user <- Sys.getenv("GBIF_USER")
gbif_pwd <- Sys.getenv("GBIF_PWD")
gbif_mail <- Sys.getenv("GBIF_EMAIL")


#Find taxon key corresponding to your organism of interest
find_taxon()

#Prepare occurence data dowload from Gbif
gbif_download_init(taxon_key)

#Check if download is ready
rgbif::occ_download_meta(res) # this step has to be repeated until STATUS = SUCCEEDED

#Retreive download key from the metadata called by the occ_download_meta() function
#dl_key <-""

#Once download is ready (occ_download_meta$ = SUCCEEDED), fetch and import data
gbif_download(dl_key)