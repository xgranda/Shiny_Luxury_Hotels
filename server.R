
shinyServer(function(input, output, session){


  
#Code for map that will show in Maps tab####
  output$map_1= renderLeaflet({
  address_filter=test_dataset %>% distinct(Hotel_Address, lat, lng)
    leaflet(address_filter) %>% 
      addTiles() %>% 
    addMarkers(lng =~lng, lat=~lat,clusterOptions = markerClusterOptions())
  })
  
#Hotel information Tab ####  

    hotel_1= reactive ({
      test_dataset %>% 
      filter(type_trip==input$h_trip) %>% 
      group_by(Hotel_Name) %>% tally() %>% top_n(5)
    })
    
  output$hotel_trip = renderGvis({
    
    gvisPieChart(hotel_1(), options = list(title="Top 5 Hotels"))
    
  })
  output$map_3= renderLeaflet({
    hotel_3=head(test_dataset %>% 
                   filter(type_trip=='Leisure trip') %>% 
                   group_by(Hotel_Name, lng, lat) %>% 
                   count(Hotel_Name) %>% arrange(desc(n)),5)
    
    leaflet(hotel_3) %>%
      addTiles() %>%
      addMarkers(lng =~lng, lat=~lat,clusterOptions = markerClusterOptions())
  })
  
  
  
#Type of trip graphs####
  output$pie_trip = renderGvis(gvisPieChart(summary_trip,
                                            options = list(title="Percentage of Types of Trips")))
  
  # output$hotel_score <- renderGvis({
  #   hotel_range_trip=test_dataset %>% 
  #     filter(type_trip==input$s_type_trip) %>% 
  #     group_by(score_range) %>% tally()
  #   
  #   gvisPieChart(hotel_range_trip)
  # })
  
  output$bar_night = renderGvis({
    night_trip= test_dataset %>%
      filter(type_trip==input$s_type_trip) %>%
      group_by(Reviewer_Nationality) %>% tally() %>% 
      rename(Number_of_Bookings=n)%>% 
      top_n(5)

    gvisBarChart(night_trip, 
                 options = list(title= "Top 5 Nationatlities",
                                            titleTextStyle="fontSize = 16",
                                            vAxes="[{title:'Nationalities'}]"))
  })

#Graphs for Traveller####
  
  output$traveller_1 = renderGvis({
    
    traveller_type= test_dataset %>%
      filter(type_trip==input$t_trip) %>%
      group_by(Tags_04) %>% tally()
    
    gvisPieChart(traveller_type,
                 options = list(title="Types of Travellers"))
  })
  
  output$night_1 = renderGvis({
    
    night_type= test_dataset %>%
      filter(type_trip==input$t_trip & Tags_04==input$n_trip) %>%
      group_by(nights_2) %>% tally()
    
    gvisColumnChart(night_type,
                 options = list(title="Number of nights"))
  })
  
  
#Graph for Timeline####
  
  output$time_1 = renderGvis({
    timeline= test_dataset %>% 
      filter(type_trip==input$time_trip & Year==input$time_trip_2) %>% 
      group_by(Review_Date) %>% tally()
    
    gvisLineChart(timeline)
    })
  
  output$time_2 <- renderGvis({
    timeline2= test_dataset %>% 
      filter(type_trip==input$time_trip & Year==input$time_trip_2) %>% 
      select(Review_Date, Reviewer_Score)
    
    gvisCalendar(timeline2, option=list(width="automatic", 
                                        height= 190))
  })
  
  
  
#Info box in reviewers tab that shows average review score for each country####
  output$max_Reviewer_Box <- renderValueBox({
  select_nationality = select_nationality[order(select_nationality$n, decreasing = T),]
  
  avg_score_nationality=test_dataset %>% 
    filter(Reviewer_Nationality==input$Selected) %>% 
    summarise(., average=mean(Reviewer_Score))

  avg_score_nationality=format(round(avg_score_nationality, 2), nsmall=2)
  
    valueBox(input$Selected, 
            paste0("Avg. Review Score: ", avg_score_nationality), 
            icon = icon("star-half-alt"))
  })
  
  output$avg_num_night <- renderValueBox({
    avg_nights = test_dataset %>% 
      filter(Reviewer_Nationality==input$Selected) %>% 
      summarise(., average=mean(nights_2))
    
    avg_nights = format(round(avg_nights, 2), nsmall=2)
    valueBox(input$Selected, 
             paste0("Avg. Number of Nights: ", avg_nights), 
             icon = icon("bed"))
  })
  
  # Most hotels attended by reviewers nationality####
  output$map_2= renderLeaflet({
    hotel_filter=test_dataset %>% 
      filter(Reviewer_Nationality==input$Selected) %>% 
      distinct(Hotel_Address, lat, lng)
    leaflet(hotel_filter) %>%
      addTiles() %>%
      addMarkers(lng =~lng, lat=~lat,clusterOptions = markerClusterOptions())
  })

})
