# 1. data
origData <- data.frame(Position=c(rep("President", 3), rep("Vice", 3)),
                       Name = c("Washington", "Adams", "Jefferson", "Adams", "Jefferson", "Burr"),
                       start = rep(c("1789-03-29", "1797-02-03", "1801-02-03"), 2),
                       col.end = rep(c("1797-02-03", "1801-02-03", "1809-02-03"), 2),
                       color = c('#cbb69d', '#603913', '#c69c6e'),
                       fontcolor = rep(c("black", "white", "black"), 2))

#2. standard parameters
col.event="event"
col.start="start"
col.end="end"
col.group="group"
col.color="color"
col.fontcolor="fontcolor"
col.tooltip="tooltip"
title=NULL

# 3. function call
vistime(origData, col.event="Position", col.group ="Name", title="Presidents of the USA")
gg_vistime(origData, col.event="Position", col.group ="Name", title="Presidents of the USA")
hc_vistime(origData, col.event="Position", col.group ="Name", title="Presidents of the USA")
col.event="Position"
col.group="Name"
title="Presidents of the USA"

vistime(origData, col.event="Position", col.group ="Name", title="Presidents of the USA")
hc_vistime(origData, col.event="Position", col.group ="Name", title="Presidents of the USA")
