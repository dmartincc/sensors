import requests
import pandas as pd
import numpy as np
import random

API_KEYS = {
    '': 0,
}

def load_data():
    df = pd.read_csv('sample_tweets.csv', 
        header=None, 
        names=['id','date','lat','lng','text','flu'])

    return df

def selectKey():
    key = random.choice([
        key for key in list(API_KEYS.keys()) if API_KEYS[key] < 501
    ])
    API_KEYS[key] = +API_KEYS[key]
    return key

def call(text):
    
    key = selectKey()
    headers = {
        'x-textrazor-key': key
    }
    data = {
        'classifiers':'textrazor_newscodes',
        'text': text
    }
    r = requests.post('http://api.textrazor.com', 
        headers = headers,
        data = data)
    
    return r
    

def parse(r):
    label = ''
    if r.status_code == 200:
        if 'categories' in r.json()['response']:
            for category in r.json()['response']['categories']:
                label = label + ' ' + category['label'].split('>')[-1]
            return label
    else:
        return ''
   
def main():

    df = load_data()
    s = df['text'].tolist()

    labels = []
    for item in s:
        r = call(item)
        label = parse(r)
        labels.append(label)

    data = pd.DataFrame(np.column_stack((df, labels)))
    data.to_csv('sample_tweets_labelled.csv')

if __name__ == '__main__':
    main()