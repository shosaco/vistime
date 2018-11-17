#' Heuristic for background lines in timeline graph
#'
#' Guesses the total range of data and calculates an appropriate background line
#' interval. If \code{lineInterval} is provided, checks if that is appropriate and
#' prints a warning message otherwise.
#'
#' @param data \code{data.frame} with (at least) columns \code{start} and \code{end}
#' @param lineInterval (optional) integer with suggested result (line interval
#'   in seconds)
#'
#' @return an integer (distance in seconds to draw background lines)
#'
#' @examples
#' # range is 10 days, result is 2-day-line interval
#' heuristic_lineInterval(data.frame(start = Sys.Date() - 10, end = Sys.Date() - 1))
#'
#' @keywords internal

heuristic_lineInterval <- function(data, lineInterval = NULL) {
  total_range <- difftime(max(data$end), min(data$start), units="secs")

  if(is.null(lineInterval)){
    if(total_range <= 60*60*3){ # max 3 hours
      lineInterval <- 60*10 # 10-min-lineIntervals
    }else if(total_range < 60*60*24){ # max 1 day
      lineInterval <- 60*60*2 # 2-hour-lineIntervals
    }else if(total_range < 60*60*24*30){ # max 30 days
      lineInterval <- 60*60*24*2 # 2-day-lineIntervals
    }else if(total_range < 60*60*24*365/2){ # max 0.5 years
      lineInterval <- 60*60*24*7 # 7-day-lineIntervals
    }else if(total_range < 60*60*24*365){ # max 1 year
      lineInterval <- 60*60*24*7*2 # 2-week-lineIntervals
    }else if(total_range < 60*60*24*365*10){ # max 10 years
      lineInterval <- 60*60*24 *30*6 # 6-months-lineIntervals
    }else if(total_range < 60*60*24*365*20){ # max 20 years
      lineInterval <- 60*60*24*30*24 # 24-months-lineIntervals
    }else{
      lineInterval <- 60*60*24 *30*12*10 # 10-year-lineIntervals
    }
  }else{
    if(total_range > lineInterval * 1000) message("Warning: lineInterval is small while total range of events is large - yields a very big plot in terms of memory.")
  }

  return(lineInterval)
}
