require("jsonlite")
require("RCurl")
require(tidyr)
require(dplyr)
require(ggplot2)
batdf <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from Batting where yearID >= 2010"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cca628', PASS='orcl_cca628', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

tbl_df(batdf)

d <- batdf %>% select(IBB,HR,TEAMID) %>% filter(batdf$TEAMID == "HOU" | batdf$TEAMID == "TEX") %>% tbl_df

require(extrafont)
ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='Home Runs vs Intentional Walks for Texas Teams') +
  labs(x="Home Runs", y=paste("Intentional walks")) +
  layer(data=d, 
        mapping=aes(x=as.numeric(as.character(HR)), y=as.numeric(as.character(IBB)), color=TEAMID), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )
