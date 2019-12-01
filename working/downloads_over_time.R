
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
                  selected = "vistime", # initialize the graph with a random package
                  choices = package_names,
                  multiple = TRUE),
      radioButtons("transformation",
                   "Data Transformation:",
                   c("Monthly" = "monthly", "Weekly" = "weekly", "Cumulative" = "cumulative")),
      sliderInput("mav_n", "Windows for moving average", min = 1, max = 50, step = 5, value = 7),
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
                      to      = Sys.Date()-2)
    })

    output$downloadsPlot <- renderPlotly({
      d <- downloads()

      if (input$transformation=="monthly") {
        d <- d %>%
          group_by(package) %>% mutate(count = rollsum(count, 30, fill=0)) %>% ungroup()
      } else if (input$transformation=="weekly") {
        d <- d %>%
          group_by(package) %>% mutate(count = rollsum(count, 7, fill=0)) %>% ungroup()
      } else if (input$transformation=="cumulative") {
        d = d %>%
          group_by(package) %>%
          transmute(count=cumsum(count), date=date)
      }

      d <- d %>% group_by(package) %>% mutate(mav = rollmean(count, input$mav_n, fill = 0, align = "right")) %>% ungroup()

      p <- plot_ly(d, type="scatter", x=~date, y=~mav, color=~package) %>%
        layout(xaxis=list(title="Date"),
               yaxis=list(title="Number of downloads"))

      if('vistime' %in% input$package){
        print(d %>% filter(package == 'vistime') %>% tail)
        releases <- content(GET(paste0("http://crandb.r-pkg.org/vistime/all")))$timeline

        for(version in names(releases)){

          p <- p %>%
            add_segments(x = as.POSIXct(releases[[version]]), xend = as.POSIXct(releases[[version]]),
                                 y = 0, yend = max(d$count), color = I("grey"), showlegend = FALSE) %>%
            add_text(x = as.POSIXct(releases[[version]]),
                     y = max(d$count)*1.01,
                     text = version,
                     color = I("grey"), showlegend = FALSE)
        }
      }


      return(p)
    })


}

# Run the application
shinyApp(ui = ui, server = server)

