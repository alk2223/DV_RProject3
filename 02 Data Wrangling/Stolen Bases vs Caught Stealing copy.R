require("jsonlite")
require("RCurl")
require("ggplot2")
require(tidyr)
require(dplyr)

batdf <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from Batting where yearID >= 2010"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cca628', PASS='orcl_cca628', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

tbl_df(batdf)

s <- batdf %>% select(SB,CS,LGID) %>% arrange(desc(SB)) %>% tbl_df

require(extrafont)
ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='Stolen Bases versus Caught Stealing') +
  labs(x="Stolen Bases", y=paste("Caught Stealing")) +
  layer(data=s, 
        mapping=aes(x=as.numeric(as.character(SB)), y=as.numeric(as.character(CS)), color=LGID), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )

