# 1. data
origData <- read.csv(text="event,group,start,end,color
P..,Project,2016-12-22,2016-12-23,#c8e6c9
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
1-399.7,moon rising,2017-01-13,2017-01-13,#f44336
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


#2. standard parameters
col.event="event"
col.start="start"
col.end="end"
col.group="group"
col.color="color"
col.fontcolor="fontcolor"
col.tooltip="tooltip"
title=NULL

gg_vistime(origData, background_lines = 100)
hc_vistime(origData)
