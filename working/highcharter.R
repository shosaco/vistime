# notebook to output plot as highchart
library(highcharter)

vistime_hc <- function(data, events = "event", start = "start", end = "end", groups = "group",
                    colors = "color", fontcolors = "fontcolor", tooltips = "tooltip",
                    optimize_y = TRUE, linewidth = NULL, title = NULL,
                    show_labels = TRUE, background_lines = 10) {
  library(dplyr)
  library(tidyr)
  data <- validate_input(data, start, end, events, groups, tooltips, optimize_y, linewidth, title, show_labels, background_lines)
  data <- set_colors(data, colors, fontcolors)
  data <- fix_columns(data, events, start, end, groups, tooltips)
  data <- set_order(data)
  data <- set_y_values(data, optimize_y) %>%
    # experimental: An events length is 1/20 of the total event range
    mutate(end = if_else(start != end, end, end + diff(range(c(start, end)))/50)) %>%
    mutate_at(c("start", "end"), ~1000*as.double(.x)) %>% mutate(y = max(y) - y + 1)

  cat <- data %>% distinct(y, group) %>% distinct(group, .keep_all = TRUE)
  highchart() %>%
    hc_chart(zoomType = "xy") %>%
    hc_add_series(type = "columnrange", data = data,  hcaes(x = y, low = start, high = end, color = col),
                  dataLabels = list(
                    enabled = TRUE, inside=T,
                    formatter = JS("function () {return (this.y === this.point.high ? this.point.event : \"\")}"))) %>%
    hc_yAxis(type = "datetime") %>%
    hc_xAxis(categories = c("", tibble(y = seq_len(max(cat$y))) %>% left_join(cat) %>% pull(group) %>% replace_na(""))) %>%
    hc_chart(inverted = TRUE) %>%
    hc_tooltip(crosshairs = TRUE, pointFormat = "{point.event}: from: {point.y:%Y-%m-%d}") %>%
    hc_legend(enabled=F) %>%
    hc_title(text = title)

}



##########################################
origData <- read.csv(text="event,group,start,end,color
P..,Project,2016-12-22,2016-12-23,#c8e6c9
Phase 2,Project,2016-12-23,2016-12-29,#a5d6a7
Phase 3,Project,2016-12-29,2017-01-06,#fb8c00
Phase 4,Project,2017-01-06,2017-02-02,#DD4B39
1-217.0,category 2,2016-12-27,2016-12-27,#90caf9
3-200,category 1,2016-12-25,2016-12-25,#1565c0
3-330,category 1,2016-12-25,2016-12-25,#1565c0
3-223,category 1,2016-12-28,2016-12-28,#1565c0
3-225,category 1,2016-12-28,2016-12-28,#1565c0
3-226,category 1,2016-12-28,2016-12-28,#1565c0
3-226,category 1,2017-01-19,2017-01-19,#1565c0
3-330,category 1,2017-01-19,2017-01-19,#1565c0
1-399.7,moon rising,2017-01-13,2017-01-13,#f44336
9-984.1,birthday party,2016-12-22,2016-12-22,#90a4ae
F01.9,Meetings,2016-12-26,2016-12-26,#e8a735
Z71,Meetings,2017-01-12,2017-01-12,#e8a735
B95.7,Meetings,2017-01-15,2017-01-15,#e8a735
T82.7,Meetings,2017-01-15,2017-01-15,#e8a735
Room 334,Team 1,2016-12-22,2016-12-28,#DEEBF7
Room 335,Team 1,2016-12-28,2017-01-05,#C6DBEF
Room 335,Team 1,2017-01-05,2017-01-23,#9ECAE1
Group 1,Team 2,2016-12-22,2016-12-28,#E5F5E0
Group 2,Team 2,2016-12-28,2017-01-23,#C7E9C0", stringsAsFactors = F) %>%
  as_tibble %>%
  mutate_at(c("start", "end"), as.Date)

prepare_data <- function(dat){

  events <- "event"
  start <- "start"
  end <- "end"
  groups <- "group"
  colors <- "color"
  fontcolors <- "fontcolor"
  tooltips <- "tooltip"
  optimize_y <- TRUE
  linewidth <- NULL
  title <- NULL
  show_labels <- TRUE
  background_lines <- 11

  dat <- vistime:::validate_input(dat, start, end, events, groups, tooltips, optimize_y, linewidth, title, show_labels, background_lines)
  dat <- vistime:::set_colors(dat, colors, fontcolors)
  dat <- vistime:::fix_columns(dat, events, start, end, groups, tooltips)
  dat <- vistime:::set_order(dat)
  dat <- vistime:::set_y_values(dat, TRUE) %>%
    mutate(end = if_else(start != end, end, end + diff(range(c(start, end)))/50)) %>%
    mutate_at(c("start", "end"), ~1000*as.double(.x)) %>% mutate(y = max(y) - y + 1)
  return(dat)
}

data <- prepare_data(origData) %>% as_tibble
cat <- data %>% distinct(y, group) %>% distinct(group, .keep_all = TRUE)
highchart() %>%
  hc_add_series(type = "columnrange", data = data,  hcaes(x = y, low = start, high = end, color = col),
                dataLabels = list(
                  enabled = TRUE, inside=T,
                  formatter = JS("function () {return (this.y === this.point.high ? this.point.event : \"\")}"))) %>%
  hc_yAxis(type = "datetime") %>%
  hc_xAxis(categories = c("", tibble(y = seq_len(max(cat$y))) %>% left_join(cat) %>% pull(group) %>% replace_na(""))) %>%
  hc_chart(inverted = TRUE) %>%
  hc_tooltip(crosshairs = TRUE, pointFormat = "{point.event}: from: {point.y:%Y-%m-%d}") %>%
  hc_legend(enabled=F)


######################
data <- origData %>% mutate_at(c("start", "end"), ~.x - years(500)) %>%
  prepare_data() %>% as_tibble
