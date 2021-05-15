#' ---
#' output:
#'   md_document:
#'     variant: gfm
#' ---
#' # COVID-19 app with Shiny
#' > Workflow
#' Load required packages
suppressPackageStartupMessages({
library(forecast)
library(jsonlite)
library(ggplot2)
library(plotly)
})
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = ""
)
#' Source the functions
source("functions.R")
#' Get the table listing the regions/coutries and their slugified ID
#+eval=FALSE
r <- fromJSON("https://hub.analythium.io/covid-19/api/v1/regions")
r$slug
#' Pich an ID, get/process the data, fit/forecast an ETS model
pred <- "canada-combined" %>%
  get_data() %>%
  process_data(cases="confirmed", last="2021-05-01") %>%
  fit_model() %>%
  predict_model(window=30, level=95)
#' Inspect the forecast and prediction intervals
head(pred$prediction)
#' Plot the time series and forecast
p <- plot_all(pred)
#+ covid-19,fig.width=8,fig.height=5
p
#' Turn the plot into a plotly widget
#+ eval=FALSE
ggplotly(p)
