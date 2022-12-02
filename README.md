
# Social Media Sensors to Detect Early Warnings of Influenza at Scale

This repository contains the code and aggregated data to reproduce sofware arfacts and figures of Martín-Corral et al. "Social Media Sensors to Detect Early Warnings of Influenza at Scale".

1. First person ili-related mentions classifier (folder: 01_nlp)

2. Tweets topic labelling procedure using TextRazor (folder: 02_textrazor)

3. Seasonal ILI regression models (folder: 03_linear_regression)

4. ILI Sensors logistic regression models (folder: 04_logistic_regression)

Below you can find details on how to run the code for each folder.

## First person ili-related mentions classifier

This first folder contains a sample code in _python_ to train a NLP model classifier with the purpose to detect First person ili-related mentions.

It also contains a sample dataset of tweets (_sample_tweets.csv_) to run the code.

How to run the code.

First, it is needed to install some python libraries, they are contained in the file _requierements.txt_

After you have installed all libraries, then run:

```
python 01_nlp/classifier.py

```


### Sample tweets

This dataset contains a 100 ILI-related mentions and are labelled by first or not first person.

**sample_tweets.csv**

Variables:

**id**: String variable. Hashed id to anonymized user.

**date**: String variable. Date when the tweet was published.

**lat**: Numeric variable. Geographic latitude.

**lng**: Numeric variable. Geopraphic longitude.

**text**: String variable. Tweet content with metadata anonimized.

**flu**: Binary variable. 1 first person ili-related mention, 0 no first person ili-related mention.


## Tweets topic labelling procedure using TextRazor

This second folder contains the python code develop to enrich our data with the IPTC taxonomy.

It also contains a sample dataset of tweets (_sample_tweets.csv_) to run the code.


```
python 02_textrazor/labelling.py

```

Note: Before running the code you should generate an API Key from TextRazor in order to access to their service and add it to the line 7 of the script.


## Seasonal ILI regression models

This third folder contains a Rscript and the final time series dataset _(time_series_flu_model.csv)_, described below, to simulate _Table 1_ and _Figure 5A_ from our paper.

### ILI weekly dataset

This dataset contains a weekly projection of the ILI at national level in Spain.

**time_series_flu_model.csv**

Variables:

**date_week**: String variable. Calendar week 

**week_flu**: Numeric variable. Seasonal weeks since the peak.

**I**: Numeric variable. Official ILI rate.

**DT**: Numeric variable. Weekly total out-degree Twitter population.

**DS**: Numeric variable. Weekly total out-degree Sensors population.


```
Rscript 03_linear_regression/model.R

```

## ILI Sensors logistic regression models 


This fourth folder contains a Rscript and the final sensor dataset _(model_sensors_behaviours_topics.csv)_, described below, to simulate  _Figure 6A_ from our paper.


```
Rscript 04_logistic_regression/model.R

```

### ILI sensors  dataset

This dataset contains individuals labeled as sensors and no-sensors of the ILI on Twitter, along behavioural and content features.

**model_sensors_behaviour_topics.csv**

Variables: 

**Ci**:  Numeric variables. IPTC Categories Weight from 0 to 1. 45 variables.

**number_posts_30days**: Numeric variable. Number of posts over the 30 days of observation.

**gyration_radius**: Numeric variable. Radius of gyration over the 30 days of observation.

**out_degree**: Numeric variable. Individual out-degree.

**sensor**: Binary variable. 1 sensor, 0 control.

All variables are already normalized.





