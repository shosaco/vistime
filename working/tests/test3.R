# 1. data
origData <- data.frame(Position=c(rep("President", 3), rep("Vice", 3)),
Name = c("Washington", "Adams", "Jefferson", "Adams", "Jefferson", "Burr"),
start = rep(c("1789-03-29", "1797-02-03", "1801-02-03"), 2),
end = rep(c("1797-02-03", "1801-02-03", "1809-02-03"), 2),
color = c('#cbb69d', '#603913', '#c69c6e'),
fontcolor = rep("white", 6))

#2. standard parameters
events="event"
start="start"
end="end"
groups="group"
colors="color"
fontcolors="fontcolor"
tooltips="tooltip"
title=NULL

# 3. function call
# vistime(origData, events="Position",title="Presidents of the USA")
events="Position"
title="Presidents of the USA"

vistime(origData, events="Position", title="Presidents of the USA")
