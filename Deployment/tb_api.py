import librosa
import numpy as np
import pandas as pd
import tensorflow as tf
from flask import Flask, jsonify, request

app = Flask(__name__)

tbdetection_model = tf.keras.models.load_model('tb-detection_model')

tb_classes = {-1 : 'Label Unknown',0: 'TB Negative', 1: 'TB Positive'}

def gettbdetection_prediction(filename):
    audio, sample_rate = librosa.load(filename)
    mfccs_features = librosa.feature.mfcc(y=audio, sr=sample_rate, n_mfcc=40)
    mfccs_scaled_features = np.mean(mfccs_features.T,axis=0)
    #mfccs_scaled_features = np.repeat(mfccs_scaled_features, 1, axis=0)
    mfccs_scaled_features=mfccs_scaled_features.reshape(1, 8, 5, 1)
    print(tbdetection_model.predict(mfccs_scaled_features,verbose=1))
    print(np.argmax(tbdetection_model.predict(mfccs_scaled_features)))
    predicted_label=np.argmax(tbdetection_model.predict(mfccs_scaled_features),axis=1)
    return tb_classes[predicted_label[0]]


@app.route('/predict',methods=['POST'])
def tb_predict():
    if 'audio' not in request.files:
        return 'No file provided', 400
    audio_file = request.files['audio']
    if not audio_file.filename.lower().endswith('.wav'):
        return 'Invalid file type, must be .wav', 400
    preditction = gettbdetection_prediction(audio_file)
    return preditction

if __name__ == '__main__':
    app.run(debug=True,host="0.0.0.0",port=80)