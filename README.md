[![CRAN](http://www.r-pkg.org/badges/version/vistime)](https://cran.r-project.org/package=vistime)
[![dev](https://img.shields.io/badge/dev-0.6.0.9000-yellow.svg)](commits/master)
[![Downloads](http://cranlogs.r-pkg.org/badges/last-week/vistime)](https://www.r-pkg.org/pkg/vistime)
<p style="text-align: right;">[![Support via PayPal](https://cdn.rawgit.com/twolfson/paypal-github-button/1.0.0/dist/button.svg)](https://paypal.me/shosaco)</p>

vistime - Pretty Timeline Creation
=========

Create interactive timelines or Gantt charts that are usable in the 'RStudio' viewer pane, in 'R Markdown' documents and in 'Shiny' apps. Hover the mouse pointer over a point or task to show details or drag a rectangle to zoom in. Timelines and their components can afterwards be manipulated using 'plotly_build()', which transforms the plot into a mutable list.

**Feedback welcome:** shosaco_nospam@hotmail.com  

## Table of Contents

1. [Installation](#1-installation)
2. [Usage](#2-usage)
3. [Arguments](#3-arguments)
4. [Value](#4-value)
5. [Examples](#5-examples)
   * [Ex. 1: Presidents](#ex-1-presidents)
   * [Ex. 2: Project Planning](#ex-2-project-planning)
6. [Usage in Shiny apps](#6-usage-in-shiny-apps)
7. [Customization](#7-customization)
   * [Ex1: Changing x-axis tick font size](#ex1-changing-x-axis-tick-font-size)
   * [Ex2: Changing events font size](#ex2-changing-events-font-size)
   * [Ex3: Changing marker size](#ex3-changing-marker-size)

## 1. Installation

To install the package from CRAN (v0.6.0):

```{r}
install.packages("vistime")
```
To install the development version (v0.7.0, most recent fixes and improvements, but not released on CRAN yet, see NEWS.md), run the following code in an R console:
```{r}
if(!require("devtools")) install.packages("devtools")
devtools::install_github("shosaco/vistime")
```


## 2. Usage

```{r}
vistime(data, start = "start", end = "end", groups = "group", events = "event", colors = "color", 
              fontcolors = "fontcolor", tooltips = "tooltip", linewidth = NULL, 
              title = NULL, showLabels = TRUE, lineInterval = NULL)
````


## 3. Arguments

parameter | optional? | data type | explanation 
--------- |----------- | -------- | ----------- 
data | mandatory | data.frame | data.frame that contains the data to be visualised
start | optional | character | the column name in data that contains start dates. Default: *start*
end | optional | character | the column name in data that contains end dates. Default: *end*
groups | optional | character | the column name in data to be used for grouping. Default: *group*
events | optional | character | the column name in data that contains event names. Default: *event*
colors | optional | character | the column name in data that contains colors for events. Default: *color*, if not present, colors are chosen via RColorBrewer.
fontcolors | optional | character | the column name in data that contains the font color for event labels. Default: *fontcolor*, if not present, color will be black.
tooltips | optional | character | the column name in data that contains the mouseover tooltips for the events. Default: *tooltip*, if not present, then tooltips are build from event name and date. [Basic HTML](https://help.plot.ly/adding-HTML-and-links-to-charts/#step-2-the-essentials) is allowed.
linewidth | optional | numeric | override the calculated linewidth for events. Default: heuristic value.
title | optional | character | the title to be shown on top of the timeline. Default: empty.
showLabels | optional | logical | choose whether or not event labels shall be visible. Default: `TRUE`.
lineInterval | optional | integer| the distance of vertical lines (in **seconds**) to improve layout. Default: heuristic value, depending on total data range.

## 4. Value

`vistime` returns an object of class `plotly` and `htmlwidget`.


## 5. Examples  

### Ex. 1: Presidents
```{r}
pres <- data.frame(Position = rep(c("President", "Vice"), each = 3),
                   Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
                   start = c("1789-03-29", "1797-02-03", "1801-02-03"),
                   end = c("1797-02-03", "1801-02-03", "1809-02-03"),
                   color = c('#cbb69d', '#603913', '#c69c6e'),
                   fontcolor = c("black", "white", "black"))
                  
vistime(pres, events="Position", groups="Name", title="Presidents of the USA", lineInterval = 60*60*24*365*5)
````
![](inst/img/ex2.png)

### Ex. 2: Project Planning
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

## 6. Usage in Shiny apps

Since the result of any call to `vistime(...)` is a `Plotly` object, you can use `plotlyOutput` in the UI and `renderPlotly` in the server of your [Shiny app](https://shiny.rstudio.com/) to display your chart:

```{r}
library(shiny)
library(plotly)
library(vistime)

pres <- data.frame(Position = rep(c("President", "Vice"), each = 3),
                   Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
                   start = c("1789-03-29", "1797-02-03", "1801-02-03"),
                   end = c("1797-02-03", "1801-02-03", "1809-02-03"),
                   color = c('#cbb69d', '#603913', '#c69c6e'),
                   fontcolor = c("black", "white", "black"))

shinyApp(
  ui = plotlyOutput("myVistime"),
  server = function(input, output) {
    output$myVistime <- renderPlotly({
      vistime(pres, events="Position", groups="Name")
    })
  }
)
```

## 7. Customization
The function `plotly_build` turns your plot into a list. You can then use the function `str` to explore the structure of your plot. You can even manipulate all the elements there.

The key is to first create a **simple Plotly example** yourself, turning it into a list (using `plotly_build`) and **exploring the resulting list** regarding the naming of the relevant attributes. Then manipulate or create them in your vistime example accordingly. Below are some examples of common solutions.

### Ex1: Changing x-axis tick font size
The following example creates the presidents example and manipulates the font size of the x axis ticks:

```{r}
pres <- data.frame(Position = rep(c("President", "Vice"), each = 3),
                   Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
                   start = c("1789-03-29", "1797-02-03", "1801-02-03"),
                   end = c("1797-02-03", "1801-02-03", "1809-02-03"),
                   color = c('#cbb69d', '#603913', '#c69c6e'),
                   fontcolor = c("black", "white", "black"))
 
p <- vistime(pres, events="Position", groups="Name", title="Presidents of the USA")

# step 1: transform into a list
pp <- plotly_build(p)

# step 2: change the font size
pp$x$layout$xaxis$tickfont <- list(size = 28)

pp
```
![](inst/img/ex2-tickfontsize.png)

### Ex2: Changing events font size
The following example creates the presidents example and manipulates the font size of the events:


```{r}
pres <- data.frame(Position = rep(c("President", "Vice"), each = 3),
                    Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
                    start = c("1789-03-29", "1797-02-03", "1801-02-03"),
                    end = c("1797-02-03", "1801-02-03", "1809-02-03"),
                    color = c('#cbb69d', '#603913', '#c69c6e'),
                    fontcolor = c("black", "white", "black"))
 
p <- vistime(pres, events="Position", groups="Name", title="Presidents of the USA")

# step 1: transform into a list
pp <- plotly_build(p)

# step 2: loop over pp$x$data, and change the font size of all text elements to 28
pp$x$data <- lapply(pp$x$data, function(x){
 if(x$mode == "text") x$textfont$size <- 28
 return(x)
})

pp
```
![](inst/img/ex2-eventfontsize.png)

### Ex3: Changing marker size
The following example a simple example using markers and manipulates the size of the markers:


```{r}
dat <- data.frame(event = 1:4, start = c(Sys.Date(), Sys.Date() + 10))
 
p <- vistime(dat)

# step 1: transform into a list
pp <- plotly_build(p)

# step 2: loop over pp$x$data, and change the marker size of all text elements to 50px
pp$x$data <- lapply(pp$x$data, function(x){
    if(x$mode == "markers") x$marker$size <- 50
    return(x)
})

pp
```

![](inst/img/ex3-markersize.png)

