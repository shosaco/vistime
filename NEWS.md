# vistime (development version)

## New features
- `vistime()` passes `source` and `customdata` to plot for interactive `Plotly` click or hover events in Shiny. Thanks @jonocarroll.

## Bugfixes
- Now asserts that `col.color` and `col.fontcolor` are string type, i.e. `vistime(dat, col.color = color_column)` fails and `vistime(dat, col.color = "color_column")` succeeds. This was implemented for the other columns already.

# vistime 1.2.4
## Bugfixes
- Fix failing dependency by exchanging package usage of `assertive.types` with `assertthat`

# vistime 1.2.3
- keep group column order in case of factors (otherwise groups appear in order of appearance) (closes #27, thanks @kelly-sovacool)

# vistime 1.2.2
## Bugfixes
- added `markdown` dependency for vignette building as per [yhui/knitr#1864](https://github.com/yihui/knitr/issues/1864)

# vistime 1.2.1
## Bugfixes
- `hc_vistime()` labels on y-axis were incorrectly reversed (#24)

# vistime 1.2.0

## Breaking Changes
- `highcharter` is no more installed by default when you install `vistime`

## Bugfixes
- `optimize_y = TRUE` did not work correctly for ranges that occur during other ranges (issue #22)

## New features
- Added mouse zooming capability to `hc_vistime()`
- Split the `README.md` into three vignettes:
  - [`vistime()` manual](https://CRAN.R-project.org/package=vistime/vignettes/vistime-vignette.html)
  - [`gg_vistime()` manual](https://CRAN.R-project.org/package=vistime/vignettes/gg_vistime-vignette.html)
  - [`hc_vistime()` manual](https://CRAN.R-project.org/package=vistime/vignettes/hc_vistime-vignette.html)


## Minor adjustments
- Updated documentation
- Internals: 
  * Using the `assertive.types` package instead of `assertthat` for nicer error messages
  * Upgraded to `testthat 3.0` for unit tests
  * Bugfixes for `hc_vistime()` arguments

# vistime 1.1.0
 
## Breaking Changes
- Made arguments more intuitive:
  * `col.event` instead of `event`
  * `col.start` instead of `start`
  * `col.end` instead of `end`
  * `col.group` instead of `groups`
  * `col.color` instead of `colors`
  * `col.fontcolor` instead of `fontcolors`
  * `col.tooltip` instead of `tooltips`

## New features
- New function `hc_vistime()`: Create an interactive timeline rendered by the great `Highcharter.js` library

## Minor adjustments
- `gg_vistime()`:
  * Use `geom_text()` for labels
  * Avoid overlapping of event labels using `ggrepel::geom_text_repel()`
  * Layout adjustments: Panel border and changes under-the-hood
- `vistime()`:
  * Changes under the hood (vertical and horizontal lines)
  * Panel border
- Usage of package `assertthat` and re-organization of dependencies
 
# vistime 1.0.0
 
## Breaking Changes
- `vistime()` no longer uses cumbersome Plotly-subplots. Everything renders in the same plot and can be zoomed seamlessly.
- Events are drawn from top to bottom (not from bottom to top) - always in the order of the input data frame (per groups that are arranged from top to bottom). This makes the result more intuitive: &#175;&#8212;-\_-\_ instead of \_-\_-&#8212;&#175;

## New features
- `gg_vistime()` as new function to output the timeline as a static ggplot (in addition to `vistime()`, which outputs an interactive Plotly object).
- `vistime_data()` as new function to output the cleaned and optimized timeline data for your own plotting experiments.

## Removed functionality
- arguments `showLabels` and `lineInterval` have long been deprecated and have now been removed (use `show_labels` and `background_lines` instead).

# vistime 0.9.0
- Fixed bug for plots having more than 9 groups - in these cases the order was not the same as in the input data frame
- New argument `optimize_y` (default: `TRUE`)
  * If `optimize_y = TRUE`, use heuristic to optimally distribute events on y axis
  * If `optimize_y = FALSE`, use fixed order on y axis according to input data
- Relaxed package dependencies: (e.g. `plotly` only Imports, not Depends)

# vistime 0.8.1
- Hotfix: due to new Plotly version, colors and fontcolors handling was broken. Changed dependency to Plotly > 4.0.0.

# vistime 0.8.0
- Internals (no exporting of helper functions, unit tests using `testthat` package, continuous integration using `travis`, test code coverage using `covr`)
- Activated Github Page: https://shosaco.github.io/vistime/
- Argument `showLabels` has been renamed to `show_labels` for consistency. A deprecation message is shown.

# vistime 0.7.0
- We have a vignette now
- Events and ranges that are in the same group are now plotted directly below each other (in the past, all ranges were plotted first, followed by all events). Groups are sorted in order of first appearance but all items of one group are plotted together.
- Argument `lineInterval` is now deprecated. It was replaced by the new, more intuitive argument `background_lines` - the number of lines to draw in the background.
- Remove leading and trailing whitespaces of events and groups before drawing 

# vistime 0.6.0
- Hotfix for broken y-axis labeling (introduced through new plotly package 4.8.0.)
- Events are now shown as circles (was: squares)
- Corrected font colors of Presidents example on help page

# vistime 0.5.0
- Added a new argument `showLabels` to choose whether or not the event labels shall be drawn - improves layout of dense timelines
- New argument `lineInterval`: the distance in seconds that vertical lines shall be drawn (to reduce plot size and increase performance). When omitted, a heuristic (as before) is used.
- Improved heuristic of vertical line drawing

# vistime 0.4.0
- Line width calculation for ranges improved (thicker lines if less events happening simultaneously)
- New parameter: `linewidth` to override the calculated line width for events
- Layout and labeling improvements
- Simplified examples
- Improved error checking

# vistime 0.3.0
- New parameters: 
    + `title` (a title for the timeline)
    + `tooltips` (column name of data that contains individual tooltips)
    + `fontcolors` (column name of data that contains color of the event font)
- Ordering of groups in plot is now the same as the order of "groups" column in data
- Added more complex example and removed school data/example
- Changed `colors` argument default to "color" (i.e. if a column `color` is present in your data, it will be used for coloring the events)
- Bugfix if data contains only one event
- Bugfix where events where not correctly categorized into their respective groups
- Improved error checking
- Improved drawing of vertical lines for certain ranges
- Major improvement of intelligent levelling of ranges (\_-\_&#175;-&#8212;)

# vistime 0.2.0
- Improved error checking
- Various bugfixes 

# vistime 0.1.0
First public release on 29/01/2017
