syst2 <- data.frame(Position = c(0,0,rep(c( 1,0), 3)),
                    Name = rep(c("SYS2", "SYS2","SYS4","SYS4"), each=2),
                    start = c("2018-10-01","2018-10-11","2018-11-26","2018-12-06","2018-10-01","2018-10-24","2018-11-23","2018-12-05"),
                    end = c("2018-10-16","2018-11-26","2018-12-06","2018-12-31","2018-10-24","2018-11-23","2018-12-05","2018-12-31"),
                    color = c('#FF0000','#FF0000',rep(c("#008000",'#FF0000'), 3)),
                    fontcolor = c('#FF0000','#FF0000',rep(c("#008000",'#FF0000'), 3)))


vistime(syst2, events = "Position", groups = "Name", optimize_y = T)

vistime(syst2, events = "Position", groups = "Name", optimize_y = F)  # nice Gantt chart
