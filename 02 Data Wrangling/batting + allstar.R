require("jsonlite")
require("RCurl")
require("dplyr")

bat <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from BATTING where yearID = 2010"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
View(bat)

allstar <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from ALLSTARFULL where yearID = 2010"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
View(allstar)

good <- dplyr::inner_join(bat, allstar, by="PLAYERID")
View(good)


require("jsonlite")
require("RCurl")

summary(good)
head(good)

require(extrafont)
ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  #facet_wrap(~LGID.y) +
  #facet_grid(.~SURVIVED, labeller=label_both) +
  #facet_grid(PCLASS~SURVIVED, labeller=label_both) +
  labs(title='Baseball') +
  labs(x="hits", y=paste("ab")) +
  layer(data=good, 
        mapping=aes(x=as.numeric(as.character(H)), y=as.numeric(as.character(AB)), color=LGID.y), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )
