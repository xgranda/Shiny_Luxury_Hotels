
shinyServer(function(input, output, session){

  
#Code for map that will show in Maps tab####
  output$map_1= renderLeaflet({
  address_filter=test_dataset %>% distinct(Hotel_Address, lat, lng)
    leaflet(address_filter) %>% 
      addTiles() %>% 
    addMarkers(lng =~lng, lat=~lat,clusterOptions = markerClusterOptions())
  })
  
#Hotel information Tab ####  
  # output$max_Hotel_Box <- renderValueBox({
  #   select_hotel = test_dataset %>% 
  #     group_by(Hotel_Name) %>% 
  #     tally()
  #   select_hotel = select_hotel[order(select_hotel$n, decreasing = T),]
  #   
  #   avg_score_hotel=test_dataset %>% 
  #     filter(Hotel_Name==input$selec_hotel) %>% 
  #     summarise(., average=mean(Average_Score))
  #   
  #   avg_score_hotel=format(round(avg_score_hotel, 2), nsmall=2)
  #   
  #   valueBox(input$selec_hotel, 
  #            paste0("Avg. Score: ", avg_score_hotel), 
  #            icon = icon("star-half-alt"))
  # })
  
  output$max_Hotel_Box <- renderValueBox({
    select_hotel = test_dataset %>%
      group_by(Hotel_Name) %>%
      tally()
    select_hotel = select_hotel[order(select_hotel$n, decreasing = T),]
    
    valueBox(subtitle = "Most Visited Hotel",
             value = select_hotel,
             icon = "trophy")
  })
  
#Type of trip graphs####
  
  summary_trip= test_dataset %>% group_by(type_trip) %>% tally()
  summary_trip= summary_trip %>% 
    filter(!(type_trip=='With a pet'))
  
  trip_list=summary_trip %>% select(type_trip)
  
  
  output$pie_trip = renderGvis(gvisPieChart(summary_trip,
                                            options = list(title="Percentage of Types of Trips")))
  
  output$hotel_score <- renderGvis({
    hotel_range_trip=test_dataset %>% 
      filter(type_trip==input$s_type_trip) %>% 
      group_by(score_range) %>% tally()
    
    gvisPieChart(hotel_range_trip)
  })
  
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
t_list= summary_trip %>% select(type_trip)
  
  output$traveller_1 = renderGvis({
    
    traveller_type= test_dataset %>%
      filter(type_trip==input$t_trip) %>%
      group_by(Tags_04) %>% tally()
    
    
    gvisBarChart(traveller_type, 
                 options = (title="Types of Travellers"))
    
  })
  
  
  
  
#Info box in reviewers tab that shows average review score for each country####
  output$max_Reviewer_Box <- renderValueBox({
  select_nationality = test_dataset %>% 
    group_by(Reviewer_Nationality) %>% 
    tally()
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
