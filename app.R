library(tidyverse)
library(shiny)
library(httr)
library(sf)
library(units)
library(geofacet)
library(shinythemes)

# Load Data & Filter to Rwanda
rwanda_distance <- read_csv("DHS_distance.csv") %>%
  filter(country  == "Rwanda") %>%
  mutate(year_of_interest = ifelse(dhsyear %in% c(2014, 2015, 2016), 1, 0)) %>%
  filter(year_of_interest == 1) %>%
  select(-c("year_of_interest"))


rwanda_time_travel <- read_csv("013_DHS_traveltime.csv") %>%
  filter(country  == "Rwanda") %>%
  mutate(year_of_interest = ifelse(dhsyear %in% c(2014, 2015, 2016), 1, 0)) %>%
  filter(year_of_interest == 1) %>%
  select(-c("country","country_code", "end_year","year_of_interest", "dhsregco", "dhsregna", "dhsyear", "URBAN_RURA",
            "latnum", "longnum", "v001"))

rwanda_pop <- read_csv("003_DHS_main.csv") %>%
  filter(country  == "Rwanda") %>%
  mutate(year_of_interest = ifelse(dhsyear %in% c(2014, 2015, 2016), 1, 0)) %>%
  filter(year_of_interest == 1) %>%
  select(-c("country","country_code", "end_year","year_of_interest", "dhsregco", "dhsregna", "dhsyear", "URBAN_RURA",
            "latnum", "longnum", "v001"))

rwanda_df <- rwanda_distance %>%
  full_join(rwanda_time_travel, by = "dhsid", na_matches ="never") %>%
  full_join(rwanda_pop, by = "dhsid", na_matches ="never") 
  
# Fourth-level Administrative Divisions, Rwanda, 2015 
# https://earthworks.stanford.edu/catalog/stanford-kt081vp3812
rwanda_sf <- st_read(dsn = "rwanda_sf.shp")

# Second-level Administrative Divisions, Rwanda, 2015 
# https://earthworks.stanford.edu/catalog/stanford-qy869sx9298
second_rwanda_sf <- st_read(dsn = "second_rwanda_sf.shp")

rwanda_region <- sort(unique(rwanda_distance$dhsregna))

color_palette <- c("#D81B60", "#1E88E5", "#FFC107", "#004D40")


