# app.py

from flask import Flask, jsonify, request
import matlab.engine
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Mapowanie plików danych do odpowiednich skryptów MATLAB
matlab_scripts = {
    "linear": {
        "wyniki_15_g10_12": "Projekt_wyniki_15_g10_12",
        "wyniki_15_g12_16": "Projekt_wyniki_15_g12_16"
    },
    "random_forest": {
        "wyniki_15_g10_12": "Projekt_wyniki_15_g10_12_random_forest",
        "wyniki_15_g12_16": "Projekt_wyniki_15_g12_16_random_forest"
    },
    "ridge": {
        "wyniki_15_g10_12": "Projekt_wyniki_15_g10_12_ridge",
        "wyniki_15_g12_16": "Projekt_wyniki_15_g12_16_ridge"
    },
    "lstm": {
        "wyniki_15_g10_12": "Projekt_wyniki_15_g10_12_lstm",
        "wyniki_15_g12_16": "Projekt_wyniki_15_g12_16_lstm"
    },
    "boosted": {
        "wyniki_15_g10_12": "Projekt_wyniki_15_g10_12_boosted",
        "wyniki_15_g12_16": "Projekt_wyniki_15_g12_16_boosted"
    },
    "decision_tree": {
        "wyniki_15_g10_12": "Projekt_wyniki_15_g10_12_decision_tree",
        "wyniki_15_g12_16": "Projekt_wyniki_15_g12_16_decision_tree"
    },
    "neural_network": {
        "wyniki_15_g10_12": "Projekt_wyniki_15_g10_12_neural_network",
        "wyniki_15_g12_16": "Projekt_wyniki_15_g12_16_neural_network"
    },
    "fuzzy_logic": {
        "wyniki_15_g10_12": "Projekt_wyniki_15_g10_12_fuzzy_logic",
        "wyniki_15_g12_16": "Projekt_wyniki_15_g12_16_fuzzy_logic"
    }
}

# Ścieżki do katalogów ze skryptami MATLAB
script_directories = {
    "linear": r'D:\STUDIA\App2\backend\matlab_scripts\machine_learning\linear',
    "random_forest": r'D:\STUDIA\App2\backend\matlab_scripts\machine_learning\random_forest',
    "ridge": r'D:\STUDIA\App2\backend\matlab_scripts\machine_learning\ridge',
    "lstm": r'D:\STUDIA\App2\backend\matlab_scripts\machine_learning\lstm',
    "boosted": r'D:\STUDIA\App2\backend\matlab_scripts\machine_learning\boosted',
    "decision_tree": r'D:\STUDIA\App2\backend\matlab_scripts\machine_learning\decision_tree',
    "neural_network": r'D:\STUDIA\App2\backend\matlab_scripts\machine_learning\neural_network',
    "fuzzy_logic": r'D:\STUDIA\App2\backend\matlab_scripts\fuzzy_logic'  # Dodajemy ścieżkę dla fuzzy_logic
}

@app.route('/')
def index():
    return "Backend is running!"

@app.route('/run_matlab', methods=['POST'])
def run_matlab():
    data = request.json
    param = data.get('param')  # Parametr określający wybór pliku danych
    algorithm = data.get('algorithm')  # Parametr określający wybór algorytmu

    # Debugowanie parametrów
    print(f"Received parameter: {param}")
    print(f"Received algorithm: {algorithm}")

    # Pobieranie odpowiedniego skryptu MATLAB na podstawie parametru i algorytmu
    matlab_function = matlab_scripts.get(algorithm, {}).get(param)
    script_directory = script_directories.get(algorithm)

    if not matlab_function or not script_directory:
        return jsonify({"result": None, "status": "error", "message": "Invalid data parameter or algorithm"})

    eng = matlab.engine.start_matlab()
    eng.addpath(script_directory, nargout=0)  # Dodanie ścieżki do MATLAB

    try:
        # Uruchomienie wybranego skryptu MATLAB
        result = getattr(eng, matlab_function)(nargout=1)
        eng.quit()
        return jsonify({"result": result, "status": "success"})
    except Exception as e:
        eng.quit()
        return jsonify({"result": None, "status": "error", "message": str(e)})

if __name__ == "__main__":
    app.run(debug=True)
