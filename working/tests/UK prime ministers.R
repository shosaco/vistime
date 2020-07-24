
timeline_data <- read.csv(file="https://ndownloader.figshare.com/files/5533355")
timeline_data$Start.Date <- as.Date(timeline_data$Start.Date)
timeline_data$End.Date <- as.Date(timeline_data$End.Date)
label_column <- "Prime.Minister"
category_column <- "Political.Party"
earliest_date_by_Prime_Minister <-
  timeline_data[timeline_data$Start.Date == ave(timeline_data$Start.Date, timeline_data$Prime.Minister, FUN =
                                                  min), ]
earliest_date_by_Prime_Minister <-
  earliest_date_by_Prime_Minister[order(
    earliest_date_by_Prime_Minister$Start.Date,
    earliest_date_by_Prime_Minister$Prime.Minister), ]
timeline_data$Prime.Minister <-
  factor(timeline_data$Prime.Minister, levels = rev(as.character(unique(earliest_date_by_Prime_Minister$Prime.Minister))))
timeline_data <- timeline_data[!is.na(timeline_data$End.Date) & !is.na(timeline_data$Start.Date),]
party_colours <- list("Labour" = "#DC241f", "Conservatives" = "#0087DC", "Liberal Democrat" = "#FDBB30")
party_colours <- as.character(party_colours[levels(timeline_data$Political.Party)])

vistime(timeline_data[order(timeline_data$Start.Date),], col.event = "Prime.Minister", start = "Start.Date", end = "End.Date", col.group = "Prime.Minister", colors = "Political.Party", optimize_y = T, show_labels =F, linewidth=8)

hc_vistime(timeline_data[order(timeline_data$Start.Date),], col.event = "Prime.Minister", start = "Start.Date", end = "End.Date", col.group = "Prime.Minister", colors = "Political.Party", optimize_y = T, show_labels =T)
