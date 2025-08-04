import os
import sys
import json
import numpy as np
import pickle
import opensmile
from tensorflow.keras.models import load_model

BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), 'datas'))


def load_breed_data(razza):
    breed_dir = os.path.join(BASE_DIR, razza)
    model_path = os.path.join(breed_dir, 'best_model_razza.h5')
    encoder_path = os.path.join(breed_dir, 'best_label_encoder.pkl')
    preprocess_data_path = os.path.join(breed_dir, 'best_preprocessing_params.npz')

    if not os.path.exists(model_path):
        raise FileNotFoundError(f'Model file non trovato per la razza: {razza}')

    model = load_model(model_path)

    data = np.load(preprocess_data_path)
    mean = data['mean']
    std = data['std']
    max_len = int(data['max_len'])
    n_features = int(data['n_features'])

    with open(encoder_path, 'rb') as f:
        label_encoder = pickle.load(f)

    return model, label_encoder, mean, std, max_len, n_features


def extract_lld_features(audio_path):
    smile = opensmile.Smile(
        feature_set=opensmile.FeatureSet.ComParE_2016,
        feature_level=opensmile.FeatureLevel.LowLevelDescriptors
    )
    features = smile.process_file(audio_path).values
    return features


def predict_audio_file(audio_path, model, label_encoder, mean, std, max_len, n_features):
    features = extract_lld_features(audio_path)

    if features.shape[0] < max_len:
        pad_width = max_len - features.shape[0]
        features = np.pad(features, ((0, pad_width), (0, 0)), mode='constant')
    else:
        features = features[:max_len, :]

    features = (features - mean) / (std + 1e-8)
    features = features.reshape(1, max_len, n_features, 1)
    features = features[:, ::4, :, :]

    preds = model.predict(features)[0]

    pred_class_idx = np.argmax(preds)
    pred_label = label_encoder.inverse_transform([pred_class_idx])[0]

    probs = {label: float(preds[idx]) for idx, label in enumerate(label_encoder.classes_)}

    return pred_label, probs


def main(audio_path, razza):
    try:
        model, label_encoder, mean, std, max_len, n_features = load_breed_data(razza)
        pred_label, probs = predict_audio_file(audio_path, model, label_encoder, mean, std, max_len, n_features)
        response = {
            'prediction': pred_label,
            'probabilities': probs
        }
        print(json.dumps(response))
        sys.stdout.flush()
    except Exception as e:
        import traceback
        traceback.print_exc()
        sys.stderr.write(f'Errore in Python: {str(e)}\n')
        sys.stderr.flush()
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.stderr.write('Errore: devi specificare audio_path e razza\n')
        sys.exit(1)
    audio_path = sys.argv[1]
    razza = sys.argv[2]
    main(audio_path, razza)
