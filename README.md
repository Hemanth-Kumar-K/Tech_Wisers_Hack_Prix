<center><h1>Tuberculosis Detection</h1></center>


## Table of Contents

1. [Introduction](#introduction)
2. [Repository Structure](#repository-structure)
3. [Frontend](#frontend)
4. [Backend](#backend)
    - [Model Training](#model-training)
5. [Deployment](#deployment)
6. [Requirements](#requirements)
7. [Running the Application](#running-the-application)
8. [Demo Video](#demo-video)

## Introduction

This repository contains the code for a Flutter application along with a Flask backend. The frontend is built using Flutter, and the backend consists of a model training script and a Flask application that serves the trained model. This setup connects the backend and frontend, providing a seamless integration for the entire application.

## Repository Structure

The repository is structured as follows:

```
.
├── frontend
│   └── tbd
|        └── flutter_app_code
|
├── backend
│   └── model_training
|
|── deployment
│   ├── tb_api.py
|   ├── tb_api1.py
│   ├── requirements.txt
│   └── tb-detection_model
└── App_demo.mp4
```

- **frontend/**: Contains the Flutter application code.
- **backend/**: Contains the backend code.
  - **model_training/**: Scripts and files related to training the model.
-**deployment/**: Flask application and related files.
    - **tb_api.py**: Flask application code.
    - **requirements.txt**: Python dependencies required for the Flask app.
    - **final_model/**: Directory containing the final trained model.
- **demo_video/**: Directory containing a demo video of the application.

## Frontend

The frontend of the application is built using Flutter. To run the Flutter app:

1. Ensure you have Flutter installed on your machine. Instructions can be found [here](https://flutter.dev/docs/get-started/install).
2. Navigate to the `frontend/flutter_app_code` directory.
3. Run `flutter pub get` to fetch the necessary dependencies.
4. Use `flutter run` to start the application on your desired device or emulator.

## Backend

### Model Training

The `model_training` folder contains the scripts and data required to train the machine learning model used by the application. Follow the instructions in the respective scripts to train and generate the model file.

### Deployment

The `deployment` folder contains the Flask application that serves the trained model.

- `app.py`: This is the main Flask application file that connects the backend and frontend.
- `requirements.txt`: Contains the list of dependencies required to run the Flask application.
- `final_model/`: This directory contains the trained model file used by `app.py`.

To set up and run the Flask application:

1. Create a virtual environment:

    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
    ```

2. Install the required dependencies:

    ```bash
    pip install -r requirements.txt
    ```

3. Run the Flask application:

    ```bash
    python app.py
    ```

The Flask application will start, and you can access it at `http://127.0.0.1:80`.

## Requirements

All the necessary dependencies for the backend Flask application are listed in the `requirements.txt` file located in the `backend/deployment` folder. Install them using:

```bash
pip install -r backend/deployment/requirements.txt
```

## Running the Application

To run the entire application:

1. Start the Flask backend by following the steps in the [Backend](#backend) section.
2. Run the Flutter frontend by following the steps in the [Frontend](#frontend) section.
3. Ensure the frontend is correctly configured to make API requests to the Flask backend.

## Demo Video

A demo video showcasing the functionality of the application can be found in the `App demo.mp4`.
