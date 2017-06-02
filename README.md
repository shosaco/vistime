[![CRAN](http://www.r-pkg.org/badges/version/vistime)](https://cran.r-project.org/package=vistime)
[![packageversion](https://img.shields.io/badge/packageversion-0.4.0-orange.svg)](commits/master)
[![Downloads](http://cranlogs.r-pkg.org/badges/last-week/vistime)](https://www.r-pkg.org/pkg/vistime)

# vistime
#### an R package for pretty timeline creation

Create timelines or Gantt charts, offline and interactive, that are usable in the 'RStudio' viewer pane, in 'R Markdown' documents and in 'Shiny' apps using 'plotly.js', a high-level, declarative charting library. Hover the mouse pointer over a point or task to show details or drag a rectangle to zoom in. Timelines (and the data behind them) can be manipulated using 'plotly_build()' or, once uploaded to a 'plotly' account, viewed and modified in a web browser.

**Feedback welcome:** shosaco_nospam@hotmail.com  


### Installation

To install the package from CRAN (v0.3.0):

```{r}
install.packages("vistime")
```

To install the development version (v0.4.0, most recent fixes and improvements, but not released on CRAN yet, see NEWS), run the following code in an R console:
```{r}
require("devtools")
devtools::install_github("shosaco/vistime") 
```


### Usage

```{r}
vistime(data, start = "start", end = "end", groups = "group", events = "event", colors = "color", 
              fontcolors = "fontcolor", tooltips = "tooltip", linewidth=NULL, title = NULL)
````


### Arguments

parameter | optional? | data type | explanation 
--------- |----------- | ----------- 
data | mandatory | data.frame | data.frame that contains the data to be visualised
start | optional | character | the column name in data that contains start dates. Default: *"start"*
end | optional | character | the column name in data that contains end dates. Default: *"end"*
groups | optional | character | the column name in data to be used for grouping. Default: *"group"*
events | optional | character | the column name in data that contains event names. Default: *"event"*
colors | optional | character | the column name in data that contains colors for events. Default: *"color"*, if not present, colors are chosen via RColorBrewer
fontcolors | optional | character | the column name in data that contains the font color for event labels. Default: "*fontcolor*", if not present, color will be black
tooltips | optional | character | the column name in data that contains the mouseover tooltips for the events. Default: "*tooltip*", if not present, then tooltips are build from event name and date. <a href="http://help.plot.ly/adding-HTML-and-links-to-charts/#step-2-the-essentials", target="_blank">Basic HTML</a> is allowed
linewidth | optional | numeric | override the calculated linewidth for events
title | optional | character | the title to be shown on top of the timeline

### Value

`vistime` returns an object of class `plotly` and `htmlwidget`.


### Examples  

#### Ex. 1: Presidents
```{r}
dat <- data.frame(Position=rep(c("President", "Vice"), each = 3),
                  Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
                  start = c("1789-03-29", "1797-02-03", "1801-02-03"),
                  end = c("1797-02-03", "1801-02-03", "1809-02-03"),
                  color = c('#cbb69d', '#603913', '#c69c6e'),
                  fontcolor = c("black", "white", "black"))
                  
vistime(dat, events="Position", groups="Name", title="Presidents of the USA")
````
![](inst/img/ex2.png)

#### Ex. 2: Project Planning
````{r}
data <- read.csv(text="event,group,start,end,color
                       Phase 1,Project,2016-12-22,2016-12-23,#c8e6c9
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
                       4-399.7,moon rising,2017-01-13,2017-01-13,#f44336
                       8-831.0,sundowner drink,2017-01-17,2017-01-17,#8d6e63
                       9-984.1,birthday party,2016-12-22,2016-12-22,#90a4ae
                       F01.9,Meetings,2016-12-26,2016-12-26,#e8a735
                       Z71,Meetings,2017-01-12,2017-01-12,#e8a735
                       B95.7,Meetings,2017-01-15,2017-01-15,#e8a735
                       T82.7,Meetings,2017-01-15,2017-01-15,#e8a735
                       Room 334,Team 1,2016-12-22,2016-12-28,#DEEBF7
                       Room 335,Team 1,2016-12-28,2017-01-05,#C6DBEF
                       Room 335,Team 1,2017-01-05,2017-01-23,#9ECAE1
                       Group 1,Team 2,2016-12-22,2016-12-28,#E5F5E0
                       Group 2,Team 2,2016-12-28,2017-01-23,#C7E9C0")
                           
vistime(data)
````

![](inst/img/ex3.png)

