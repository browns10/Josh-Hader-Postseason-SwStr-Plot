#Using statcast data from 2018 visualize the swinging strikes from Josh Hader's Postseason Appearances

H <- scrape_statcast_savant(start_date = "2018-10-01", end_date = "2018-10-20", playerid = 623352, player_type = 'pitcher')

Hader_Data <-rbind(H) 

#Use SQL to filter the data to swinging strikes
Hader_Data <- sqldf("select *
                    from Hader_Data
                    where description = 'swinging_strike'")

#Check that we have the data that we want
View(Hader_Data)

#Create strike zone based on MLB averages (Source: Analyzing Baseball Data with R)
top_zone <- 3.5
bot_zone <- 1.6
left_zone <- -0.95
right_zone <- 0.95
strike_zone_df <- data.frame(
  x = c(left_zone, left_zone, right_zone, right_zone, left_zone),
  y = c(bot_zone, top_zone, top_zone, bot_zone, bot_zone)
)

#Filter the swinging strikes by unique pitch types 
#Split plot by batter hand
#Plot our data 

Hader_Plot <- ggplot() + 
geom_path(data = strike_zone_df, aes(x = x, y = y)) +
coord_equal() +
xlab("Horizontal Distance (ft)") +
ylab("Vertical Distance (ft)") +
geom_point(data = Hader_Data, aes(x = plate_x, y = plate_z, color = pitch_type, size = release_speed)) +
facet_wrap(. ~ stand)

#add title and subtitle to our plot
Hader_Plot + labs(title = "Josh Hader Swinging Strike Locations 2018 Postseason", subtitle = "Catcher's View", caption = "Data courtesy of MLBAM")

