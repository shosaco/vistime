
plot_highchart <- function(data, title, show_labels){

  library(tidyr)

  data <- data %>%
    # experimental: An events length is 1/20 of the total event range
    mutate(end = if_else(start != end, end, end + diff(range(c(start, end)))/50)) %>%
    mutate_at(c("start", "end"), ~1000*as.double(.x)) %>% mutate(y = max(y) - y + 1) %>%
    rename(low = start, high = end, x = y, color = col) %>%
    mutate_if(is.POSIXct, as_datetime)

  cat <- data %>% group_by(group) %>% summarize(x = round(mean(x)))
  y_axis <- tibble(x = seq_len(max(cat$x))) %>% left_join(cat) %>% pull(group) %>% as.character %>% replace_na("")

  highchart() %>%
    hc_chart(type = "columnrange", inverted =TRUE) %>%
    hc_add_series(name  = "series", data = data,
                  dataLabels = list(
                    enabled = show_labels, inside=T,
                    formatter = JS("function () {return (this.y === this.point.high ? this.point.event : \"\")}"))) %>%
    hc_plotOptions(columnrange = list(lineWidth = 1)) %>%
    hc_yAxis(type = "datetime") %>%
    hc_xAxis(categories = c("", y_axis)) %>%
    hc_tooltip(crosshairs = TRUE, formatter = JS("function () {return this.point.event}")) %>%
    hc_legend(enabled=F)%>%
    hc_title(text = title)
}
