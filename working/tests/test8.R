# 1. data
data <- read.csv(text=
"event,start,end
1,2,9
2,3,8
3,5,5")

data$start <- paste0("2017-01-0", data$start)
data$end   <- paste0("2017-01-0", data$end)
data$group <- paste("Group", c(1,2,1))

#2. standard parameters
events = "event"; start = "start"; end = "end"; groups = "group";
colors = "color"; fontcolors = "fontcolor"; tooltips = "tooltip";
optimize_y = TRUE; linewidth = NULL; title = NULL; showLabels = NULL;
show_labels = TRUE; lineInterval = NULL; background_lines = 10

# 3. function call
vistime(data)
