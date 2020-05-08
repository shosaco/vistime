
library(jsonlite)
library(shiny)
library(stringr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(cranlogs)
library(zoo)
library(plotly)
library(scales)
library(httr)

cranlogs::cran_downloads("vistime", "last-month")

# show a graph of cran_downloads("vistime", from="2017-01-29"))
get_initial_release_date = function(packages)
{
  min_date = Sys.Date() - 1

  for (pkg in packages)
  {
    # api data for package. we want the initial release - the first element of the "timeline"
    pkg_data = httr::GET(paste0("http://crandb.r-pkg.org/", pkg, "/all"))
    pkg_data = httr::content(pkg_data)

    initial_release = pkg_data$timeline[[1]]
    min_date = min(min_date, as.Date(initial_release))
  }

  min_date
}


# get the list of all packages on CRAN
package_names = names(httr::content(httr::GET("http://crandb.r-pkg.org/-/desc")))

ui <- fluidPage(

  # Application title
  titlePanel("Package Downloads Over Time"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      HTML("Enter an R package to see the # of downloads over time from the RStudio CRAN Mirror.",
           "You can enter multiple packages to compare them"),
      selectInput("package",
                  label = "Packages:",
                  selected = c("timevis", "timeline", "vistime", "timelineS"), # initialize the graph with a random package
                  choices = package_names,
                  multiple = TRUE),
      radioButtons("transformation",
                   "Data Transformation:",
                   c("Monthly", "Weekly", "Daily", "Cumulative")),
      sliderInput("mav_n", "Window for moving average", min = 1, max = 50, step = 5, value = 7),
      HTML("Created using the <a href='https://github.com/metacran/cranlogs'>cranlogs</a> package.",
           "This app is not affiliated with RStudio or CRAN.",
           "You can find the code for the app <a href='https://github.com/dgrtwo/cranview'>here</a>,",
           "or read more about it <a href='http://varianceexplained.org/r/cran-view/'>here</a>.")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("downloadsPlot")
    )
  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {

    downloads <- shiny::reactive({
      packages <- input$package
      # cran_downloads0 <- purrr::possibly(cran_downloads, otherwise = NULL)
      cran_downloads(packages = packages,
                      from    = get_initial_release_date(packages),
                      to      = Sys.Date()-2) %>% as_tibble
    })

    output$downloadsPlot <- renderPlotly({
      d <- downloads() %>% group_by(package)

      if (input$transformation == "Cumulative") {
        d <- d %>% mutate_at("count", cumsum)
      } else if (input$transformation == "Monthly"){
        d <- d %>% group_by(package, month = as.yearmon(date)) %>%
          summarize(date = min(date), count = sum(count))
      } else if (input$transformation == "Weekly"){
        d <- d %>% group_by(package, week = paste0(year(date), "-", str_pad(week(date), pad = "0", width = 2))) %>%
          summarize(date = min(date), count = sum(count))
      }

      d <- d %>% group_by(package) %>%
        mutate(mav = rollmean(count, input$mav_n, fill = NA, align = "right")) %>%
        ungroup() %>% filter(!is.na(mav))

      p <- plot_ly(type = "scatter")

      if('vistime' %in% input$package){
        #p <- p %>% add_bars(x=~date, y=~count, data = downloads() %>% filter(package == "vistime"), color = I("grey90"))

        releases <- content(GET(paste0("http://crandb.r-pkg.org/vistime/all")))$timeline

        for(version in names(releases)){

          p <- p %>%
            add_segments(x = as.POSIXct(releases[[version]]), xend = as.POSIXct(releases[[version]]),
                                 y = 0, yend = max(d$mav), color = I("grey"), showlegend = FALSE) %>%
            add_text(x = as.POSIXct(releases[[version]]),
                     y = max(d$mav)*1.1,
                     text = version,
                     color = I("grey"), showlegend = FALSE)
        }
      }
      p %>%
        add_lines(x = ~date, y=~mav, data = d, color = ~package) %>%
        layout(xaxis=list(title="Date"),
               yaxis=list(title="Number of downloads"),
               title = paste("Averaged over", input$mav_n, case_when(input$transformation == "7" ~ "weeks",
                                                                     input$transformation == "30" ~ "months",
                                                                     TRUE ~ "days")))
    })


}

# Run the application
shinyApp(ui = ui, server = server)

