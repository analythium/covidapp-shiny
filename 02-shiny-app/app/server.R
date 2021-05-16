server <- function(input, output) {
  raw <- reactive({
    req(input$region)
    get_data(input$region)
  })
  proc <- reactive({
    req(raw())
    process_data(raw(),
      cases = input$cases)
  })
  mod <- reactive({
    req(proc())
    fit_model(proc())
  })
  pred <- reactive({
    req(mod())
    predict_model(mod(),
      window = input$window,
      level = input$level)
  })
  plot <- reactive({
    req(pred())
    plot_all(pred())
  })
  output$ggplot2 <- renderPlot({
    req(plot())
    plot()
  })
  output$ggplotly <- renderPlotly({
    req(plot())
    ggplotly(plot()) %>%
      config(displayModeBar = FALSE)
  })
  output$plot <- renderUI({
    tagList(
      if (input$plotly)
        plotlyOutput("ggplotly") else plotOutput("ggplot2")
    )
  })
}
