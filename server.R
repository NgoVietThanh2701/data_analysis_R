
function(input, output, session) {
  
  #----------------------------------------------------- question 1
  
  # Structure
  output$structure <- renderPrint(
    #structure of the data
    my_data %>%
      str() # xem cau truc dl
  )
  
  # Summary
  output$summary <- renderPrint(
    my_data %>% 
      summary() # xem tong quat
  )
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('player-2020', ".csv", sep = "")
    },
    content = function(file) {
      write.csv(my_data, file, row.names = FALSE)
    }
  )
  
  # Data Table output
  
  output$dataFilter <- renderDataTable({
    
    if(is.null(input$filter_1) & is.null(input$filter_2) & is.null(input$filter_3)) {
      my_data
    } else if(!is.null(input$filter_1 )) {
        if(is.null(input$filter_2) && is.null(input$filter_3) ) {
            filter(my_data, my_data$nationality == input$filter_1)
        } else if(!is.null(input$filter_2) & !is.null(input$filter_3)) {
            filter(my_data, my_data$nationality == input$filter_1 & my_data$club == input$filter_2 & my_data$age==input$filter_3)
        } else if(!is.null(input$filter_2) & is.null(input$filter_3)) {
          filter(my_data, my_data$nationality == input$filter_1 & my_data$club == input$filter_2)
        } else if(is.null(input$filter_2) & !is.null(input$filter_3)) {
          filter(my_data, my_data$nationality == input$filter_1 & my_data$age == input$filter_3)
        }
    } else {
      my_data
    }
      
  })
  
  output$dataTable <- renderDataTable( # lam sach dataset
    if(is.null(input$checkGroupClear)) { # dont choose checkbox
      my_data_raw
    } else if(length(input$checkGroupClear) == 1) { # choose one
        if(input$checkGroupClear == 'row') {
          if(input$valueReplace=='') {
            my_data_raw %>%
              janitor::clean_names()
          } else {
            replace(my_data_raw, is.na(my_data_raw), input$valueReplace)
          }
        } else if(input$checkGroupClear == 'NA'){
          my_data_raw %>%
            na.omit(my_data_raw) 
        }
    } else if(length(input$checkGroupClear) == 2){ # choose two
        my_data
    } 
  )
  
  # draw chart for percent NA 
  output$chart_na <- renderPlotly({
    gg_miss_var(my_data_raw %>% janitor::clean_names())
  })
  
  #----------------------------------------------------------------- question 2 -------------------------------
  
  # statistical trends player
  
  output$trends_player <- renderPlotly({
    my_data_head100 %>% 
      plot_ly() %>%
      add_bars(x=~nationality, y=~get(input$select_var1)) %>% 
      layout(title = paste(input$select_var1, "của các cầu thủ"),
             xaxis = list(title = "Quốc gia"),
             yaxis = list(title =  input$select_var1 ))
  })
  
  # Rendering the box header
  output$head1 <- renderText(
    paste("5 Quốc gia cầu thủ có", input$select_var1, "cao nhất")
  )

  # Rendering the box header
  output$head2 <- renderText(
    paste("5 Quốc gia cầu thủ có", input$select_var1, "thấp nhất")
  )

  # rendering table with 5 nationality 
  output$top5_nationality <- renderTable({
    my_data %>%
      select(nationality, input$select_var1) %>%
      arrange(desc(get(input$select_var1))) %>%
      head(5)
  })

  # rendering table with 5 nationality 
  output$low5_nationality <- renderTable({
    my_data %>%
      select(nationality, input$select_var1) %>%
      arrange(get(input$select_var1)) %>%
      head(5)
  })
  
  #  correlation plot
  output$correlation_plot <- renderPlotly({
    my_df <- my_data %>% select("age", "potential", "value", "wage")

    # Compute a correlation matrix
    corr <- round(cor(my_df), 1)

    # Compute a matrix of correlation p-values
    p.mat <- cor_pmat(my_df)

    corr.plot <- ggcorrplot(
      corr,
      hc.order = TRUE,
      lab= TRUE,
      outline.col = "white",
      p.mat = p.mat
    )
    ggplotly(corr.plot)

  })
  
  # distribution plot
  output$distribution <- renderPlotly({
    p = my_data %>%
      plot_ly() %>%
      add_histogram(~get(input$select_distribution)) %>%
      layout(xaxis = list(title = input$select_distribution), yaxis = list(title = 'Số lượng'))
  })
  
  # #For histogram - distribution charts
  # output$histplot <- renderPlotly({
  #   p1 = my_data %>%
  #     plot_ly() %>%
  #     add_histogram(~get(input$var1)) %>%
  #     layout(xaxis = list(title = input$var1))
  #   
  #   # box plot
  #   p2 = my_data %>% 
  #     plot_ly() %>%
  #     add_boxplot(~get(input$var1)) %>%
  #     layout(yaxis = list(showticklabels = F))
  #   
  #   #  stacking the plots on top of each other
  #   subplot(p2, p1, nrows = 2) %>%
  #    hide_legend() %>%  # an chu thich
  #     layout(title = "distribution chart - Histogram and Boxplot",
  #            yaxis = list(title = "Frequency"))
  #   
  # })
  # 
  # # scatter charts
  # output$scatter <- renderPlotly({
  #   # creating scatter plot for ralationship using ggplot
  #   p = my_data %>%
  #     ggplot(aes(x=get(input$var3), y=get(input$var4))) +
  #     geom_point() +
  #     geom_smooth(method=get(input$fit)) + 
  #     labs(title = paste("Relation b/w" , input$var3, "and" , input$var4),
  #          x = input$var3,
  #          y = input$var4) +
  #     theme(plot.title = element_textbox_simple(size=10, halign=0.5))
  #   
  #   # applied ggplot to make it interactive
  #   ggplotly(p)
  # })
  # 
  # 
  
  # # Choropleth map
  # output$map_plot <- renderPlot({
  #   new_join %>% 
  #     ggplot(aes(x=long, y=lat,fill=get(input$crimetype) , group = group)) +
  #     geom_polygon(color="black", size=0.4) +
  #     scale_fill_gradient(low="#73A5C6", high="#001B3A", name = paste(input$crimetype, "Arrest rate")) +
  #     theme_void() +
  #     labs(title = paste("Choropleth map of", input$crimetype , " Arrests per 100,000 residents by state in 1973")) +
  #     theme(
  #       plot.title = element_textbox_simple(face="bold", 
  #                                           size=18,
  #                                           halign=0.5),
  #       
  #       legend.position = c(0.2, 0.1),
  #       legend.direction = "horizontal"
  #       
  #     ) +
  #     geom_text(aes(x=x, y=y, label=abb), size = 4, color="white")
  #   
  #   
  #   
  # })
  # 
}


















