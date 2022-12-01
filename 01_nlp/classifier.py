# -*- coding: utf-8 -*-
from __future__ import print_function

import csv
import os.path
import pickle
import re
import string
import sys

import numpy as np
import pandas as pd

from pprint import pprint
from time import time

from nltk.corpus import stopwords

from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.decomposition import TruncatedSVD
from sklearn.svm import SVC
from sklearn.linear_model import SGDClassifier
from sklearn.multiclass import OneVsRestClassifier
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import MultiLabelBinarizer
# from sklearn.externals import joblib

CSV_PATH = './sample_tweets.csv'

BAD_CHARS = ')({}<>[]-,;=:“”.¿"#$/\*?¡+|@_!—…' + "'"

MODEL_NAME = './ili_classifier.pkl'
MODEL =  MODEL_NAME

_APP_DIR = os.path.normpath(os.path.dirname(os.path.realpath(__file__)))
MODEL_FILE_PATH = os.path.join(_APP_DIR, MODEL)

url = re.compile("http:\/\/(.*?)/")
username = re.compile(r'@([A-Za-z0-9_]+)')
hashtag = re.compile(r'#([A-Za-z0-9_]+)')

def read_csv(filename):
    df = pd.read_csv(filename, sep=',', header=0)
    return df[['id','date','lat','lng','text','flu']]

def tokenize(text):
    return [s.strip() for s in text.split() if len(s) > 2]

def clean_text(text):
    text = text.lower().strip()
    text = text.replace('rt', 'RTW')
    text = url.sub('URL ', text)
    text = hashtag.sub('HASHTAG', text)
    text = username.sub('USERNAME', text)
    text = ' '.join(filter(lambda x: x not in stopwords.words('spanish'), text.split()))
    text = ''.join(c for c in text if c not in BAD_CHARS)
    text = ' '.join(word for word in tokenize(text))
    return text

def main():

    print("Loading training data...")
    input_data = read_csv(CSV_PATH)

    print("Cleaning training data...")
    data = input_data['text'].apply(clean_text)
    labels = input_data[['flu']]

    X = data.values
    y = labels.values

    _y = []
    for i in y:
        _y.append([_i for _i, j in enumerate(i) if j == 1])

    lb = MultiLabelBinarizer()
    y = lb.fit_transform(_y)

    print("Spliting in training and testing datasets...")
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.33)

    classifier = Pipeline([
        ('tfidf', TfidfVectorizer(ngram_range=(1, 2), min_df=2)),
        ('pca', TruncatedSVD(n_components=74)),
        ('clf', OneVsRestClassifier(SGDClassifier(alpha=0.0001, penalty='l2')))])
    
    print("Traning classifier...")
    classifier.fit(X_train, y_train)
    predicted = classifier.predict(X_test)
    
    print("Accuracy Score: ", accuracy_score(y_test, predicted))
    
if __name__ == '__main__':
    main()
