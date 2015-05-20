library(forecast)
train = read.csv("trainNew.csv")
#http://stackoverflow.com/questions/28538822/forecasting-timeseries-with-tslm-in-r
#http://cran.r-project.org/web/packages/forecast/forecast.pdf
#http://stackoverflow.com/questions/10302261/forecasting-time-series-data
#http://robjhyndman.com/hyndsight/tscharacteristics/
#running.tslm <- function(units){


start = 1
end = nrow(train[(train$store_nbr == train$store_nbr[start])&(train$item_nbr ==train$item_nbr[start]),])
temp = (train$store_nbr == train$store_nbr[start])&(train$item_nbr ==train$item_nbr[start]),]
while (end != start-1){
  
  x = which(is.na(train$units[start:end])) +start -1
  while(length(x) != 0) {
    t = 1
    
    while (x[t+1] == x[t] +1) {
      t = t+1
      if (t == length(x)){
        break
      }
    }
    units = train$units[start:(x[1]-1)]
    y = ts(units, frequency = 7)
    fit = tslm(y ~ trend +season+ I(trend^2))
    fcast = forecast.lm(fit, h = t)
    train$units[x[1]:x[t]] = round(fcast$mean[1:t])
    
    x = which(is.na(train[(train$store_nbr == train$store_nbr[start])&(train$item_nbr ==train$item_nbr[start]),]$units)) + start -1
  }
  start = end +1
  end = end + nrow(train[(train$store_nbr == train$store_nbr[start])&(train$item_nbr ==train$item_nbr[start]),])
  print(start)
}
#http://stackoverflow.com/questions/16657346/non-nested-double-seasonality-using-dshw-in-r
#units[units == 0] =1
#units<-msts(units, seasonal.periods=c(7,364), ts.frequency=7,start = 2012+1/52)
#fit1 = dshw(units,7,364)
#fit2 = tbats(units)
#fcast = forecast.lm(fit2, h = 7)
#arfima
#http://en.wikipedia.org/wiki/Autoregressive_fractionally_integrated_moving_average

#ets
#http://stackoverflow.com/questions/10302261/forecasting-time-series-data
#}
#dfSS = train$units[train$dataType  == 0]
id = mapply(function(x,y,z) {paste(x,y,z,sep = "_")},train$store_nbr[train$dataType  == 0],train$item_nbr[train$dataType  == 0],as.Date(train$date[train$dataType  == 0],"%Y-%m-%d"))
dfSS = as.data.frame(cbind(id,train$units[train$dataType  == 0]))
colnames(dfSS) = c('id','units')
#dfSS$units = as.numeric((dfSS$units))
#dfSS$units[dfSS$units <= 0] = 0
#write.csv(dfSS,"dfSS.csv")
sampleSub = read.csv("sampleSubmission.csv")
#require(sqldf)
#dfSSt = sqldf("SELECT sampleSub.id, dfSS.units 
#              FROM dfSS
#              LEFT JOIN sampleSub
#              on sampleSub.id = dfSS.id")
require(plyr)
dfSSt = join(sampleSub, dfSS, by = "id")
dfSSt[,2] = NULL
dfSSt[is.na(dfSSt[,2]),2] = "0"
write.csv(dfSSt,"sampleSubmissiontslmC.csv")