
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
        # conditional 
        # conditionalPanel("input.sidebar=='viz' && input.t2=='distro' ",
        #     selectInput(inputId = "var1", label="Chọn biến", choices = c1)),
        # # condition 
        # conditionalPanel("input.sidebar=='viz' && input.t2=='trends' ",
        #     selectInput(inputId = "var2", label="Chọn loại Arrest", choices = c2)),
        # # condition
        # conditionalPanel("input.sidebar=='viz' && input.t2=='relation' ",
        #     selectInput(inputId = "var3", label="Select the X variable", choices = c1, selected = "Rape")),
        # # condition
        # conditionalPanel("input.sidebar=='viz' && input.t2=='relation' ",
        #     selectInput(inputId = "var4", label="Select the Y variable", choices = c1, selected = "Assault")),
      # ---------------------------------
      menuItem("3. Mô hình hồi quy tuyến tính", tabName = "question_3")
    )
  ),
  #---------------
  dashboardBody(
    tabItems(
      #----------first tab item
      tabItem(tabName = "question_1",
              #tab box
              tabBox(id="tab_1", width = 12,
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
                              style='overflow-x: scroll; height:600px', 
                              fluidRow(
                                column(2, checkboxGroupInput("checkGroupClear", label = h4("Làm sạch"), choices = list("Cột" = "row", "NULL" = "NA"), selected = NULL,inline=TRUE)),
                                column(6, textInput("valueReplace", label = h4("Thay thế NA"), value = '', width = '300px',)),
                              ),
                              withSpinner(dataTableOutput("dataTable")),
                     ),
                     tabPanel(title="Chart NA", icon=icon("uncharted"), withSpinner(plotlyOutput("chart_na"))),
                     tabPanel(title="Structure", icon=icon("uncharted"), verbatimTextOutput("structure")),
                     tabPanel(title="Sumary Status", icon=icon("chart-pie"), verbatimTextOutput("summary")),
              )
      ),
      #------------second tab item or landing page...
      tabItem(tabName = 'question_2',
              # tabBox(id="t2", width = 12,
              #        tabPanel("Crime Trends by State", value="trends", 
              #             fluidRow(
              #               tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1"), collapsible = TRUE, 
              #                     status = "primary", collapsed = TRUE, solidHeader = TRUE)),
              #               tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2"), collapsible = TRUE, 
              #                     status = "primary", collapsed = TRUE, solidHeader = TRUE))
              #             ),withSpinner(plotlyOutput("bar"))),
              #        tabPanel(title = "Distribution", value="distro", plotlyOutput("histplot")),
              #        tabPanel(title="Correlation Matrix", plotlyOutput("cor")),
              #        tabPanel(title="Sumary Status", value = "relation", 
              #           radioButtons(inputId = "fit", label = "Select smooth method", choices = c("loess", "lm"), inline = TRUE),      
              #                 withSpinner(plotlyOutput("scatter")))
              # )
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






