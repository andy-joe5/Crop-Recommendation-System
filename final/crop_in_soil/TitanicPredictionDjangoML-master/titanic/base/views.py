from django.shortcuts import render
import pickle
import numpy as np

def home(request):
    return render(request, 'index.html')

def getPredictions(humidity, ph, rain, temp, N, P, K, soil_type):
    model = pickle.load(open('DecisionTree.pkl', 'rb'))
    prediction = model.predict(np.array([[humidity, ph, rain, temp, N, P, K, soil_type]]))
    
    if prediction == 'rice':
        return 'rice'
    elif prediction == 'potato':
        return 'potato'
    elif prediction == 'onion':
        return 'onion'
    elif prediction == 'cofee':
        return 'cofee'
    elif prediction == 'tomato':
        return 'tomato'
    else:
        return 'error'

def result(request):
    humidity = int(request.GET['HUMIDITY'])
    ph = int(request.GET['       PH'])
    rain = int(request.GET['     RAIN'])
    temp = int(request.GET['TEMPARATURE'])
    N = int(request.GET['        N'])
    P = int(request.GET['        P'])
    K = int(request.GET['        K'])
    soil_type = int(request.GET['soil_type'])

    result = getPredictions(humidity, ph, rain, temp, N, P, K, soil_type)

    return render(request, 'result.html', {'result': result})
