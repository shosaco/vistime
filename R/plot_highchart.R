
plot_highchart <- function(data, title, show_labels){

  library(tidyr)

  data$end <- with(data, ifelse(start != end, end, end + diff(range(c(start, end)))/50))
  data$start <- 1000*as.double(data$start)
  data$end <- 1000*as.double(data$end)
  data$y <- max(data$y) - data$y + 1
  data$start <- as_datetime(data$start)
  data$end <- as_datetime(data$end)
  names(data)[names(data) == "start"] <- "low"
  names(data)[names(data) == "end"] <- "high"
  names(data)[names(data) == "y"] <- "x"
  names(data)[names(data) == "col"] <- "color"

  cat <- data %>% group_by(group) %>% summarize(x = round(mean(x)))
  y_axis <- tibble(x = seq_len(max(cat$x))) %>% left_join(cat) %>% pull(group) %>% as.character %>% replace_na("")

  highchart() %>%
    hc_chart(type = "columnrange", inverted =TRUE) %>%
    hc_add_series(name  = "series", data = data,
                  dataLabels = list(
                    enabled = show_labels, inside=T,
                    formatter = JS("function () {return (this.y === this.point.low ? this.point.event : \"\")}"))) %>%
    hc_yAxis(type = "datetime") %>%
    hc_xAxis(categories = c("", y_axis)) %>%
    hc_tooltip(crosshairs = TRUE, formatter = JS("function () {return this.point.event}")) %>%
    hc_legend(enabled=F)%>%
    hc_title(text = title)
}
