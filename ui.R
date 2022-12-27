
# dashboard has three parts: a header, a sidebar and a bod
dashboardPage(
  dashboardHeader(title = "Phân tích cầu thủ bóng đá", 
                  titleWidth =  230,
                  tags$li(class="dropdown",tags$a("Nhóm 9"))
                  ),
  #--------------
  dashboardSidebar(
    # sidebar Menu
    sidebarMenu(
      id = "sidebar",
      menuItem("1. Làm sạch dữ liệu", tabName = "question_1"),
      # --------------------------------
      menuItem("2. Phân tích thống kê", tabName = 'question_2'),
        conditionalPanel("input.sidebar=='question_2' && input.tab2 == 'trends' ",
            selectInput(inputId = "select_var1", label="Chọn biến", choices = c1)), 
        conditionalPanel("input.sidebar == 'question_2' && input.tab2 == 'tab_distribution' ",
            selectInput(inputId = "select_distribution", label="Chọn biến", choices = my_data %>% select("age", "potential", "value", "wage") %>% names() )),
      # ---------------------------------
      menuItem("3. Mô hình hồi quy tuyến tính", tabName = "question_3")
    )
  ),
  #---------------
  dashboardBody(
    tags$style(".downloadbtn { margin-top:40px }"),
    tabItems(
      #---------- first tab item
      tabItem(tabName = "question_1",
              #tab box
              tabBox(id="tab1", width = '100%',
                     tabPanel("About", icon=icon("address-card"), 
                         fluidRow(
                           column(width = 8, tags$img(src="player.jpg", width=840, height=570),
                                 tags$br(),
                                 tags$a("Photo by Campbell Jensen on Unsplash"), align="center"),
                           column(width = 4, 
                                 tags$br(),
                                 tags$p("This data set comes along with base R and contains statistics, 
                                        in arrests per 100,000 residents for assault, murder, and rape in 
                                        each of the 50 US states in 1973. Also, given is the percent of 
                                        the population living in urban areas."))     
                        )
                     ),
                     tabPanel(title = "Data", icon=icon("table"),
                              fluidRow(
                                column(2, checkboxGroupInput("checkGroupClear", label = h4("Làm sạch"), choices = list("Cột" = "row", "NULL" = "NA"), selected = NULL,inline=TRUE)),
                                column(3, textInput("valueReplace", label = h5("Thay thế NA"), value = '', width = '300px')),
                                column(3, downloadButton("downloadData", "Download", class='downloadbtn')),
                              ),
                              tags$div(withSpinner(dataTableOutput("dataTable")), style='overflow-x: scroll; height:510px'),
                     ),
              )
      ),
      #------------ second tab item 
      tabItem(tabName = 'question_2',
              tabBox(id="tab2", width = 12,
                     tabPanel(title = 'Bộ lọc', value='fliter',  
                              fluidRow(
                                column(2, h4('Chọn bộ lọc'), 
                                       selectInput(inputId = 'filter_1',label = "Quốc gia", choices = my_data %>% select("nationality"), multiple = TRUE,),
                                       selectInput(inputId = 'filter_2',label = "Câu lạc bộ", choices = my_data %>% select("club"),   multiple = TRUE,),
                                       selectInput(inputId = 'filter_3',label = "Tuổi", choices = my_data %>% select("age"), multiple = TRUE, ),                           
                                ),
                                column(10,  tags$div( style='overflow-x: scroll; height:600px', withSpinner(dataTableOutput("dataFilter")))), 
                              )
                              
                     ),
                     tabPanel(title="Chart NA", icon=icon("uncharted"), withSpinner(plotlyOutput("chart_na"))),
                     tabPanel(title="Structure", icon=icon("uncharted"), verbatimTextOutput("structure")),
                     tabPanel(title="Sumary Status", icon=icon("chart-pie"), verbatimTextOutput("summary")),
                     tabPanel("Xu hướng cầu thủ", value="trends",
                          fluidRow(
                            tags$div(align="center", box(tableOutput("top5_nationality"), title = textOutput("head1"), collapsible = TRUE,
                                  status = "primary", collapsed = TRUE, solidHeader = TRUE)),
                            tags$div(align="center", box(tableOutput("low5_nationality"), title = textOutput("head2"), collapsible = TRUE,
                                  status = "primary", collapsed = TRUE, solidHeader = TRUE))
                          ),withSpinner(plotlyOutput("trends_player", height = '500px'))),
                     tabPanel(title = 'Tương quan', plotlyOutput("correlation_plot")),
                     tabPanel(title = 'Phân bố', value = 'tab_distribution', withSpinner(plotlyOutput("distribution")))
                     
              #        tabPanel(title = "Distribution", value="distro", plotlyOutput("histplot")),
              #        tabPanel(title="Correlation Matrix", plotlyOutput("cor")),
              #        tabPanel(title="Sumary Status", value = "relation", 
              #           radioButtons(inputId = "fit", label = "Select smooth method", choices = c("loess", "lm"), inline = TRUE),      
              #                 withSpinner(plotlyOutput("scatter")))
              )
      ),
      #-------------- third tab Item
      tabItem(tabName = "question_3",
              # box(selectInput("crimetype","Select Arrest Type", choices = c2, 
              #     selected="Rape", width = 250),
              #     withSpinner(plotOutput("map_plot")), width = 12) 
              #   # withSpinner for loading 
      )
    )
  )
)






