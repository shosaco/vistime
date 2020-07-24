# vistime 1.1.0 (2020-07-24)
 
## Breaking Changes
- more intuitive argument naming:
  * `col.event` instead of `event`
  * `col.start` instead of `start`
  * `col.end` instead of `end`
  * `col.group` instead of `groups`
  * `col.color` instead of `colors`
  * `col.fontcolor` instead of `fontcolors`
  * `col.tooltip` instead of `tooltips`

## New features
- new function `hc_vistime()`: Create an interactive timeline rendered by the famous `Highcharter.js` library

## Minor adjustments
- `gg_vistime`:
  * use `geom_text` for labels
  * avoid overlapping of event labels using `ggrepel::geom_text_repel()`
  * layout adjustments: Panel border and changes under-the-hood
- `vistime`:
  * changes under the hood (vertical and horizontal lines)
  * panel border
- usage of package `assertthat` and re-organisation of dependencies
 
# vistime 1.0.0 (2020-04-17)
 
## Breaking Changes
- `vistime` no longer uses cumbersome Plotly-subplots. Everything renders in the same plot and can be zoomed seamlessly.
- Events are drawn from top to bottom (not from bottom to top) - always in the order of the input data frame (per groups that are arranged from top to bottom). This makes the result more intuitive: &#175;&#8212;-\_-\_ instead of \_-\_-&#8212;&#175;

## New features
- `gg_vistime()` as new function to output the timeline as a static ggplot (in addition to `vistime`, which outputs an interactive Plotly object).
- `vistime_data()` as new function to output the cleaned and optimized timeline data for your own plotting experiments.

## Removed functionality
- arguments `showLabels` and `lineInterval` have long been deprecated and have now been removed (use `show_labels` and `background_lines` instead).

# vistime 0.9.0 (2020-01-10)
- fixed bug for plots having more than 9 groups - in these cases the order was not the same as in the input data frame
- new argument `optimize_y` (default: `TRUE`)
  * if `optimize_y = TRUE`, use heuristic to optimally distribute events on y axis
  * if `optimize_y = FALSE`, use fixed order on y axis according to input data
- relaxed package dependencies: (e.g. `plotly` only Imports, not Depends)

# vistime 0.8.1 (2019-03-24)
- hotfix: due to new Plotly version, colors and fontcolors handling was broken. Changed dependency to Plotly > 4.0.0.

# vistime 0.8.0 (2019-03-03)
- internals (no exporting of helper functions, unit tests using `testthat` package, continuous integration using `travis`, test code coverage using `covr`)
- activated Github Page: https://shosaco.github.io/vistime/
- argument `showLabels` has been renamed to `show_labels` for consistency. A deprecation message is shown.

# vistime 0.7.0 (2019-01-04)
- we have a vignette now
- events and ranges that are in the same group are now plotted directly below each other (in the past, all ranges were plotted first, followed by all events). Groups are sorted in order of first appearance but all items of one group are plotted together.
- argument `lineInterval` is now deprecated. It was replaced by the new, more intuitive argument `background_lines` - the number of lines to draw in the background.
- remove leading and trailing whitespaces of events and groups before drawing 

# vistime 0.6.0 (2018-10-28)
- Hotfix for broken y-axis labeling (introduced through new plotly package 4.8.0.)
- events are now shown as circles (was: squares)
- corrected font colors of Presidents example on help page

# vistime 0.5.0 (2018-04-15)
- added a new argument `showLabels` to choose whether or not the event labels shall be drawn - improves layout of dense timelines
- new argument `lineInterval`: the distance in seconds that vertical lines shall be drawn (to reduce plot size and increase performance). When omitted, a heuristic (as before) is used.
- improved heuristic of vertical line drawing

# vistime 0.4.0 (2017-06-03)
- line width calculation for ranges improved (thicker lines if less events happening simultaneously)
- new parameter: `linewidth` to override the calculated line width for events
- layout and labeling improvements
- simplified examples
- improved error checking

# vistime 0.3.0 (2017-02-12)
- new parameters: 
    + `title` (a title for the timeline)
    + `tooltips` (column name of data that contains individual tooltips)
    + `fontcolors` (column name of data that contains color of the event font)
- ordering of groups in plot is now the same as the order of "groups" column in data
- added more complex example and removed school data/example
- changed `colors` argument default to "color" (i.e. if a column `color` is present in your data, it will be used for coloring the events)
- bugfix if data contains only one event
- bugfix where events where not correctly categorized into their respective groups
- improved error checking
- improved drawing of vertical lines for certain ranges
- major improvement of intelligent levelling of ranges (\_-\_&#175;-&#8212;)

# vistime 0.2.0 (2017-01-30)
- improved error checking
- various bugfixes

# vistime 0.1.0 (2017-01-29)
First public release on 29/01/2017
