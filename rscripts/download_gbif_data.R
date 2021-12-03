
#Set up your Gbif credentials (you have to set these in R.environ first, see Help section in the dashboard)
gbif_user <- Sys.getenv("GBIF_USER")
gbif_pwd <- Sys.getenv("GBIF_PWD")
gbif_mail <- Sys.getenv("GBIF_EMAIL")


#Find taxon key corresponding to your organism of interest
taxon_key <- find_taxon("laminariales", "order") #first argument : "taxon name", second argument "rank"


#Prepare occurrence data download from Gbif
status<-gbif_download_init()


#Check if download is ready
check_status() # this step will run until STATUS = SUCCEEDED


#Retrieve Download key
dl_key <-"0071825-210914110416597" #enter the key manually from the metadata displayed after check_status() has finished running


#Fetch and import data
gbif_download(dl_key)


#Unzip in data/occurrence folder and delete zip file from root 
unzip(zipfile = "0071825-210914110416597.zip", exdir = "./data/occurrence") #enter zip file name manually
unlink("0071825-210914110416597.zip")
#The file containing the occurrence data is "occurrence.txt"


#Zip occurrence file to make it <100Mb (because of Github file size limitation) and move it back up one level to /data
R.utils::gzip("data/occurrence/occurrence.txt", destname = "data/occurrence.gz", remove = FALSE)
