# vistime - Pretty Timelines in R <img src="man/figures/logo.png" align="right" width="120" />

[![Buy Me A Coffee](https://i.imgur.com/xI5UtRm.png)](https://www.buymeacoffee.com/shosaco)
[![CRAN](https://www.r-pkg.org/badges/version/vistime)](https://cran.r-project.org/package=vistime)
[![R build status](https://github.com/shosaco/vistime/workflows/R-CMD-check/badge.svg)](https://github.com/shosaco/vistime/actions)
[![Downloads per month](https://cranlogs.r-pkg.org/badges/last-month/vistime)](https://www.r-pkg.org/pkg/vistime)
[![Downloads per week](https://cranlogs.r-pkg.org/badges/last-week/vistime)](https://www.r-pkg.org/pkg/vistime)
[![Downloads per day](https://cranlogs.r-pkg.org/badges/last-day/vistime)](https://www.r-pkg.org/pkg/vistime)
[![codecov](https://codecov.io/github/shosaco/vistime/branch/master/graphs/badge.svg)](https://app.codecov.io/github/shosaco/vistime)
[![Github Stars](https://img.shields.io/github/stars/shosaco/vistime.svg)](https://github.com/shosaco/vistime)

A library for creating time-based charts, like Gantt or timelines. Possible outputs include `ggplot`s, `plotly` graphs, `Highcharts` or data.frames. Results can be used in the RStudio viewer pane, in R Markdown documents or in Shiny apps. In the interactive outputs created by `vistime()` and `hc_vistime()` you can interact with the plot using mouse hover or zoom. Timelines and their components can afterwards be manipulated using `ggplot::theme()`, `plotly_build()` or `hc_*`functions (for `gg_vistime()`, `vistime()` or `hc_vistime()`, respectively). When choosing the `data.frame` output, you can use your own plotting engine for visualizing the graph.

If you find vistime useful, please consider supporting its development: <a href="https://www.buymeacoffee.com/shosaco" target="_blank"><img src="https://i.imgur.com/kN1GxnC.png" alt="Buy Me A Coffee"></a>

**Feedback welcome:** [sa.ra.online@posteo.de](mailto:sa.ra.online@posteo.de)

## Table of Contents

1. [Installation](#1-installation)
2. [Main functionality](#2-main-functionality)
3. [Real-life example](#3-real-life-example)
3. [Usage and documentation](#4-usage-and-documentation)


## 1. Installation

To install the package from CRAN, type the following in your R console:
```{r}
install.packages("vistime")
```
<!--
To install the development version containing most recent fixes and improvements, but not released on CRAN yet, see NEWS.md), run the following code in an R console:

```{r}
if (!require("remotes")) install.packages("remotes")
remotes::install_github("shosaco/vistime")
```

-->

## 2. Main functionality

This package `vistime` provides four main functions, the first three allow you to draw a timeline with Plotly, Highcharts or ggplot2, the last one 
outputs the pure optimized data frame ready for plotting.

### vistime() - interactive `Plotly` charts

```{r}
timeline_data <- data.frame(event = c("Event 1", "Event 2"),
                            start = c("2020-06-06", "2020-10-01"), 
                            end   = c("2020-10-01", "2020-12-31"),
                            group = "My Events")
                            
vistime(timeline_data)
```

<img src="man/figures/basic_plotly.png" />


### hc_vistime() - interactive `Highcharts` timelines

```{r}
timeline_data <- data.frame(event = c("Event 1", "Event 2"),
                            start = c("2020-06-06", "2020-10-01"), 
                            end   = c("2020-10-01", "2020-12-31"),
                            group = "My Events")
                            
hc_vistime(timeline_data)
```

<img src="man/figures/basic_highchart.png" />

This is facilitated by the `highcharter` package, so, this package needs to be installed before attempting to produce any `hc_vistime()` output.

### gg_vistime() - static `ggplot2` output

```{r}
timeline_data <- data.frame(event = c("Event 1", "Event 2"),
                            start = c("2020-06-06", "2020-10-01"), 
                            end   = c("2020-10-01", "2020-12-31"),
                            group = "My Events")
                            
gg_vistime(timeline_data)
```
<img src="man/figures/basic_ggplot.png" />

### vistime_data() - pure `data.frame` output if you want to draw yourself

```{r}
timeline_data <- data.frame(event = c("Event 1", "Event 2"),
                            start = c("2020-06-06", "2020-10-01"), 
                            end   = c("2020-10-01", "2020-12-31"),
                            group = "My Events")
                            
vistime_data(timeline_data)

#>     event      start        end     group                                      tooltip      col subplot   y
#> 1 Event 1 2020-06-06 2020-10-01 My Events  from <b>2020-06-06</b> to <b>2020-10-01</b>  #8DD3C7       1   1
#> 2 Event 2 2020-10-01 2020-12-31 My Events  from <b>2020-10-01</b> to <b>2020-12-31</b>  #FFFFB3       1   1
```

You want to use this for the intelligent y-axis assignment depending on overlapping of events (this can be disabled with `optimize_y = FALSE`).


## 3. Real-life example

During COVID-19 2020, [@wlhamilton](https://github.com/wlhamilton) used `gg_vistime()` for visualizing patient ward movements as timelines in order to investigate possible hospital acquired infections. See [his github](https://github.com/wlhamilton/Patient-ward-movement-timelines) for the code.

<img src="man/figures/ward_movements.png" width="500" height="283"/>

## 4. Usage and documentation

There is a vignette for each of the three functions of the package where they are explained in detail:

- `vistime()` for interactive **Plotly** output: [Link to manual](https://CRAN.R-project.org/package=vistime/vignettes/vistime-vignette.html)
- `gg_vistime()` for static **ggplot2** output: [Link to manual](https://CRAN.R-project.org/package=vistime/vignettes/gg_vistime-vignette.html)
- `hc_vistime()` for interactive **Highcharts** output: [Link to manual](https://CRAN.R-project.org/package=vistime/vignettes/hc_vistime-vignette.html)

