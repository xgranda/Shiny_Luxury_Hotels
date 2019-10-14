
shinyUI(dashboardPage(
    dashboardHeader(title = "Europe's Luxury Hotels"),
    dashboardSidebar(
      
      sidebarMenu(
        menuItem(text = "Home", tabName = "Home",icon = icon("home")),
        menuItem(text = "Countries", tabName = "Countries",icon = icon("globe")), 
        menuItem(text = "Hotels", tabName = "Hotels",icon = icon("concierge-bell")),
        menuItem(text = "Reviewers", tabName = "Reviewers",icon = icon("users")), 
        menuItem(text = "Type of Trip", tabName = "Trip",icon = icon("suitcase-rolling")),
        menuItem(text = "Type of Traveller", tabName = "Traveller",icon = icon("smile")),
        menuItem(text = "About Me", tabName = "About Me",icon = icon("user"))
      )
    ),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "Home", 
                h2("Consumer Analysis of Luxury Hotel's in Europe", align="center"),
                h2("Summary:"),
                h4("This project shows what type of travelleres 
                  luxury hotels in Europe are receiving in popular cities
                   such as London, Paris, Amsterdam, Barcelona, etc."),
                h2("Objectives:"),
                h4("- What reasons motivate people to travel to the different cities and 
                hotels"),
                h4("- How many night's are people spending on the hotel depending the type of trip"),
                h4("- Are people travelling by themselves or in groups"),
                h4("- Scores they are giving based on their type of trip"),
                img(src= 'bedroom-door-entrance-271639.jpg', height=200, width=300, style="display: block; margin-left: auto; margin-right: auto;"),
                br(),
                h5("The dataset used for this analysis can be found",  
                a("here", href="https://www.kaggle.com/jiashenliu/515k-hotel-reviews-data-in-europe"))
        ),
        tabItem(tabName = "Countries", 
                h2("Location of Hotels", align="center"),
                leafletOutput("map_1")
                ),
        tabItem(tabName = "Hotels", 
                fluidRow(valueBoxOutput("max_Hotel_Box", width = 12))
                ),
        tabItem(tabName = "Reviewers",
                selectizeInput("Selected", 
                               "Select Nationality", 
                               select_nationality),
                fluidRow(valueBoxOutput("max_Reviewer_Box", width = 6),
                         valueBoxOutput("avg_num_night", width = 6)),
                         leafletOutput("map_2", height = 350)
                ),
        tabItem(tabName = "Trip", 
                box(selectizeInput("s_type_trip", 
                               "Select Type of Trip", 
                               trip_list), width = 12),
                fluidRow(box(htmlOutput("hotel_score"),width = 6),
                         box(htmlOutput("pie_trip"),width = 6)
                         ),
                box(htmlOutput("bar_night"), width = 12)
                ),
        tabItem(tabName = "Traveller",
                box(selectizeInput("t_trip", 
                                   "Select Type of Trip", 
                                   t_list), width = 12),
                box(htmlOutput("traveller_1"), width = 12)
                ),
        tabItem(tabName = "About Me", "About me information here")
      ),
      
      
      
      #Customize title (making it bold and changing it's letter size)
      tags$head(tags$style(HTML('
      .main-header .logo {
        font-weight: bold;
        font-size: 18px;
      }')))
    )
))