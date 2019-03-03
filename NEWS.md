# 0.8.0
- internals (no exporting of helper functions, unit tests using testthat package, continuous integration using travis, test code coverage using covr)
- activated Github Page: https://shosaco.github.io/vistime/
- argument `showLabels` has been renamed to `show_labels` for consistency. A warning message is shown.

# 0.7.0
- we have a vignette now
- events and ranges that are in the same group are now plotted directly below each other (in the past, all ranges were plotted first, followed by all events). Groups are sorted in order of first appearance but all items of one group are plotted together.
- argument `lineInterval` is now deprecated. It was replaced by the new, more intuitive argument `background_lines` - the number of lines to draw in the background.
- remove leading and trailing whitespaces of events and groups before drawing 

# 0.6.0
- Hotfix for broken y-axis labelling (introduced through new plotly package 4.8.0.)
- events are now shown as circles (was: squares)
- corrected font colors of Presidents example on help page

# 0.5.0
- added a new argument `showLabels` to choose whether or not the event labels shall be drawn - improves layout of dense timelines
- new argument `lineInterval`: the distance in seconds that vertical lines shall be drawn (to reduce plot size and increase performance). When omitted, a heuristic (as before) is used.
- improved heuristic of vertical line drawing

# 0.4.0
- line width calculation for ranges improved (thicker lines if less events happening simultaneously)
- new parameter: `linewidth` to override the calculated line width for events
- layout and labelling improvements
- simplified examples
- improved error checking

# 0.3.0
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
- major improvement of intelligent levelling of ranges (" \_-\_&#175;-&#8212;")

# 0.2.0
- improved error checking
- various bugfixes

# 0.1.0
First public release on 29/01/2017
