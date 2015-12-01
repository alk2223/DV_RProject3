require("jsonlite")
require("RCurl")
require("dplyr")

salary <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from SALARIES where yearID = 2010 and SALARY > 5000000"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
  



allstar <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from ALLSTARFULL where yearID = 2010"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
  


salgood <- dplyr::left_join(salary, allstar, by="PLAYERID")
View(salgood)


require("jsonlite")
require("RCurl")

summary(salgood)
head(salgood)

require(ggplot2)
require(extrafont)
ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_grid(PCLASS~SURVIVED, labeller=label_both) +
  labs(title='Baseball') +
  labs(x="Allstar", y=paste("Salary")) +
  layer(data=salgood, 
        mapping=aes(x=LGID.x, y=as.numeric(as.character(SALARY)), color=as.character(STARTINGPOS)), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )