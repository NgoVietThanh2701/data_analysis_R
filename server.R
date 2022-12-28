
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
      my_data %>%
      plot_ly() %>%
      add_histogram(~get(input$select_distribution)) %>%
      layout(xaxis = list(title = input$select_distribution), yaxis = list(title = 'Số lượng'))
  })
  
  # discrete var
  output$plot_age <- renderPlot({
    age_group <-cut(my_data$age, breaks = c(18, 21 ,24, 27, 30, 34, 41))
    weight <- cut(my_data$weight, 2)
    group <-table(cut(my_data$weight , 2), age_group)
    barplot(group, main="Thống kê cân nặng của cầu thủ theo nhóm tuổi",
            beside=TRUE, xlab="Nhóm tuổi", ylab = 'Tần suất', col = c("red","green"))
    legend("topleft", c('(59,79.5]', '(79.5,100]'), fill = c("red","green"))
  })
  
  # ---------------------------------------------- linear regression
  
  # height & weight
  
  linear_model1 <- lm(my_data$weight ~ my_data$height, data = my_data)
  
  output$summary1 <- renderPrint({
    summary(linear_model1)
  })
  
  output$anova1 <- renderPrint({
    anova(linear_model1) # phuong sai
  })
  
  output$ncv_test <- renderPrint({
    ncvTest(linear_model1) 
  })
  
  output$plot_linear1 <- renderPlot({
    plot(my_data$height, my_data$weight, pch=18, ylab="Cân nặng", xlab = "Chiều cao", col='blue')
    abline(linear_model1, lwd=2, col='red')
    abline(lm(my_data$weight ~ my_data$weight), col='green')
  })
  
  # kiem tra dao động dư
  output$resi_plot1 <- renderPlot({ 
    res = resid(linear_model1)
    hist(res) # dao động dư = gt quan sát - gt tiên lượng
  })
  
  # kiem tra phuon sai
  output$variance_plot1 <- renderPlot({ 
    spreadLevelPlot(linear_model1) # đồ thị chẩn đoán phương sai sai số thay đổi theo sự tăng lên của gt tiên lượng
  })
  
  # kiểm tra tính tuyến tính
  output$non_linearity <- renderPlot({
    crPlots(linear_model1)
  })
  
  # kierm tra gia tri bien
  output$outliers <- renderPrint({
    outlierTest(linear_model1)
  })
}


















