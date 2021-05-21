#' Get data from JSON API
#'
#' @param region character ID for a region according to the slug property on this endpoint: https://hub.analythium.io/covid-19/api/v1/regions
#' @return A list with the region name and the raw data returned by the API
get_data <- function(region) {
    u <- paste0("https://hub.analythium.io/covid-19/api/v1/regions/", region)
    x <- jsonlite::fromJSON(u)
    list(
        region=region,
        data=x)
}

#' Process data
#'
#' @param x a list as returned by `get_data()`
#' @param cases character, `"confirmed"` or `"deaths"`
#' @param last character (`"YYYY-MM-DD"` format) or date/time, the last day of the time series to use (last day is taken from data when missing)
#' @return A list with processed time series data appended
process_data <- function(x, cases, last) {
    if (missing(cases))
        cases <- "confirmed"
    cases <- match.arg(cases, c("confirmed", "deaths"))
    y <- pmax(0, diff(x$data$rawdata[[cases]]))
    z <- as.Date(x$data$rawdata$date[-1])
    if (!missing(last)) {
        last <- min(max(z), as.Date(last))
        y <- y[z <= last]
        z <- z[z <= last]
    } else {
        last <- z[length(z)]
    }
    x$cases <- cases
    x$last <- last
    x$y <- y
    x
}

#' Fit model to time series data
#'
#' @param x a data list object as returned by `process_data()`
#' @return A list with fitted model appendes
fit_model <- function(x, ...) {
    m <- ets(x$y, ...)
    x$model <- m
    x
}

#' Forecast time series
#'
#' @param x a list object with fitted time series model as returned by `fit_model()`
#' @param window numeric (>= 1), forecast window in days, rounded to nearest integer
#' @param level prediction interval
#' @return A list with model model forecast
predict_model <- function(x, window=14, level = 95, ...) {
    window <- round(window)
    if (window < 1)
        stop("window must be > 0")
    p <- cbind(
      Date=seq(x$last+1, x$last+window, 1),
      as.data.frame(forecast(x$model, h=window, level=level, ...)))
    p[p < 0] <- 0
    colnames(p) <- c("Date", "PointForecast", "Lo", "Hi")
    x$window <- window
    x$level <- level
    x$prediction <- p
    x
}

#' Plot time series and forecast
#'
#' @param x a list object with fitted time series model and forecast as returned by `predict_model()`
#' @return A ggplot object
plot_all <- function(x) {
  Scale <- max(1, 1000 *
      (nchar(max(x$data$rawdata[[x$cases]])) %/% 3 - 1))
  x1 <- data.frame(
      y = pmax(0, diff(x$data$rawdata[[x$cases]]))/Scale,
      date = as.Date(x$data$rawdata$date[-1]))
  x2 <- data.frame(
      y = x$prediction$PointForecast/Scale,
      date = as.Date(x$prediction$Date))
  z1 <- with(x$prediction,
      data.frame(
          ymin=Lo/Scale,
          ymax=Hi/Scale,
          y=PointForecast/Scale,
          PI=rep(paste0(x$level, "%"), x$window),
          date=Date))
  p <- ggplot(x1, aes(x=date, y=y)) +
      geom_ribbon(aes(x=date, ymin=ymin, ymax=ymax, fill=PI),
                  data=z1, alpha=0.7, fill="#047adc") +
      geom_line(col="#564d70") +
      geom_line(aes(x=date, y=y), x2, col="#ffffff") +
      labs(title=paste0(gsub(", Combined", "", x$data$region$location),
              " - from ", x$data$rawdata$date[1], " to ",
              x$data$rawdata$date[length(x$data$rawdata$date)])) +
      xlab("Date") +
      ylab(paste(
          if (x$cases == "deaths") "New Deaths" else "New Confirmed Cases",
          if (Scale > 1) paste0("(x", Scale, ")") else "")) +
      theme_minimal()
  p
}
