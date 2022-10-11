# High Out Degree Twitter Users as Sensors to Detect Early Warnings of Influenza at Scale

In this repository you can find the final datasets for simulating the results of the article where you found this repository url.

## ILI weekly model dataset

This dataset contains a weekly projection of the ILI at national level in Spain.

time_series_flu_model.csv

Variables:

date_week: Calendar week 

week_flu: Flu season week

I: Official ILI rate

DT: Weekly total out-degree Twitter population

DS: Weekly total out-degree Sensors population


## ILI individual sensors model dataset

This dataset contains individuals labeled as sensors and no-sensors of the ILI on Twitter, along behavioural and content features.

model_sensors_behaviour_topics.csv

Variables: 

Ci:  Numeric variables. 45 Content categories variables.

number_posts_30days: Numeric variable. Number of posts over the 30 days of observation.

gyration_radius: Numeric variable. Radius of gyration over the 30 days of observation.

out_degree: Numeric variable. Individual out-degree.

sensor: Binary variable. 1 sensor, 0 control.

All variables are already normalized.

For further details upon request.
