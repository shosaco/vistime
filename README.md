# vistime
####an R package for pretty timeline creation

Create _fully interactive_ timelines or Gantt charts using `plotly.js`. The charts can be included in Shiny apps and manipulated via `plotly_build()`.

Given a data frame containing event names and dates (can be `String`, `Date` or `POSIXct` in standard notation) and optionally groups, end dates for ranges, colors, tooltips or title, it creates a charming diagram of the given dates and events. It distinguishes between single events (having StartDate == EndDate) and ranges (given EndDate). Color column name can be handed over with the `color`-argument, if none are given, they are chosen from `RColorBrewer`.

**Feedback welcome:** shosaco_nospam@hotmail.com  

    

### Installation

To install the package from CRAN:

```{r}
  install.packages("vistime")
```

To install the development version (most recent fixes and improvements, but not released on CRAN yet), run the following code in an R console:
```{r}
  install.packages("devtools")
  devtools::install_github("shosaco/vistime")
```
     

### Use

To create a timeline, data needs at least 2 columns: `event` and `start`. If `end`, `group`, `color` or `tooltip` are present, they will be used as well. If the names differ, the parameters `events="yourEventNames"`, `start="yourStart"`, `end="yourEnd"`, `groups="yourGroups"`, `colors="yourColors"` or `tooltips="yourTooltips"` have to be handed over to `vistime`. Optionally, a `title` argument can be specified.

### Example
```{r}
library(vistime)
data(school)
school
vistime(school, events="Language", groups="Room")
```
    
      

![](inst/img/ex1data.png)
![](inst/img/ex1.png)
 
  



