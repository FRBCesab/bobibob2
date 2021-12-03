
#Set up your Gbif credentials (you have to set these in R.environ first, see Help section in the dashboard)
gbif_user <- Sys.getenv("GBIF_USER")
gbif_pwd <- Sys.getenv("GBIF_PWD")
gbif_mail <- Sys.getenv("GBIF_EMAIL")


#Find taxon key corresponding to your organism of interest
taxon_key <- find_taxon("laminariales", "order") #first argument : "taxon name", second argument "rank"


#Prepare occurence data dowload from Gbif
status<-gbif_download_init()


#Check if download is ready
check_status() # this step will run until STATUS = SUCCEEDED


#Retreive Download key 
dl_key <-"0071825-210914110416597" #enter the key manually from the metadata called by the occ_download_meta() function


#Once download is ready (occ_download_meta$ = SUCCEEDED), fetch and import data
gbif_download(dl_key)


#Unzip in data/occurrence folder and delete zip file from root (enter zip file name manually)
unzip(zipfile = "0071825-210914110416597.zip", exdir = "./data/occurrence")
unlink("0071825-210914110416597.zip")
#The file containing the occurrence data is "occurence.txt"


#Create occurrence df
occurrence <- data.table::fread("data/occurrence/occurrence.txt")

#Zip occurrence file to make it <100Mb (because of Github file size limitation) and move it up one level to /data
R.utils::gzip("data/occurrence/occurrence.txt", destname = "data/occurrence.gz", remove = FALSE)


