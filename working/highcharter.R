
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

plot_highcharts <- function(data, title, show_labels){

  library(tidyr)

  data2 <- data %>%
    # experimental: An events length is 1/20 of the total event range
    mutate(end = if_else(start != end, end, end + diff(range(c(start, end)))/50)) %>%
    mutate(y = max(y) - y + 1)

  cat <- data2 %>% group_by(group) %>% summarize(y = round(mean(y)))
  y_axis <- tibble(y = seq_len(max(cat$y))) %>% left_join(cat) %>% pull(group) %>% as.character %>% replace_na("")

  data$start <- as.POSIXct(data$start, tz = Sys.timezone())
  data$end <- as.POSIXct(data$end, tz = Sys.timezone())

  highchart() %>%
    hc_chart(inverted =TRUE) %>%
    hc_add_series(data, "columnrange", hcaes(x=y, low=start, high=end, color=col),
                  dataLabels = list(enabled = show_labels, inside=T,
                    formatter = JS("function () {return (this.y === this.point.low ? this.point.event : \"\")}"))) %>%
    hc_yAxis(type = "datetime") %>%
    hc_xAxis(categories = c("", y_axis)) %>%
    hc_tooltip(crosshairs = TRUE, formatter = JS("function () {return this.point.event}")) %>%
    hc_legend(enabled=F)%>%
    hc_title(text = title)
}


checked_dat <- validate_input(origData, "event", "start", "end", "group", "color", NULL, NULL,
                              optimize_y = FALSE, title = "Highcharter Test",
                              show_labels = TRUE)

data <- vistime_data(checked_dat$data, checked_dat$col.event, checked_dat$col.start,
                     checked_dat$col.end, checked_dat$col.group, checked_dat$col.color,
                     checked_dat$col.fontcolor, checked_dat$col.tooltip, TRUE)

plot_highcharts(data, 0, "Test Highcharts", T)