# Define UI 
ui <- fluidPage(
  # Theme
  theme = shinytheme("simplex"),
  
  # Application title
  titlePanel("Traveling to a City in The Land of a Thousand Hills"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      p("The data points of this visualizations are the clusters defined by the 2015 Demographic and Health Surveys (DHS) Program conducted in Rwanda."),
      p("All data from this visualization came from the Advancing Research on Nutrition and Agriculture DHS-GIS Data by the International Food Policy Research Institute.
        Please check the source for further information of the data set."),
      br(),
      selectizeInput("selected_region", "Region (Up to four)", 
                     choices = rwanda_region, 
                     multiple = TRUE, 
                     selected = c("Musanze","Nyagatare"),
                     options = list(maxItems = 4)),
      sliderInput("distance", "Distance to Travel (km)",
                  min = 0,
                  max = max(rwanda_distance[,c("dist_100k", "dist_20k", "dist_50k","dist_250k","dist_500k")]),
                  value = c(0, max(rwanda_distance[,c("dist_100k", "dist_20k", "dist_50k","dist_250k","dist_500k")])),
                  post = "km"),
      sliderInput("time", "Time to Travel (minutes)",
                  min = 0,
                  max = max(rwanda_time_travel[,c("tt00_100k", "tt00_20k", "tt00_250k", "tt00_500k", "tt00_50k")]),
                  value = c(300, max(rwanda_time_travel[,c("tt00_100k", "tt00_20k", "tt00_250k", "tt00_500k", "tt00_50k")])),
                  post = "min"),   
      radioButtons("city_pop",
                   "To the City with Over Certain Number of Population:",
                   choices = c(
                     "City Over 20,000 People" = "20k",
                     "City Over 50,000 People" = "50k",
                     "City Over 100,000 People" = "100k",
                     "City Over 250,000 People" = "250k",
                     "City Over 500,000 People" = "500k"),
                   selected = c("50k")
      ),
   
      
    ),
    
    # Show a plot
    mainPanel(
      
      # Header
      h1("How much time did Rwandan have to spend to travel to the Nearest City in 2015?"),
      br(),
      p("Rwanda is a small country. It is small enough to travel to one end of the country to another in a single day. 
        However, it is also called as the land of a thousand hills. Driving in Rwanda means that constantly being surrounded by the mountains around you. 
        Therefore, traveling cost in Rwanda should be understood more than the distance between the two points on the map."),
      br(),
      p("When we graph the distance to the nearest city and the traveling time to the city, we observe that most points have a positive correlation between the two.
        Yet, not all regions follow the trend. Let's take a look at the Musanze and Nyagatare, the regions in the northern part of Rwanda.
        The regression line should represents the estimate of how much time it needs to take 
        Here, we only color the points that is above by filtering the data with clusters that take more than 5 hours (300 minutes) to travel to the nearest city. 
        One can notice that some locations are significantly over the line, representing that it takes longer time to travel than people live in similar distance away from the city."),
      br(),
      plotOutput("distribution"),
      checkboxInput("pop_dens", "Show the Population on the Graph"),
      br(),
      tabsetPanel(
        type = "tabs",
        tabPanel("Location of Points", plotOutput("map1"),
                 p("* The location of the points diverges from 0-10km from the actual point to protect the privacy of the survey respondents who provided the data")),
        tabPanel("Altitude", plotOutput("geofacet_map"),
                 p("* You can interact with this graph using the Distance to Travel and the Time to Travel sliders."))
      ),
      br(),
      p("Musanze is famous for the Virunga Mountains and their big volcanos. Not surprisingly, we can observe the high altitude when we press the altitude tab next to the map.
        We can observe that the time traveled to the city increases as the altitude rises in Nyagatare. 
    The clusters that take more than 5 hours to the nearest city with over 50,000 people are also all located on the outskirts, away from the Kigali province (Gasabo, Nyarugenge, and Kicukiro), where the capital is located.
        Yet, not all regions that take a long time to travel to the city have a high altitude."),
      em("This is why need in depth research on the accessibility of rural areas to the city."),
      br(),
      br(),
      br(),
      strong("Source"),
      p("Data:"),
      p("International Food Policy Research Institute (IFPRI). (2020). AReNA’s DHS-GIS Database. Washington, DC: IFPRI [dataset]. https://doi.org/10.7910/DVN/OQIPRW. Harvard Dataverse. Version 1."),
      p("Map:"),
      p("Hijmans, R. J., University of California, Berkeley. Museum of Vertebrate Zoology. (2015). Fourth-level Administrative Divisions, Rwanda, 2015. [Shapefile]. University of California, Berkeley. Museum of Vertebrate Zoology. Retrieved from https://earthworks.stanford.edu/catalog/stanford-kt081vp3812"),
      p("Hijmans, R. J., University of California, Berkeley. Museum of Vertebrate Zoology. (2015). Second-level Administrative Divisions, Rwanda, 2015. [Shapefile]. University of California, Berkeley. Museum of Vertebrate Zoology. Retrieved from https://earthworks.stanford.edu/catalog/stanford-qy869sx9298"),
      
    ),
    position = "right"
  )
)

server <- function(input, output){
  
  output$distribution <- renderPlot({
    # Choose column
     distance_from_pop <- paste0("dist_", input$city_pop)
     time_from_pop <- paste0("tt00_", input$city_pop)
     
     # Alter Data for Visualization 
     plot_df <- rwanda_df %>%
       rename(all_of(c(distance = distance_from_pop))) %>%
       rename(all_of(c(time = time_from_pop))) %>%
       mutate(Region = dhsregna) %>%
       mutate(population_density = case_when(
         input$pop_dens & (URBAN_RURA == "Urban") ~ popden_ur,
         input$pop_dens & (URBAN_RURA == "Rural") ~ popden_rur,
         TRUE ~ 1
       )) %>%
       # There are urban locations that do not have urban population. In those cases, we just use to rural population.
       mutate(population_density = ifelse(population_density == 0, popden_rur, population_density)) 
     
     # Filter data based on input
     plot_df_part <- plot_df %>%
       filter(distance >= input$distance[1] &distance <= input$distance[2]) %>%
       filter(time >= input$time[1] &distance <= input$time[2]) %>%       
       filter(dhsregna %in% input$selected_region)
     
    if(input$pop_dens){
      
      #Graph when showing population density 
      
      ggplot()+
        geom_point(data = plot_df, aes(x = distance, y = time, size = population_density), alpha = 0.2)+
        geom_point(data = plot_df_part, aes(x = distance, y = time, size = population_density, colour = Region))+
        scale_colour_manual(
          values = color_palette,
          aesthetics = c("colour", "fill")
        )+
        geom_smooth(data = plot_df, aes(x = distance, y = time), method = lm)+
        labs(
          title = str_to_title("Some Rwandans have to travel longer time to travel the same distance to the city"),
          subtitle = str_to_sentence("Correlation between traveled time to a city to the distance to the city in Rwanda, 2015"),
          size = str_to_sentence("Population Density (per square kilometer"),
          x = str_to_sentence("Distance to the city (kilometer)"),
          y = str_to_sentence("Time traveled to the city (minutes)"),
          caption = "Data: Advancing Research on Nutrition and Agriculture DHS-GIS Data \nby the International Food Policy Research Institute (2020)"
        )+
        theme_bw()
    } else {
      
      #Graph when not showing population density 
      
      ggplot()+
        geom_point(data = plot_df, aes(x = distance, y = time), alpha = 0.2)+
        geom_point(data = plot_df_part, aes(x = distance, y = time, colour = Region))+
        scale_colour_manual(
          values = color_palette,
          aesthetics = c("colour", "fill")
        )+
        geom_smooth(data = plot_df, aes(x = distance, y = time), method = lm)+
        theme_bw()+ 
        labs(
          title = str_to_title("Some Rwandans have to travel longer time to travel the same distance to the city"),
          subtitle = str_to_sentence("Correlation between traveled time to a city to the distance to the city in Rwanda, 2015"),
          x = str_to_sentence("Distance to the city (kilometer)"),
          y = str_to_sentence("Time traveled to the city (minutes)"),
          caption = "Data: Advancing Research on Nutrition and Agriculture DHS-GIS Data \nby the International Food Policy Research Institute (2020)"
        )
    }
    
    
  })
  
  
  output$map1 <- renderPlot({
  
    distance_from_pop <- paste0("dist_", input$city_pop)
    time_from_pop <- paste0("tt00_", input$city_pop)
    
    # Filter the dataset
    distance_filtered <- rwanda_df %>%
      rename(all_of(c(distance = distance_from_pop))) %>%
      rename(all_of(c(time = time_from_pop))) %>%
      filter(dhsregna %in% input$selected_region) %>%
      filter(is.na(longnum) == FALSE) %>%
      filter(is.na(latnum) == FALSE) %>%
      arrange(distance) %>%
      mutate(distance_in_degree = distance * 1000/110000)
  
    
    # Basic map with 
    map1 <- ggplot()+
      theme_bw()
    
    if(dim(distance_filtered)[1] == 0){
      
      # Show only the basic map when no data is selected
      map1+
        geom_sf(data = second_rwanda_sf, fill = NA, size = 1.5, colour = "black")+
        coord_sf(crs = st_crs(4326), 
                 xlim = input$long,
                 ylim = input$lat)
      
    } else {
      # Filter the map
      rwanda_region_sf <- rwanda_sf %>%
        filter(name_2 %in% input$selected_region)

      
      # Create geometry
      distance_filtered_sf <- distance_filtered %>%
        filter(distance >= input$distance[1] &distance <= input$distance[2]) %>%
        filter(time >= input$time[1] &distance <= input$time[2]) %>%     
        st_as_sf(coords = c("longnum", "latnum"), crs = st_crs(4326))
      
      # Map that shows the selected region & second administrative level
      map1 +
        geom_sf(data = second_rwanda_sf, fill = NA, size = 1, colour = "black")+
        geom_sf_text(data = second_rwanda_sf, aes(label = name_2), size=2, family = "sans")+
        geom_sf(data = rwanda_region_sf, aes(fill = name_2), alpha = 0.5)+
        geom_sf(data = distance_filtered_sf)+
        scale_colour_manual(
          values = color_palette,
          aesthetics = c("colour", "fill")
        )+
        coord_sf(crs = st_crs(4326), 
                 xlim = input$long,
                 ylim = input$lat)+
        theme_minimal() +
        labs(
          title = str_to_title("The Locations of the Selected Clusters on the State-wide Rwandan Map"),
          subtitle = str_to_sentence("The Location of Clusters and the 2015 4th Level Administrative Division of the Selected Regions"),
          fill = "Region",
          x = "",
          y = "",
          caption = "Data: Advancing Research on Nutrition and Agriculture DHS-GIS Data \nby the International Food Policy Research Institute (2020)\nMap: Hijmans, R. and University of California, Berkeley, Museum of Vertebrate Zoology (2015)"
        )
    }
  })
  
  output$geofacet_map <- renderPlot({
    # Select the column
    distance_from_pop <- paste0("dist_", input$city_pop)
    time_from_pop <- paste0("tt00_", input$city_pop)
    
    # Create a Grid
    rwanda_grid <- grid_auto(second_rwanda_sf, names = "name_2")

    
    # Filter the dataset
    renamed_rwanda_df <- rwanda_df %>%
      rename(all_of(c(distance = distance_from_pop))) %>%
      rename(all_of(c(time = time_from_pop)))
    
    df_filtered <-renamed_rwanda_df %>%
      #filter(dhsregna %in% input$selected_region) %>%
      filter(is.na(longnum) == FALSE) %>%
      filter(is.na(latnum) == FALSE) %>%
      filter(distance >= input$distance[1] &distance <= input$distance[2]) %>%
      filter(time >= input$time[1] &distance <= input$time[2])
      
   
        
    ggplot(data = df_filtered)+
      geom_line(aes(x = time, y = alt), colour = "darkgreen")+
      geom_ribbon(aes(x= time, ymin = 950, ymax= alt), fill = "darkgreen", alpha = 0.2)+
      ylim(c(950, 3000))+
      xlim(c(min(renamed_rwanda_df[,"time"]), max(renamed_rwanda_df[,"time"])))+
      facet_geo(~dhsregna, grid = rwanda_grid)+
      theme_bw()+
      labs(
        title = str_to_title("In some regions, living in higher in the mountains may mean longer travel to the city"),
        subtitle = str_to_sentence("The altitude of the locations and the time traveled to the city in each region"),
        x = str_to_sentence("Time traveled to the city (minutes)"),
        y = str_to_sentence("Elevation above sea level (meters)"),
        caption = "Data: Advancing Research on Nutrition and Agriculture DHS-GIS Data \nby the International Food Policy Research Institute (2020)"
      )

    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
