import librosa
import numpy as np
import tensorflow as tf
from flask import Flask, jsonify, request
import io

app = Flask(__name__)

tbdetection_model = tf.keras.models.load_model('tb-detection_model')

tb_classes = {-1 : 'Label Unknown', 0: 'TB Negative', 1: 'TB Positive'}

def gettbdetection_prediction(audio_file):
    audio_file.seek(0)
    audio, sample_rate = librosa.load(io.BytesIO(audio_file.read()), sr=None)
    mfccs_features = librosa.feature.mfcc(y=audio, sr=sample_rate, n_mfcc=40)
    mfccs_scaled_features = np.mean(mfccs_features.T, axis=0)
    mfccs_scaled_features = mfccs_scaled_features.reshape(1, 8, 5, 1)
    
    predicted_label = np.argmax(tbdetection_model.predict(mfccs_scaled_features, verbose=1), axis=1)
    return tb_classes[predicted_label[0]]

@app.route('/predict', methods=['POST'])
def tb_predict():
    if 'audio' not in request.files:
        return 'No file provided', 400
    audio_file = request.files['audio']
    
    try:
        prediction = gettbdetection_prediction(audio_file)
    except Exception as e:
        return f'Error in processing file: {str(e)}', 400
    
    return prediction

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=80)