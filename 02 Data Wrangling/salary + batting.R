require("jsonlite")
require("RCurl")
require("dplyr")

fielding <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from FIELDING where yearID = 2010 and G > 57"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

  


batting <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from BATTING where yearID = 2010 and G > 57"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


catch <- fielding %>% select(PLAYERID, POS, PB, SB, CS) %>% filter(POS == "C")


salbat <- dplyr::inner_join(catch, batting, by="PLAYERID") 



require("jsonlite")
require("RCurl")

summary(dfb)
head(dfb)

require(ggplot2)
require(extrafont)
ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  #facet_grid(PCLASS~SURVIVED, labeller=label_both) +
  labs(title='Baseball') +
  labs(x="Opponents Caught Stealing", y=paste("HR")) +
  layer(data=salbat, 
        mapping=aes(x=as.numeric(as.character(CS.x)), y=as.numeric(as.character(HR)), color=as.character(PLAYERID)), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )