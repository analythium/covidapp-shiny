library(shiny)
library(jsonlite)
library(forecast)
library(ggplot2)
library(plotly)

source("functions.R")

regs <- fromJSON("https://hub.analythium.io/covid-19/api/v1/regions")
regs <- regs[regs$`province-state` == "",]

regs$location <- gsub(", Combined", "", regs$location)
regs$location <- gsub("\\*", "", regs$location)

choices <- structure(regs$slug, names = regs$location)
choices <- choices[order(names(choices))]
choices <- lapply(choices, c)
