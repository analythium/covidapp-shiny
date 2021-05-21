ui <- fluidPage(
  titlePanel("COVID-19 Shiny App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("region",
        label = "Country/Region",
        choices = choices,
        selected = "canada-combined"),
      radioButtons("cases",
        label = "Cases",
        choices = c(
          "Confirmed" = "confirmed",
          "Deaths"="deaths")),
      numericInput("window",
        label = "Time window (days)",
        value = 14,
        min = 1,
        max = 30),
      sliderInput("level",
        label = "Level",
        min = 10,
        max = 99,
        value = 95,
        step = 1),
      hr(),
      checkboxInput("plotly",
        label = "Use Plotly"),
      HTML(paste0("<p><small>Global data set by JHU, details at ",
        "<a href='https://github.com/analythium/covid-19#readme'>",
        "analythium/covid-19</a></small></p>"))),
    mainPanel(
      uiOutput("plot")))
)
