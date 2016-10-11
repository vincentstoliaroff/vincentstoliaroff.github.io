#########################################################################
#Webscrapping of the Dax components/price/divisor etc...
#Data from Deutsche Börse
#http://www.dax-indices.com/EN/index.aspx?pageID=4
# Vincent Stoliaroff - 2016/10/11
#########################################################################

library(magrittr) # for the %>% operator

#############################################
# Date to be downloaded (inclusive days without tradings)
#############################################
refdate <- data.frame(datum = as.character(seq(as.Date("2010-10-01"),
                                  as.Date("2016-09-30"),
                                  by = "day"),
                                  format="%Y%m%d"),
                      stringsAsFactors = FALSE)%>%
  dplyr::mutate(
    url = paste0(
      "http://www.dax-indices.com/MediaLibraryCache/Document/WeightingFiles/",
      substr(as.character(datum), 5, 6),
      "/DAX_ICR.",
      as.character(datum),
      ".xls"))%>%
  dplyr::mutate(url=ifelse(as.numeric(datum)>=20160624, # another url as of 2016/06/24
                           paste0("http://www.dax-indices.com/MediaLibrary/Document/WeightingFiles/",
                                  substr(as.character(datum), 5, 6),
                                  "/DAX_ICR.",as.character(datum),".xls"),
                           url))

# 23 au 24 juin 2016 = passage au MediaLibrary depuis MediaLibraryCache


#############################################
# Loop to get the data + merge them in 1 data.frame
#############################################

mylist<-vector("list", length(refdate[,2]))
for (i in 1:length(refdate[,2])
     ){
  if (!httr::http_error(refdate[i,2])) {
  data  <- gdata::read.xls(xls=refdate[i,2],
                         sheet=2,
                         verbose=FALSE,
                         header=TRUE,
                         skip=2,
                         stringsAsFactor=FALSE,
                         na.strings="n/a")
colnames(data)<-gsub(".","",colnames(data),fixed=TRUE) 
data$datum<-refdate[i,1]
mylist[[i]]<-data 
  }
print(paste(i,Sys.time(),refdate[i,1]))
}
rm(data)
# get rid of the list element without data (no trading day)
mylist<-mylist[!sapply(mylist, is.null)] 

#############################################
# Serialize the data
#############################################
 
# getwd()
# setwd("./_R")
saveRDS(mylist,file="raw-dax-20101001-20160930.rds")

#############################################
# rbind data.frame component of the list with type check
#############################################

mydata<-dplyr::bind_rows(mylist)


# Check type consistency over time






toto<-mylist[1]
typeof(toto)

sapply(mylist[1:3],function(x) return(typeof[x]))

mydata<-dplyr::bind_rows(mylist[84:85])
sapply(mylist[84:85],colnames)
sapply(mylist[84:87],function(x) return(x[c("pi0lastregularrebalancing","datum")]))
str(mylist[84:85])
mylist[[85]]$pi0lastregularrebalancing
mylist[[85]]$datum

"n/a"

c(mylist[1:2])
