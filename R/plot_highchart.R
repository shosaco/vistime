
plot_highchart <- function(data, title, show_labels){

  # let an event be 1/50th of total timeline range
  data$end <- with(data, ifelse(start != end, end, end + diff(range(c(start, end)))/50))
  data$start <- 1000 * as.double(data$start)
  data$end <- 1000 * as.double(data$end)
  data$y <- max(data$y) - data$y + 1

  cats <- round(tapply(data$y, data$group, mean))
  y_vals <- names(sort(c(cats, setdiff(seq_len(max(data$y)), cats))))


  highcharter::highchart() %>%
    highcharter::hc_chart(inverted =TRUE) %>%
    highcharter::hc_add_series(data, "columnrange",
                               highcharter::hcaes(x = y, low=start, high=end, color=col),
                  dataLabels = list(enabled = show_labels, inside=T,
                                    formatter = highcharter::JS("function () {return (this.y === this.point.low ? this.point.event : \"\")}"))) %>%
    highcharter::hc_yAxis(type = "datetime") %>%
    highcharter::hc_xAxis(categories = c("", y_vals)) %>%
    highcharter::hc_tooltip(crosshairs = TRUE, formatter = highcharter::JS("function () {return this.point.tooltip}")) %>%
    highcharter::hc_legend(enabled=F) %>%
    highcharter::hc_title(text = title)
}
