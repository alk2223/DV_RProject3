require("jsonlite")
require("RCurl")
require("dplyr")

bat <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from BATTING"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
View(bat)

allstar <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from ALLSTARFULL"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
View(allstar)

good <- dplyr::inner_join(bat, allstar, by="PLAYERID")
View(good)


require("jsonlite")
require("RCurl")

summary(good)
head(good)
require(ggplot2)
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
