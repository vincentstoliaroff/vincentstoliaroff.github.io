#########################################################################
#Webscrapping of the Dax components/price/divisor etc...
#Data from Deutsche Börse
#http://www.dax-indices.com/EN/index.aspx?pageID=4
# Vincent Stoliaroff - 2016/10/11
#########################################################################

library(magrittr) # for the %>% operator
library(ggplot2)
library(dplyr)
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
saveRDS(mylist,file="./_R/prying-the-dax/raw-dax-20101001-20160930.rds")

#############################################
# rbind data.frame component of the list 
# a bit of type cleaning and renaming
#############################################

mydata<-dplyr::bind_rows(mylist)
# get rid of useless columns
mydata<-mydata[,-grep("X[0-9]+", colnames(mydata))]
mydata["X"]<-list(NULL)

saveRDS(mydata,file="./_R/prying-the-dax/dax-history.rds")
# mydata<-readRDS(file="./_R/prying-the-dax/dax-history.rds")

# pi0  = price at base date (30.12.87) or at IPO-date - pi0lastregularrebalancing
# pit  = actual price (Xetra) - pit
# qi0  = no. of shares at base date (30.12.87) or at IPO-date - qi0lastregularrebalancing
# qit  = no. of shares (last review date) - qitlastregularrebalancing
# ffit  = actual free float factor - ffitlastregularrebalancing
# ci  = correction factor - cilastregularrebalancing
# Kt  = chaining factor - KtlastregularrebalancingIndex


mydatalight<-mydata%>%
  dplyr::transmute(date=as.Date(datum,format="%Y%m%d"),
                   datum,
                   IndexTradingSymbol,
                   IndexISIN,
                   IndexClose=as.numeric(gsub(",","",IndexValueclose,fixed=TRUE)),
                   TradingSymbol,
                   Instrument,
                   ISIN,
                   pit,
                   pi0=pi0lastregularrebalancing,
                   qi0=as.numeric(gsub(",","",qi0lastregularrebalancing,fixed=TRUE)),
                   qit=as.numeric(gsub(",","",qitlastregularrebalancing,fixed=TRUE)),
                   ffit=ffitlastregularrebalancing,
                   ci=cilastregularrebalancing,
                   Kt=KtlastregularrebalancingIndex,
                   A=as.numeric(gsub(",","",ConstantAlastregularrebalancingIndex,fixed=TRUE)),
                   Fit=Filastregularrebalancing)

saveRDS(mydatalight,file="./_R/prying-the-dax/dax-history-retreated.rds")
# mydatalight<-readRDS(file="./_R/prying-the-dax/dax-history-retreated.rds")




#############################################
# Check Consistency of primary Keys (TradingSymbol,ISIN,Instrument)
# Create new Isin and Name with 
#############################################

ptf20160930<-cbind(unique(mydatalight[mydatalight$datum=="20160930",c("TradingSymbol"),drop=FALSE]),
                   Exist20160930=1)
keyhistory<-group_by(mydatalight,TradingSymbol,ISIN,Instrument)%>%
  summarize(count=n(),
            maxdate=max(date),
            mindate=min(date))%>%
  merge(.,
        ptf20160930,
        all=TRUE)%>%
  arrange(Instrument)

write.csv2(keyhistory,file="./_R/prying-the-dax/keyhistory.csv",sep=";")
keyhistory.bearb<-read.csv2("./_R/prying-the-dax/keyhistory-bearbeitet.csv",sep=",")
colnames(keyhistory.bearb)

mydatalight.consistent<-dplyr::select(keyhistory.bearb,ISIN,TradingSymbolMap,ISINmap,InstrumentMap)%>%
  merge(mydatalight,.,
        all.x=TRUE,all.y=TRUE)

#############################################
# Check Number of constituent per snapshot date and In/out
#############################################

check.anz<-group_by(mydatalight,date)%>%summarize(count=n())
View(filter(check.anz,count<60)) # OK every snapshot has 30*2 components

View(
group_by(mydatalight.consistent,TradingSymbolMap,ISINmap,InstrumentMap)%>%
  summarize(count=n(),
            maxdate=max(date),
            mindate=min(date))%>%
  filter(count<3048&count>2)%>%
  arrange(mindate)
)


#############################################
# Check Price (stock split...)
#############################################

checkprice<-mydatalight.consistent%>%
  group_by(IndexTradingSymbol,TradingSymbolMap,ISINmap,InstrumentMap)%>%
  arrange(IndexTradingSymbol,TradingSymbolMap,ISINmap,InstrumentMap,date)%>%
  transmute(date,
            datum,
            pit,
            pit.lag=lag(pit),
            rt=pit/pit.lag-1)%>%
  arrange(IndexTradingSymbol,TradingSymbolMap,ISINmap,InstrumentMap,date)


View(filter(checkprice,abs(rt)>1))
# Commerzbank
View(filter(checkprice,ISINmap=="DE000CBK1001"))



#http://dax-indices.com/EN/MediaLibrary/Document/Leitfaden_Aktienindizes.pdf
# Page 38
# Index = Kt * (Sum(pit * ffit * qit * ci) / Sum(pi0 * qi0)) * Base
# Index = (Sum(pit * Fit) / A) * Base

#############################################
# recompute the index with lagged weighing factors 
# Check for 1 date (last rebalancing date: 20160916)
#############################################

t1<-dplyr::filter(mydatalight,datum=="20160916")
t2<-dplyr::filter(mydatalight,datum=="20160919")%>%
  dplyr::select(IndexTradingSymbol,
                TradingSymbol,
                A,
                Kt,
                ffit,
                qit,
                ci,
                pi0,
                qi0,
                Fit)

tcross<-t1%>%dplyr::left_join(t2,by=c("IndexTradingSymbol","TradingSymbol"))
View(tcross)

# It works!!!
check<-tcross%>%
  dplyr::group_by(date,datum,IndexTradingSymbol)%>%
  dplyr::summarize(IndexClose=mean(IndexClose),IndexClose2=min(IndexClose),
                   A=mean(A.y,na.rm=TRUE),
                   Kt=mean(Kt.y,na.rm=TRUE),
                   CheckA1=mean(Kt.y,na.rm=TRUE)*(sum(pit*ffit.y*qit.y*ci.y,na.rm=TRUE)/sum(pi0.y*qi0.y,na.rm=TRUE)),
                   CheckA2=min(Kt.y,na.rm=TRUE)*(sum(pit*ffit.y*qit.y*ci.y,na.rm=TRUE)/sum(pi0.y*qi0.y,na.rm=TRUE)),
                   CheckB1=sum(pit*Fit.y)/mean(A.y,na.rm=TRUE),
                   CheckB2=sum(pit*Fit.y)/min(A.y,na.rm=TRUE))%>%
  dplyr::ungroup()%>%
  dplyr::mutate(BaseA=IndexClose/CheckA1,
                BaseB=IndexClose/CheckB1)

View(check)

#############################################
# recompute the index with lagged weighing factors 
# for everydate. 
# On the date the factors are changing, it means the rebalancing was done 1 day earlier
#############################################

toto<-dplyr::arrange(mydatalight,
               IndexTradingSymbol,
               TradingSymbol,
               datum,
               date)%>%
  by(data=.$Fit,INDICES=list(.$TradingSymbol),FUN=rle)


calendarunique<-dplyr::select(mydatalight,date,datum)%>%
  unique()%>%
  dplyr::arrange(date,datum)%>%
  dplyr::mutate(n=row_number(),
                nplus1=n+1)
calendarnext<-merge(dplyr::select(calendarunique,-n),
                dplyr::select(calendarunique,-nplus1),
                by.x="nplus1",by.y="n",
                all.x=TRUE,all.y=FALSE)%>%
  dplyr::transmute(date=date.x,
                   datum=datum.x,
                   datenext=date.y,
                   datumnext=datum.y)
rm(calendarunique)


factorchange<-mydatalight%>%
  dplyr::select(datum,
              date,
              IndexTradingSymbol,
              TradingSymbol,
              A,
              # Kt,
              # ffit,
              # qit,
              # ci,
              # pi0,
              # qi0,
              Fit)%>%
  dplyr::group_by(IndexTradingSymbol,TradingSymbol)%>%
  dplyr::arrange(IndexTradingSymbol,TradingSymbol,datum,date)%>%
  dplyr::mutate(leadFit=dplyr::lead(Fit),
              leadA=dplyr::lead(A),
              # leadIndexTradingSymbol=dplyr::lead(IndexTradingSymbol),
              # leadTradingSymbol=dplyr::lead(TradingSymbol),
              Change=ifelse((lead&leadFit==Fit&leadA==A),0,1)
              )
  dplyr::group_by(IndexTradingSymbol,
                  TradingSymbol,
                  A,
                  Kt,
                  ffit,
                  qit,
                  ci,
                  pi0,
                  qi0,
                  Fit)%>%
  dplyr::mutate(rank=dplyr::dense_rank(c("Fit","A"),
                                       order_by(IndexTradingSymbol,
                                                TradingSymbol,
                                                date,
                                                datum)))%>%
  dplyr::ungroup()%>%
  dplyr::arrange(IndexTradingSymbol,datum,date,TradingSymbol)

calendar<-dplyr::select(mydatalight,date,datum)%>%unique()%>%dplyr::arrange(date,datum)%>%dplyr::mutate(n=row_number())
  


#############################################
# Check Stability of weighing factor for 1 stock or more
#############################################
bmwkdax<-dplyr::filter(mydatalight,TradingSymbol=="BMW"&IndexTradingSymbol=="DAXK")
otherkdax<-dplyr::filter(mydatalight,TradingSymbol%in%c("CBK","BMW","DB1")&IndexTradingSymbol=="DAXK")
View(bmwkdax)
View(dplyr::arrange(bmwkdax,desc(date)))
ggplot(data=bmwkdax,aes(x=date,y=A))+geom_line()
ggplot(data=otherkdax,aes(x=date,y=A,group=TradingSymbol,color=TradingSymbol))+geom_line()
ggplot(data=mydatalight,aes(x=date,y=A,group=TradingSymbol,color=TradingSymbol))+geom_line()
ggplot(data=mydatalight,aes(x=date,y=Fit,group=TradingSymbol,color=TradingSymbol))+geom_line()
ggplot(data=dplyr::filter(bmwkdax,datum>="20160901"),aes(x=date,y=Fit))+geom_line()
ggplot(data=dplyr::filter(bmwkdax,datum>="20160901"),aes(x=date,y=A))+geom_line()

#############################################
# recompute the index with actual weighing factors. (WRONG METHODOLOGIE!!!)
#############################################

check<-mydatalight%>%
  dplyr::group_by(date,datum,IndexTradingSymbol)%>%
  dplyr::summarize(IndexClose=mean(IndexClose),IndexClose2=min(IndexClose),
                   A=mean(A,na.rm=TRUE),
                   Kt=mean(Kt,na.rm=TRUE),
                   CheckA1=mean(Kt,na.rm=TRUE)*(sum(pit*ffit*qit*ci,na.rm=TRUE)/sum(pi0*qi0,na.rm=TRUE)),
                   CheckA2=min(Kt,na.rm=TRUE)*(sum(pit*ffit*qit*ci,na.rm=TRUE)/sum(pi0*qi0,na.rm=TRUE)),
                   CheckB1=sum(pit*Fit)/mean(A,na.rm=TRUE),
                   CheckB2=sum(pit*Fit)/min(A,na.rm=TRUE))%>%
  dplyr::ungroup()%>%
  dplyr::mutate(BaseA=IndexClose/CheckA1,
                BaseB=IndexClose/CheckB1)
  
check2<-mydatalight%>%
  dplyr::group_by(date,datum,IndexTradingSymbol)%>%
  dplyr::mutate(piqiffici=pit*ffit*qit*ci,
                pi0qi0=pi0*qi0)%>%
  dplyr::summarize(IndexClose=mean(IndexClose,na.rm=TRUE),
                   A=mean(A,na.rm=TRUE),
                   Kt=mean(Kt,na.rm=TRUE),
                   piqiffici=sum(piqiffici,na.rm=TRUE),
                   pi0qi0=sum(pi0qi0,na.rm=TRUE))%>%
  dplyr::ungroup()%>%
  dplyr::mutate(check=1000*Kt*piqiffici/pi0qi0,
                Diff=IndexClose-check)%>%
  dplyr::ungroup()
  
View(dplyr::filter(check2,abs(Diff)<0.01))
  

#############################################
# Working dataset: fewer columns + other colnames
#############################################

wdata<-mydata%>%dplyr::transmute(date=as.Date(datum,format="%Y%m%d"),
                          datum,
                          IndexISIN,
                          IndexTradingSymbol,
                          Price=as.numeric(gsub(",","",IndexValueclose,fixed=TRUE)))%>%unique


#############################################
# Working dataset: fewer columns + other colnames
#############################################


library(ggplot2)
ggplot(data=wdata,aes(x=date,y=Price,group=IndexTradingSymbol))+geom_line()
ggplot(data=check2,aes(x=date,y=Diff,group=IndexTradingSymbol,color=IndexTradingSymbol))+geom_line()

#############################################
# junk
#############################################




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
