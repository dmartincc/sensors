# High Out Degree Twitter Users as Sensors to Detect Early Warnings of Influenza at Scale

Dear reviewer,

If you are here, it's beacause you read our article _High Out Degree Twitter Users as Sensors to Detect Early Warnings of Influenza at Scale_.

Thanks for taking the time.

In this repository you can find the following artefacts to understand and reproduce our work:

1. First person ili-related mentions classifier (folder: 01_nlp)

2. Tweets topic labelling procedure using TextRazor (folder: 02_textrazor)

3. Seasonal ILI regression models (folder: 03_linear_regression)

4. ILI Sensors logistic regression models (folder: 04_logistic_regression)

Below you can find details on how to run our code for each folder.

## First person ili-related mentions classifier

This first folder contains a sample code in _python_ to train a NLP model with the purpose to train a First person ili-related mentions classifier.

We also provide a sample dataset of tweets (_sample_tweets.csv_) to run the code.

How to run the code.

First, you should install all the libraries needed, they are contained in the file _requierements.txt_

After you have installed all libraries, then run:

```
python 01_nlp/classifier.py

```

## Tweets topic labelling procedure using TextRazor

This second folder contains the python code develop to enrich our data with the IPTC taxonomy.

We also provide a sample dataset of tweets (_sample_tweets.csv_) to run the code.


```
python 02_textrazor/labelling.py

```

Note: Before running the code you should generate an API Key from TextRazor in order to access to their service.


## Seasonal ILI regression models

This third folder contains a Rscript and the final time series dataset _(time_series_flu_model.csv)_, describe below, to simulate _Table 1_ and _Figure 5A_ from our paper.

### ILI weekly dataset

This dataset contains a weekly projection of the ILI at national level in Spain.

time_series_flu_model.csv

Variables:

date_week: Calendar week 

week_flu: Flu season week

I: Official ILI rate

DT: Weekly total out-degree Twitter population

DS: Weekly total out-degree Sensors population


```
Rscript 03_linear_regression/model.R

```

## ILI Sensors logistic regression models 


This fourth folder contains a Rscript and the final sensor dataset _(model_sensors_behaviours_topics.csv)_, describe below, to simulate  _Figure 6A_ from our paper.


```
Rscript 04_logist_regression/model.R

```

### ILI sensors  dataset

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




We hope we have helped you on your work with this documentation. 