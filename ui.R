
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
    tags$style(".qs3_tab1_linear {width: 600px; margin-top:auto}"),
    tags$style(".p {font-size: 18px; color: red}"),
    tabItems(
      #---------- first tab item
      tabItem(tabName = "question_1",
              #tab box
              tabBox(id="tab1", width = '100%',
                     tabPanel("About", icon=icon("address-card"), 
                         fluidRow(
                           column(width = 8, tags$img(src="player.jpg", width=830, height=570),
                                 tags$a("Cầu thủ nổi tiếng năm 2020"), align="center"),
                           column(width = 4, 
                                 tags$p("Đây là dữ liệu thống kê về cầu thủ bóng đá năm 2020. Gồm các biến sau: "),
                                 tags$p('ID: id cầu thủ là duy nhất'),
                                 tags$p('Name: Tên cầu thủ'),
                                 tags$p('Age: Tuổi cầu thủ'),
                                 tags$p('Dob: Ngày sinh'),
                                 tags$p('Height: Chiều cao'),
                                 tags$p('Weight: Cân nặng'),
                                 tags$p('Nationality: quốc gia'),
                                 tags$p('Club: câu lạc bộ đang thi đấu'),
                                 tags$p('Overall: đánh giá tổng quan về cầu thủ'),
                                 tags$p('Potential: id cầu thủ là duy nhất'),
                                 tags$p('Value: giá trị của cầu thủ'),
                                 tags$p('Wage: Tiền lương'),
                                 tags$p('Play Positions: chơi ở vị trí'),
                                 tags$p('Preferred Foot: Chân thuận'),
                                 tags$p('Skill Moves: kĩ năng di chuyển'),
                                 tags$p('Release Clause: Khoảng tiền để giải phóng hợp đồng'),
                                 tags$p('Jersey Number: Số áo đang mặc'),
                                 tags$p('Joined: thời gian tham gia'),
                                 tags$p('Contract Valid Until: thời gian hợp đồng kết thúc')
                          )
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
                     tabPanel(title = 'Phân bố', value = 'tab_distribution', withSpinner(plotlyOutput("distribution"))),
                     tabPanel(title = "Độ tuổi",value='age', withSpinner(plotOutput("plot_age")))
                     
              )
      ),
      #-------------- third tab Item
      tabItem(tabName = "question_3",
              tabBox(id='tab3', width = 16,
                tabPanel(title = 'cân nặng & chiều cao',
                         fluidRow(
                           column(7, withSpinner(plotOutput("plot_linear1"))),
                           column(5, tabsetPanel(
                             tabPanel("Dao động dư", withSpinner(plotOutput("resi_plot1"))),
                             tabPanel("Phương sai", withSpinner(plotOutput("variance_plot1"))),
                             tabPanel("Tính tuyến tính", withSpinner(plotOutput("non_linearity"))),
                             ))
                         ), 
                         fluidRow(
                           column(6, tabsetPanel(
                              tabPanel("summary",verbatimTextOutput("summary1")),
                              tabPanel('anova',verbatimTextOutput('anova1')),
                              tabPanel('Phương sai',verbatimTextOutput('ncv_test')),
                              tabPanel('Gía trị biên',verbatimTextOutput('outliers')),
                             )),
                           column(6,  
                              tags$p('Mô hình: weight = -80.56 + 0.866 * height', class='p'),
                              tags$p('Nếu không biết height -> weight = mean(weight) = 77.46032'),
                              tags$p('Nếu biết height ->tại height = 170 => weight = -80.56 + 0.866 * 170 = 66.66'),
                              tags$p('Tổng số dao động: TSS = 33368 + 18991 = 52359'),
                              tags$p('Hệ số xác định: R^2 = 33368/TSS = 63.72%')
                            )
                         ), 
              
                )
              )
              # box(selectInput("crimetype","Select Arrest Type", choices = c2, 
              #     selected="Rape", width = 250),
              #     withSpinner(plotOutput("map_plot")), width = 12) 
              #   # withSpinner for loading 
      ) # end tab item
    )
  )
)






